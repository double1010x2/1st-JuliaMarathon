module Tables

using LinearAlgebra, DataValueInterfaces, DataAPI, TableTraits, IteratorInterfaceExtensions

export rowtable, columntable

if !hasmethod(getproperty, Tuple{Tuple, Int})
    Base.getproperty(t::Tuple, i::Int) = t[i]
end

"""
    Tables.AbstractColumns

An interface type defined as an ordered set of columns that support
retrieval of individual columns by name or index. A retrieved column
must be an indexable collection with known length, i.e. an object
that supports `length(col)` and `col[i]` for any `i = 1:length(col)`.
`Tables.columns` must return an object that satisfies the `Tables.AbstractColumns` interface.
While `Tables.AbstractColumns` is an abstract type that custom "columns" types may subtype for
useful default behavior (indexing, iteration, property-access, etc.), users should not use it
for dispatch, as Tables.jl interface objects ***are not required*** to subtype, but only
implement the required interface methods.

Interface definition:

| Required Methods                                         | Default Definition          | Brief Description                                                                                                                                            |
|----------------------------------------------------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Tables.getcolumn(table, i::Int)`                        | getfield(table, i)          | Retrieve a column by index                                                                                                                                   |
| `Tables.getcolumn(table, nm::Symbol)`                    | getproperty(table, nm)      | Retrieve a column by name                                                                                                                                    |
| `Tables.columnnames(table)`                              | propertynames(table)        | Return column names for a table as an indexable collection                                                                                                   |
| **Optional methods**                                     |                             |                                                                                                                                                              |
| `Tables.getcolumn(table, ::Type{T}, i::Int, nm::Symbol)` | Tables.getcolumn(table, nm) | Given a column eltype `T`, index `i`, and column name `nm`, retrieve the column. Provides a type-stable or even constant-prop-able mechanism for efficiency. |

While types aren't required to subtype `Tables.AbstractColumns`, benefits of doing so include:
  * Indexing interface defined (using `getcolumn`); i.e. `tbl[i]` will retrieve the column at index `i`
  * Property access interface defined (using `columnnames` and `getcolumn`); i.e. `tbl.col1` will retrieve column named `col1`
  * Iteration interface defined; i.e. `for col in table` will iterate each column in the table
  * `AbstractDict` methods defined (`get`, `haskey`, etc.) for checking and retrieving columns
  * A default `show` method
This allows a custom table type to behave as close as possible to a builtin `NamedTuple` of vectors object.
"""
abstract type AbstractColumns end

"""
    Tables.AbstractRow

Abstract interface type representing the expected `eltype` of the iterator returned from `Tables.rows(table)`.
`Tables.rows` must return an iterator of elements that satisfy the `Tables.AbstractRow` interface.
While `Tables.AbstractRow` is an abstract type that custom "row" types may subtype for
useful default behavior (indexing, iteration, property-access, etc.), users should not use it
for dispatch, as Tables.jl interface objects ***are not required*** to subtype, but only
implement the required interface methods.

Interface definition:

| Required Methods                                       | Default Definition        | Brief Description                                                                                                                                                |
|--------------------------------------------------------|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Tables.getcolumn(row, i::Int)`                        | getfield(row, i)          | Retrieve a column value by index                                                                                                                                 |
| `Tables.getcolumn(row, nm::Symbol)`                    | getproperty(row, nm)      | Retrieve a column value by name                                                                                                                                  |
| `Tables.columnnames(row)`                              | propertynames(row)        | Return column names for a row as an indexable collection                                                                                                         |
| **Optional methods**                                   |                           |                                                                                                                                                                  |
| `Tables.getcolumn(row, ::Type{T}, i::Int, nm::Symbol)` | Tables.getcolumn(row, nm) | Given a column type `T`, index `i`, and column name `nm`, retrieve the column value. Provides a type-stable or even constant-prop-able mechanism for efficiency. |

While custom row types aren't required to subtype `Tables.AbstractRow`, benefits of doing so include:
  * Indexing interface defined (using `getcolumn`); i.e. `row[i]` will return the column value at index `i`
  * Property access interface defined (using `columnnames` and `getcolumn`); i.e. `row.col1` will retrieve the value for the column named `col1`
  * Iteration interface defined; i.e. `for x in row` will iterate each column value in the row
  * `AbstractDict` methods defined (`get`, `haskey`, etc.) for checking and retrieving column values
  * A default `show` method
This allows the custom row type to behave as close as possible to a builtin `NamedTuple` object.
"""
abstract type AbstractRow end

