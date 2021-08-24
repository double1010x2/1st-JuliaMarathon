# Autogenerated wrapper script for Qt5Declarative_jll for armv7l-linux-gnueabihf-cxx03
export libqt5qml, libqt5qmlmodels, libqt5qmlworkerscript, libqt5quick, libqt5quickparticles, libqt5quickshapes, libqt5quicktest, libqt5quickwidgets

using Qt5Base_jll
JLLWrappers.@generate_wrapper_header("Qt5Declarative")
JLLWrappers.@declare_library_product(libqt5qml, "libQt5Qml.so.5")
JLLWrappers.@declare_library_product(libqt5qmlmodels, "libQt5QmlModels.so.5")
JLLWrappers.@declare_library_product(libqt5qmlworkerscript, "libQt5QmlWorkerScript.so.5")
JLLWrappers.@declare_library_product(libqt5quick, "libQt5Quick.so.5")
JLLWrappers.@declare_library_product(libqt5quickparticles, "libQt5QuickParticles.so.5")
JLLWrappers.@declare_library_product(libqt5quickshapes, "libQt5QuickShapes.so.5")
JLLWrappers.@declare_library_product(libqt5quicktest, "libQt5QuickTest.so.5")
JLLWrappers.@declare_library_product(libqt5quickwidgets, "libQt5QuickWidgets.so.5")
function __init__()
    JLLWrappers.@generate_init_header(Qt5Base_jll)
    JLLWrappers.@init_library_product(
        libqt5qml,
        "lib/libQt5Qml.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5qmlmodels,
        "lib/libQt5QmlModels.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5qmlworkerscript,
        "lib/libQt5QmlWorkerScript.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5quick,
        "lib/libQt5Quick.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5quickparticles,
        "lib/libQt5QuickParticles.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5quickshapes,
        "lib/libQt5QuickShapes.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5quicktest,
        "lib/libQt5QuickTest.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@init_library_product(
        libqt5quickwidgets,
        "lib/libQt5QuickWidgets.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
