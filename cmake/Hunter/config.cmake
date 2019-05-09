hunter_config(Boost VERSION 1.49.0)

hunter_config(console_bridge
    VERSION 0.4.3
    GIT_SUBMODULE "dependencies/console_bridge"
    KEEP_PACKAGE_SOURCES
    CMAKE_ARGS
        BUILD_SHARED_LIBS=OFF
)
