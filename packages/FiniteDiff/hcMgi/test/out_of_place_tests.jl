using FiniteDiff, LinearAlgebra, SparseArrays, Test, StaticArrays

function f(x)
  xm1 = [0;x[1:end-1]]
  xp1 = [x[2:end];0]
  xm1 - 2x + xp1
end

function second_derivative_stencil(N)
  A = zeros(N,N)
  for i in 1:N, j in 1:N
      (j-i==-1 || j-i==1) && (A[i,j]=1)
      j-i==0 && (A[i,j]=-2)
  end
  A
end

x = @SVector ones(30)
J = FiniteDiff.finite_difference_jacobian(f,x, Val{:forward}, eltype(x))
@test J ≈ second_derivative_stencil(30)

J = FiniteDiff.finite_difference_jacobian(f,x, Val{:central}, eltype(x))
@test J ≈ second_derivative_stencil(30)

J = FiniteDiff.finite_difference_jacobian(f,x, Val{:complex}, eltype(x))
@test J ≈ second_derivative_stencil(30)

spJ = sparse(second_derivative_stencil(30))
J = FiniteDiff.finite_difference_jacobian(f,x, Val{:forward}, eltype(x),jac_prototype=spJ)
@test J ≈ second_derivative_stencil(30)
@test typeof(J) == typeof(spJ)
J = FiniteDiff.finite_difference_jacobian(f,x, Val{:forward}, eltype(x),colorvec=repeat(1:3,10),sparsity=spJ,jac_prototype=spJ)
@test J ≈ second_derivative_stencil(30)
@test typeof(J) == typeof(spJ)
#1x1 SVector test
x = SVector{1}([1.])
f(x) = x
J = FiniteDiff.finite_difference_jacobian(f, x, Val{:forward}, eltype(x))
@test J ≈ SMatrix{1,1}([1.])
J = FiniteDiff.finite_difference_jacobian(f, x, Val{:central}, eltype(x))
@test J ≈ SMatrix{1,1}([1.])
J = FiniteDiff.finite_difference_jacobian(f, x, Val{:complex}, eltype(x))
@test J ≈ SMatrix{1,1}([1.])
