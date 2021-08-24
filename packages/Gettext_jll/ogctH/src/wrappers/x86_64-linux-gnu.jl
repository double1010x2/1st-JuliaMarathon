# Autogenerated wrapper script for Gettext_jll for x86_64-linux-gnu
export libgettext

using Libiconv_jll
using XML2_jll
JLLWrappers.@generate_wrapper_header("Gettext")
JLLWrappers.@declare_library_product(libgettext, "libgettextlib-0.20.1.so")
function __init__()
    JLLWrappers.@generate_init_header(Libiconv_jll, XML2_jll)
    JLLWrappers.@init_library_product(
        libgettext,
        "lib/libgettextlib.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
