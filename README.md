# C++ Embedded Web App - Windows

A production-ready C++ web application with an embedded HTTP server, RESTful API, and comprehensive test suite.

## Overview

**Location:** `C:\Wrok_Zone\cpp-embedded-web-app`

This project demonstrates modern C++20 development practices with:
- HTTP server using the Crow framework
- JSON REST API endpoints
- Interactive web interface (HTML/CSS/JavaScript)
- 8 comprehensive unit tests
- Automated build system (CMake + Conan)

## Quick Start

### 1. Install C++ Compiler

Choose one (MSVC recommended):

```powershell
# Option A: Visual Studio 2022 Build Tools
# Download: https://visualstudio.microsoft.com/downloads/
# Select: "Desktop development with C++"

# Option B: MinGW-w64
# Download: https://www.mingw-w64.org/

# Option C: LLVM/Clang
# Download: https://releases.llvm.org/
```

### 2. Build the Project

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app
powershell -ExecutionPolicy Bypass -File .\build.ps1 build
```

### 3. Run the Application

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 run
```

### 4. Access the Web Interface

Open browser: `http://127.0.0.1:8080`

## Project Structure

```
cpp-embedded-web-app/
├── CMakeLists.txt              Build configuration
├── conanfile.txt               Dependencies (Crow, ASIO)
├── build.ps1                   Automated build script
├── src/main.cpp                HTTP server application
├── tests/                      Unit tests (8 tests)
│   ├── test_main.cpp          Test framework
│   └── test_routes.cpp         Route tests
└── build/                      Build output directory
    └── cpp_embedded_web.exe    Main executable
```

## Features

- ✓ **Modern C++20** code
- ✓ **HTTP Server** with Crow framework
- ✓ **REST API** with JSON responses
- ✓ **Web UI** with embedded HTML/CSS/JavaScript
- ✓ **8 Unit Tests** validating functionality
- ✓ **CMake Build System** with Conan dependency management
- ✓ **Automated Scripts** for one-command builds
- ✓ **Static Linking** (executable runs standalone)

## Usage

### Run Application

```powershell
.\build\cpp_embedded_web.exe
```

Server starts on `http://127.0.0.1:8080`

### Test API Endpoint

```powershell
Invoke-RestMethod http://127.0.0.1:8080/api/message
# Returns: { "message": "Hello from C++" }
```

### Run Unit Tests

```powershell
.\build\cpp_embedded_web_tests.exe
```

Expected: `Passed: 8, Failed: 0`

## API Routes

| Route | Method | Returns |
|-------|--------|---------|
| `/` | GET | HTML web interface |
| `/api/message` | GET | `{"message": "Hello from C++"}` |

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Language | C++20 | - |
| Framework | Crow | 1.2.0 |
| Networking | ASIO | 1.29.0 |
| Build System | CMake | 3.21+ |
| Package Manager | Conan | 2.0+ |
| Supported Compilers | MSVC, MinGW, Clang | - |

## Documentation

- **[BUILD_GUIDE.md](BUILD_GUIDE.md)** - Complete build instructions
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheatsheet
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Architecture details
- **[INDEX.md](INDEX.md)** - Documentation index

## Development

### Add New Route

Edit `src/main.cpp`:

```cpp
CROW_ROUTE(app, "/api/users")
([] {
    return crow::json::wvalue{{"users", "data"}};
});
```

Rebuild: `cmake --build build`

### Add Unit Test

Edit `tests/test_routes.cpp` and add test function, then rebuild.

## Production Deployment

Before deployment:

- Build in Release mode (default)
- All 8 tests pass
- Input validation on all endpoints
- CORS headers configured
- Authentication implemented as needed
- Logging enabled
- Tested on clean Windows system

The executable is statically linked and requires no runtime dependencies.

## Troubleshooting

### "No C++ Compiler Found"
Install MSVC, MinGW, or Clang. See [BUILD_GUIDE.md](BUILD_GUIDE.md) for details.

### "Port 8080 Already In Use"
Edit `src/main.cpp` and change port number, then rebuild.

### "Build Failed"
Check [BUILD_GUIDE.md](BUILD_GUIDE.md) troubleshooting section.

## Resources

- [Crow HTTP Framework](https://crowcpp.org/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)
- [Conan Package Manager](https://docs.conan.io/)
- [ASIO Networking Library](https://think-async.com/Asio/)

---

**Status:** ✓ Ready for development and deployment  
**Last Updated:** 2026-11-26
