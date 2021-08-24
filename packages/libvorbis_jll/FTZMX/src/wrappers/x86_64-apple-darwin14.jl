# Autogenerated wrapper script for libvorbis_jll for x86_64-apple-darwin14
export libvorbisenc, libvorbisfile, libvorbis

using Ogg_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "DYLD_FALLBACK_LIBRARY_PATH"

# Relative path to `libvorbisenc`
const libvorbisenc_splitpath = ["lib", "libvorbisenc.2.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libvorbisenc_path = ""

# libvorbisenc-specific global declaration
# This will be filled out by __init__()
libvorbisenc_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libvorbisenc = "@rpath/libvorbisenc.2.dylib"


# Relative path to `libvorbisfile`
const libvorbisfile_splitpath = ["lib", "libvorbisfile.3.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libvorbisfile_path = ""

# libvorbisfile-specific global declaration
# This will be filled out by __init__()
libvorbisfile_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libvorbisfile = "@rpath/libvorbisfile.3.dylib"


# Relative path to `libvorbis`
const libvorbis_splitpath = ["lib", "libvorbis.0.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libvorbis_path = ""

# libvorbis-specific global declaration
# This will be filled out by __init__()
libvorbis_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libvorbis = "@rpath/libvorbis.0.dylib"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"libvorbis")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (Ogg_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (Ogg_jll.LIBPATH_list,))

    global libvorbisenc_path = normpath(joinpath(artifact_dir, libvorbisenc_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libvorbisenc_handle = dlopen(libvorbisenc_path)
    push!(LIBPATH_list, dirname(libvorbisenc_path))

    global libvorbisfile_path = normpath(joinpath(artifact_dir, libvorbisfile_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libvorbisfile_handle = dlopen(libvorbisfile_path)
    push!(LIBPATH_list, dirname(libvorbisfile_path))

    global libvorbis_path = normpath(joinpath(artifact_dir, libvorbis_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libvorbis_handle = dlopen(libvorbis_path)
    push!(LIBPATH_list, dirname(libvorbis_path))

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

