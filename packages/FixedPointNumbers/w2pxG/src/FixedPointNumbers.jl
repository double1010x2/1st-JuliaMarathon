module FixedPointNumbers

import Base: ==, <, <=, -, +, *, /, ~, isapprox,
             convert, promote_rule, show, isinteger, abs, decompose,
             isnan, isinf, isfinite,
             zero, oneunit, one, typemin, typemax, floatmin, floatmax, eps, sizeof, reinterpret,
             float, trunc, round, floor, ceil, bswap,
             div, fld, rem, mod, mod1, fld1, min, max, minmax,
             rand, length

using Base.Checked: checked_add, checked_sub, checked_div

using Base: @pure

"""
    FixedPoint{T <: Integer, f} <: Real

Supertype of the two fixed-point number types: `Fixed{T, f}` and `Normed{T, f}`.

The parameter `T` is the underlying machine representation and `f` is the number
of fraction bits.
"""
abstract type FixedPoint{T <: Integer, f} <: Real end


export
    FixedPoint,
    Fixed,
    Normed,
    floattype,
# "special" typealiases
    # Q and N typealiases are exported in separate source files
# Functions
    scaledual

include("utilities.jl")

# reinterpretation
reinterpret(x::FixedPoint) = x.i
reinterpret(::Type{T}, x::FixedPoint{T,f}) where {T,f} = x.i
reinterpret(::Type{X}, x::T) where {T <: Integer, X <: FixedPoint{T}} = X(x, 0)

# static parameters
nbitsfrac(::Type{X}) where {T, f, X <: FixedPoint{T,f}} = f
rawtype(::Type{X}) where {T, X <: FixedPoint{T}} = T

# construction using the (approximate) intended value, i.e., N0f8
*(x::Real, ::Type{X}) where {X <: FixedPoint} = _convert(X, x)

# constructor-style conversions
(::Type{X})(x::Real) where {X <: FixedPoint} = _convert(X, x)

function (::Type{<:FixedPoint})(x::AbstractChar)
    throw(ArgumentError("FixedPoint (Fixed or Normed) cannot be constructed from a Char"))
end
(::Type{X})(x::Complex) where {X <: FixedPoint} = X(convert(real(typeof(x)), x))
function (::Type{X})(x::Base.TwicePrecision) where {X <: FixedPoint}
    floattype(X) === BigFloat ? X(big(x)) : X(convert(floattype(X), x))
end

# conversions
function Base.Bool(x::FixedPoint)
    x == zero(x) ? false : x == oneunit(x) ? true : throw(InexactError(:Bool, Bool, x))
end
function (::Type{Ti})(x::FixedPoint) where {Ti <: Integer}
    isinteger(x) || throw(InexactError(:Integer, typeof(x), x))
    floor(Ti, x)
end
Base.Rational{Ti}(x::FixedPoint) where {Ti <: Integer} = Rational{Ti}(Rational(x))

"""
    isapprox(x::FixedPoint, y::FixedPoint; rtol=0, atol=max(eps(x), eps(y)))

For FixedPoint numbers, the default criterion is that `x` and `y` differ by no more than `eps`, the separation between adjacent fixed-point numbers.
"""
function isapprox(x::T, y::T; rtol=0, atol=max(eps(x), eps(y))) where {T <: FixedPoint}
    maxdiff = T(atol+rtol*max(abs(x), abs(y)))
    rx, ry, rd = reinterpret(x), reinterpret(y), reinterpret(maxdiff)
    abs(signed(widen1(rx))-signed(widen1(ry))) <= rd
end
function isapprox(x::FixedPoint, y::FixedPoint; rtol=0, atol=max(eps(x), eps(y)))
    isapprox(promote(x, y)...; rtol=rtol, atol=atol)
end

# predicates
isinteger(x::FixedPoint) = x == trunc(x) # TODO: use floor(x) when dropping support for Fixed{Int8,8}
isfinite(x::FixedPoint) = true
isnan(x::FixedPoint) = false
isinf(x::FixedPoint) = false