"""
    Tables.getcolumn(::AbstractColumns, nm::Symbol) => Indexable collection with known length
    Tables.getcolumn(::AbstractColumns, i::Int) => Indexable collection with known length
    Tables.getcolumn(::AbstractColumns, T, i::Int, nm::Symbol) => Indexable collection with known length

    Tables.getcolumn(::AbstractRow, nm::Symbol) => Column value
    Tables.getcolumn(::AbstractRow, i::Int) => Column value
    Tables.getcolumn(::AbstractRow, T, i::Int, nm::Symbol) => Column value

Retrieve an entire column (from `AbstractColumns`) or single row column value (from an `AbstractRow`) by column name (`nm`), index (`i`),
or if desired, by column type (`T`), index (`i`), and name (`nm`). When called on a `AbstractColumns` interface object,
the returned object should be an indexable collection with known length. When called on a `AbstractRow` interface
object, it returns the single column value. The methods taking a single `Symbol` or `Int` are both required
for the `AbstractColumns` and `AbstractRow` interfaces; the third method is optional if type stability is possible.
The default definition of `Tables.getcolumn(x, i::Int)` is `getfield(x, i)`. The default definition of
`Tables.getcolumn(x, nm::Symbol)` is `getproperty(x, nm)`.
"""
function getcolumn end

getcolumn(x, i::Int) = getfield(x, i)
getcolumn(x, nm::Symbol) = getproperty(x, nm)
getcolumn(x, ::Type{T}, i::Int, nm::Symbol) where {T} = getcolumn(x, nm)
getcolumn(x::NamedTuple{names, types}, ::Type{T}, i::Int, nm::Symbol) where {names, types, T} = Core.getfield(x, i)

"""
    Tables.columnnames(::Union{AbstractColumns, AbstractRow}) => Indexable collection

Retrieves the list of column names as an indexable collection (like a `Tuple` or `Vector`) for a `AbstractColumns` or `AbstractRow` interface object. The default definition calls `propertynames(x)`.
"""
function columnnames end

columnnames(x) = propertynames(x)

"""
    Tables.isrowtable(x) => Bool

For convenience, some table objects that are naturally "row oriented" can
define `Tables.isrowtable(::Type{TableType}) = true` to simplify satisfying the
Tables.jl interface. Requirements for defining `isrowtable` include:
  * `Tables.rows(x) === x`, i.e. the table object itself is a `Row` iterator
  * If the table object is mutable, it should support:
    * `push!(x, row)`: allow pushing a single row onto table
    * `append!(x, rows)`: allow appending set of rows onto table
  * If table object is mutable and indexable, it should support:
    * `x[i] = row`: allow replacing of a row with another row by index

A table object that defines `Tables.isrowtable` will have definitions for
`Tables.istable`, `Tables.rowaccess`, and `Tables.rows` automatically defined.
"""
function isrowtable end

isrowtable(::T) where {T} = isrowtable(T)
isrowtable(::Type{T}) where {T} = false

# default definitions for AbstractDict to act as an AbstractColumns or AbstractRow
getcolumn(x::AbstractDict{Symbol}, i::Int) = x[columnnames(x)[i]]
getcolumn(x::AbstractDict{Symbol}, nm::Symbol) = x[nm]
getcolumn(x::AbstractDict{Symbol}, ::Type{T}, i::Int, nm::Symbol) where {T} = x[nm]
columnnames(x::AbstractDict{Symbol}) = collect(keys(x))

# AbstractVector of Dicts for Tables.rows
const DictRows = AbstractVector{T} where {T <: AbstractDict{Symbol}}
isrowtable(::Type{<:DictRows}) = true
# DictRows doesn't naturally lend itself to the `Tables.schema` requirement
# we can't just look at the first row, because the types might change,
# row-to-row (e.g. `missing`, then `1.1`, etc.). Therefore, the safest option
# is to just return `nothing`
schema(x::DictRows) = nothing

# Dict of AbstractVectors for Tables.columns
const DictColumns = AbstractDict{K, V} where {K <: Symbol, V <: AbstractVector}
istable(::Type{<:DictColumns}) = true
columnaccess(::Type{<:DictColumns}) = true
columns(x::DictColumns) = x
schema(x::DictColumns) = Schema(collect(keys(x)), eltype.(values(x)))

# for other AbstractDict, let's throw an informative error
columns(x::T) where {T <: AbstractDict} = error("to treat $T as a table, it must have a key type of `Symbol`, and a value type `<: AbstractVector`")

# default definitions for AbstractRow, AbstractColumns
const RorC = Union{AbstractRow, AbstractColumns}

