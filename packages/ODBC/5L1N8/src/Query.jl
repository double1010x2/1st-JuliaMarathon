using Tables

struct Query{rows, NT, T}
    stmt::Ptr{Cvoid}
    status::Base.RefValue{Int}
    columns::T
    rowsfetched::Base.RefValue{ODBC.API.SQLLEN}
    boundcols::Vector{Any}
    indcols::Vector{Vector{ODBC.API.SQLLEN}}
    sizes::Vector{ODBC.API.SQLULEN}
    ctypes::Vector{ODBC.API.SQLSMALLINT}
    jltypes::Vector{Type}
    boundcount::Int
end
getstmt(q::Query) = q.stmt

Tables.istable(::Type{<:Query}) = true
Tables.rowaccess(::Type{<:Query}) = true
Tables.rows(q::Query) = q
Tables.schema(q::Query{rows, NT}) where {rows, NT} = Tables.Schema(NT)
Base.IteratorSize(::Type{Query{missing, NT, T}}) where {NT, T} = Base.SizeUnknown()
Base.IteratorSize(::Type{<:Query}) = Base.HasLength()
Base.length(q::Query{rows}) where {rows} = rows
Base.eltype(q::Query{rows, NT}) where {rows, NT} = NT

@inline function generate_namedtuple(::Type{NamedTuple{names, types}}, q, row) where {names, types}
    if @generated
        return Expr(:new, :(NamedTuple{names,$types}), Any[ :(q.columns[$i][row]) for i in 1:length(names) ]...)
    else
        return NamedTuple{names, types}(Tuple(q.columns[i][row] for i = 1:length(names)))
    end
end

function Base.iterate(q::Query{rows, NT}, st=1) where {rows, NT}
    ((st > q.rowsfetched[] && q.status[] != API.SQL_SUCCESS && q.status[] != API.SQL_SUCCESS_WITH_INFO) || q.status[] == API.SQL_NO_DATA) && return nothing
    nt = generate_namedtuple(NT, q, st)
    if st == q.rowsfetched[]
        q.status[] = @CHECK q.stmt API.SQL_HANDLE_STMT API.SQLFetchScroll(q.stmt, API.SQL_FETCH_NEXT, 0)
        q.rowsfetched[] > 0 && foreach(i->cast!(q.jltypes[i], q, i), 1:length(q.jltypes))
        st = 0
    end
    return nt, st + 1
end

# Initial read size - can be small since first read should return
# final length needed in most cases
const LONG_DATA_BUFFER_SIZE = 1000

