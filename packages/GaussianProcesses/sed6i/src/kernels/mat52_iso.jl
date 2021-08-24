# Matern 5/2 isotropic covariance function

"""
    Mat52Iso <: MaternIso

Isotropic Matern 5/2 kernel (covariance)
```math
k(x,x') = σ²(1+√5|x-x'|/ℓ + 5|x-x'|²/(3ℓ²))\\exp(- √5|x-x'|/ℓ)
```
with length scale ``ℓ`` and signal standard deviation ``σ``.
"""
mutable struct Mat52Iso{T<:Real} <: MaternIso
    "Length scale"
    ℓ::T
    "Signal variance"
    σ2::T
    "Priors for kernel parameters"
    priors::Array
end

"""
Matern 5/2 isotropic covariance function
    
    Mat52Iso(ll::Real, lσ::Real)

# Arguments
  - `ll::Real`: length scale (given on log scale)
  - `lσ::Real`: signal standard deviation (given on log scale)  
"""
Mat52Iso(ll::T, lσ::T) where T = Mat52Iso{T}(exp(ll), exp(2 * lσ), [])

function set_params!(mat::Mat52Iso, hyp::AbstractVector)
    length(hyp) == 2 || throw(ArgumentError("Matern 5/2 has two parameters, received $(length(hyp))."))
    mat.ℓ, mat.σ2 = exp(hyp[1]), exp(2 * hyp[2])
end
get_params(mat::Mat52Iso{T}) where T = T[log(mat.ℓ), log(mat.σ2) / 2]
get_param_names(mat::Mat52Iso) = [:ll, :lσ]
num_params(mat::Mat52Iso) = 2

cov(mat::Mat52Iso, r::Number) =
    (s = √5 * r / mat.ℓ; mat.σ2 * (1 + s + s^2 / 3) * exp(-s))

@inline dk_dll(mat::Mat52Iso, r::Real) =
    (s = √5 * r / mat.ℓ; mat.σ2 / 3 * s^2 * (1 + s) * exp(-s))
