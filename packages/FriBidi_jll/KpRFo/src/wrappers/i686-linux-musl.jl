# Autogenerated wrapper script for FriBidi_jll for i686-linux-musl
export fribidi, libfribidi

## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "LD_LIBRARY_PATH"
LIBPATH_default = ""

# Relative path to `fribidi`
const fribidi_splitpath = ["bin", "fribidi"]

# This will be filled out by __init__() for all products, as it must be done at runtime
fribidi_path = ""

# fribidi-specific global declaration
function fribidi(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
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
        f(fribidi_path)
    end
end


# Relative path to `libfribidi`
const libfribidi_splitpath = ["lib", "libfribidi.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libfribidi_path = ""

# libfribidi-specific global declaration
# This will be filled out by __init__()
libfribidi_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libfribidi = "libfribidi.so.0"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"FriBidi")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    global fribidi_path = normpath(joinpath(artifact_dir, fribidi_splitpath...))

    push!(PATH_list, dirname(fribidi_path))
    global libfribidi_path = normpath(joinpath(artifact_dir, libfribidi_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libfribidi_handle = dlopen(libfribidi_path)
    push!(LIBPATH_list, dirname(libfribidi_path))

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