function Query(dsn::DSN, query::AbstractString)
    stmt = dsn.stmt_ptr
    ODBCFreeStmt!(stmt)
    @CHECK stmt API.SQL_HANDLE_STMT API.SQLExecDirect(stmt, query)
    rowsref, colsref = Ref{Int}(), Ref{Int16}()
    API.SQLNumResultCols(stmt, colsref)
    API.SQLRowCount(stmt, rowsref)
    rows, cols = rowsref[], colsref[]
    # Allocate arrays to hold each column's metadata
    cnames = Vector{Symbol}(undef, cols)
    ctypes, csizes = Vector{API.SQLSMALLINT}(undef, cols), Vector{API.SQLULEN}(undef, cols)
    cdigits, cnulls = Vector{API.SQLSMALLINT}(undef, cols), Vector{API.SQLSMALLINT}(undef, cols)
    juliatypes = Vector{Type}(undef, cols)
    alloctypes = Vector{DataType}(undef, cols)
    longtexts = Vector{Bool}(undef, cols)
    longtext = false
    # Allocate space for and fetch the name, type, size, etc. for each column
    len, dt, csize = Ref{API.SQLSMALLINT}(), Ref{API.SQLSMALLINT}(), Ref{API.SQLULEN}()
    digits, maybemissing = Ref{API.SQLSMALLINT}(), Ref{API.SQLSMALLINT}()
    cname = Block(API.SQLWCHAR, BUFLEN)
    for x = 1:cols
        API.SQLDescribeCol(stmt, x, cname.ptr, BUFLEN, len, dt, csize, digits, maybemissing)
        cnames[x] = Symbol(string(cname, len[]))
        t = dt[]
        ctypes[x], csizes[x], cdigits[x], cnulls[x] = t, csize[], digits[], maybemissing[]
        alloctypes[x], juliatypes[x], longtexts[x] = API.SQL2Julia[t]
        # Some drivers return 0 size for variable length or large fields
        if csizes[x] == 0
            longtexts[x] = ctypes[x] in (API.SQL_VARCHAR, API.SQL_WVARCHAR, API.SQL_VARBINARY)
        end
        longtext |= longtexts[x]
    end
    # Determine fetch strategy
    # rows might be -1 (dbms doesn't return total rows in resultset), 0 (empty resultset), or 1+
    if longtext
        rowset = allocsize = 1
    elseif rows > -1
        # rowset = min(rows, API.MAXFETCHSIZE)
        allocsize = rowset = rows
    else
        rowset = allocsize = 1
    end
    API.SQLSetStmtAttr(stmt, API.SQL_ATTR_ROW_ARRAY_SIZE, rowset, API.SQL_IS_UINTEGER)
    boundcols = Vector{Any}(undef, cols)
    indcols = Vector{Vector{API.SQLLEN}}(undef, cols)

    # For drivers that do not support SQL_GD_ANY_COLUMN, can only
    # bind columns prior to the first longtext. Must use
    # SQLGetData on all subsequent columns.
    boundcount = longtext ? findfirst(longtexts) - 1 : cols
    for x = 1:cols
        indcols[x] = Vector{API.SQLLEN}(undef, rowset)
        if longtexts[x]
            boundcols[x] = Vector{alloctypes[x]}(undef, LONG_DATA_BUFFER_SIZE)
        else
            # Setup storage for fixed columns here whether bound or not.
            boundcols[x], elsize = internal_allocate(alloctypes[x], rowset, csizes[x])
            if x <= boundcount
                API.SQLBindCols(stmt, x, API.SQL2C[ctypes[x]], pointer(boundcols[x]), elsize, indcols[x])
            end
        end
    end
    names = Tuple(cnames)
    columns = Tuple(allocate(T) for T in juliatypes)
    NT = NamedTuple{names, Tuple{juliatypes...}}
    rowsfetched = Ref{API.SQLLEN}(0) # will be populated by call to SQLFetchScroll
    API.SQLSetStmtAttr(stmt, API.SQL_ATTR_ROWS_FETCHED_PTR, rowsfetched, API.SQL_NTS)
    types = [API.SQL2C[ctypes[x]] for x = 1:cols]
    jltypes = Type[longtexts[x] ? API.Long{T} : T for (x, T) in enumerate(juliatypes)]
    q = Query{rows >= 0 ? rows : missing, NT, typeof(columns)}(
        stmt, Ref(0), columns, rowsfetched, boundcols, indcols, csizes, types, jltypes, boundcount)
    if rows != 0
        q.status[] = @CHECK q.stmt API.SQL_HANDLE_STMT API.SQLFetchScroll(q.stmt, API.SQL_FETCH_NEXT, 0)
        q.rowsfetched[] > 0 && foreach(i->cast!(jltypes[i], q, i), 1:length(jltypes))
    else
        q.status[] = 100
    end
    return q
end

cast(x) = x
cast(x::Dates.Date) = API.SQLDate(x)
cast(x::Dates.DateTime) = API.SQLTimestamp(x)
cast(x::String) = WeakRefString(pointer(x), sizeof(x))

getpointer(::Type{T}, A, i) where {T} = unsafe_load(Ptr{Ptr{Cvoid}}(pointer(A, i)))
getpointer(::Type{WeakRefString{T}}, A, i) where {T} = A[i].ptr
getpointer(::Type{String}, A, i) = pointer(A[i])

sqllength(x) = 1
sqllength(x::AbstractString) = sizeof(x)
sqllength(x::Vector{UInt8}) = length(x)
sqllength(x::WeakRefString{T}) where {T} = codeunits2bytes(T, x.len)
sqllength(x::API.SQLDate) = 10
sqllength(x::Union{API.SQLTime,API.SQLTimestamp}) = sizeof(string(x))

