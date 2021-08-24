```@meta
CurrentModule = JuMP
DocTestSetup = quote
    using JuMP
end
```

# Querying Solutions

So far we have seen all the elements and constructs related to writing a JuMP
optimization model. In this section we reach the point of what to do with a
solved problem. Suppose your model is named `model`. Right after the call to
`optimize!(model)`, it's natural to ask JuMP questions about the finished
optimization step. Typical questions include:
 - Why has the optimization process stopped? Did it hit the time limit or run
   into numerical issues?
 - Do I have a solution to my problem?
 - Is it optimal?
 - Do I have a dual solution?
 - How sensitive is the solution to data perturbations?

JuMP follows closely the concepts defined in [MathOptInterface (MOI)](https://github.com/jump-dev/MathOptInterface.jl)
to answer user questions about a finished call to `optimize!(model)`. There
are three main steps in querying a solution:

First, we can query the [`termination_status`](@ref) which will tell us why the
optimization stopped. This could be due to a number of reasons. For example, the
solver found an optimal solution, the problem was proven to be infeasible, or a
user-provided limit such as a time limit was encountered. For more information,
see the [Termination statuses](@ref) section below.

Second, we can query the [`primal_status`](@ref) and the [`dual_status`](@ref),
which will tell us what kind of results we have for our primal and dual
solutions. This might be an optimal primal-dual pair, a primal solution without
a corresponding dual solution, or a certificate of primal or dual infeasibility.
For more information, see the [Solution statuses](@ref) section below.

Third, we can query [`value`](@ref) and [`dual`](@ref) to obtain the
primal and dual values of the optimization variables and constraints (if there
are values to be queried).

## Termination statuses

The reason why the optimization of `model` was finished is given by
```julia
termination_status(model)
```

This function will return a `MOI.TerminationStatusCode` `enum`.

```@docs
MOI.TerminationStatusCode
```

Additionally, we can receive a solver specific string explaining why the
optimization stopped with [`raw_status`](@ref).

## Solution statuses

These statuses indicate what kind of result is available to be queried
with [`value`](@ref) and [`dual`](@ref). It's possible that no result
is available to be queried.

We can obtain these statuses by calling [`primal_status`](@ref) for the
primal status, and [`dual_status`](@ref) for the dual status. Both will
return a `MOI.ResultStatusCode` `enum`.

```@docs
MOI.ResultStatusCode
```

Common status situations are described in the
[MOI docs](http://jump.dev/MathOptInterface.jl/v0.9.1/apimanual/#Common-status-situations-1).

## Obtaining solutions

Provided the primal status is not `MOI.NO_SOLUTION`, the primal solution can
be obtained by calling [`value`](@ref). For the dual solution, the function
is [`dual`](@ref). Calling [`has_values`](@ref) for the primal status and
[`has_duals`](@ref) for the dual solution is an equivalent way to check whether
the status is `MOI.NO_SOLUTION`.

It is important to note that if [`has_values`](@ref) or [`has_duals`](@ref)
return false, calls to [`value`](@ref) and [`dual`](@ref) might throw an error
or return arbitrary values.

The container type (e.g., scalar, vector, or matrix) of the returned solution
(primal or dual) depends on the type of the variable or constraint. See
[`AbstractShape`](@ref) and [`dual_shape`](@ref) for details.

!!! info
    To call [`value`](@ref) or [`dual`](@ref) on containers of
    [`VariableRef`](@ref) or [`ConstraintRef`](@ref), use the broadcast syntax,
    e.g., `value.(x)`.

The objective value of a solved problem can be obtained via
[`objective_value`](@ref). The best known bound on the optimal objective
value can be obtained via [`objective_bound`](@ref). If the solver supports it,
the value of the dual objective can be obtained via
[`dual_objective_value`](@ref).

The following is a recommended workflow for solving a model and querying the
solution:
```julia
using JuMP
model = Model()
@variable(model, x[1:10] >= 0)
# ... other constraints ...
optimize!(model)

if termination_status(model) == MOI.OPTIMAL
    optimal_solution = value.(x)
    optimal_objective = objective_value(model)
elseif termination_status(model) == MOI.TIME_LIMIT && has_values(model)
    suboptimal_solution = value.(x)
    suboptimal_objective = objective_value(model)
else
    error("The model was not solved correctly.")
end
```

!!! warning "Querying after modification"
    If a solved model is modified, then querying the solution is undefined
    behavior. Adding, deleting, or modifying a constraint (or variable)
    may invalidate any part of the solution.

```@meta
# TODO: How to accurately measure the solve time.
```

## Accessing MathOptInterface attributes

[MathOptInterface](https://jump.dev/MathOptInterface.jl/v0.9.10/) defines a large
number of model attributes that can be queried. Examples include
[`MOI.RelativeGap`](https://jump.dev/MathOptInterface.jl/v0.9.10/apireference/#MathOptInterface.RelativeGap) and
[`MOI.SimplexIterations`](https://jump.dev/MathOptInterface.jl/v0.9.10/apireference/#MathOptInterface.SimplexIterations).

Some attributes can be directly accessed by getter functions. These include
- [`objective_bound`](@ref)
- [`relative_gap`](@ref)
- [`simplex_iterations`](@ref)
- [`barrier_iterations`](@ref)
- [`node_count`](@ref)

To query these attributes, use:
```julia
using JuMP
model = Model()
# ...
optimize!(model)

@show relative_gap(model)
# or
@show MOI.get(model, MOI.RelativeGap())

@show simplex_iterations(model)
# or
@show MOI.get(model, MOI.SimplexIterations())
```

## Sensitivity analysis for LP

Given an LP problem and an optimal solution corresponding to a basis, we can
question how much an objective coefficient or standard form rhs coefficient
(c.f., [`normalized_rhs`](@ref)) can change without violating primal or dual
feasibility of the basic solution. Note that not all solvers compute the basis,
and for sensitivity analysis, the solver interface must implement
`MOI.ConstraintBasisStatus`.

Given an LP optimal solution (and both [`has_values`](@ref) and
[`has_duals`](@ref) returns `true`) [`lp_objective_perturbation_range`](@ref)
returns a range of the allowed perturbation of the cost coefficient
corresponding to the input variable. Note that the current primal solution
remains optimal within this range, however the corresponding dual solution might
change since a cost coefficient is perturbed. Similarly,
[`lp_rhs_perturbation_range`](@ref) returns a range of the allowed perturbation
of the rhs coefficient corresponding to the input constraint. And in this range
the current dual solution remains optimal but the primal solution might change
since a rhs coefficient is perturbed.

However, if the problem is degenerate, there are multiple optimal bases and
hence these ranges might not be as intuitive and seem too narrow. E.g., a larger
cost coefficient perturbation might not invalidate the optimality of the current
primal solution. Moreover, if a problem is degenerate, due to finite precision,
it can happen that, e.g., a perturbation seems to invalidate a basis even though
it doesn't (again providing too narrow ranges). To prevent this
`feasibility_tolerance` and `optimality_tolerance` is introduced, which in turn,
might make the ranges too wide for numerically challenging instances. Thus do not
blindly trust these ranges, especially not for highly degenerate or numerically
unstable instances.

To give a simple example, we could analyze the sensitivity of the optimal
solution to the following (non-degenerate) LP problem:

```julia
julia> model = Model();
julia> @variable(model, x[1:2]);
julia> @constraint(model, c1, x[1] + x[2] <= 1);
julia> @constraint(model, c2, x[1] - x[2] <= 1);
julia> @constraint(model, c3, -0.5 <= x[2] <= 0.5);
julia> @objective(model, Max, x[1]);
```

```@meta
DocTestSetup = quote
    using JuMP
    model = Model(() -> MOIU.MockOptimizer(MOIU.Model{Float64}(),
                          eval_variable_constraint_dual=true));
    @variable(model, x[1:2]);
    @constraint(model, c1, x[1] + x[2] <= 1);
    @constraint(model, c2, x[1] - x[2] <= 1);
    @constraint(model, c3, -0.5 <= x[2] <= 0.5);
    @objective(model, Max, x[1]);
    optimize!(model);
    mock = backend(model).optimizer.model;
    MOI.set(mock, MOI.TerminationStatus(), MOI.OPTIMAL);
    MOI.set(mock, MOI.DualStatus(), MOI.FEASIBLE_POINT);
    MOI.set(mock, MOI.VariablePrimal(), JuMP.optimizer_index(x[1]), 1.0);
    MOI.set(mock, MOI.VariablePrimal(), JuMP.optimizer_index(x[2]), 0.0);
    MOI.set(mock, MOI.ConstraintBasisStatus(), JuMP.optimizer_index(c1), MOI.NONBASIC);
    MOI.set(mock, MOI.ConstraintBasisStatus(), JuMP.optimizer_index(c2), MOI.NONBASIC);
    MOI.set(mock, MOI.ConstraintBasisStatus(), JuMP.optimizer_index(c3), MOI.BASIC);
    MOI.set(mock, MOI.ConstraintDual(), optimizer_index(c1), -0.5);
    MOI.set(mock, MOI.ConstraintDual(), optimizer_index(c2), -0.5);
    MOI.set(mock, MOI.ConstraintDual(), optimizer_index(c3), 0.0);
end
```

To analyze the sensitivity of the problem we could check the allowed
perturbation ranges of, e.g., the cost coefficients and the rhs coefficient of
constraint `c1` as follows:
```jldoctest
julia> optimize!(model);

julia> value.(x)
2-element Array{Float64,1}:
 1.0
 0.0
julia> lp_objective_perturbation_range(x[1])
(-1.0, Inf)
julia> lp_objective_perturbation_range(x[2])
(-1.0, 1.0)
julia> lp_rhs_perturbation_range(c1)
(-1.0, 1.0)
```

```@docs
lp_objective_perturbation_range
lp_rhs_perturbation_range
```

## Conflicts

When the model you input is infeasible, some solvers can help you find the 
cause of this infeasibility by offering a conflict, i.e., a subset of the 
constraints that create this infeasibility. Depending on the solver, 
this can also be called an IIS (irreducible inconsistent subsystem). 

The function [`compute_conflict!`](@ref) is used to trigger the computation of
a conflict. Once this process is finished, the attribute
[`MOI.ConflictStatus`](@ref) returns a [`MOI.ConflictStatusCode`](@ref).

If there is a conflict, you can query from each constraint whether it 
participates in the conflict or not using the attribute
[`MOI.ConstraintConflictStatus`](@ref), which returns a
[`MOI.ConflictParticipationStatusCode`](@ref).

For instance, this is how you can use this functionality: 

```julia
using JuMP
model = Model() # You must use a solver that supports conflict refining/IIS computation, like CPLEX or Gurobi
@variable(model, x >= 0)
@constraint(model, c1, x >= 2)
@constraint(model, c2, x <= 1)
optimize!(model)

# termination_status(model) will likely be MOI.INFEASIBLE, 
# depending on the solver

compute_conflict!(model)
if MOI.get(model, MOI.ConflictStatus()) != MOI.CONFLICT_FOUND
    error("No conflict could be found for an infeasible model.")
end

# Both constraints should participate in the conflict.
MOI.get(model, MOI.ConstraintConflictStatus(), c1)
MOI.get(model, MOI.ConstraintConflictStatus(), c2)
```

## Multiple solutions

Some solvers support returning multiple solutions. You can check how many
solutions are available to query using [`result_count`](@ref).

Functions for querying the solutions, e.g., [`primal_status`](@ref) and
[`value`](@ref), all take an additional keyword argument `result` which can be
used to specify which result to return.

```julia
using JuMP
model = Model()
@variable(model, x[1:10] >= 0)
# ... other constraints ...
optimize!(model)

if termination_status(model) != MOI.OPTIMAL
    error("The model was not solved correctly.")
end

num_results = result_count(model)
@assert has_values(model; result = num_results)
an_optimal_solution = value.(x; result = num_results)
an_optimal_objective = objective_value(model; result = num_results)
```

## Reference

```@docs
JuMP.termination_status
JuMP.raw_status
JuMP.primal_status
JuMP.has_values
JuMP.value
JuMP.dual_status
JuMP.has_duals
JuMP.dual
JuMP.solve_time
OptimizeNotCalled
MOI.optimize!
JuMP.result_count
JuMP.relative_gap
JuMP.simplex_iterations
JuMP.barrier_iterations
JuMP.node_count
```

```@docs
JuMP.compute_conflict!
MOI.compute_conflict!
MOI.ConflictStatus
MOI.ConflictStatusCode
MOI.ConstraintConflictStatus
MOI.ConflictParticipationStatusCode
```
