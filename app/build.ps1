# build.ps1 - Quick build script for Playify
# Run this from the app/ directory

param(
    [string]$Version = "1.3.0"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Playify Build Script" -ForegroundColor Cyan
Write-Host "  Version: $Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "app.py")) {
    Write-Host "Error: app.py not found. Please run this script from the app/ directory." -ForegroundColor Red
    exit 1
}

# Step 1: Clean previous builds
Write-Host "[1/4] Cleaning previous builds..." -ForegroundColor Yellow
if (Test-Path "dist") { 
    Remove-Item -Recurse -Force "dist" 
    Write-Host "  Removed dist/ folder" -ForegroundColor Gray
}
if (Test-Path "build") { 
    Remove-Item -Recurse -Force "build"
    Write-Host "  Removed build/ folder" -ForegroundColor Gray
}
if (Test-Path "Output") { 
    Remove-Item -Recurse -Force "Output"
    Write-Host "  Removed Output/ folder" -ForegroundColor Gray
}
Write-Host "  Clean complete!" -ForegroundColor Green
Write-Host ""

# Step 2: Verify required files
Write-Host "[2/4] Verifying required files..." -ForegroundColor Yellow
$missingFiles = @()

if (-not (Test-Path "bin/ffmpeg.exe")) {
    $missingFiles += "bin/ffmpeg.exe"
}
if (-not (Test-Path "bin/libopus-0.x64.dll")) {
    $missingFiles += "bin/libopus-0.x64.dll"
}
if (-not (Test-Path "assets/images/playify.ico")) {
    $missingFiles += "assets/images/playify.ico"
}

if ($missingFiles.Count -gt 0) {
    Write-Host "  WARNING: Missing required files:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "    - $file" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "  Please ensure these files exist before building." -ForegroundColor Yellow
    Write-Host "  See BUILD_GUIDE.md for download links." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
} else {
    Write-Host "  All required files found!" -ForegroundColor Green
}
Write-Host ""

# Step 3: Build with PyInstaller
Write-Host "[3/4] Building application with PyInstaller..." -ForegroundColor Yellow
Write-Host "  This may take 5-10 minutes..." -ForegroundColor Gray

# Use python -m PyInstaller for better reliability
Write-Host "  Running: python -m PyInstaller app.spec" -ForegroundColor Gray
python -m PyInstaller app.spec

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  ERROR: PyInstaller build failed!" -ForegroundColor Red
    Write-Host "  Check the output above for errors." -ForegroundColor Red
    Write-Host "  Exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "dist/Playify/Playify.exe")) {
    Write-Host ""
    Write-Host "  ERROR: Playify.exe not found in dist/Playify/" -ForegroundColor Red
    exit 1
}

Write-Host "  Application built successfully!" -ForegroundColor Green
Write-Host "  Output: dist/Playify/" -ForegroundColor Cyan
Write-Host ""

# Step 4: Build installer with Inno Setup
Write-Host "[4/4] Building installer with Inno Setup..." -ForegroundColor Yellow

# Try to find Inno Setup
$innoPaths = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
)

$innoPath = $null
foreach ($path in $innoPaths) {
    if (Test-Path $path) {
        $innoPath = $path
        break
    }
}

if ($null -eq $innoPath) {
    Write-Host "  WARNING: Inno Setup not found!" -ForegroundColor Yellow
    Write-Host "  Please install Inno Setup from: https://jrsoftware.org/isdl.php" -ForegroundColor Yellow
    Write-Host "  Or build the installer manually:" -ForegroundColor Yellow
    Write-Host "    1. Open Inno Setup Compiler" -ForegroundColor Gray
    Write-Host "    2. Open: playify_installer.iss" -ForegroundColor Gray
    Write-Host "    3. Build -> Compile (F9)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Application build complete! Installer build skipped." -ForegroundColor Green
    exit 0
}

Write-Host "  Found Inno Setup at: $innoPath" -ForegroundColor Gray
& $innoPath "playify_installer.iss"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  WARNING: Installer build may have failed!" -ForegroundColor Yellow
    Write-Host "  Check the Inno Setup output above." -ForegroundColor Yellow
} else {
    if (Test-Path "Output\Playify_Setup_v*.exe") {
        $installerFile = Get-ChildItem "Output\Playify_Setup_v*.exe" | Select-Object -First 1
        Write-Host "  Installer built successfully!" -ForegroundColor Green
        Write-Host "  Output: $($installerFile.FullName)" -ForegroundColor Cyan
    } else {
        Write-Host "  WARNING: Installer file not found in Output/" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Test the application: dist\Playify\Playify.exe" -ForegroundColor Gray
Write-Host "  2. Test the installer: Output\Playify_Setup_v*.exe" -ForegroundColor Gray
Write-Host "  3. Create GitHub release with the installer" -ForegroundColor Gray
Write-Host ""

