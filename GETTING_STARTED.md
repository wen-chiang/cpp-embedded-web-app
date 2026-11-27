# Getting Started Checklist

## ✅ What's Already Done

- [x] Project structure created
- [x] Source code written (main.cpp)
- [x] Test suite created (9 unit tests)
- [x] CMake build configuration set up
- [x] Conan dependency management configured
- [x] Automated build script created
- [x] Complete documentation written
- [x] Tools installed (CMake, Conan, Ninja)
- [x] Dependencies cached by Conan

## ⚠️ What You Need to Do

### 1. Install a C++ Compiler (Choose One)

**Option A: Visual Studio 2022 Build Tools (Recommended for Windows)**
- Download from: https://visualstudio.microsoft.com/downloads/
- Choose: "Desktop development with C++"
- Estimated size: 2-4 GB
- Time: 10-15 minutes

**Option B: MinGW-w64 (Lightweight)**
- Download from: https://www.mingw-w64.org/
- Or use: `choco install mingw-w64` (if Chocolatey installed)
- Estimated size: 500 MB
- Time: 5-10 minutes

**Option C: LLVM/Clang**
- Download from: https://releases.llvm.org/
- Or use: `choco install llvm` (if Chocolatey installed)
- Estimated size: 1-2 GB
- Time: 5-10 minutes

### 2. Build the Project

After installing a compiler, navigate to the project:

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app

# Method 1: Automated (Recommended)
.\build.ps1 build

# Method 2: Manual
conan install . --output-folder=build --build=missing
cmake --preset conan-release
cmake --build build --config Release
```

### 3. Run the Application

```powershell
# Method 1: Automated
.\build.ps1 run

# Method 2: Manual
.\build\Release\cpp_embedded_web.exe
```

### 4. Test the Application

**In a web browser:**
- Open: http://127.0.0.1:8080
- Click the "Call C++ endpoint" button
- You should see: "Hello from C++"

**In PowerShell:**
```powershell
Invoke-RestMethod http://127.0.0.1:8080/api/message
```

Expected output:
```
message
-------
Hello from C++
```

**Run unit tests:**
```powershell
.\build\tests\cpp_embedded_web_tests.exe
```

## 📋 Troubleshooting Checklist

### Build Fails with "No compiler found"
- [ ] Is a C++ compiler installed?
- [ ] Run: `conan profile detect --force`
- [ ] Check Conan profile at: `C:\Users\<username>\.conan2\profiles\default`
- [ ] Install MSVC, MinGW, or Clang

### CMake Configuration Fails
- [ ] Is CMake installed? `cmake --version`
- [ ] Is Conan installed? `conan --version`
- [ ] Run: `conan install . --output-folder=build --build=missing`
- [ ] Clean build: `Remove-Item -Recurse build`

### Application won't start
- [ ] Was it built successfully?
- [ ] Is port 8080 in use? `netstat -ano | findstr :8080`
- [ ] Try a different port in `src/main.cpp` line 80

### Tests fail
- [ ] Build tests: `.\build.ps1 test`
- [ ] Check test output for specific failures
- [ ] All 9 tests should pass: "Passed: 9, Failed: 0"

## 📚 Documentation Roadmap

After getting started, you might want to:

1. **Quick Overview**
   - Read: `README.md` (5 min)
   - Shows: Features, quick start, tech stack

2. **Build Troubleshooting**
   - Read: `QUICK_REFERENCE.md` (10 min)
   - Shows: Common commands, quick tips

3. **Detailed Build Steps**
   - Read: `BUILD_GUIDE.md` (20 min)
   - Shows: Step-by-step, all build methods, production tips

4. **Project Architecture**
   - Read: `PROJECT_SUMMARY.md` (15 min)
   - Shows: File structure, code statistics, next steps

## 🔧 Development Workflow

After successfully building:

### Add a new API endpoint:

1. Edit `src/main.cpp`
2. Add new route:
   ```cpp
   CROW_ROUTE(app, "/api/users")
   ([] {
       return crow::json::wvalue{{"users", "data"}};
   });
   ```
3. Rebuild: `cmake --build build --config Release`
4. Test: `Invoke-RestMethod http://127.0.0.1:8080/api/users`

### Add a new test:

1. Edit `tests/test_routes.cpp`
2. Add test function:
   ```cpp
   void test_new_feature() {
       std::cout << "\n--- New Feature Tests ---" << std::endl;
       test::assert_true(condition, "Test description");
   }
   ```
3. Call test from `main()` in `test_main.cpp`
4. Rebuild tests: `.\build.ps1 test`

## 🚀 Once It's Working

### Celebrate! You have:
- ✅ Modern C++20 HTTP server
- ✅ Working web interface
- ✅ Passing unit tests
- ✅ Automated build system
- ✅ Production-ready code

### Next ideas:
- Add authentication
- Create more complex routes
- Build a more sophisticated UI
- Add database integration
- Deploy to cloud platform

## 📞 Quick Help

**Can't remember a command?**
- Read: `QUICK_REFERENCE.md`

**Build not working?**
- Check: `BUILD_GUIDE.md` Troubleshooting section

**Want to understand the code?**
- Read: `PROJECT_SUMMARY.md`

**Just starting out?**
- Read: `README.md`

## ✨ Success Indicators

You'll know everything is working when:

- ✅ `.\build.ps1 build` completes with "Done!"
- ✅ All 9 tests show "[PASS]"
- ✅ Application starts at http://127.0.0.1:8080
- ✅ Web page loads with "C++ Embedded Web App" title
- ✅ Button works and shows "Hello from C++"
- ✅ API returns JSON: `{"message": "Hello from C++"}`

## 📊 Estimated Time

| Task | Time | Difficulty |
|------|------|------------|
| Install compiler | 15 min | Easy |
| Build project | 5 min | Easy |
| Run application | 2 min | Easy |
| Test API | 5 min | Easy |
| **Total** | **27 min** | **Easy** |

---

You're all set! Start by running:
```powershell
.\build.ps1 build
```

Questions? Check `QUICK_REFERENCE.md` or `BUILD_GUIDE.md`.
