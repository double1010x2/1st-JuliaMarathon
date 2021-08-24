Tables.istable(::Type{<:AbstractDataFrame}) = true
Tables.columnaccess(::Type{<:AbstractDataFrame}) = true
Tables.columns(df::AbstractDataFrame) = df
Tables.rowaccess(::Type{<:AbstractDataFrame}) = true
Tables.rows(df::AbstractDataFrame) = Tables.rows(columntable(df))

Tables.schema(df::AbstractDataFrame) = Tables.Schema(names(df), eltype.(eachcol(df)))
Tables.materializer(df::AbstractDataFrame) = DataFrame

Tables.getcolumn(df::AbstractDataFrame, i::Int) = df[!, i]
Tables.getcolumn(df::AbstractDataFrame, nm::Symbol) = df[!, nm]
Tables.columnnames(df::AbstractDataFrame) = names(df)

Tables.getcolumn(dfr::DataFrameRow, i::Int) = dfr[i]
Tables.getcolumn(dfr::DataFrameRow, nm::Symbol) = dfr[nm]
Tables.columnnames(dfr::DataFrameRow) = names(dfr)

getvector(x::AbstractVector) = x
getvector(x) = [x[i] for i = 1:length(x)]
# note that copycols is ignored in this definition (Tables.CopiedColumns implies copies have already been made)
fromcolumns(x::Tables.CopiedColumns, names; copycols::Bool=true) =
    DataFrame(AbstractVector[getvector(Tables.getcolumn(x, nm)) for nm in names],
              Index(names),
              copycols=false)
fromcolumns(x, names; copycols::Bool=true) =
    DataFrame(AbstractVector[getvector(Tables.getcolumn(x, nm)) for nm in names],
              Index(names),
              copycols=copycols)

function DataFrame(x::T; copycols::Bool=true) where {T}
    if x isa AbstractVector && all(col -> isa(col, AbstractVector), x)
        return DataFrame(Vector{AbstractVector}(x), copycols=copycols)
    end
    if x isa AbstractVector || x isa Tuple
        if all(v -> v isa Pair{Symbol, <:AbstractVector}, x)
            return DataFrame(AbstractVector[last(v) for v in x], [first(v) for v in x],
                             copycols=copycols)
        end
    end
    cols = Tables.columns(x)
    names = collect(Symbol, Tables.columnnames(cols))
    return fromcolumns(cols, names, copycols=copycols)
end

function Base.append!(df::DataFrame, table; cols::Symbol=:setequal)
    if table isa Dict && cols == :orderequal
        throw(ArgumentError("passing `Dict` as `table` when `cols` is equal to " *
                            "`:orderequal` is not allowed as it is unordered"))
    end
    append!(df, DataFrame(table, copycols=false), cols=cols)
end

# This supports the Tables.RowTable type; needed to avoid ambiguities w/ another constructor
DataFrame(x::AbstractVector{NamedTuple{names, T}}; copycols::Bool=true) where {names, T} =
    fromcolumns(Tables.columns(Tables.IteratorWrapper(x)), collect(names), copycols=false)
DataFrame!(x::AbstractVector{<:NamedTuple}) =
    throw(ArgumentError("It is not possible to construct a `DataFrame` from " *
                        "`$(typeof(x))` without allocating new columns: use " *
                        "`DataFrame(x)` instead"))

IteratorInterfaceExtensions.getiterator(df::AbstractDataFrame) = Tables.datavaluerows(df)
IteratorInterfaceExtensions.isiterable(x::AbstractDataFrame) = true
TableTraits.isiterabletable(x::AbstractDataFrame) = true
