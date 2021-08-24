module LearnBase

# Only reexport required functions by default
import StatsBase: nobs, fit, fit!, predict, params, params!

import LinearAlgebra: issymmetric

"""
Baseclass for any kind of cost. Notable examples for
costs are `Loss` and `Penalty`.
"""
abstract type Cost end

"""
Baseclass for all losses. A loss is some (possibly simplified)
function `L(features, targets, outputs)`, where `outputs` are the
result of some function `f(features)`.
"""
abstract type Loss <: Cost end

"""
A loss is considered **supervised**, if all the information needed
to compute `L(features, targets, outputs)` are contained in
`targets` and `outputs`, and thus allows for the simplification
`L(targets, outputs)`.
"""
abstract type SupervisedLoss <: Loss end

"""
A supervised loss, where the targets are in {-1, 1}, and which
can be simplified to `L(targets, outputs) = L(targets * outputs)`
is considered **margin-based**.
"""
abstract type MarginLoss <: SupervisedLoss end


"""
A supervised loss that can be simplified to
`L(targets, outputs) = L(targets - outputs)` is considered
distance-based.
"""
abstract type DistanceLoss <: SupervisedLoss end

"""
A loss is considered **unsupervised**, if all the information needed
to compute `L(features, targets, outputs)` are contained in
`features` and `outputs`, and thus allows for the simplification
`L(features, outputs)`.
"""
abstract type UnsupervisedLoss <: Loss end

abstract type Penalty <: Cost end

function scaled end

function value end
function value! end
function meanvalue end
function sumvalue end
function meanderiv end
function sumderiv end
function deriv end
function deriv2 end
function deriv! end
function value_deriv end
function addgrad! end
function value_grad end
function value_grad! end
function prox end
function prox! end

"Return the gradient of the learnable parameters w.r.t. some objective"
function grad end
"Do a backward pass, updating the gradients of learnable parameters and/or inputs"
function grad! end

function isminimizable end
function isdifferentiable end
function istwicedifferentiable end
function isconvex end
function isstrictlyconvex end
function isstronglyconvex end
function isnemitski end
function isunivfishercons end
function isfishercons end
function islipschitzcont end
function islocallylipschitzcont end
function islipschitzcont_deriv end # maybe overkill
function isclipable end
function ismarginbased end
function isclasscalibrated end
function isdistancebased end

# fallback to supersets
isstrictlyconvex(any) = isstronglyconvex(any)
isconvex(any) = isstrictlyconvex(any)
islocallylipschitzcont(any) = islipschitzcont(any)

"""
Anything that takes an input and performs some kind
of function to produce an output. For example a linear
prediction function.
"""
abstract type Transformation end
abstract type StochasticTransformation <: Transformation end
abstract type Learnable <: Transformation end

function transform end
"Do a forward pass, and return the output"
function transform! end

"""
Baseclass for any prediction model that can be minimized.
This means that an object of a subclass contains all the
information needed to compute its own current loss.
"""
abstract type Minimizable <: Learnable end

function update end
function update! end
function learn end
function learn! end

#    getobs(data, [idx], [obsdim])
#
# Return the observations corresponding to the observation-index
# `idx`. Note that `idx` can be of type `Int` or `AbstractVector`.
# Both options must be supported by a custom type.
#
# The returned observation(s) should be in the form intended to
# be passed as-is to some learning algorithm. There is no strict
# interface requirement on how this "actual data" must look like.
# Every author behind some custom data container can make this
# decision him-/herself. We do, however, expect it to be consistent
# for `idx` being an integer, as well as `idx` being an abstract
# vector, respectively.
#
# If it makes sense for the type of `data`, `obsdim` can be used
# to disptach on which dimension of `data` denotes the observations.
# See `?ObsDim`
#
# This function is implemented in MLDataPattern
function getobs end

#    getobs!(buffer, data, [idx], [obsdim])
#
# Inplace version of `getobs(data, idx, obsdim)`. If this method
# is defined for the type of `data`, then `buffer` should be used
# to store the result, instead of allocating a dedicated object.
#
# Implementing this function is optional. In the case no such
# method is provided for the type of `data`, then `buffer` will be
# *ignored* and the result of `getobs` returned. This could be
# because the type of `data` may not lend itself to the concept
# of `copy!`. Thus supporting a custom `getobs!(::MyType, ...)`
# is optional and not required.
#
# If it makes sense for the type of `data`, `obsdim` can be used
# to disptach on which dimension of `data` denotes the observations.
# See `?ObsDim`
#
# This function is implemented in MLDataPattern
function getobs! end

