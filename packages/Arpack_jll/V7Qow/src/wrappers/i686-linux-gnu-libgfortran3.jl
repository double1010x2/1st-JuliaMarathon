# Autogenerated wrapper script for Arpack_jll for i686-linux-gnu-libgfortran3
export libarpack

using OpenBLAS_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "LD_LIBRARY_PATH"

# Relative path to `libarpack`
const libarpack_splitpath = ["lib", "libarpack.so"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libarpack_path = ""

# libarpack-specific global declaration
# This will be filled out by __init__()
libarpack_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libarpack = "libarpack.so.2"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"Arpack")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (OpenBLAS_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (OpenBLAS_jll.LIBPATH_list,))

    global libarpack_path = normpath(joinpath(artifact_dir, libarpack_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libarpack_handle = dlopen(libarpack_path)
    push!(LIBPATH_list, dirname(libarpack_path))

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

