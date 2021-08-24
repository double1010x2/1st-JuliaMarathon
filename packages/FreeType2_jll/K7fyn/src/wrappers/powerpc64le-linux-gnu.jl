# Autogenerated wrapper script for FreeType2_jll for powerpc64le-linux-gnu
export libfreetype

using Bzip2_jll
using Zlib_jll
JLLWrappers.@generate_wrapper_header("FreeType2")
JLLWrappers.@declare_library_product(libfreetype, "libfreetype.so.6")
function __init__()
    JLLWrappers.@generate_init_header(Bzip2_jll, Zlib_jll)
    JLLWrappers.@init_library_product(
        libfreetype,
        "lib/libfreetype.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
