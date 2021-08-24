# Autogenerated wrapper script for Blosc_jll for i686-w64-mingw32-cxx03
export libblosc

using Zlib_jll
using Zstd_jll
using Lz4_jll
JLLWrappers.@generate_wrapper_header("Blosc")
JLLWrappers.@declare_library_product(libblosc, "libblosc.dll")
function __init__()
    JLLWrappers.@generate_init_header(Zlib_jll, Zstd_jll, Lz4_jll)
    JLLWrappers.@init_library_product(
        libblosc,
        "bin\\libblosc.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
