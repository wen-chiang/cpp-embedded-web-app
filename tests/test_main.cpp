#include <iostream>
#include <cassert>

// Simple test framework
namespace test {
    int passed = 0;
    int failed = 0;

    void assert_true(bool condition, const char* test_name) {
        if (condition) {
            std::cout << "[PASS] " << test_name << std::endl;
            passed++;
        } else {
            std::cout << "[FAIL] " << test_name << std::endl;
            failed++;
        }
    }

    void assert_equal(const char* a, const char* b, const char* test_name) {
        if (std::string(a) == std::string(b)) {
            std::cout << "[PASS] " << test_name << std::endl;
            passed++;
        } else {
            std::cout << "[FAIL] " << test_name << " - Expected: " << b << ", Got: " << a << std::endl;
            failed++;
        }
    }

    void print_summary() {
        std::cout << "\n=== Test Summary ===" << std::endl;
        std::cout << "Passed: " << passed << std::endl;
        std::cout << "Failed: " << failed << std::endl;
        std::cout << "Total:  " << (passed + failed) << std::endl;
    }
}

// Forward declarations from test_routes.cpp
void test_json_message_format();
void test_route_responses();
void test_message_content();

int main() {
    std::cout << "=== C++ Embedded Web App - Test Suite ===" << std::endl << std::endl;

    // Run test suites
    test_json_message_format();
    test_route_responses();
    test_message_content();

    test::print_summary();

    return test::failed > 0 ? 1 : 0;
}