# identities
zero(::Type{X}) where {X <: FixedPoint} = X(zero(rawtype(X)), 0)
oneunit(::Type{X}) where {X <: FixedPoint} = X(rawone(X), 0)
one(::Type{X}) where {X <: FixedPoint} = oneunit(X)

# for Julia v1.0, which does not fold `div_float` before inlining
inv_rawone(x) = (@generated) ? (y = 1.0 / rawone(x); :($y)) : 1.0 / rawone(x)

# traits
sizeof(::Type{X}) where {X <: FixedPoint} = sizeof(rawtype(X))
eps(::Type{X}) where {X <: FixedPoint} = X(oneunit(rawtype(X)), 0)
typemax(::Type{T}) where {T <: FixedPoint} = T(typemax(rawtype(T)), 0)
typemin(::Type{T}) where {T <: FixedPoint} = T(typemin(rawtype(T)), 0)
floatmin(::Type{T}) where {T <: FixedPoint} = eps(T)
floatmax(::Type{T}) where {T <: FixedPoint} = typemax(T)


"""
    floattype(::Type{T})

Return the minimum float type that represents `T` without overflow to `Inf`.

# Example

A classic usage is to avoid overflow behavior by promoting `FixedPoint` to `AbstractFloat`

```julia
julia> x = N0f8(1.0)
1.0N0f8

julia> x + x # overflow
0.996N0f8

julia> float_x = floattype(eltype(x))(x)
1.0f0

julia> float_x + float_x
2.0f0
```
"""
floattype(::Type{T}) where {T <: Real} = T # fallback
floattype(::Type{T}) where {T <: Union{ShortInts, Bool}} = Float32
floattype(::Type{T}) where {T <: Integer} = Float64
floattype(::Type{T}) where {T <: LongInts} = BigFloat
floattype(::Type{X}) where {T <: ShortInts, X <: FixedPoint{T}} = Float32
floattype(::Type{X}) where {T <: Integer, X <: FixedPoint{T}} = Float64
floattype(::Type{X}) where {T <: LongInts, X <: FixedPoint{T}} = BigFloat

float(x::FixedPoint) = convert(floattype(x), x)

function minmax(x::X, y::X) where {X <: FixedPoint}
    a, b = minmax(reinterpret(x), reinterpret(y))
    X(a,0), X(b,0)
end

bswap(x::X) where {X <: FixedPoint} = sizeof(X) == 1 ? x : X(bswap(x.i), 0)

for f in (:zero, :oneunit, :one, :eps, :rawone, :rawtype, :floattype)
    @eval begin
        $f(x::FixedPoint) = $f(typeof(x))
    end
end
for f in (:(==), :<, :<=, :div, :fld, :fld1)
    @eval begin
        $f(x::X, y::X) where {X <: FixedPoint} = $f(x.i, y.i)
    end
end
for f in (:-, :~, :abs)
    @eval begin
        $f(x::X) where {X <: FixedPoint} = X($f(x.i), 0)
    end
end
for f in (:+, :-, :rem, :mod, :mod1, :min, :max)
    @eval begin
        $f(x::X, y::X) where {X <: FixedPoint} = X($f(x.i, y.i), 0)
    end
end
for (m, f) in ((:(:Nearest), :round),
               (:(:ToZero), :trunc),
               (:(:Up), :ceil),
               (:(:Down), :floor))
    @eval begin
        round(x::FixedPoint, ::RoundingMode{$m}) = $f(x)
        round(::Type{Ti}, x::FixedPoint, ::RoundingMode{$m}) where {Ti <: Integer} = $f(Ti, x)
    end
end

function length(r::StepRange{X,X}) where {X <: FixedPoint{<:ShorterThanInt}}
    start, step, stop = Int(reinterpret(r.start)), Int(reinterpret(r.step)), Int(reinterpret(r.stop))
    return div((stop - start) + step, step)
end
function length(r::StepRange{X,X}) where {X <: FixedPoint}
    start, step, stop = reinterpret(r.start), reinterpret(r.step), reinterpret(r.stop)
    return checked_div(checked_add(checked_sub(stop, start), step), step)
