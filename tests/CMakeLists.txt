cmake_minimum_required(VERSION 3.21)

# Using a simple testing approach without external dependencies
add_executable(cpp_embedded_web_tests
    test_main.cpp
    test_routes.cpp
)

target_compile_features(cpp_embedded_web_tests PRIVATE cxx_std_20)
target_include_directories(cpp_embedded_web_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Link Crow for testing
target_link_libraries(cpp_embedded_web_tests PRIVATE
    Crow::Crow
)

# Self-contained test executable on MinGW (no runtime DLL dependency).
if(MINGW)
    target_link_options(cpp_embedded_web_tests PRIVATE
        -static -static-libgcc -static-libstdc++)
endif()

add_test(NAME cpp_embedded_web_tests COMMAND cpp_embedded_web_tests)
