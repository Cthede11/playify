# setup-build-files.ps1 - Downloads required files for building Playify

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Playify Build Files Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create directories
Write-Host "Creating directories..." -ForegroundColor Yellow
if (-not (Test-Path "bin")) { New-Item -ItemType Directory -Path "bin" -Force | Out-Null }
if (-not (Test-Path "assets/images")) { 
    New-Item -ItemType Directory -Path "assets/images" -Force | Out-Null 
}

# Copy icon if it exists
if (Test-Path "..\docs\playify.ico") {
    Copy-Item "..\docs\playify.ico" "assets\images\playify.ico" -Force
    Write-Host "  ✓ Icon copied" -ForegroundColor Green
} else {
    Write-Host "  ✗ Icon not found at ..\docs\playify.ico" -ForegroundColor Red
}

Write-Host ""

# Check for FFmpeg
Write-Host "Checking for FFmpeg..." -ForegroundColor Yellow
if (Test-Path "bin\ffmpeg.exe") {
    Write-Host "  ✓ FFmpeg found" -ForegroundColor Green
} else {
    Write-Host "  ✗ FFmpeg not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Please download FFmpeg:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Cyan
    Write-Host "  2. Download: ffmpeg-release-essentials.zip" -ForegroundColor Cyan
    Write-Host "  3. Extract ffmpeg.exe to: app\bin\ffmpeg.exe" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Or use this direct link (may change):" -ForegroundColor Gray
    Write-Host "  https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -ForegroundColor Gray
}

Write-Host ""

# Check for Opus DLL
Write-Host "Checking for Opus DLL..." -ForegroundColor Yellow
if (Test-Path "bin\libopus-0.x64.dll") {
    Write-Host "  ✓ Opus DLL found" -ForegroundColor Green
} else {
    Write-Host "  ✗ Opus DLL not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "  The Opus DLL is usually included with discord.py." -ForegroundColor Yellow
    Write-Host "  Try one of these methods:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Method 1: Check discord.py installation" -ForegroundColor Cyan
    Write-Host "    python -c 'import discord; print(discord.__file__)'" -ForegroundColor Gray
    Write-Host "    Look for libopus DLL in the discord package directory" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Method 2: Download from Discord.py releases" -ForegroundColor Cyan
    Write-Host "    https://github.com/Rapptz/discord.py/releases" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Method 3: Download from Opus website" -ForegroundColor Cyan
    Write-Host "    https://opus-codec.org/downloads/" -ForegroundColor Gray
    Write-Host "    Look for: libopus-0.x64.dll (Windows x64)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Place the DLL at: app\bin\libopus-0.x64.dll" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After downloading the missing files, run:" -ForegroundColor Yellow
Write-Host "  .\build.ps1" -ForegroundColor Cyan
Write-Host ""