end
function length(r::StepRange{<:FixedPoint})
    start, step, stop = float(r.start), r.step, float(r.stop)
    return div((stop - start) + step, step)
end

# Printing. These are used to generate type-symbols, so we need them
# before we include any files.
function showtype(io::IO, ::Type{X}) where {X <: FixedPoint}
    print(io, typechar(X))
    f = nbitsfrac(X)
    m = bitwidth(X)-f-signbits(X)
    print(io, m, 'f', f)
    io
end
function show(io::IO, x::FixedPoint{T,f}) where {T,f}
    log10_2 = 0.3010299956639812
    show(io, round(convert(Float64,x), digits=ceil(Int, f * log10_2)))
    get(io, :compact, false) || showtype(io, typeof(x))
end

function Base.showarg(io::IO, a::Array{T}, toplevel) where {T<:FixedPoint}
    toplevel || print(io, "::")
    print(io, "Array{")
    showtype(io, T)
    print(io, ",$(ndims(a))}")
    toplevel && print(io, " with eltype ", T)
end

include("fixed.jl")
include("normed.jl")
include("deprecations.jl")
const UF = (N0f8, N6f10, N4f12, N2f14, N0f16)

# Promotions for reductions
const Treduce = Float64
Base.add_sum(x::FixedPoint, y::FixedPoint) = Treduce(x) + Treduce(y)
Base.reduce_empty(::typeof(Base.add_sum), ::Type{F}) where {F<:FixedPoint}  = zero(Treduce)
Base.reduce_first(::typeof(Base.add_sum), x::FixedPoint)   = Treduce(x)
Base.mul_prod(x::FixedPoint, y::FixedPoint) = Treduce(x) * Treduce(y)
Base.reduce_empty(::typeof(Base.mul_prod), ::Type{F}) where {F<:FixedPoint} = one(Treduce)
Base.reduce_first(::typeof(Base.mul_prod), x::FixedPoint)  = Treduce(x)


"""
    sd, ad = scaledual(s::Number, a)

Return `sd` and `ad` such that `sd * ad == s * a`.
When `a` is an array of FixedPoint numbers, `sd*ad` might be faster to compute than `s*a`.
"""
scaledual(b::Number, x::Union{Number,AbstractArray{<:Number}}) = b, x
scaledual(b::Number, x::FixedPoint) = b/rawone(x), reinterpret(x)
scaledual(b::Number, x::AbstractArray{T}) where T <: FixedPoint =
    b/rawone(T), reinterpret(rawtype(T), x)

scaledual(::Type{Tdual}, x::Union{Number,AbstractArray{<:Number}}) where Tdual = oneunit(Tdual), x
scaledual(::Type{Tdual}, x::FixedPoint) where Tdual = convert(Tdual, 1/rawone(x)), reinterpret(x)
scaledual(::Type{Tdual}, x::AbstractArray{T}) where {Tdual, T <: FixedPoint} =
    convert(Tdual, 1/rawone(T)), reinterpret(rawtype(T), x)

@noinline function throw_converterror(::Type{X}, x) where {X <: FixedPoint}
    n = 2^bitwidth(X)
    bitstring = bitwidth(X) == 8 ? "an 8-bit" : "a $(bitwidth(X))-bit"
    io = IOBuffer()
    show(IOContext(io, :compact=>true), typemin(X)); Xmin = String(take!(io))
    show(IOContext(io, :compact=>true), typemax(X)); Xmax = String(take!(io))
    throw(ArgumentError("$X is $bitstring type representing $n values from $Xmin to $Xmax; cannot represent $x"))
end

rand(::Type{T}) where {T <: FixedPoint} = reinterpret(T, rand(rawtype(T)))
rand(::Type{T}, sz::Dims) where {T <: FixedPoint} = reinterpret(T, rand(rawtype(T), sz))

if VERSION >= v"1.1" # work around https://github.com/JuliaLang/julia/issues/34121
    include("precompile.jl")
    _precompile_()
end

end # module
