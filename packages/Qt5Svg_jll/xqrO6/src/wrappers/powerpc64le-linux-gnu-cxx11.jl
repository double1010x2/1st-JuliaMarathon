# Autogenerated wrapper script for Qt5Svg_jll for powerpc64le-linux-gnu-cxx11
export libqt5svg

using Qt5Base_jll
JLLWrappers.@generate_wrapper_header("Qt5Svg")
JLLWrappers.@declare_library_product(libqt5svg, "libQt5Svg.so.5")
function __init__()
    JLLWrappers.@generate_init_header(Qt5Base_jll)
    JLLWrappers.@init_library_product(
        libqt5svg,
        "lib/libQt5Svg.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