Base.IteratorSize(::Type{R}) where {R <: RorC} = Base.HasLength()
Base.length(r::RorC) = length(columnnames(r))
Base.IndexStyle(::Type{<:RorC}) = Base.IndexLinear()
Base.firstindex(r::RorC) = 1
Base.lastindex(r::RorC) = length(r)
Base.getindex(r::RorC, i::Int) = getcolumn(r, i)
Base.getindex(r::RorC, nm::Symbol) = getcolumn(r, nm)
Base.getproperty(r::RorC, nm::Symbol) = getcolumn(r, nm)
Base.getproperty(r::RorC, i::Int) = getcolumn(r, i)
Base.propertynames(r::RorC) = columnnames(r)
Base.keys(r::RorC) = columnnames(r)
Base.values(r::RorC) = collect(r)
Base.haskey(r::RorC, key::Symbol) = key in columnnames(r)
Base.haskey(r::RorC, i::Int) = 0 < i < length(columnnames(r))
Base.get(r::RorC, key::Union{Integer, Symbol}, default) = haskey(r, key) ? getcolumn(r, key) : default
Base.get(f::Base.Callable, r::RorC, key::Union{Integer, Symbol}) = haskey(r, key) ? getcolumn(r, key) : f()
Base.iterate(r::RorC, i=1) = i > length(r) ? nothing : (getcolumn(r, i), i + 1)
Base.isempty(r::RorC) = length(r) == 0

function Base.NamedTuple(r::RorC)
    names = columnnames(r)
    return NamedTuple{names}(Tuple(getcolumn(r, nm) for nm in names))
end

function Base.show(io::IO, x::T) where {T <: RorC}
    println(io, "$T:")
    names = collect(columnnames(x))
    values = [getcolumn(x, nm) for nm in names]
    Base.print_matrix(io, hcat(names, values))
end

# AbstractRow AbstractVector as Rows
const AbstractRowTable = AbstractVector{T} where {T <: AbstractRow}
isrowtable(::Type{<:AbstractRowTable}) = true
schema(x::AbstractRowTable) = nothing

# AbstractColumns as Columns
istable(::Type{<:AbstractColumns}) = true
columnaccess(::Type{<:AbstractColumns}) = true
columns(x::AbstractColumns) = x
schema(x::AbstractColumns) = nothing

"""
    Tables.Row(row)

Convenience type to wrap any `AbstractRow` interface object in a dedicated struct
to provide useful default behaviors (allows any `AbstractRow` to be used like a `NamedTuple`):
  * Indexing interface defined; i.e. `row[i]` will return the column value at index `i`, `row[nm]` will return column value for column name `nm`
  * Property access interface defined; i.e. `row.col1` will retrieve the value for the column named `col1`
  * Iteration interface defined; i.e. `for x in row` will iterate each column value in the row
  * `AbstractDict` methods defined (`get`, `haskey`, etc.) for checking and retrieving column values
"""
struct Row{T} <: AbstractRow
    x::T
end

Row(x::AbstractRow) = x

"""
    Tables.Columns(columns)

Convenience type to wrap any `AbstractColumns` interface object in a dedicated struct
to provide useful default behaviors (allows any `AbstractColumns` to be used like a `NamedTuple` of `Vectors`):
  * Indexing interface defined; i.e. `row[i]` will return the column at index `i`, `row[nm]` will return column for column name `nm`
  * Property access interface defined; i.e. `row.col1` will retrieve the value for the column named `col1`
  * Iteration interface defined; i.e. `for x in row` will iterate each column in the row
  * `AbstractDict` methods defined (`get`, `haskey`, etc.) for checking and retrieving columns
"""
struct Columns{T} <: AbstractColumns
    x::T
end

Columns(x::AbstractColumns) = x

const RorC2 = Union{Row, Columns}

getx(x::RorC2) = getfield(x, :x)

getcolumn(x::RorC2, i::Int) = getcolumn(getx(x), i)
getcolumn(x::RorC2, nm::Symbol) = getcolumn(getx(x), nm)
getcolumn(x::RorC2, ::Type{T}, i::Int, nm::Symbol) where {T} = getcolumn(getx(x), T, i, nm)
columnnames(x::RorC2) = columnnames(getx(x))

"""
    Tables.istable(x) => Bool

Check if an object has specifically defined that it is a table. Note that 
not all valid tables will return true, since it's possible to satisfy the
Tables.jl interface at "run-time", e.g. a `Generator` of `NamedTuple`s iterates
`NamedTuple`s, which satisfies the `AbstractRow` interface, but there's no static way
of knowing that the generator is a table.
"""
function istable end

