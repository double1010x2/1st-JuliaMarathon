"""
    Tangent{P, T} <: AbstractTangent

This type represents the differential for a `struct`/`NamedTuple`, or `Tuple`.
`P` is the the corresponding primal type that this is a differential for.

`Tangent{P}` should have fields (technically properties), that match to a subset of the
fields of the primal type; and each should be a differential type matching to the primal
type of that field.
Fields of the P that are not present in the Tangent are treated as `Zero`.

`T` is an implementation detail representing the backing data structure.
For Tuple it will be a Tuple, and for everything else it will be a `NamedTuple`.
It should not be passed in by user.

For `Tangent`s of `Tuple`s, `iterate` and `getindex` are overloaded to behave similarly
to for a tuple.
For `Tangent`s of `struct`s, `getproperty` is overloaded to allow for accessing values
via `comp.fieldname`.
Any fields not explictly present in the `Tangent` are treated as being set to `ZeroTangent()`.
To make a `Tangent` have all the fields of the primal the [`canonicalize`](@ref)
function is provided.
"""
struct Tangent{P, T} <: AbstractTangent
    # Note: If T is a Tuple/Dict, then P is also a Tuple/Dict
    # (but potentially a different one, as it doesn't contain differentials)
    backing::T
end

function Tangent{P}(; kwargs...) where P
    backing = (; kwargs...)  # construct as NamedTuple
    return Tangent{P, typeof(backing)}(backing)
end

function Tangent{P}(args...) where P
    return Tangent{P, typeof(args)}(args)
end

function Tangent{P}() where P<:Tuple
    backing = ()
    return Tangent{P, typeof(backing)}(backing)
end

function Tangent{P}(d::Dict) where {P<:Dict}
    return Tangent{P, typeof(d)}(d)
end

function Base.:(==)(a::Tangent{P, T}, b::Tangent{P, T}) where {P, T}
    return backing(a) == backing(b)
end
function Base.:(==)(a::Tangent{P}, b::Tangent{P}) where {P, T}
    all_fields = union(keys(backing(a)), keys(backing(b)))
    return all(getproperty(a, f) == getproperty(b, f) for f in all_fields)
end
Base.:(==)(a::Tangent{P}, b::Tangent{Q}) where {P, Q} = false

Base.hash(a::Tangent, h::UInt) = Base.hash(backing(canonicalize(a)), h)

function Base.show(io::IO, comp::Tangent{P}) where P
    print(io, "Tangent{")
    show(io, P)
    print(io, "}")
    if isempty(backing(comp))
        print(io, "()")  # so it doesn't show `NamedTuple()`
    else
        # allow Tuple or NamedTuple `show` to do the rendering of brackets etc
        show(io, backing(comp))
    end
end

Base.getindex(comp::Tangent, idx) = getindex(backing(comp), idx)

# for Tuple
Base.getproperty(comp::Tangent, idx::Int) = unthunk(getproperty(backing(comp), idx))
function Base.getproperty(
    comp::Tangent{P, T}, idx::Symbol
) where {P, T<:NamedTuple}
    hasfield(T, idx) || return ZeroTangent()
    return unthunk(getproperty(backing(comp), idx))
end

Base.keys(comp::Tangent) = keys(backing(comp))
Base.propertynames(comp::Tangent) = propertynames(backing(comp))

Base.haskey(comp::Tangent, key) = haskey(backing(comp), key)
if isdefined(Base, :hasproperty)
    Base.hasproperty(comp::Tangent, key::Symbol) = hasproperty(backing(comp), key)
end

Base.iterate(comp::Tangent, args...) = iterate(backing(comp), args...)
Base.length(comp::Tangent) = length(backing(comp))
Base.eltype(::Type{<:Tangent{<:Any, T}}) where T = eltype(T)
function Base.reverse(comp::Tangent)
    rev_backing = reverse(backing(comp))
    Tangent{typeof(rev_backing), typeof(rev_backing)}(rev_backing)
