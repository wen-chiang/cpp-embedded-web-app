# Build Guide - C++ Embedded Web App

Complete build and deployment instructions for the C++ Embedded Web App project on Windows.

## Prerequisites

The following tools are required. All except the C++ compiler are already installed.

| Tool | Requirement | Status |
|------|-------------|--------|
| Python | 3.8+ | ✓ Installed (3.14.8) |
| CMake | 3.21+ | ✓ Installed (4.4.5) |
| Conan | 2.0+ | ✓ Installed (2.34.0) |
| Git | 2.0+ | ✓ Installed (2.56.0) |
| Ninja | 1.0+ | ✓ Installed |
| **C++ Compiler** | Any one below | ⚠️ **Required** |

### C++ Compiler Installation

You must install ONE of the following C++ compilers:

#### Option 1: Visual Studio 2022 Build Tools (Recommended)

Download from: https://visualstudio.microsoft.com/downloads/

1. Run the installer
2. Select: "Desktop development with C++"
3. Install (10-15 minutes, 2-4 GB)
4. Verify: Open PowerShell and run:
   ```powershell
   cl
   ```
   Should show MSVC version information

#### Option 2: MinGW-w64 (Lightweight)

Download from: https://www.mingw-w64.org/

1. Recommended: Download **w64devkit** (precompiled)
2. Extract to `C:\mingw64`
3. Add to PATH:
   ```powershell
   # Temporary (current session):
   $env:PATH = "C:\mingw64\bin;" + $env:PATH
   
   # Permanent (all sessions):
   # Settings → Environment Variables → Path → Add C:\mingw64\bin
   ```
4. Verify: Run:
   ```powershell
   gcc --version
   g++ --version
   ```

#### Option 3: LLVM/Clang

Download from: https://releases.llvm.org/

1. Download Windows installer (17.x or later)
2. Run installer
3. Check: "Add LLVM to PATH" during installation
4. Verify: Run:
   ```powershell
   clang --version
   ```

## Compiler Comparison

| Feature | MSVC | MinGW-w64 | Clang |
|---------|------|-----------|-------|
| Download Size | 2-4 GB | 500 MB | 1-2 GB |
| Installation Time | 10-15 min | 5-10 min | 5-10 min |
| Recommended | ✓ Yes | ✓ Good | ✓ Good |
| C++20 Support | ✓ Excellent | ✓ Good | ✓ Excellent |

---

## Building the Project

### Quick Method (Recommended)

After installing a C++ compiler, simply run:

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app
powershell -ExecutionPolicy Bypass -File .\build.ps1 build
```

The script will:
1. Locate the C++ compiler automatically
2. Install dependencies via Conan
3. Configure CMake
4. Compile the application and test suite
5. Run all 8 unit tests
6. Display results

### Manual Method (Step-by-Step)

#### Step 1: Install Dependencies

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app
conan install . --output-folder=build --build=missing
```

This downloads Crow HTTP framework and ASIO networking library.

#### Step 2: Configure CMake

Using CMake presets (requires CMake 3.23+):

```powershell
cmake --preset conan-release
```

Or manual configuration:

```powershell
cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake
```

#### Step 3: Compile

```powershell
cmake --build build
```

#### Step 4: Verify Build

Check that executable exists:

```powershell
Test-Path .\build\cpp_embedded_web.exe
```

Should return `True`.

---

## Running the Application

### Quick Method

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 run
```

### Manual Method

```powershell
.\build\cpp_embedded_web.exe
```

Expected output:
```
(2026-11-26 21:04:07) Crow/0.3 server is running at http://127.0.0.1:8080
(2026-11-26 21:04:07) Call `app.loglevel(crow::LogLevel::Debug)` to see debugging logs
```

The server listens on `http://127.0.0.1:8080`

### Stop the Server

Press `Ctrl+C` in the PowerShell window.

---

## Testing

### Run All Tests

After building, run the test suite:

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 test
```

Or manually:

```powershell
.\build\cpp_embedded_web_tests.exe
```

Expected output:
```
=== C++ Embedded Web App - Test Suite ===

--- JSON Message Format Tests ---
[PASS] JSON contains 'message' key
[PASS] JSON contains message value

