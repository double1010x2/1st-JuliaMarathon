struct DataValue{T}
    hasvalue::Bool
    value::T

    DataValue{T}() where {T} = new(false)
    DataValue{T}(value::T, hasvalue::Bool=true) where {T} = new(hasvalue, value)
end

struct DataValueException <: Exception
end

const NA = DataValue{Union{}}()

DataValue(value::T, hasvalue::Bool=true) where {T} = DataValue{T}(value, hasvalue)
DataValue(value::Missing) = DataValue{Union{}}()
DataValue{T}(::Missing) where T = DataValue{T}()
DataValue() = DataValue{Union{}}()
DataValue{T}(value::Any) where T = DataValue{T}(convert(T, value), true)

Base.eltype(::Type{DataValue{T}}) where {T} = T

Base.convert(::Type{DataValue{T}}, x::DataValue{T}) where {T} = x
Base.convert(::Type{DataValue}, x::DataValue) = x

Base.convert(t::Type{DataValue{T}}, x::Any) where {T} = convert(t, convert(T, x))

function Base.convert(::Type{DataValue{T}}, x::DataValue) where {T}
    return isna(x) ? DataValue{T}() : DataValue{T}(convert(T, unsafe_get(x)))
end

Base.convert(::Type{DataValue{T}}, x::T) where {T} = DataValue{T}(x)
Base.convert(::Type{DataValue}, x::T) where {T} = DataValue{T}(x)

Base.convert(::Type{DataValue{T}}, ::Missing) where {T} = DataValue{T}()
Base.convert(::Type{DataValue}, ::Missing) = DataValue{Union{}}()

Base.convert(::Type{DataValue{T}}, ::Nothing) where {T} = DataValue{T}()
Base.convert(::Type{DataValue}, ::Nothing) = DataValue{Union{}}()

Base.convert(::Type{Union{Missing, T}}, value::DataValues.DataValue{T}) where T = get(value, missing)
Base.convert(::Type{Union{Missing, T}}, ::DataValues.DataValue{Union{}}) where T = missing
Base.convert(::Type{Any}, ::DataValue{Union{}}) = NA
Base.convert(::Type{Missing}, ::DataValue{Union{}}) = missing

Base.promote_rule(::Type{DataValue{S}}, ::Type{T}) where {S,T} = DataValue{promote_type(S, T)}
Base.promote_rule(::Type{DataValue{T}}, ::Type{Any}) where {T} = DataValue{Any}
Base.promote_rule(::Type{DataValue{Union{}}}, ::Type{Any}) = DataValue{Any}
Base.promote_rule( ::Type{Any}, ::Type{DataValue{Union{}}}) = DataValue{Any}
Base.promote_rule(::Type{DataValue{S}}, ::Type{DataValue{T}}) where {S,T} = DataValue{promote_type(S, T)}
Base.promote_op(op::Any, ::Type{DataValue{S}}, ::Type{DataValue{T}}) where {S,T} = DataValue{Base.promote_op(op, S, T)}

function Base.show(io::IO, x::DataValue{T}) where {T}
    if get(io, :compact, false)
        if isna(x)
            print(io, "#NA")
        else
            show(io, unsafe_get(x))
        end
    else
        print(io, "DataValue{")
        show(IOContext(io, :compact => true), eltype(x))
        print(io, "}(")
        if !isna(x)
            show(IOContext(io, :compact => true), unsafe_get(x))
        end
        print(io, ')')
    end
end

@inline function Base.get(x::DataValue{S}, y::T) where {S,T}
    if isbitstype(S)
        ifelse(isna(x), y, unsafe_get(x))
    else
        isna(x) ? y : unsafe_get(x)
    end
end

Base.get(x::DataValue) = isna(x) ? throw(DataValueException()) : unsafe_get(x)

"""
    getindex(x::DataValue)

Attempt to access the value of `x`. Throw a `DataValueException` if the
value is not present. Usually, this is written as `x[]`.
"""
Base.getindex(x::DataValue) = isna(x) ? throw(DataValueException()) : unsafe_get(x)

Base.get(x::DataValue{Union{}}) = throw(DataValueException())
Base.get(x::DataValue{Union{}}, y) = y

unsafe_get(x::DataValue) = x.value

isna(x) = false
isna(x::DataValue) = !x.hasvalue

hasvalue(x::DataValue) = x.hasvalue

const DataValuehash_seed = UInt === UInt64 ? 0x932e0143e51d0171 : 0xe51d0171

function Base.hash(x::DataValue, h::UInt)
    if isna(x)
        return h + DataValuehash_seed
    else
        return hash(unsafe_get(x), h)
    end
end

