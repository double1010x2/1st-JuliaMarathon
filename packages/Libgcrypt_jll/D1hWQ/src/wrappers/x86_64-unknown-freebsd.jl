# Autogenerated wrapper script for Libgcrypt_jll for x86_64-unknown-freebsd
export libgcrypt

using Libgpg_error_jll
JLLWrappers.@generate_wrapper_header("Libgcrypt")
JLLWrappers.@declare_library_product(libgcrypt, "libgcrypt.so.22")
function __init__()
    JLLWrappers.@generate_init_header(Libgpg_error_jll)
    JLLWrappers.@init_library_product(
        libgcrypt,
        "lib/libgcrypt.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