clength(x) = 1
clength(x::AbstractString) = sizeof(x)
clength(x::Vector{UInt8}) = length(x)
clength(x::WeakRefString{T}) where {T} = codeunits2bytes(T, x.len)
clength(x::CategoricalArrays.CategoricalValue) = sizeof(String(x))
clength(x::Missing) = API.SQL_NULL_DATA

digits(x) = 0
digits(x::API.SQLTimestamp) = length(string(x.fraction * 1000000))

# primitive types
allocate(::Type{T}) where {T} = Vector{T}(undef, 0)
allocate(::Type{Union{Missing, WeakRefString{T}}}) where {T} = StringVector{String}(undef, 0)

internal_allocate(::Type{T}, rowset, size) where {T} = Vector{T}(undef, rowset), sizeof(T)
# string/binary types
internal_allocate(::Type{T}, rowset, size) where {T <: Union{UInt8, UInt16, UInt32}} = zeros(T, rowset * (size + 1)), sizeof(T) * (size + 1)

# primitive types
function cast!(::Type{T}, source, col) where {T}
    len = source.rowsfetched[]
    c = source.columns[col]
    resize!(c, len)
    inds = source.indcols[col]
    data = source.boundcols[col]
    # If this column was not bound, get the data
    if col > source.boundcount
        @assert len == 1
        res = API.SQLGetData(getstmt(source), col, source.ctypes[col],
            pointer(data), sizeof(data), Ref(inds, 1))
    end
    @simd for i = 1:len
        @inbounds c[i] = ifelse(inds[i] == API.SQL_NULL_DATA, missing, data[i])
    end
    return c
end

cast(::Type{Dec64}, arr, cur, ind) = ind <= 0 ? Dec64(0) : parse(Dec64, String(unsafe_wrap(Array, pointer(arr, cur), ind)))

function cast!(::Type{Union{Dec64, Missing}}, source, col)
    len = source.rowsfetched[]
    c = source.columns[col]
    resize!(c, len)
    cur = 1
    elsize = source.sizes[col] + 1
    inds = source.indcols[col]
    data = source.boundcols[col]
    # If this column was not bound, get the data
    if col > source.boundcount
        @assert len == 1
        res = API.SQLGetData(getstmt(source), col, source.ctypes[col],
            pointer(data), sizeof(data), Ref(inds, 1))
    end
    @inbounds for i = 1:len
        ind = inds[i]
        c[i] = ind == API.SQL_NULL_DATA ? missing : cast(Dec64, data, cur, ind)
        cur += elsize
    end
    return c
end

cast(::Type{Vector{UInt8}}, arr, cur, ind) = arr[cur:(cur + max(ind, 0) - 1)]

function cast!(::Type{Union{Vector{UInt8}, Missing}}, source, col)
    len = source.rowsfetched[]
    c = source.columns[col]
    resize!(c, len)
    cur = 1
    elsize = source.sizes[col] + 1
    inds = source.indcols[col]
    data = source.boundcols[col]
    # If this column was not bound, get the data
    if col > source.boundcount
        @assert len == 1
        res = API.SQLGetData(getstmt(source), col, source.ctypes[col],
            pointer(data), sizeof(data), Ref(inds, 1))
    end
    @inbounds for i = 1:len
        ind = inds[i]
        c[i] = ind == API.SQL_NULL_DATA ? missing : cast(Vector{UInt8}, data, cur, ind)
        cur += elsize
    end
    return c
end

# string types
bytes2codeunits(::Type{UInt8},  bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes))
bytes2codeunits(::Type{UInt16}, bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes >> 1))
bytes2codeunits(::Type{UInt32}, bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes >> 2))
codeunits2bytes(::Type{UInt8},  bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes))
codeunits2bytes(::Type{UInt16}, bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes * 2))
codeunits2bytes(::Type{UInt32}, bytes) = ifelse(bytes == API.SQL_NULL_DATA, 0, Int(bytes * 4))