istable(x::T) where {T} = istable(T) || TableTraits.isiterabletable(x) === true
istable(::Type{T}) where {T} = isrowtable(T)

"""
    Tables.rowaccess(x) => Bool

Check whether an object has specifically defined that it implements the `Tables.rows`
function that does _not_ copy table data.  That is to say, `Tables.rows(x)` must be done
with O(1) time and space complexity when `Tables.rowaccess(x) == true`.  Note that
`Tables.rows` will work on any object that iterates `AbstractRow`-compatible objects, even if
they don't define `rowaccess`, e.g. a `Generator` of `NamedTuple`s.  However, this
generic fallback may copy the data from input table `x`.  Also note that just because
an object defines `rowaccess` doesn't mean a user should call `Tables.rows` on it;
`Tables.columns` will also work, providing a valid `AbstractColumns` object from the rows.
Hence, users should call `Tables.rows` or `Tables.columns` depending on what is most
natural for them to *consume* instead of worrying about what and how the input is oriented.
"""
function rowaccess end

rowaccess(x::T) where {T} = rowaccess(T)
rowaccess(::Type{T}) where {T} = isrowtable(T)

"""
    Tables.columnaccess(x) => Bool

Check whether an object has specifically defined that it implements the `Tables.columns`
function that does _not_ copy table data.  That is to say, `Tables.columns(x)` must be done
with O(1) time and space complexity when `Tables.columnaccess(x) == true`.  Note that
`Tables.columns` has generic fallbacks allowing it to produces `AbstractColumns` objects, even if
the input doesn't define `columnaccess`.  However, this generic fallback may copy the data
from input table `x`.  Also note that just because an object defines `columnaccess` doesn't
mean a user should call `Tables.columns` on it; `Tables.rows` will also work, providing a
valid `AbstractRow` iterator. Hence, users should call `Tables.rows` or `Tables.columns` depending
on what is most natural for them to *consume* instead of worrying about what and how the
input is oriented.
"""
function columnaccess end

columnaccess(x::T) where {T} = columnaccess(T)
columnaccess(::Type{T}) where {T} = false

"""
    Tables.schema(x) => Union{Nothing, Tables.Schema}

Attempt to retrieve the schema of the object returned by `Tables.rows` or `Tables.columns`.
If the `AbstractRow` iterator or `AbstractColumns` object can't determine its schema, `nothing` will be returned.
Otherwise, a `Tables.Schema` object is returned, with the column names and types available for use.
"""
function schema end

schema(x) = nothing

"""
    Tables.materializer(x) => Callable

For a table input, return the "sink" function or "materializing" function that can take a
Tables.jl-compatible table input and make an instance of the table type. This enables "transform"
workflows that take table inputs, apply transformations, potentially converting the table to
a different form, and end with producing a table of the same type as the original input. The
default materializer is `Tables.columntable`, which converts any table input into a `NamedTuple`
of `Vector`s.
"""
function materializer end

materializer(x::T) where {T} = materializer(T)
materializer(::Type{T}) where {T} = columntable

"""
    Tables.columns(x) => AbstractColumns-compatible object

Accesses data of input table source `x` by returning an [`AbstractColumns`](@ref)-compatible
object, which allows retrieving entire columns by name or index. A retrieved column
is an object that is indexable and has a known length, i.e. supports 
`length(col)` and `col[i]` for any `i = 1:length(col)`. Note that
even if the input table source is row-oriented by nature, an efficient generic
definition of `Tables.columns` is defined in Tables.jl to build a `AbstractColumns`-
compatible object object from the input rows.

The [`Tables.Schema`](@ref) of a `AbstractColumns` object can be queried via `Tables.schema(columns)`,
which may return `nothing` if the schema is unknown.
Column names can always be queried by calling `Tables.columnnames(columns)`, and individual columns
can be accessed by calling `Tables.getcolumn(columns, i::Int )` or `Tables.getcolumn(columns, nm::Symbol)`
with a column index or name, respectively.
"""
function columns end

"""
    Tables.rows(x) => Row iterator

Accesses data of input table source `x` row-by-row by returning an [`AbstractRow`](@ref)-compatible iterator.
Note that even if the input table source is column-oriented by nature, an efficient generic
definition of `Tables.rows` is defined in Tables.jl to return an iterator of row views into
the columns of the input.

The [`Tables.Schema`](@ref) of an `AbstractRow` iterator can be queried via `Tables.schema(rows)`,
which may return `nothing` if the schema is unknown.
Column names can always be queried by calling `Tables.columnnames(row)` on an individual row,
and row values can be accessed by calling `Tables.getcolumn(rows, i::Int )` or
`Tables.getcolumn(rows, nm::Symbol)` with a column index or name, respectively.
"""
function rows end