--- Route Response Tests ---
[PASS] Response code is 200 OK
[PASS] Response body is not empty
[PASS] JSON response body is not empty

--- Message Content Tests ---
[PASS] Message content is correct
[PASS] Header name is correct
[PASS] JSON structure is valid

=== Test Summary ===
Passed: 8
Failed: 0
Total:  8
```

### Test API Endpoint

While the application is running, test the API in another PowerShell window:

```powershell
Invoke-RestMethod http://127.0.0.1:8080/api/message
```

Expected response:
```
message
-------
Hello from C++
```

### Access Web Interface

Open browser to: `http://127.0.0.1:8080`

You should see the web interface with a button to test the C++ endpoint.

---

## Project Structure

```
cpp-embedded-web-app/
├── CMakeLists.txt              Main build configuration
├── conanfile.txt               Conan dependency manifest
├── build.ps1                   Automated build script
│
├── src/
│   └── main.cpp                HTTP server (Crow framework)
│
├── tests/
│   ├── CMakeLists.txt          Test build configuration
│   ├── test_main.cpp           Test framework
│   └── test_routes.cpp         Unit tests (8 total)
│
└── build/                      Build output directory
    ├── cpp_embedded_web.exe    Main executable
    └── cpp_embedded_web_tests.exe  Test executable
```

---

## Development Workflow

### Add New API Route

1. Edit `src/main.cpp`
2. Add route:
   ```cpp
   CROW_ROUTE(app, "/api/users")
   ([] {
       return crow::json::wvalue{{"users", "data"}};
   });
   ```
3. Rebuild:
   ```powershell
   cmake --build build
   ```

### Add Unit Test

1. Edit `tests/test_routes.cpp`
2. Add test function:
   ```cpp
   void test_new_feature() {
       std::cout << "\n--- New Feature Tests ---" << std::endl;
       test::assert_true(condition, "Test description");
   }
   ```
3. Call test from `main()` in `test_main.cpp`
4. Rebuild tests:
   ```powershell
   cmake --build build --target cpp_embedded_web_tests
   ```

### Change Server Port

Edit `src/main.cpp` and modify:
```cpp
app.port(8080)  // Change to desired port
```

Then rebuild.

---

## Troubleshooting

### Build Error: "No C++ Compiler Found"

**Cause:** No C++ compiler installed or not on PATH.

**Solution:**
1. Install one of the three compilers (MSVC, MinGW, or Clang) listed above
2. Restart PowerShell
3. Verify: Run `cl`, `gcc --version`, or `clang --version`
4. Retry build

### Build Error: "Could Not Find Toolchain File"

**Cause:** Conan toolchain not generated.

**Solution:**
```powershell
# Remove build directory
Remove-Item -Recurse build

# Reinstall dependencies
conan install . --output-folder=build --build=missing

# Retry build
cmake --preset conan-release
```

### Build Error: "Settings.Compiler Value Not Defined"

**Cause:** Conan profile missing compiler settings.

**Solution:**
```powershell
# Update Conan profile
conan profile detect --force

# Verify profile at:
# C:\Users\<username>\.conan2\profiles\default
```

### Application Error: "Port Already In Use"

**Cause:** Another application uses port 8080.

**Solution:** Edit `src/main.cpp` and change port number, then rebuild.

### Application Crash on Startup

**Cause:** Missing runtime dependencies.

**Solution:** Ensure the executable was built successfully with:
```powershell
Test-Path .\build\cpp_embedded_web.exe
```

---

## Production Deployment

Before deploying to production:

1. ✓ Build in Release mode (default)
2. ✓ All 8 tests pass
3. ✓ Input validation on all API endpoints
4. ✓ CORS headers configured appropriately
5. ✓ Authentication implemented for sensitive operations
6. ✓ Structured logging enabled
7. ✓ Tested on clean Windows machine
8. ✓ Runtime dependencies packaged or statically linked

The executable `build\cpp_embedded_web.exe` is statically linked and can run on any Windows system without additional runtime dependencies.

---

## Additional Resources

- [Crow HTTP Framework](https://crowcpp.org/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)
- [Conan Package Manager](https://docs.conan.io/)
- [ASIO Networking Library](https://think-async.com/Asio/)
