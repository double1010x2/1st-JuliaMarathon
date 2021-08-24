# Autogenerated wrapper script for Gettext_jll for i686-w64-mingw32-cxx11
export libgettext

using CompilerSupportLibraries_jll
using Libiconv_jll
using XML2_jll
JLLWrappers.@generate_wrapper_header("Gettext")
JLLWrappers.@declare_library_product(libgettext, "libgettextlib-0-21.dll")
function __init__()
    JLLWrappers.@generate_init_header(CompilerSupportLibraries_jll, Libiconv_jll, XML2_jll)
    JLLWrappers.@init_library_product(
        libgettext,
        "bin\\libgettextlib-0-21.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
