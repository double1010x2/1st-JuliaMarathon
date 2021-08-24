# Autogenerated wrapper script for FFMPEG_jll for x86_64-apple-darwin14
export libavfilter, libswresample, ffprobe, libavutil, libavdevice, libpostproc, libavformat, ffmpeg, libswscale, libavcodec, libavresample

using libass_jll
using libfdk_aac_jll
using FriBidi_jll
using FreeType2_jll
using LAME_jll
using libvorbis_jll
using Ogg_jll
using LibVPX_jll
using x264_jll
using x265_jll
using Bzip2_jll
using Zlib_jll
using OpenSSL_jll
using Opus_jll
## Global variables
PATH = ""
LIBPATH = ""
LIBPATH_env = "DYLD_FALLBACK_LIBRARY_PATH"

# Relative path to `libavfilter`
const libavfilter_splitpath = ["lib", "libavfilter.7.40.101.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavfilter_path = ""

# libavfilter-specific global declaration
# This will be filled out by __init__()
libavfilter_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavfilter = "@rpath/libavfilter.7.dylib"


# Relative path to `libswresample`
const libswresample_splitpath = ["lib", "libswresample.3.3.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libswresample_path = ""

# libswresample-specific global declaration
# This will be filled out by __init__()
libswresample_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libswresample = "@rpath/libswresample.3.dylib"


# Relative path to `ffprobe`
const ffprobe_splitpath = ["bin", "ffprobe"]

# This will be filled out by __init__() for all products, as it must be done at runtime
ffprobe_path = ""

# ffprobe-specific global declaration
function ffprobe(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
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
        if !isempty(get(ENV, LIBPATH_env, ""))
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', ENV[LIBPATH_env])
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(ffprobe_path)
    end
end


# Relative path to `libavutil`
const libavutil_splitpath = ["lib", "libavutil.56.22.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavutil_path = ""

# libavutil-specific global declaration
# This will be filled out by __init__()
libavutil_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavutil = "@rpath/libavutil.56.dylib"


# Relative path to `libavdevice`
const libavdevice_splitpath = ["lib", "libavdevice.58.5.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavdevice_path = ""

# libavdevice-specific global declaration
# This will be filled out by __init__()
libavdevice_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavdevice = "@rpath/libavdevice.58.dylib"


# Relative path to `libpostproc`
const libpostproc_splitpath = ["lib", "libpostproc.55.3.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libpostproc_path = ""

# libpostproc-specific global declaration
# This will be filled out by __init__()
libpostproc_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libpostproc = "@rpath/libpostproc.55.dylib"


# Relative path to `libavformat`
const libavformat_splitpath = ["lib", "libavformat.58.20.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavformat_path = ""

# libavformat-specific global declaration
# This will be filled out by __init__()
libavformat_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavformat = "@rpath/libavformat.58.dylib"


# Relative path to `ffmpeg`
const ffmpeg_splitpath = ["bin", "ffmpeg"]

# This will be filled out by __init__() for all products, as it must be done at runtime
ffmpeg_path = ""

# ffmpeg-specific global declaration
function ffmpeg(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
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
        if !isempty(get(ENV, LIBPATH_env, ""))
            env_mapping[LIBPATH_env] = string(LIBPATH, ':', ENV[LIBPATH_env])
        else
            env_mapping[LIBPATH_env] = LIBPATH
        end
    end
    withenv(env_mapping...) do
        f(ffmpeg_path)
    end
end


# Relative path to `libswscale`
const libswscale_splitpath = ["lib", "libswscale.5.3.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libswscale_path = ""

# libswscale-specific global declaration
# This will be filled out by __init__()
libswscale_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libswscale = "@rpath/libswscale.5.dylib"


# Relative path to `libavcodec`
const libavcodec_splitpath = ["lib", "libavcodec.58.35.100.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavcodec_path = ""

# libavcodec-specific global declaration
# This will be filled out by __init__()
libavcodec_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavcodec = "@rpath/libavcodec.58.dylib"


# Relative path to `libavresample`
const libavresample_splitpath = ["lib", "libavresample.4.0.0.dylib"]

# This will be filled out by __init__() for all products, as it must be done at runtime
libavresample_path = ""

# libavresample-specific global declaration
# This will be filled out by __init__()
libavresample_handle = C_NULL

# This must be `const` so that we can use it with `ccall()`
const libavresample = "@rpath/libavresample.4.dylib"


"""
Open all libraries
"""
function __init__()
    global artifact_dir = abspath(artifact"FFMPEG")

    # Initialize PATH and LIBPATH environment variable listings
    global PATH_list, LIBPATH_list
    # We first need to add to LIBPATH_list the libraries provided by Julia
    append!(LIBPATH_list, [joinpath(Sys.BINDIR, Base.LIBDIR, "julia"), joinpath(Sys.BINDIR, Base.LIBDIR)])
    # From the list of our dependencies, generate a tuple of all the PATH and LIBPATH lists,
    # then append them to our own.
    foreach(p -> append!(PATH_list, p), (libass_jll.PATH_list, libfdk_aac_jll.PATH_list, FriBidi_jll.PATH_list, FreeType2_jll.PATH_list, LAME_jll.PATH_list, libvorbis_jll.PATH_list, Ogg_jll.PATH_list, LibVPX_jll.PATH_list, x264_jll.PATH_list, x265_jll.PATH_list, Bzip2_jll.PATH_list, Zlib_jll.PATH_list, OpenSSL_jll.PATH_list, Opus_jll.PATH_list,))
    foreach(p -> append!(LIBPATH_list, p), (libass_jll.LIBPATH_list, libfdk_aac_jll.LIBPATH_list, FriBidi_jll.LIBPATH_list, FreeType2_jll.LIBPATH_list, LAME_jll.LIBPATH_list, libvorbis_jll.LIBPATH_list, Ogg_jll.LIBPATH_list, LibVPX_jll.LIBPATH_list, x264_jll.LIBPATH_list, x265_jll.LIBPATH_list, Bzip2_jll.LIBPATH_list, Zlib_jll.LIBPATH_list, OpenSSL_jll.LIBPATH_list, Opus_jll.LIBPATH_list,))

    global libavfilter_path = normpath(joinpath(artifact_dir, libavfilter_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavfilter_handle = dlopen(libavfilter_path)
    push!(LIBPATH_list, dirname(libavfilter_path))

    global libswresample_path = normpath(joinpath(artifact_dir, libswresample_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libswresample_handle = dlopen(libswresample_path)
    push!(LIBPATH_list, dirname(libswresample_path))

    global ffprobe_path = normpath(joinpath(artifact_dir, ffprobe_splitpath...))

    push!(PATH_list, dirname(ffprobe_path))
    global libavutil_path = normpath(joinpath(artifact_dir, libavutil_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavutil_handle = dlopen(libavutil_path)
    push!(LIBPATH_list, dirname(libavutil_path))

    global libavdevice_path = normpath(joinpath(artifact_dir, libavdevice_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavdevice_handle = dlopen(libavdevice_path)
    push!(LIBPATH_list, dirname(libavdevice_path))

    global libpostproc_path = normpath(joinpath(artifact_dir, libpostproc_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libpostproc_handle = dlopen(libpostproc_path)
    push!(LIBPATH_list, dirname(libpostproc_path))

    global libavformat_path = normpath(joinpath(artifact_dir, libavformat_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavformat_handle = dlopen(libavformat_path)
    push!(LIBPATH_list, dirname(libavformat_path))

    global ffmpeg_path = normpath(joinpath(artifact_dir, ffmpeg_splitpath...))

    push!(PATH_list, dirname(ffmpeg_path))
    global libswscale_path = normpath(joinpath(artifact_dir, libswscale_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libswscale_handle = dlopen(libswscale_path)
    push!(LIBPATH_list, dirname(libswscale_path))

    global libavcodec_path = normpath(joinpath(artifact_dir, libavcodec_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavcodec_handle = dlopen(libavcodec_path)
    push!(LIBPATH_list, dirname(libavcodec_path))

    global libavresample_path = normpath(joinpath(artifact_dir, libavresample_splitpath...))

    # Manually `dlopen()` this right now so that future invocations
    # of `ccall` with its `SONAME` will find this path immediately.
    global libavresample_handle = dlopen(libavresample_path)
    push!(LIBPATH_list, dirname(libavresample_path))

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