function cast!(::Type{Union{String, Missing}}, source, col)
    len = source.rowsfetched[]
    c = source.columns[col]
    resize!(c, len)
    data = source.boundcols[col]
    T = eltype(data)
    cur = 1
    elsize = source.sizes[col] + 1
    inds = source.indcols[col]
    # If this column was not bound, get the data
    if col > source.boundcount
        @assert len == 1
        res = API.SQLGetData(getstmt(source), col, source.ctypes[col],
            pointer(data), sizeof(data), Ref(inds, 1))
    end
    @inbounds for i in 1:len
        ind = inds[i]
        length = bytes2codeunits(T, max(ind, 0))
        c[i] = ind == API.SQL_NULL_DATA ? missing : (length == 0 ? "" : transcode(String, data[cur:(cur + length - 1)]))
        cur += elsize
    end
    return c
end

function cast!(::Type{Union{WeakRefString{T}, Missing}}, source, col) where {T}
    len = source.rowsfetched[]
    c = source.columns[col]
    resize!(c, len)
    empty!(c.data)
    inds = source.indcols[col]
    # If this column was not bound, get the data
    if col > source.boundcount
        @assert len == 1
        res = API.SQLGetData(getstmt(source), col, source.ctypes[col],
            pointer(source.boundcols[col]), sizeof(source.boundcols[col]), Ref(inds, 1))
    end
    data = copy(source.boundcols[col])
    push!(c.data, data)
    cur = 1
    elsize = source.sizes[col] + 1
    EMPTY = WeakRefString{T}(Ptr{T}(0), 0)
    @inbounds for i = 1:len
        ind = inds[i]
        length = bytes2codeunits(T, max(ind, 0))
        c[i] = ind == API.SQL_NULL_DATA ? missing : (length == 0 ? EMPTY : WeakRefString{T}(pointer(data, cur), length))
        cur += elsize
    end
    return c
end

# long types
function cast!(::Type{API.Long{Union{T, Missing}}}, source, col) where {T}
    stmt = getstmt(source)
    ctype = source.ctypes[col]
    c = source.columns[col]
    resize!(c, 1)

    # Grob column's SQLGetData buffer
    buffer = source.boundcols[col]
    eT = eltype(buffer)
    ind = Ref(source.indcols[col], 1)

    # String data needs room for a null character, binary data does not
    nullbytes = T <: AbstractString ? sizeof(eT) : 0

    # Looping invariants
    sqlgetsize = sizeof(buffer)
    sqlgetfilled = sqlgetsize-nullbytes
    datalen = sqlgetfilled
    copiedlen = 0
    dataalloc = 0

    function update_invariants(indlen)
        if indlen == API.SQL_NO_TOTAL
            # Total length unavailable, must loop
            copiedlen += sqlgetfilled
            # Cut down on number of data resizes by increasing sqlgetsize
            # each time. Should help quickly read even the largest unknown
            # size data with fewer allocations.
            sqlgetsize *= 2
            sqlgetfilled = sqlgetsize-nullbytes
            datalen += sqlgetfilled
            dataalloc = bytes2codeunits(eT, datalen+nullbytes)
        elseif indlen > sqlgetfilled
            # Size known - setup to read all remaining bytes
            copiedlen += sqlgetfilled
            # indlen includes last buffer filled, subtract it out
            sqlgetfilled = indlen-sqlgetfilled
            # But keep room for null in next read size
            sqlgetsize = sqlgetfilled+nullbytes
            datalen += sqlgetfilled
            dataalloc = bytes2codeunits(eT, datalen+nullbytes)
        else
            # All bytes read - adjust sizes discarding null or oversizing
            datalen = (copiedlen += indlen)
            dataalloc = bytes2codeunits(eT, datalen)
        end
    end

    # String data null uses buffer space but is
    # in not included in returned ind length
    @CHECK(stmt, API.SQL_HANDLE_STMT,
        API.SQLGetData(stmt, col, ctype, pointer(buffer), sqlgetsize, ind))

    # Return immediately on null
    if ind[] == API.SQL_NULL_DATA
        c[1] = missing
        return c
    end

    # update loop variables to reflect state
    update_invariants(ind[])

    # Allocate data and copy in first buffer
    data = Vector{eT}(undef, dataalloc)
    ccall(:memcpy, Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t), pointer(data),
        pointer(buffer), copiedlen)

    while copiedlen < datalen
        # Read remaining bytes directly into data
        @CHECK(stmt, API.SQL_HANDLE_STMT,
            API.SQLGetData(stmt, col, ctype, pointer(data)+copiedlen,
                sqlgetsize, ind))

        # Forward update loop invariants
        update_invariants(ind[])

        # Will resize bigger (for SQL_NO_TOTAL looping),
        # smaller (removing null for string or extra size for SQL_NO_TOTAL),
        # or maybe not at all (exact size binary field data read)
        resize!(data, dataalloc)
    end

    c[1] = T(transcode(UInt8, data))
    return c
