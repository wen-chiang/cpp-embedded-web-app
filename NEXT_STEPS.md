# NEXT STEPS - Build & Run Instructions

## ✅ What's Complete

✓ Project structure created  
✓ Source code written (C++20 HTTP server)  
✓ 9 unit tests implemented  
✓ CMake + Conan build system configured  
✓ Automated build script ready  
✓ Complete documentation provided  
✓ Tools installed (CMake, Conan, Ninja)  

## ⚠️ What's Needed

**You need to install ONE C++ compiler:**

### Option 1: Visual Studio 2022 Build Tools (Recommended)
- **Download:** https://visualstudio.microsoft.com/downloads/
- **Choose:** "Desktop development with C++"
- **Size:** ~2-4 GB
- **Time:** 10-15 minutes
- **Result:** Automatic detection by build script

### Option 2: MinGW-w64 (Lightweight)
- **Download:** https://www.mingw-w64.org/
- **Size:** ~500 MB
- **Time:** 5-10 minutes
- **Then:** Add to Windows PATH

### Option 3: LLVM/Clang
- **Download:** https://releases.llvm.org/
- **Size:** ~1-2 GB
- **Time:** 5-10 minutes
- **Then:** Add to Windows PATH

---

## 🚀 Once You Install a Compiler

### Method 1: Run Build Script (Easiest)

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app
powershell -ExecutionPolicy Bypass -File .\build.ps1 build
```

The script will:
1. Detect your compiler automatically
2. Install dependencies via Conan
3. Configure CMake
4. Compile the HTTP server
5. Compile the test suite
6. Run all 9 tests
7. Show results

### Method 2: Manual Build Steps

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app

# Install dependencies
conan install . --output-folder=build --build=missing

# Configure CMake
cmake --preset conan-release

# Build
cmake --build build --config Release

# Run tests
.\build\tests\cpp_embedded_web_tests.exe
```

---

## ▶️ Running the Application

After successful build:

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 run
```

Or manually:

```powershell
.\build\Release\cpp_embedded_web.exe
```

Expected output:
```
(2026-11-26 21:04:07) Crow/0.3 server is running at http://127.0.0.1:8080
(2026-11-26 21:04:07) Call `app.loglevel(crow::LogLevel::Debug)` to see debugging logs
```

---

## 🌐 Access the Application

Open your browser to:
```
http://127.0.0.1:8080
```

You should see:
- Title: "C++ Embedded Web App"
- Button: "Call C++ endpoint"
- Click the button → Should display: "Hello from C++"

---

## 🧪 Test the API

From PowerShell (while app is running):

```powershell
Invoke-RestMethod http://127.0.0.1:8080/api/message
```

Expected output:
```
message
-------
Hello from C++
```

---

## ✨ Success Indicators

Build was successful when you see:
- ✓ All 9 tests pass: `Passed: 9, Failed: 0`
- ✓ Executable created: `build\Release\cpp_embedded_web.exe`

Application works when:
- ✓ Server starts on http://127.0.0.1:8080
- ✓ Web page loads in browser
- ✓ Button click returns "Hello from C++"
- ✓ API returns JSON response

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| **GETTING_STARTED.md** | Complete setup checklist |
| **QUICK_REFERENCE.md** | Command reference |
| **README.md** | Project overview |
| **BUILD_GUIDE.md** | Detailed build instructions |
| **PROJECT_SUMMARY.md** | Architecture details |
| **INDEX.md** | Navigation guide |

---

## 🆘 Troubleshooting

**"No C++ compiler found"**
- Install Visual Studio 2022 Build Tools or MinGW-w64
- Run: `conan profile detect --force`

**"CMake configuration failed"**
- Ensure compiler is installed
- Check PATH includes compiler binary
- Run build script again

**"Port 8080 in use"**
- Another app is using the port
- Edit `src/main.cpp` and change port
- Rebuild project

**More help:**
- See BUILD_GUIDE.md Troubleshooting section
- Check QUICK_REFERENCE.md FAQ

---

## 📋 Estimated Time

| Step | Time |
|------|------|
| Install compiler | 10-20 min |
| Run build script | 2-3 min |
| Access web app | <1 min |
| **Total** | **15-25 min** |

---

## 🎯 Ready?

1. Install a C++ compiler
2. Run: `powershell -ExecutionPolicy Bypass -File .\build.ps1 build`
3. Run: `powershell -ExecutionPolicy Bypass -File .\build.ps1 run`
4. Open: `http://127.0.0.1:8080`
5. Enjoy! 🎉

---

Questions? See documentation files or BUILD_GUIDE.md troubleshooting section.
