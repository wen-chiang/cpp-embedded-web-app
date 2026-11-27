# C++ Embedded Web App - Build Script
# Automates dependency install, configure, build, test and run on Windows.

param(
    [ValidateSet("build", "test", "clean", "run")]
    [string]$Action = "build"
)

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildDir    = Join-Path $ProjectRoot "build"
$ConanProfile = Join-Path $ProjectRoot "conan\gcc-windows.profile"

Write-Host "C++ Embedded Web App - Build Script" -ForegroundColor Green
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host ""

# Locate the toolchain (MinGW GCC + Conan) and put it on PATH for this session.
function Initialize-Toolchain {
    Write-Host "Locating toolchain..." -ForegroundColor Yellow

    # 1) MinGW GCC (search the winget packages dir, then common locations).
    $mingwBin = $null
    $wingetPkgs = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
    if (Test-Path $wingetPkgs) {
        $gcc = Get-ChildItem -Path $wingetPkgs -Recurse -Filter gcc.exe -ErrorAction SilentlyContinue |
               Where-Object { $_.FullName -match 'mingw64\\bin\\gcc\.exe$' } |
               Select-Object -First 1
        if ($gcc) { $mingwBin = Split-Path -Parent $gcc.FullName }
    }
    if (-not $mingwBin) {
        foreach ($cand in @("C:\mingw64\bin", "C:\msys64\ucrt64\bin", "C:\msys64\mingw64\bin")) {
            if (Test-Path (Join-Path $cand "gcc.exe")) { $mingwBin = $cand; break }
        }
    }
    if ($mingwBin) {
        $env:PATH = "$mingwBin;" + $env:PATH
        Write-Host "[OK] MinGW GCC: $mingwBin" -ForegroundColor Green
    } else {
        Write-Host "[WARN] MinGW GCC not found on this machine." -ForegroundColor Yellow
        Write-Host "       Install with: winget install BrechtSanders.WinLibs.POSIX.UCRT" -ForegroundColor Yellow
    }

    # 2) Conan (pip console script). Add the Python Scripts dir if needed.
    if (-not (Get-Command conan -ErrorAction SilentlyContinue)) {
        $scripts = & py -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>$null
        if ($scripts -and (Test-Path (Join-Path $scripts "conan.exe"))) {
            $env:PATH = "$scripts;" + $env:PATH
        }
    }

    Write-Host ""
}

function Check-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Yellow
    $missing = @()

    foreach ($tool in @("gcc", "cmake", "conan", "ninja")) {
        $cmd = Get-Command $tool -ErrorAction SilentlyContinue
        if ($cmd) {
            Write-Host "[OK] $tool -> $($cmd.Source)" -ForegroundColor Green
        } else {
            $missing += $tool
        }
    }

    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Host "Missing prerequisites: $($missing -join ', ')" -ForegroundColor Red
        Write-Host "  - C++ compiler: winget install BrechtSanders.WinLibs.POSIX.UCRT" -ForegroundColor Yellow
        Write-Host "  - Build tools:  py -m pip install cmake conan ninja" -ForegroundColor Yellow
        exit 1
    }
    Write-Host ""
}

function Clean-Build {
    Write-Host "Cleaning build directory..." -ForegroundColor Yellow
    if (Test-Path $BuildDir) { Remove-Item -Recurse -Force $BuildDir }
    if (Test-Path (Join-Path $ProjectRoot "CMakeUserPresets.json")) {
        Remove-Item (Join-Path $ProjectRoot "CMakeUserPresets.json")
    }
    Write-Host "[OK] Clean" -ForegroundColor Green
    Write-Host ""
}

function Install-Dependencies {
    Write-Host "Installing dependencies with Conan..." -ForegroundColor Yellow
    Set-Location $ProjectRoot

    & conan install . --output-folder="$BuildDir" --build=missing `
        -pr:h "$ConanProfile" -pr:b "$ConanProfile"

    # Conan may exit non-zero even on success for this config; verify by output.
    if (-not (Test-Path (Join-Path $BuildDir "conan_toolchain.cmake"))) {
        Write-Host "[ERROR] Conan did not generate the toolchain file." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Dependencies installed" -ForegroundColor Green
    Write-Host ""
}

function Configure-CMake {
    Write-Host "Configuring CMake (conan-release preset)..." -ForegroundColor Yellow
    Set-Location $ProjectRoot

    & cmake --preset conan-release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] CMake configuration failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] CMake configured" -ForegroundColor Green
    Write-Host ""
}

function Build-Project {
    Write-Host "Building project..." -ForegroundColor Yellow
    Set-Location $ProjectRoot

    & cmake --build $BuildDir --config Release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Build failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Build succeeded" -ForegroundColor Green
    Write-Host ""
}

# Resolve an executable that may live in the build root (Ninja, single-config)
# or a per-config subdir (Visual Studio, multi-config).
function Resolve-Exe([string]$name, [string]$subdir) {
    $candidates = @(
        (Join-Path $BuildDir "$subdir\$name"),
        (Join-Path $BuildDir "$subdir\Release\$name"),
        (Join-Path $BuildDir $name)
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

function Run-Tests {
    Write-Host "Running tests..." -ForegroundColor Yellow
    Set-Location $ProjectRoot

    $testExe = Resolve-Exe "cpp_embedded_web_tests.exe" "tests"
    if (-not $testExe) {
        Write-Host "[ERROR] Test executable not found" -ForegroundColor Red
        exit 1
    }
    & $testExe
    $code = $LASTEXITCODE
    Write-Host ""
    if ($code -eq 0) {
        Write-Host "[OK] All tests passed" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Tests failed (exit $code)" -ForegroundColor Red
        exit $code
    }
    Write-Host ""
}

function Run-Application {
    Write-Host "Starting application..." -ForegroundColor Yellow
    Set-Location $ProjectRoot

    $appExe = Resolve-Exe "cpp_embedded_web.exe" "."
    if (-not $appExe) {
        Write-Host "[ERROR] Application executable not found. Run '.\build.ps1 build' first." -ForegroundColor Red
        exit 1
    }

    Write-Host "[OK] Server starting" -ForegroundColor Green
    Write-Host "   Web UI: http://127.0.0.1:8080" -ForegroundColor Cyan
    Write-Host "   API:    http://127.0.0.1:8080/api/message" -ForegroundColor Cyan
    Write-Host "   Press Ctrl+C to stop" -ForegroundColor Yellow
    Write-Host ""
    & $appExe
}

# --- Main ---
Initialize-Toolchain
Check-Prerequisites

switch ($Action) {
    "clean" { Clean-Build }
    "build" {
        Clean-Build
        Install-Dependencies
        Configure-CMake
        Build-Project
        Run-Tests
    }
    "test" {
        if (-not (Test-Path (Join-Path $BuildDir "conan_toolchain.cmake"))) {
            Install-Dependencies
            Configure-CMake
        }
        Build-Project
        Run-Tests
    }
    "run" {
        if (-not (Resolve-Exe "cpp_embedded_web.exe" ".")) {
            Write-Host "Application not built. Building first..." -ForegroundColor Yellow
            Clean-Build
            Install-Dependencies
            Configure-CMake
            Build-Project
        }
        Run-Application
    }
}

Write-Host "Done!" -ForegroundColor Green
exit 0