# --------------------------------------------------------------------

#    gettarget([f], observation)
#
# Use `f` (if provided) to extract the target from the single
# `observation` and return it. It is used internally by
# `targets` (only if `f` is provided) and by
# `eachtarget` (always) on each individual observation.
#
# Even though this function is not exported, it is intended to be
# extended by users to support their custom data storage types.
#
# This function is implemented in MLDataPattern
function gettarget end # not exported

#    gettargets(data, [idx], [obsdim])
#
# Return the targets corresponding to the observation-index `idx`.
# Note that `idx` can be of type `Int` or `AbstractVector`.
#
# Implementing this function for a custom type of `data` is
# optional. It is particularly useful if the targets in `data` can
# be provided without invoking `getobs`. For example if you have a
# remote data-source where the labels are part of some metadata
# that is locally available.
#
# If it makes sense for the type of `data`, `obsdim` can be used
# to disptach on which dimension of `data` denotes the observations.
# See `?ObsDim`
#
# This function is implemented in MLDataPattern
function gettargets end # not exported

#    targets([f], data, [obsdim])
#
# This function is implemented in MLDataPattern
function targets end

# --------------------------------------------------------------------

"""
    abstract DataView{TElem, TData} <: AbstractVector{TElem}

Baseclass for all vector-like views of some data structure.
This allow for example to see some design matrix as a vector of
individual observation-vectors instead of one matrix.

see `MLDataPattern.ObsView` and `MLDataPattern.BatchView` for examples.
"""
abstract type DataView{TElem, TData} <: AbstractVector{TElem} end

"""
    abstract AbstractObsView{TElem, TData} <: DataView{TElem, TData}

Baseclass for all vector-like views of some data structure,
that views it as some form or vector of observations.

see `MLDataPattern.ObsView` for a concrete example.
"""
abstract type AbstractObsView{TElem, TData} <: DataView{TElem, TData} end

"""
    abstract AbstractBatchView{TElem, TData} <: DataView{TElem, TData}

Baseclass for all vector-like views of some data structure,
that views it as some form or vector of equally sized batches.

see `MLDataPattern.BatchView` for a concrete example.
"""
abstract type AbstractBatchView{TElem, TData} <: DataView{TElem, TData} end

# --------------------------------------------------------------------

"""
    abstract DataIterator{TElem,TData}

Baseclass for all types that iterate over a `data` source
in some manner. The total number of observations may or may
not be known or defined and in general there is no contract that
`getobs` or `nobs` has to be supported by the type of `data`.
Furthermore, `length` should be used to query how many elements
the iterator can provide, while `nobs` may return the underlying
true amount of observations available (if known).

see `MLDataPattern.RandomObs`, `MLDataPattern.RandomBatches`
"""
abstract type DataIterator{TElem,TData} end

"""
    abstract ObsIterator{TElem,TData} <: DataIterator{TElem,TData}

Baseclass for all types that iterate over some data source
one observation at a time.

```julia
using MLDataPattern
@assert typeof(RandomObs(X)) <: ObsIterator

for x in RandomObs(X)
    # ...
end
```

see `MLDataPattern.RandomObs`
"""
abstract type ObsIterator{TElem,TData} <: DataIterator{TElem,TData} end

"""
    abstract BatchIterator{TElem,TData} <: DataIterator{TElem,TData}

Baseclass for all types that iterate over of some data source one
batch at a time.

```julia
@assert typeof(RandomBatches(X, size=10)) <: BatchIterator

for x in RandomBatches(X, size=10)
    @assert nobs(x) == 10
    # ...
end
```

see `MLDataPattern.RandomBatches`
"""
abstract type BatchIterator{TElem,TData} <: DataIterator{TElem,TData} end

# --------------------------------------------------------------------

# just for dispatch for those who care to
const AbstractDataIterator{E,T}  = Union{DataIterator{E,T}, DataView{E,T}}
const AbstractObsIterator{E,T}   = Union{ObsIterator{E,T},  AbstractObsView{E,T}}
const AbstractBatchIterator{E,T} = Union{BatchIterator{E,T},AbstractBatchView{E,T}}

# --------------------------------------------------------------------

#    datasubset(data, [idx], [obsdim])
#
# Return a lazy subset of the observations in `data` that correspond
# to the given `idx`. No data should be copied except of the
# indices. Note that `idx` can be of type `Int` or `AbstractVector`.
# Both options must be supported by a custom type.
#
# If it makes sense for the type of `data`, `obsdim` can be used
# to disptach on which dimension of `data` denotes the observations.
# See `?ObsDim`
#
# This function is implemented in MLDataPattern
function datasubset end

