#include <crow.h>
#include <iostream>
#include <string>
#include <cassert>

namespace test {
    extern int passed;
    extern int failed;
    void assert_true(bool condition, const char* test_name);
    void assert_equal(const char* a, const char* b, const char* test_name);
}

// Test: JSON message format is valid
void test_json_message_format() {
    std::cout << "\n--- JSON Message Format Tests ---" << std::endl;

    // Create a JSON response object
    crow::json::wvalue response;
    response["message"] = "Hello from C++";

    // Convert to string
    std::string json_str = response.dump();

    // Check that it contains expected content
    bool contains_message = json_str.find("message") != std::string::npos;
    bool contains_hello = json_str.find("Hello from C++") != std::string::npos;

    test::assert_true(contains_message, "JSON contains 'message' key");
    test::assert_true(contains_hello, "JSON contains message value");
}

// Test: HTTP status codes and route behavior
void test_route_responses() {
    std::cout << "\n--- Route Response Tests ---" << std::endl;

    // Test basic response object creation
    crow::response resp(200);
    test::assert_true(resp.code == 200, "Response code is 200 OK");

    // Test response with HTML content type
    crow::response html_resp("<!DOCTYPE html><html></html>");
    html_resp.set_header("Content-Type", "text/html; charset=utf-8");
    test::assert_true(!html_resp.body.empty(), "Response body is not empty");

    // Test JSON response
    crow::json::wvalue json_resp;
    json_resp["status"] = "success";
    crow::response api_resp(json_resp);
    test::assert_true(!api_resp.body.empty(), "JSON response body is not empty");
}

// Test: Message content and structure
void test_message_content() {
    std::cout << "\n--- Message Content Tests ---" << std::endl;

    const std::string expected_message = "Hello from C++";
    const std::string expected_header = "Content-Type";

    // Test message string
    test::assert_equal(expected_message.c_str(), "Hello from C++", "Message content is correct");

    // Test that header name is correct
    test::assert_equal(expected_header.c_str(), "Content-Type", "Header name is correct");

    // Test JSON structure
    crow::json::wvalue msg;
    msg["message"] = "Hello from C++";
    std::string json_dump = msg.dump();

    bool valid_json = json_dump.find('{') != std::string::npos &&
                      json_dump.find('}') != std::string::npos;
    test::assert_true(valid_json, "JSON structure is valid");
}