end

function query(dsn::DSN, sql::AbstractString, sink=DataFrame, args...; weakrefstrings::Bool=true, append::Bool=false, transforms::Dict=Dict{Int,Function}())
    if append
        Base.depwarn("`ODBC.query(dsn, sql; append=true)` is no longer supported in favor of individual sink support, like `append!(existing_dataframe, ODBC.query(dsn, sql))`", nothing)
    end
    !weakrefstrings && Base.depwarn("`ODBC.query(dsn, sql; weakrefstrings=false)` is no longer supported", nothing)
    !isempty(transforms) && Base.depwarn("`ODBC.query(dsn, sql; transforms=...)` is no longer supported", nothing)
    return DataFrame(ODBC.Query(dsn, sql))
end

function query(dsn::DSN, sql::AbstractString, sink::T; weakrefstrings::Bool=true, append::Bool=false, transforms::Dict=Dict{Int,Function}()) where {T}
    if append
        Base.depwarn("`ODBC.query(dsn, sql; append=true)` is no longer supported in favor of individual sink support, like `append!(existing_dataframe, ODBC.query(dsn, sql))`", nothing)
    end
    !weakrefstrings && Base.depwarn("`ODBC.query(dsn, sql; weakrefstrings=false)` is no longer supported", nothing)
    !isempty(transforms) && Base.depwarn("`ODBC.query(dsn, sql; transforms=...)` is no longer supported", nothing)
    return DataFrame(ODBC.Query(dsn, sql))
end

function query(source::Query, sink=DataFrame, args...; append::Bool=false, transforms::Dict=Dict{Int,Function}())
    if append
        Base.depwarn("`ODBC.query(dsn, sql; append=true)` is no longer supported in favor of individual sink support, like `append!(existing_dataframe, ODBC.query(dsn, sql))`", nothing)
    end
    if sink != DataFrame
        Base.depwarn("`ODBC.query(dsn, sql, $(typeof(sink)))` is no longer supported; returning a DataFrame instead", nothing)
    end
    !isempty(transforms) && Base.depwarn("`ODBC.query(dsn, sql; transforms=...)` is no longer supported", nothing)
    return DataFrame(source)
end
function query(source::Query, sink::T; append::Bool=false, transforms::Dict=Dict{Int,Function}()) where {T}
    if append
        Base.depwarn("`ODBC.query(dsn, sql; append=true)` is no longer supported in favor of individual sink support, like `append!(existing_dataframe, ODBC.query(dsn, sql))`", nothing)
    end
    !isempty(transforms) && Base.depwarn("`ODBC.query(dsn, sql; transforms=...)` is no longer supported", nothing)
    return DataFrame(source)
end

"Convenience string macro for executing an SQL statement against a DSN."
macro sql_str(s,dsn)
    query(dsn,s)
end

function Source(dsn::DSN, query::AbstractString; weakrefstrings::Bool=true, noquery::Bool=false)
    Base.depwarn("`ODBC.Source(dsn, query)` is deprecated in favor of `ODBC.Query(dsn, query)`", nothing)
    return Query(dsn, query)
end