"""
    default_obsdim(data)

The specify the default obsdim for a specific type of data.
Defaults to `ObsDim.Undefined()`
"""
function default_obsdim end

# just for dispatch for those who care to
"see `?ObsDim`"
abstract type ObsDimension end

"""
    module ObsDim

Singleton types to define which dimension of some data structure
(e.g. some `Array`) denotes the observations.

- `ObsDim.First()`
- `ObsDim.Last()`
- `ObsDim.Contant(dim)`

Used for efficient dispatching
"""
module ObsDim
    using ..LearnBase: ObsDimension

    """
    Default value for most functions. Denotes that the concept of
    an observation dimension is not defined for the given data.
    """
    struct Undefined <: ObsDimension end

    """
        ObsDim.Last <: ObsDimension

    Defines that the last dimension denotes the observations
    """
    struct Last <: ObsDimension end

    """
        ObsDim.Constant{DIM} <: ObsDimension

    Defines that the dimension `DIM` denotes the observations
    """
    struct Constant{DIM} <: ObsDimension end
    Constant(dim::Int) = Constant{dim}()

    """
        ObsDim.First <: ObsDimension

    Defines that the first dimension denotes the observations
    """
    const First = Constant{1}
end

Base.convert(::Type{ObsDimension}, dim) = throw(ArgumentError("Unknown way to specify a obsdim: $dim"))
Base.convert(::Type{ObsDimension}, dim::ObsDimension) = dim
Base.convert(::Type{ObsDimension}, ::Nothing) = ObsDim.Undefined()
Base.convert(::Type{ObsDimension}, dim::Int) = ObsDim.Constant(dim)
Base.convert(::Type{ObsDimension}, dim::String) = convert(ObsDimension, Symbol(lowercase(dim)))
Base.convert(::Type{ObsDimension}, dims::Tuple) = map(d->convert(ObsDimension, d), dims)
function Base.convert(::Type{ObsDimension}, dim::Symbol)
    if dim == :first || dim == :begin
        ObsDim.First()
    elseif dim == Symbol("end") || dim == :last
        ObsDim.Last()
    elseif dim == Symbol("nothing") || dim == :none || dim == :null || dim == :na || dim == :undefined
        ObsDim.Undefined()
    else
        throw(ArgumentError("Unknown way to specify a obsdim: $dim"))
    end
end

@deprecate obs_dim(dim) convert(ObsDimension, dim)

default_obsdim(data) = ObsDim.Undefined()
default_obsdim(A::AbstractArray) = ObsDim.Last()
default_obsdim(tup::Tuple) = map(default_obsdim, tup)


import Base: AbstractSet

"A continuous range (inclusive) between a lo and a hi"
struct IntervalSet{T} <: AbstractSet{T}
    lo::T
    hi::T
end
function IntervalSet(lo::A, hi::B) where {A,B}
    T = promote_type(A,B)
    IntervalSet{T}(convert(T,lo), convert(T,hi))
end

# numeric interval
randtype(s::IntervalSet{T}) where T <: Number = Float64
Base.rand(s::IntervalSet{T}, dims::Integer...) where T <: Number = rand(dims...) .* (s.hi - s.lo) .+ s.lo
Base.in(x::Number, s::IntervalSet{T}) where T <: Number = s.lo <= x <= s.hi
Base.length(s::IntervalSet{T}) where T <: Number = 1
Base.:(==)(s1::IntervalSet{T}, s2::IntervalSet{T}) where T = s1.lo == s2.lo && s1.hi == s2.hi


# vector of intervals
randtype(s::IntervalSet{T}) where T <: AbstractVector = Vector{Float64}
Base.rand(s::IntervalSet{T}) where T <: AbstractVector = Float64[rand() * (s.hi[i] - s.lo[i]) + s.lo[i] for i=1:length(s)]
Base.in(x::AbstractVector, s::IntervalSet{T}) where T <: AbstractVector = all(i -> s.lo[i] <= x[i] <= s.hi[i], 1:length(s))
Base.length(s::IntervalSet{T}) where T <: AbstractVector = length(s.lo)


"Set of discrete items"
struct DiscreteSet{T<:AbstractArray} <: AbstractSet{T}
    items::T
