# Autogenerated wrapper script for HDF5_jll for x86_64-apple-darwin14
export libhdf5, libhdf5_hl

using Zlib_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "DYLD_FALLBACK_LIBRARY_PATH"

# Relative path to `libhdf5`
const libhdf5_splitpath = ["lib", "libhdf5.103.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libhdf5_path = ""

# libhdf5-specific global declaration
# This will be filled out by __init__()
libhdf5_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libhdf5 = "@rpath/libhdf5.103.dylib"


# Relative path to `libhdf5_hl`
const libhdf5_hl_splitpath = ["lib", "libhdf5_hl.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libhdf5_hl_path = ""

# libhdf5_hl-specific global declaration
# This will be filled out by __init__()
libhdf5_hl_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libhdf5_hl = "@rpath/libhdf5_hl.100.dylib"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"HDF5")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (Zlib_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (Zlib_jll.LIBPATH_list,))

    global libhdf5_path = normpath(joinpath(artifact_dir, libhdf5_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libhdf5_handle = dlopen(libhdf5_path)
    push!(LIBPATH_list, dirname(libhdf5_path))

    global libhdf5_hl_path = normpath(joinpath(artifact_dir, libhdf5_hl_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libhdf5_hl_handle = dlopen(libhdf5_hl_path)
    push!(LIBPATH_list, dirname(libhdf5_hl_path))

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

