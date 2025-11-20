# Build Guide for Playify Windows App & Installer

## Prerequisites

1. **Python 3.9+** installed
2. **PyInstaller** installed: `pip install pyinstaller`
3. **Inno Setup** installed (download from https://jrsoftware.org/isdl.php)
4. **Required files:**
   - `bin/ffmpeg.exe` - FFmpeg binary for Windows
   - `bin/libopus-0.x64.dll` - Opus audio codec DLL
   - `assets/images/playify.ico` - Application icon

## Step 1: Prepare Required Files

### Download FFmpeg and Opus DLL

1. **FFmpeg:**
   - Download from: https://www.gyan.dev/ffmpeg/builds/
   - Extract `ffmpeg.exe` and place it in `app/bin/ffmpeg.exe`

2. **Opus DLL:**
   - Download from: https://opus-codec.org/downloads/
   - Or get from Discord.py dependencies
   - Place `libopus-0.x64.dll` in `app/bin/libopus-0.x64.dll`

3. **Assets folder:**
   - Ensure `app/assets/images/playify.ico` exists
   - Or copy from `docs/playify.ico` to `app/assets/images/playify.ico`

### Directory Structure Should Be:
```
app/
├── app.py
├── app.spec
├── playify_bot.py
├── playify_installer.iss
├── requirements.txt
├── bin/
│   ├── ffmpeg.exe
│   └── libopus-0.x64.dll
└── assets/
    └── images/
        └── playify.ico
```

## Step 2: Install Dependencies

```powershell
cd app
pip install -r requirements.txt
```

Or install all dependencies:
```powershell
pip install pyinstaller customtkinter pystray pillow requests packaging opencv-python
```

## Step 3: Update Version Numbers

Before building, make sure version numbers match:

1. **app/app.py:**
   ```python
   CURRENT_VERSION = "1.3.0"  # Update this
   ```

2. **app/playify_installer.iss:**
   ```ini
   AppVersion=1.3.0  # Update this
   AppVerName=Playify v1.3.0  # Update this
   OutputBaseFilename=Playify_Setup_v1.3.0  # Update this
   ```

## Step 4: Build the Application (PyInstaller)

```powershell
cd app
pyinstaller app.spec
```

This will create:
- `app/dist/Playify/` - Contains all the built files
- `app/dist/Playify/Playify.exe` - The main executable

**Build time:** This can take 5-10 minutes depending on your system.

## Step 5: Build the Installer (Inno Setup)

1. **Open Inno Setup Compiler**

2. **Open the script:**
   - File → Open
   - Navigate to `app/playify_installer.iss`

3. **Build the installer:**
   - Build → Compile (or press F9)
   - Or: Build → Build

4. **Output:**
   - The installer will be created in `app/Output/`
   - Filename: `Playify_Setup_v1.3.0.exe` (or your version)

## Step 6: Test the Build

1. **Test the executable:**
   ```powershell
   cd app/dist/Playify
   .\Playify.exe
   ```

2. **Test the installer:**
   - Run `Playify_Setup_v1.3.0.exe`
   - Install to a test location
   - Verify the app runs correctly

## Step 7: Create GitHub Release

1. **Tag the release:**
   ```powershell
   git tag v1.3.0
   git push origin v1.3.0
   ```

2. **Create release on GitHub:**
   - Go to: https://github.com/Cthede11/playify/releases/new
   - Tag: `v1.3.0`
   - Title: `Playify v1.3.0`
   - Upload: `Playify_Setup_v1.3.0.exe`
   - Add release notes

## Quick Build Script

Create a `build.ps1` file in the `app` directory:

```powershell
# build.ps1 - Quick build script for Playify

Write-Host "Building Playify..." -ForegroundColor Green

# Step 1: Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
if (Test-Path "Output") { Remove-Item -Recurse -Force "Output" }

# Step 2: Build with PyInstaller
Write-Host "Building application with PyInstaller..." -ForegroundColor Yellow
pyinstaller app.spec

if ($LASTEXITCODE -ne 0) {
    Write-Host "PyInstaller build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Application built successfully!" -ForegroundColor Green
Write-Host "Build output: dist/Playify/" -ForegroundColor Cyan

# Step 3: Build installer with Inno Setup
Write-Host "Building installer with Inno Setup..." -ForegroundColor Yellow
$innoPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (Test-Path $innoPath) {
    & $innoPath "playify_installer.iss"
    Write-Host "Installer built successfully!" -ForegroundColor Green
    Write-Host "Installer output: Output/" -ForegroundColor Cyan
} else {
    Write-Host "Inno Setup not found at: $innoPath" -ForegroundColor Yellow
    Write-Host "Please build the installer manually using Inno Setup Compiler" -ForegroundColor Yellow
}

Write-Host "Build complete!" -ForegroundColor Green
```

Run it:
```powershell
cd app
.\build.ps1
```

## Troubleshooting

### PyInstaller Issues

**Error: "Module not found"**
- Add missing modules to `hiddenimports` in `app.spec`
- Reinstall dependencies: `pip install -r requirements.txt`

**Error: "FFmpeg not found"**
- Ensure `bin/ffmpeg.exe` exists in the `app` directory
- Check the path in `app.spec` is correct: `('bin/ffmpeg.exe', '.')`

**Error: "Icon not found"**
- Ensure `assets/images/playify.ico` exists
- Or update the icon path in `app.spec`

### Inno Setup Issues

**Error: "Source files not found"**
- Ensure PyInstaller build completed successfully
- Check that `dist/Playify/` folder exists
- Verify the path in `playify_installer.iss`: `Source: "dist\Playify\*"`

**Error: "Icon file not found"**
- Ensure `assets/images/playify.ico` exists
- Update path in `playify_installer.iss` if needed

## File Size Optimization

The built application can be large (100-200MB). To reduce size:

1. **Remove unused dependencies** from `requirements.txt`
2. **Use UPX compression** (already enabled in app.spec)
3. **Exclude unnecessary modules** in `app.spec` excludes list

## Notes

- The build process creates a standalone executable - no Python installation needed
- All dependencies are bundled into the `dist/Playify` folder
- The installer packages everything into a single `.exe` file
- User config is stored in `%LOCALAPPDATA%\Playify\` and won't be overwritten on updates

