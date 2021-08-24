# Autogenerated wrapper script for Bzip2_jll for x86_64-w64-mingw32
export libbzip2

## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "PATH"

# Relative path to `libbzip2`
const libbzip2_splitpath = ["bin", "libbz2-1.dll"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libbzip2_path = ""

# libbzip2-specific global declaration
# This will be filled out by __init__()
libbzip2_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libbzip2 = "libbz2-1.dll"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"Bzip2")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [Sys.BINDIR, joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    global libbzip2_path = normpath(joinpath(artifact_dir, libbzip2_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libbzip2_handle = dlopen(libbzip2_path)
    push!(LIBPATH_list, dirname(libbzip2_path))

    # Filter out duplicate and empty entries in our PATH and LIBPATH entries
    filter!(!isempty, unique!(PATH_list))
    filter!(!isempty, unique!(LIBPATH_list))
    global PATH = join(PATH_list, ';')
    global LIBPATH = join(LIBPATH_list, ';')

    # Add each element of LIBPATH to our DL_LOAD_PATH (necessary on platforms
    # that don't honor our "already opened" trick)
    #for lp in LIBPATH_list
    #    push!(DL_LOAD_PATH, lp)
    #end
end  # __init__()