end

function Base.indexed_iterate(comp::Tangent{P,<:Tuple}, i::Int, state=1) where {P}
    return Base.indexed_iterate(backing(comp), i, state)
end

function Base.map(f, comp::Tangent{P, <:Tuple}) where P
    vals::Tuple = map(f, backing(comp))
    return Tangent{P, typeof(vals)}(vals)
end
function Base.map(f, comp::Tangent{P, <:NamedTuple{L}}) where{P, L}
    vals = map(f, Tuple(backing(comp)))
    named_vals = NamedTuple{L, typeof(vals)}(vals)
    return Tangent{P, typeof(named_vals)}(named_vals)
end
function Base.map(f, comp::Tangent{P, <:Dict}) where {P<:Dict}
    return Tangent{P}(Dict(k => f(v) for (k, v) in backing(comp)))
end

Base.conj(comp::Tangent) = map(conj, comp)

"""
    backing(x)

Accesses the backing field of a `Tangent`,
or destructures any other composite type into a `NamedTuple`.
Identity function on `Tuple`. and `NamedTuple`s.

This is an internal function used to simplify operations between `Tangent`s and the
primal types.
"""
backing(x::Tuple) = x
backing(x::NamedTuple) = x
backing(x::Dict) = x
backing(x::Tangent) = getfield(x, :backing)

# For generic structs
function backing(x::T)::NamedTuple where T
    # note: all computation outside the if @generated happens at runtime.
    # so the first 4 lines of the branchs look the same, but can not be moved out.
    # see https://github.com/JuliaLang/julia/issues/34283
    if @generated
        !isstructtype(T) && throw(DomainError(T, "backing can only be use on composite types"))
        nfields = fieldcount(T)
        names = fieldnames(T)
        types = fieldtypes(T)

        vals = Expr(:tuple, ntuple(ii->:(getfield(x, $ii)), nfields)...)
        return :(NamedTuple{$names, Tuple{$(types...)}}($vals))
    else
        !isstructtype(T) && throw(DomainError(T, "backing can only be use on composite types"))
        nfields = fieldcount(T)
        names = fieldnames(T)
        types = fieldtypes(T)

        vals = ntuple(ii->getfield(x, ii), nfields)
        return NamedTuple{names, Tuple{types...}}(vals)
    end
end

"""
    canonicalize(comp::Tangent{P}) -> Tangent{P}

Return the canonical `Tangent` for the primal type `P`.
The property names of the returned `Tangent` match the field names of the primal,
and all fields of `P` not present in the input `comp` are explictly set to `ZeroTangent()`.
"""
function canonicalize(comp::Tangent{P, <:NamedTuple{L}}) where {P,L}
    nil = _zeroed_backing(P)
    combined = merge(nil, backing(comp))
    if length(combined) !== fieldcount(P)
        throw(ArgumentError(
            "Tangent fields do not match primal fields.\n" *
            "Tangent fields: $L. Primal ($P) fields: $(fieldnames(P))"
        ))
    end
    return Tangent{P, typeof(combined)}(combined)
end

# Tuple composites are always in their canonical form
canonicalize(comp::Tangent{<:Tuple, <:Tuple}) = comp

# Dict composite are always in their canonical form.
canonicalize(comp::Tangent{<:Any, <:AbstractDict}) = comp

# Tangents of unspecified primal types (indicated by specifying exactly `Any`)
# all combinations of type-params are specified here to avoid ambiguities
canonicalize(comp::Tangent{Any, <:NamedTuple{L}}) where {L} = comp
canonicalize(comp::Tangent{Any, <:Tuple}) where {L} = comp
canonicalize(comp::Tangent{Any, <:AbstractDict}) where {L} = comp