# TODO This is type piracy, but I think ok for now
function Base.hash(x::DataValue{Union{}}, h::UInt)
    return h + DataValuehash_seed
end

import Base.==
import Base.!=

Base.zero(::Type{DataValues.DataValue{T}}) where {T <: Number} = DataValue{T}(zero(T))
Base.zero(x::DataValues.DataValue{T}) where {T <: Number} = DataValue{T}(zero(T))
Base.zero(::Type{DataValue{T}}) where {T<:Dates.Period} = DataValue{T}(zero(T))
Base.zero(x::DataValues.DataValue{T}) where {T<:Dates.Period}= DataValue{T}(zero(T))

# C# spec section 7.10.9

==(a::DataValue{T},b::DataValue{Union{}}) where {T} = isna(a)
==(a::DataValue{Union{}},b::DataValue{T}) where {T} = isna(b)
==(a::DataValue{Union{}}, b::DataValue{Union{}}) = true
!=(a::DataValue{T},b::DataValue{Union{}}) where {T} = !isna(a)
!=(a::DataValue{Union{}},b::DataValue{T}) where {T} = !isna(b)
!=(a::DataValue{Union{}}, b::DataValue{Union{}}) = false

# Strings

for op in (:lowercase,:uppercase,:reverse,:uppercasefirst,:lowercasefirst,:chop,:chomp)
    @eval begin
        function Base.$op(x::DataValue{T}) where {T <: AbstractString}
            if isna(x)
                return DataValue{T}()
            else
                return DataValue($op(unsafe_get(x)))
            end
        end
    end
end

function Base.rstrip(f, s::DataValue{T}) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(rstrip(f, unsafe_get(s)))
end
function Base.rstrip(s::DataValue{T}, chars::Base.Chars) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(rstrip(unsafe_get(s), chars))
end
function Base.rstrip(s::DataValue{T}) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(rstrip(unsafe_get(s)))
end

function Base.lstrip(f, s::DataValue{T}) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(lstrip(f, unsafe_get(s)))
end
function Base.lstrip(s::DataValue{T}, chars::Base.Chars) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(lstrip(unsafe_get(s), chars))
end
function Base.lstrip(s::DataValue{T}) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(lstrip(unsafe_get(s)))
end

function Base.strip(s::DataValue{T}, chars::Base.Chars) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(strip(unsafe_get(s), chars))
end
function Base.strip(s::DataValue{T}) where {T <: AbstractString}
    return isna(s) ? DataValue{SubString{T}}() : DataValue(strip(unsafe_get(s)))
end

import Base.getindex
function Base.getindex(s::DataValue{T},i) where {T <: AbstractString}
    if isna(s)
        return DataValue{T}()
    else
        return DataValue(unsafe_get(s)[i])
    end
end

function Base.lastindex(s::DataValue{T}) where {T <: AbstractString}
    if isna(s)
        # TODO Decide whether this makes sense?
        return 0
    else
        return lastindex(unsafe_get(s))
    end
end

import Base.length
function length(s::DataValue{T}) where {T <: AbstractString}
    if isna(s)
        return DataValue{Int}()
    else
        return DataValue{Int}(length(unsafe_get(s)))
    end
end

# C# spec section 7.3.7

for op in (:+, :-, :!, :~)
    @eval begin
        import Base.$(op)
        $op(x::DataValue{T}) where {T <: Number} = isna(x) ? DataValue{T}() : DataValue($op(unsafe_get(x)))
    end
end


for op in (:+, :-, :*, :/, :%, :&, :|, :^, :<<, :>>, :min, :max)
    @eval begin
        import Base.$(op)
        $op(a::DataValue{T1},b::DataValue{T2}) where {T1 <: Number,T2 <: Number} = isna(a) || isna(b) ? DataValue{promote_type(T1,T2)}() : DataValue{promote_type(T1,T2)}($op(unsafe_get(a), unsafe_get(b)))
        $op(x::DataValue{T1},y::T2) where {T1 <: Number,T2 <: Number} = isna(x) ? DataValue{promote_type(T1,T2)}() : DataValue{promote_type(T1,T2)}($op(unsafe_get(x), y))
        $op(x::T1,y::DataValue{T2}) where {T1 <: Number,T2 <: Number} = isna(y) ? DataValue{promote_type(T1,T2)}() : DataValue{promote_type(T1,T2)}($op(x, unsafe_get(y)))
    end
end

