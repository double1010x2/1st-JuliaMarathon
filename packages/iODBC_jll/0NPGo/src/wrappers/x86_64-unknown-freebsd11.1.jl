# Autogenerated wrapper script for iODBC_jll for x86_64-unknown-freebsd11.1
export libiodbcinst, iodbctest, libiodbc, iodbctestw

## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "LD_LIBRARY_PATH"
LIBPATH_default = ""

# Relative path to `libiodbcinst`
const libiodbcinst_splitpath = ["lib", "libiodbcinst.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libiodbcinst_path = ""

# libiodbcinst-specific global declaration
# This will be filled out by __init__()
libiodbcinst_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libiodbcinst = "libiodbcinst.so.2"


# Relative path to `iodbctest`
const iodbctest_splitpath = ["bin", "iodbctest"]

# This will be filled out by __init__() for all products, as it must be done at runtime
iodbctest_path = ""

# iodbctest-specific global declaration
function iodbctest(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
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
        f(iodbctest_path)
    end
end


# Relative path to `libiodbc`
const libiodbc_splitpath = ["lib", "libiodbc.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libiodbc_path = ""

# libiodbc-specific global declaration
# This will be filled out by __init__()
libiodbc_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libiodbc = "libiodbc.so.2"


# Relative path to `iodbctestw`
const iodbctestw_splitpath = ["bin", "iodbctestw"]

# This will be filled out by __init__() for all products, as it must be done at runtime
iodbctestw_path = ""

# iodbctestw-specific global declaration
function iodbctestw(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
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
        f(iodbctestw_path)
    end
end


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"iODBC")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    global libiodbcinst_path = normpath(joinpath(artifact_dir, libiodbcinst_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libiodbcinst_handle = dlopen(libiodbcinst_path)
    push!(LIBPATH_list, dirname(libiodbcinst_path))

    global iodbctest_path = normpath(joinpath(artifact_dir, iodbctest_splitpath...))

    push!(PATH_list, dirname(iodbctest_path))
    global libiodbc_path = normpath(joinpath(artifact_dir, libiodbc_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libiodbc_handle = dlopen(libiodbc_path)
    push!(LIBPATH_list, dirname(libiodbc_path))

    global iodbctestw_path = normpath(joinpath(artifact_dir, iodbctestw_splitpath...))

    push!(PATH_list, dirname(iodbctestw_path))
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

