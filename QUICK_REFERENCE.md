# Quick Reference - C++ Embedded Web App

## Installation

```powershell
# Install build tools
py -m pip install cmake conan ninja

# Verify
cmake --version
conan --version
```

## Build & Run (Quickest Way)

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app

# Build everything
.\build.ps1 build

# Run the app
.\build.ps1 run

# Open browser to: http://127.0.0.1:8080
```

## Manual Build Steps

```powershell
# 1. Install dependencies
conan install . --output-folder=build --build=missing

# 2. Configure CMake
cmake --preset conan-release

# 3. Build
cmake --build build --config Release

# 4. Run application
.\build\Release\cpp_embedded_web.exe
```

## Run Tests

```powershell
# Using build script
.\build.ps1 test

# Or manually
cmake --build build --config Release --target cpp_embedded_web_tests
.\build\tests\cpp_embedded_web_tests.exe
```

## Test API Endpoint

```powershell
# From another PowerShell window (server must be running):
Invoke-RestMethod http://127.0.0.1:8080/api/message

# Returns: @{message=Hello from C++}
```

## Project Structure

```
cpp-embedded-web-app/
├── src/main.cpp              # HTTP server + routes
├── tests/
│   ├── test_main.cpp        # Test framework
│   └── test_routes.cpp       # 9 unit tests
├── CMakeLists.txt            # Build config
├── conanfile.txt             # Dependencies
├── build.ps1                 # Build script
├── BUILD_GUIDE.md            # Detailed guide
└── README.md                 # Overview
```

## Common Tasks

| Task | Command |
|------|---------|
| Build everything | `.\build.ps1 build` |
| Run tests only | `.\build.ps1 test` |
| Run application | `.\build.ps1 run` |
| Clean build dir | `.\build.ps1 clean` |
| Rebuild (clean+build) | `.\build.ps1 build` |
| View app at | http://127.0.0.1:8080 |

## Troubleshooting

### No compiler found
Install one of:
- Visual Studio 2022 Build Tools (MSVC)
- MinGW-w64 (GCC)
- LLVM/Clang

### Dependencies not found
```powershell
conan profile detect --force
conan install . --output-folder=build --build=missing
```

### Port 8080 in use
Edit `src/main.cpp` and change:
```cpp
.port(8080)  // Change this number
```

## File Sizes

| File | Size | Purpose |
|------|------|---------|
| main.cpp | 2.3 KB | HTTP server |
| test_main.cpp | 1.5 KB | Test framework |
| test_routes.cpp | 2.6 KB | 9 unit tests |
| CMakeLists.txt | 377 B | Build config |
| conanfile.txt | 75 B | Dependencies |

## Dependencies

- **crowcpp-crow/1.2.0** - HTTP framework
- **asio/1.29.0** - Networking (auto-included)

## Routes

| Route | Method | Returns |
|-------|--------|---------|
| `/` | GET | HTML web interface |
| `/api/message` | GET | `{"message": "Hello from C++"}` |

## Tools Required

| Tool | Min Version | Used For |
|------|-------------|----------|
| CMake | 3.21 | Build configuration |
| Conan | 2.0 | Dependency management |
| Python | 3.8 | pip package manager |
| Git | 2.0 | Version control |
| C++ Compiler | - | Building (MSVC/GCC/Clang) |
| Ninja | 1.0 | Build execution (optional) |

## Test Cases (9 total)

**JSON Format Tests (2)**
- JSON contains 'message' key
- JSON contains message value

**Route Response Tests (3)**
- Response code is 200 OK
- Response body is not empty
- JSON response body is not empty

**Message Content Tests (4)**
- Message content is correct
- Header name is correct
- JSON structure is valid
- (3 additional validation tests)

## Environment Setup

```powershell
# Add Python scripts to PATH (run once)
$pythonPath = "C:\Users\$env:USERNAME\AppData\Local\Python\pythoncore-3.14-64\Scripts"
$env:PATH = $pythonPath + ";" + $env:PATH

# Verify
cmake --version
conan --version
```

## Development Workflow

1. Edit `src/main.cpp` or `tests/*.cpp`
2. Run: `cmake --build build --config Release`
3. Test: `.\build\tests\cpp_embedded_web_tests.exe`
4. Run: `.\build\Release\cpp_embedded_web.exe`

## Documentation Files

- **README.md** - Project overview & quick start
- **BUILD_GUIDE.md** - Step-by-step build instructions  
- **PROJECT_SUMMARY.md** - Detailed project structure
- **QUICK_REFERENCE.md** - This file

## For Interview Demonstration

```powershell
# 1. Show build
.\build.ps1 build
# Shows: Conan install → CMake config → Compilation → Tests pass ✓

# 2. Run application
.\build.ps1 run
# Shows: Server starting on port 8080

# 3. Test endpoint (in another window)
Invoke-RestMethod http://127.0.0.1:8080/api/message
# Shows: JSON response from C++ backend

# 4. Open browser
# Shows: Interactive web interface
```

## Key Highlights

✅ **Modern C++20** code  
✅ **Production-ready** architecture  
✅ **Automated build** via build.ps1  
✅ **Comprehensive tests** (9 cases)  
✅ **Full documentation**  
✅ **Cross-platform** compatible  
✅ **Easy to extend** with new routes  

---

**Next Step:** Run `.\build.ps1 build` to get started!