end
randtype(s::DiscreteSet) = eltype(s.items)
Base.rand(s::DiscreteSet, dims::Integer...) = rand(s.items, dims...)
Base.in(x, s::DiscreteSet) = x in s.items
Base.length(s::DiscreteSet) = length(s.items)
Base.getindex(s::DiscreteSet, i::Int) = s.items[i]
Base.:(==)(s1::DiscreteSet, s2::DiscreteSet) = s1.items == s2.items


# operations on arrays of sets
randtype(sets::AbstractArray{S,N}) where {S <: AbstractSet, N} = Array{promote_type(map(randtype, sets)...), N}
Base.rand(sets::AbstractArray{S}) where S <: AbstractSet = eltype(randtype(sets))[rand(s) for s in sets]
function Base.rand(sets::AbstractArray{S}, dim1::Integer, dims::Integer...) where S <: AbstractSet
    A = Array{randtype(sets)}(undef, dim1, dims...)
    for i in eachindex(A)
        A[i] = rand(sets)
    end
    A
end
function Base.in(xs::AbstractArray, sets::AbstractArray{S}) where S <: AbstractSet
    size(xs) == size(sets) && all(map(in, xs, sets))
end


"Groups several heterogenous sets. Used mainly for proper dispatch."
struct TupleSet{T<:Tuple} <: AbstractSet{T}
    sets::T
end
TupleSet(sets::AbstractSet...) = TupleSet(sets)

# rand can return arrays or tuples, but defaults to arrays
randtype(sets::TupleSet, ::Type{Vector}) = Vector{promote_type(map(randtype, sets.sets)...)}
Base.rand(sets::TupleSet, ::Type{Vector}) = eltype(randtype(sets, Vector))[rand(s) for s in sets.sets]
randtype(sets::TupleSet, ::Type{Tuple}) = Tuple{map(randtype, sets.sets)...}
Base.rand(sets::TupleSet, ::Type{Tuple}) = map(rand, sets.sets)
function Base.rand(sets::TupleSet, ::Type{OT}, dim1::Integer, dims::Integer...) where OT
    A = Array{randtype(sets, OT)}(undef, dim1, dims...)
    for i in eachindex(A)
        A[i] = rand(sets, OT)
    end
    A
end
Base.length(sets::TupleSet) = sum(length(s) for s in sets.sets)
Base.iterate(sets::TupleSet) = iterate(sets.sets)
Base.iterate(sets::TupleSet, i) = iterate(sets.sets, i)

randtype(sets::TupleSet) = randtype(sets, Vector)
Base.rand(sets::TupleSet, dims::Integer...) = rand(sets, Vector, dims...)
Base.in(x, sets::TupleSet) = all(map(in, x, sets.sets))

"Returns an AbstractSet representing valid input values"
function inputdomain end

"Returns an AbstractSet representing valid output/target values"
function targetdomain end


export

    # Types
    Cost,
        Loss,
            SupervisedLoss,
                MarginLoss,
                DistanceLoss,
            UnsupervisedLoss,
        Penalty,

    Transformation,
        Learnable,
        StochasticTransformation,

    Minimizable,

    AbstractSet,
        IntervalSet,
        DiscreteSet,
        TupleSet,

    # Functions
    getobs,
    getobs!,

    scaled,

    learn,
    learn!,
    update,
    update!,
    transform,
    transform!,
    value,
    value!,
    meanvalue,
    sumvalue,
    meanderiv,
    sumderiv,
    deriv,
    deriv!,
    params,
    params!,
    grad,
    grad!,
    addgrad!,
    deriv2,
    value_deriv,
    value_deriv!,
    value_grad,
    value_grad!,
    prox,
    prox!,
    inputdomain,
    targetdomain,

    isminimizable,
    isdifferentiable,
    istwicedifferentiable,
    isconvex,
    isstrictlyconvex,
    isstronglyconvex,
    isnemitski,
    isunivfishercons,
    isfishercons,
    islipschitzcont,
    islocallylipschitzcont,
    islipschitzcont_deriv,
    isclipable,
    ismarginbased,
    isclasscalibrated,
    isdistancebased,

    # LinearAlgebra
    issymmetric,

    getobs,
    getobs!,
    datasubset,
    ObsDim,

    targets,

    AbstractDataIterator,
        AbstractObsIterator,
        AbstractBatchIterator,

    DataView,
        AbstractObsView,
        AbstractBatchView,

    DataIterator,
        ObsIterator,
        BatchIterator,

    # StatsBase
    fit,
    fit!,
    nobs

end # module
