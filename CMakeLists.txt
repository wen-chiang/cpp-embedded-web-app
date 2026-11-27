cmake_minimum_required(VERSION 3.21)

project(cpp_embedded_web
    VERSION 1.0
    LANGUAGES CXX
)

find_package(Crow CONFIG REQUIRED)

add_executable(cpp_embedded_web
    src/main.cpp
)

target_compile_features(cpp_embedded_web PRIVATE cxx_std_20)

target_link_libraries(cpp_embedded_web PRIVATE
    Crow::Crow
)

# Produce a self-contained executable on MinGW so it runs without the
# MinGW runtime DLLs (libstdc++, libgcc, libwinpthread) being on PATH.
if(MINGW)
    target_link_options(cpp_embedded_web PRIVATE
        -static -static-libgcc -static-libstdc++)
endif()

enable_testing()
add_subdirectory(tests)
