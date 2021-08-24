# Autogenerated wrapper script for unixODBC_jll for armv7l-linux-gnueabihf
export odbc_config, libodbccr, libodbcinst, libodbc, iusql, odbcinst, dltest, isql, slencheck

using Libiconv_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "LD_LIBRARY_PATH"
LIBPATH_default = ""

# Relative path to `odbc_config`
const odbc_config_splitpath = ["bin", "odbc_config"]

# This will be filled out by __init__() for all products, as it must be done at runtime
odbc_config_path = ""

# odbc_config-specific global declaration
function odbc_config(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(odbc_config_path)
    end
end


# Relative path to `libodbccr`
const libodbccr_splitpath = ["lib", "libodbccr.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libodbccr_path = ""

# libodbccr-specific global declaration
# This will be filled out by __init__()
libodbccr_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libodbccr = "libodbccr.so.2"


# Relative path to `libodbcinst`
const libodbcinst_splitpath = ["lib", "libodbcinst.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libodbcinst_path = ""

# libodbcinst-specific global declaration
# This will be filled out by __init__()
libodbcinst_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libodbcinst = "libodbcinst.so.2"


# Relative path to `libodbc`
const libodbc_splitpath = ["lib", "libodbc.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libodbc_path = ""

# libodbc-specific global declaration
# This will be filled out by __init__()
libodbc_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libodbc = "libodbc.so.2"


# Relative path to `iusql`
const iusql_splitpath = ["bin", "iusql"]

# This will be filled out by __init__() for all products, as it must be done at runtime
iusql_path = ""

# iusql-specific global declaration
function iusql(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(iusql_path)
    end
end


# Relative path to `odbcinst`
const odbcinst_splitpath = ["bin", "odbcinst"]

# This will be filled out by __init__() for all products, as it must be done at runtime
odbcinst_path = ""

# odbcinst-specific global declaration
function odbcinst(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(odbcinst_path)
    end
end


# Relative path to `dltest`
const dltest_splitpath = ["bin", "dltest"]

# This will be filled out by __init__() for all products, as it must be done at runtime
dltest_path = ""

# dltest-specific global declaration
function dltest(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(dltest_path)
    end
end


# Relative path to `isql`
const isql_splitpath = ["bin", "isql"]

# This will be filled out by __init__() for all products, as it must be done at runtime
isql_path = ""

# isql-specific global declaration
function isql(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(isql_path)
    end
end


# Relative path to `slencheck`
const slencheck_splitpath = ["bin", "slencheck"]

# This will be filled out by __init__() for all products, as it must be done at runtime
slencheck_path = ""

# slencheck-specific global declaration
function slencheck(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
    global PATH, LIBPATH
    env_mapping = Dict{String,String}()
    if adjust_PATH
        if !isempty(get(ENV, "PATH", ""))
            env_mapping["PATH"] = string(PATH, ':', ENV["PATH"])
        else
            env_mapping["PATH"] = PATH
        end
    end
    if adjust_LIBPATH
        LIBPATH_base = get(ENV, LIBPATH_env, expanduser(LIBPATH_default))
        if !isempty(LIBPATH_base)
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', LIBPATH_base)
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(slencheck_path)
    end
end


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"unixODBC")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (Libiconv_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (Libiconv_jll.LIBPATH_list,))

    global odbc_config_path = normpath(joinpath(artifact_dir, odbc_config_splitpath...))

    push!(PATH_list, dirname(odbc_config_path))
    global libodbccr_path = normpath(joinpath(artifact_dir, libodbccr_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libodbccr_handle = dlopen(libodbccr_path)
    push!(LIBPATH_list, dirname(libodbccr_path))

    global libodbcinst_path = normpath(joinpath(artifact_dir, libodbcinst_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libodbcinst_handle = dlopen(libodbcinst_path)
    push!(LIBPATH_list, dirname(libodbcinst_path))

    global libodbc_path = normpath(joinpath(artifact_dir, libodbc_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libodbc_handle = dlopen(libodbc_path)
    push!(LIBPATH_list, dirname(libodbc_path))

    global iusql_path = normpath(joinpath(artifact_dir, iusql_splitpath...))

    push!(PATH_list, dirname(iusql_path))
    global odbcinst_path = normpath(joinpath(artifact_dir, odbcinst_splitpath...))

    push!(PATH_list, dirname(odbcinst_path))
    global dltest_path = normpath(joinpath(artifact_dir, dltest_splitpath...))

    push!(PATH_list, dirname(dltest_path))
    global isql_path = normpath(joinpath(artifact_dir, isql_splitpath...))

    push!(PATH_list, dirname(isql_path))
    global slencheck_path = normpath(joinpath(artifact_dir, slencheck_splitpath...))

    push!(PATH_list, dirname(slencheck_path))
    # Filter out duplicate and empty entries in our PATH and LIBPATH entries
    filter!(!isempty, unique!(PATH_list))
    filter!(!isempty, unique!(LIBPATH_list))
    global PATH = join(PATH_list, ':')
    global LIBPATH = join(LIBPATH_list, ':')

    # Add each element of LIBPATH to our DL_LOAD_PATH (necessary on platforms
    # that don't honor our "already opened" trick)
    #for lp in LIBPATH_list
    #    push!(DL_LOAD_PATH, lp)
    #end
end  # __init__()

