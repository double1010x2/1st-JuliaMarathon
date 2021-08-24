# Autogenerated wrapper script for FriBidi_jll for i686-w64-mingw32
export fribidi, libfribidi

JLLWrappers.@generate_wrapper_header("FriBidi")
JLLWrappers.@declare_executable_product(fribidi)
JLLWrappers.@declare_library_product(libfribidi, "libfribidi-0.dll")
function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_executable_product(
        fribidi,
        "bin/fribidi.exe",
    )

    JLLWrappers.@init_library_product(
        libfribidi,
        "bin/libfribidi-0.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