^(x::DataValue{T},p::Integer) where {T <: Number} = isna(x) ? DataValue{T}() : DataValue(unsafe_get(x)^p)
(/)(x::DataValue{T}, y::DataValue{S}) where {T<:Integer,S<:Integer} = (isna(x) | isna(y)) ? DataValue{Float64}() : DataValue{Float64}(float(unsafe_get(x)) / float(unsafe_get(y)))
(/)(x::DataValue{T}, y::S) where {T<:Integer,S<:Integer} = isna(x) ? DataValue{Float64}() : DataValue{Float64}(float(unsafe_get(x)) / float(y))
(/)(x::T, y::DataValue{S}) where {T<:Integer,S<:Integer} = isna(y) ? DataValue{Float64}() : DataValue{Float64}(float(x) / float(unsafe_get(y)))

==(a::DataValue{T1},b::DataValue{T2}) where {T1,T2} = isna(a) && isna(b) ? true : !isna(a) && !isna(b) ? unsafe_get(a)==unsafe_get(b) : false
==(a::DataValue{T1},b::T2) where {T1,T2} = isna(a) ? false : unsafe_get(a)==b
==(a::T1,b::DataValue{T2}) where {T1,T2} = isna(b) ? false : a==unsafe_get(b)

!=(a::DataValue{T1},b::DataValue{T2}) where {T1,T2} = isna(a) && isna(b) ? false : !isna(a) && !isna(b) ? unsafe_get(a)!=unsafe_get(b) : true
!=(a::DataValue{T1},b::T2) where {T1,T2} = isna(a) ? true : unsafe_get(a)!=b
!=(a::T1,b::DataValue{T2}) where {T1,T2} = isna(b) ? true : a!=unsafe_get(b)

for op in (:<,:>,:<=,:>=)
    @eval begin
        import Base.$(op)
        $op(a::DataValue{T},b::DataValue{T}) where {T <: Number} = isna(a) || isna(b) ? false : $op(unsafe_get(a), unsafe_get(b))
        $op(x::DataValue{T1},y::T2) where {T1 <: Number,T2 <: Number} = isna(x) ? false : $op(unsafe_get(x), y)
        $op(x::T1,y::DataValue{T2}) where {T1 <: Number,T2 <: Number} = isna(y) ? false : $op(x, unsafe_get(y))
    end
end

# C# spec 7.11.4
function (&)(x::DataValue{Bool},y::DataValue{Bool})
    if isna(x)
        if isna(y) || unsafe_get(y)==true
            return DataValue{Bool}()
        else
            return DataValue(false)
        end
    elseif unsafe_get(x)==true
        return y
    else
        return DataValue(false)
    end
end

(&)(x::Bool,y::DataValue{Bool}) = x ? y : DataValue(false)
(&)(x::DataValue{Bool},y::Bool) = y ? x : DataValue(false)

function (|)(x::DataValue{Bool},y::DataValue{Bool})
    if isna(x)
        if isna(y) || !unsafe_get(y)
            return DataValue{Bool}()
        else
            return DataValue(true)
        end
    elseif unsafe_get(x)
        return DataValue(true)
    else
        return y
    end
end

(|)(x::Bool,y::DataValue{Bool}) = x ? DataValue(true) : y
(|)(x::DataValue{Bool},y::Bool) = y ? DataValue(true) : x

import Base.isless
function isless(x::DataValue{S}, y::DataValue{T}) where {S,T}
    if isna(x)
        return false
    elseif isna(y)
        return true
    else
        return isless(unsafe_get(x), unsafe_get(y))
    end
end

isless(x::S, y::DataValue{T}) where {S,T} = isna(y) ? true : isless(x, unsafe_get(y))

isless(x::DataValue{S}, y::T) where {S,T} = isna(x) ? false : isless(unsafe_get(x), y)

isless(x::DataValue{Union{}}, y::DataValue{Union{}}) = false

isless(x, y::DataValue{Union{}}) = true

isless(x::DataValue{Union{}}, y) = false

# TODO Is that the definition we want?
function Base.isnan(x::DataValue{T}) where {T<:AbstractFloat}
    return !isna(x) && isnan(unsafe_get(x))
end

# TODO Is that the definition we want?
function Base.isfinite(x::DataValue{T}) where {T<:AbstractFloat}
    return !isna(x) && isfinite(unsafe_get(x))
end

function Base.float(x::DataValue{T}) where T
    return isna(x) ? DataValue{Float64}() : DataValue{Float64}(float(unsafe_get(x)))
end

# DataValueInterfaces definitions
using DataValueInterfaces
DataValueInterfaces.nondatavaluetype(::Type{DataValue{T}}) where {T} = Union{T, Missing}
DataValueInterfaces.datavaluetype(::Type{T}) where {T <: DataValue} = T
DataValueInterfaces.datavaluetype(::Type{Union{T, Missing}}) where {T} = DataValue{T}
DataValueInterfaces.datavaluetype(::Type{Missing}) = DataValue{Union{}}