"""
    _zeroed_backing(P)

Returns a NamedTuple with same fields as `P`, and all values `ZeroTangent()`.
"""
@generated function _zeroed_backing(::Type{P}) where P
    nil_base = ntuple(fieldcount(P)) do i
        (fieldname(P, i), ZeroTangent())
    end
    return (; nil_base...)
end

"""
    construct(::Type{T}, fields::[NamedTuple|Tuple])

Constructs an object of type `T`, with the given fields.
Fields must be correct in name and type, and `T` must have a default constructor.

This internally is called to construct structs of the primal type `T`,
after an operation such as the addition of a primal to a composite.

It should be overloaded, if `T` does not have a default constructor,
or if `T` needs to maintain some invarients between its fields.
"""
function construct(::Type{T}, fields::NamedTuple{L}) where {T, L}
    # Tested and verified that that this avoids a ton of allocations
    if length(L) !== fieldcount(T)
        # if length is equal but names differ then we will catch that below anyway.
        throw(ArgumentError("Unmatched fields. Type: $(fieldnames(T)),  NamedTuple: $L"))
    end

    if @generated
        vals = (:(getproperty(fields, $(QuoteNode(fname)))) for fname in fieldnames(T))
        return :(T($(vals...)))
    else
        return T((getproperty(fields, fname) for fname in fieldnames(T))...)
    end
end

construct(::Type{T}, fields::T) where T<:NamedTuple = fields
construct(::Type{T}, fields::T) where T<:Tuple = fields

elementwise_add(a::Tuple, b::Tuple) = map(+, a, b)

function elementwise_add(a::NamedTuple{an}, b::NamedTuple{bn}) where {an, bn}
    # Rule of Tangent addition: any fields not present are implict hard Zeros

    # Base on the `merge(:;NamedTuple, ::NamedTuple)` code from Base.
    # https://github.com/JuliaLang/julia/blob/592748adb25301a45bd6edef3ac0a93eed069852/base/namedtuple.jl#L220-L231
    if @generated
        names = Base.merge_names(an, bn)

        vals = map(names) do field
            a_field = :(getproperty(a, $(QuoteNode(field))))
            b_field = :(getproperty(b, $(QuoteNode(field))))
            value_expr = if Base.sym_in(field, an)
                if Base.sym_in(field, bn)
                    # in both
                    :($a_field + $b_field)
                else
                    # only in `an`
                    a_field
                end
            else # must be in `b` only
                b_field
            end
            Expr(:kw, field, value_expr)
        end
        return Expr(:tuple, Expr(:parameters, vals...))
    else
        names = Base.merge_names(an, bn)
        vals = map(names) do field
            value = if Base.sym_in(field, an)
                a_field = getproperty(a, field)
                if Base.sym_in(field, bn)
                    # in both
                    b_field = getproperty(b, field)
                    a_field + b_field
                else
                    # only in `an`
                    a_field
                end
            else # must be in `b` only
                getproperty(b, field)
            end
            field => value
        end
        return (;vals...)
    end
end

elementwise_add(a::Dict, b::Dict) = merge(+, a, b)

struct PrimalAdditionFailedException{P} <: Exception
    primal::P
    differential::Tangent{P}
    original::Exception
end

function Base.showerror(io::IO, err::PrimalAdditionFailedException{P}) where {P}
    println(io, "Could not construct $P after addition.")
    println(io, "This probably means no default constructor is defined.")
    println(io, "Either define a default constructor")
    printstyled(io, "$P(", join(propertynames(err.differential), ", "), ")", color=:blue)
    println(io, "\nor overload")
    printstyled(io,
        "ChainRulesCore.construct(::Type{$P}, ::$(typeof(err.differential)))";
        color=:blue
    )
    println(io, "\nor overload")
    printstyled(io, "Base.:+(::$P, ::$(typeof(err.differential)))"; color=:blue)
    println(io, "\nOriginal Exception:")
    printstyled(io, err.original; color=:yellow)
    println(io)
end
