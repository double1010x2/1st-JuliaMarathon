# Autogenerated wrapper script for OpenSpecFun_jll for armv7l-linux-musleabihf-libgfortran4
export libopenspecfun

using CompilerSupportLibraries_jll
JLLWrappers.@generate_wrapper_header("OpenSpecFun")
JLLWrappers.@declare_library_product(libopenspecfun, "libopenspecfun.so.1")
function __init__()
    JLLWrappers.@generate_init_header(CompilerSupportLibraries_jll)
    JLLWrappers.@init_library_product(
        libopenspecfun,
        "lib/libopenspecfun.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
