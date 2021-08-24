# Autogenerated wrapper script for LAME_jll for x86_64-w64-mingw32
export lame, libmp3lame

JLLWrappers.@generate_wrapper_header("LAME")
JLLWrappers.@declare_executable_product(lame)
JLLWrappers.@declare_library_product(libmp3lame, "libmp3lame-0.dll")
function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_executable_product(
        lame,
        "bin/lame.exe",
    )

    JLLWrappers.@init_library_product(
        libmp3lame,
        "bin/libmp3lame-0.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