# Schema implementation
"""
    Tables.Schema(names, types)

Create a `Tables.Schema` object that holds the column names and types for an `AbstractRow` iterator
returned from `Tables.rows` or an `AbstractColumns` object returned from `Tables.columns`.
`Tables.Schema` is dual-purposed: provide an easy interface for users to query these properties,
as well as provide a convenient "structural" type for code generation.

To get a table's schema, one can call `Tables.schema` on the result of `Tables.rows` or `Tables.columns`,
but also note that a table may return `nothing`, indicating that its column names and/or column types
are unknown (usually not inferrable). This is similar to the `Base.EltypeUnknown()` trait for iterators
when `Base.IteratorEltype` is called. Users should account for the `Tables.schema(tbl) => nothing` case
by using the properties of the results of `Tables.rows(x)` and `Tables.columns(x)` directly.

To access the names, one can simply call `sch.names` to return the tuple of Symbols.
To access column types, one can similarly call `sch.types`, which will return a tuple of types (like `(Int64, Float64, String)`).

The actual type definition is
```julia
struct Schema{names, types} end
```
Where `names` is a tuple of Symbols, and `types` is a tuple _type_ of types (like `Tuple{Int64, Float64, String}`).
Encoding the names & types as type parameters allows convenient use of the type in generated functions
and other optimization use-cases.
"""
struct Schema{names, types} end
Schema(names::Tuple{Vararg{Symbol}}, types::Type{T}) where {T <: Tuple} = Schema{names, T}()
Schema(::Type{NamedTuple{names, types}}) where {names, types} = Schema{names, types}()

# pass through Ints to allow Tuples to act as rows
sym(x) = Symbol(x)
sym(x::Int) = x

Schema(names, ::Nothing) = Schema{Tuple(Base.map(sym, names)), nothing}()
Schema(names, types) = Schema{Tuple(Base.map(sym, names)), Tuple{types...}}()

function Base.show(io::IO, sch::Schema{names, types}) where {names, types}
    println(io, "Tables.Schema:")
    Base.print_matrix(io, hcat(collect(names), types === nothing ? fill(nothing, length(names)) : collect(fieldtype(types, i) for i = 1:fieldcount(types))))
end

function Base.getproperty(sch::Schema{names, types}, field::Symbol) where {names, types}
    if field === :names
        return names
    elseif field === :types
        return types === nothing ? nothing : Tuple(fieldtype(types, i) for i = 1:fieldcount(types))
    else
        throw(ArgumentError("unsupported property for Tables.Schema"))
    end
end

Base.propertynames(sch::Schema) = (:names, :types)

# helper functions
include("utils.jl")

# reference implementations: Vector of NamedTuples and NamedTuple of Vectors
include("namedtuples.jl")

# generic fallback definitions
include("fallbacks.jl")

# allow any valid iterator to be a table
include("tofromdatavalues.jl")

# matrix integration
include("matrix.jl")

"""
    Tables.columnindex(table, name::Symbol)

Return the column index (1-based) of a column by `name` in a table with a known schema; returns 0 if `name` doesn't exist in table
"""
columnindex(table, colname::Symbol) = columnindex(schema(table), colname)

"""
    Tables.columntype(table, name::Symbol)

Return the column type of a column by `name` in a table with a known schema; returns Union{} if `name` doesn't exist in table
"""
columntype(table, colname::Symbol) = columntype(schema(table), colname)

Base.@pure columnindex(::Schema{names, types}, name::Symbol) where {names, types} = columnindex(names, name)

"given names and a Symbol `name`, compute the index (1-based) of the name in names"
Base.@pure function columnindex(names::Tuple{Vararg{Symbol}}, name::Symbol)
    i = 1
    for nm in names
        nm === name && return i
        i += 1
    end
    return 0
end

Base.@pure columntype(::Schema{names, types}, name::Symbol) where {names, types} = columntype(names, types, name)

"given tuple type and a Symbol `name`, compute the type of the name in the tuples types"
Base.@pure function columntype(names::Tuple{Vararg{Symbol}}, ::Type{types}, name::Symbol) where {types <: Tuple}
    i = 1
    for nm in names
        nm === name && return fieldtype(types, i)
        i += 1
    end
    return Union{}
end

end # module
