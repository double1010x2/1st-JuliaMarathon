# Autogenerated wrapper script for XML2_jll for aarch64-linux-gnu
export libxml2, xmlcatalog, xmllint

using Zlib_jll
using Libiconv_jll
JLLWrappers.@generate_wrapper_header("XML2")
JLLWrappers.@declare_library_product(libxml2, "libxml2.so.2")
JLLWrappers.@declare_executable_product(xmlcatalog)
JLLWrappers.@declare_executable_product(xmllint)
function __init__()
    JLLWrappers.@generate_init_header(Zlib_jll, Libiconv_jll)
    JLLWrappers.@init_library_product(
        libxml2,
        "lib/libxml2.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_executable_product(
        xmlcatalog,
        "bin/xmlcatalog",
    )

    JLLWrappers.@init_executable_product(
        xmllint,
        "bin/xmllint",
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
