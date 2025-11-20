# app.spec - Version Manuelle et Fiable

import os
import sys

# On ne cherche plus les chemins automatiquement.
# On se fie à l'analyse de PyInstaller, aidée par les hiddenimports.

block_cipher = None

binaries = [
    ('bin/ffmpeg.exe', '.'),
    ('bin/libopus-0.x64.dll', '.')
]

# datas - Include assets and customtkinter theme files
datas = [
    ('assets', 'assets'),
]

# Include customtkinter package and assets
try:
    import customtkinter
    customtkinter_path = os.path.dirname(customtkinter.__file__)
    # Include the entire customtkinter package directory
    datas.append((customtkinter_path, 'customtkinter'))
    # Also explicitly include assets if they exist
    customtkinter_assets = os.path.join(customtkinter_path, 'assets')
    if os.path.exists(customtkinter_assets):
        datas.append((customtkinter_assets, 'customtkinter/assets'))
except ImportError:
    pass  # customtkinter not available at build time, PyInstaller will find it

# C'est ici que toute la magie opère.
# On liste TOUT ce qui est nécessaire pour forcer PyInstaller à tout trouver.
hiddenimports = [
    # Core application modules
    'playify_bot',
    
    # GUI and system tray
    'pystray',
    'pystray._win32',
    'customtkinter',
    'customtkinter.windows',
    'customtkinter.windows.ctk_tk',
    'customtkinter.windows.ctk_frame',
    'customtkinter.windows.ctk_button',
    'customtkinter.windows.ctk_label',
    'customtkinter.windows.ctk_entry',
    'customtkinter.windows.ctk_textbox',
    'customtkinter.windows.ctk_scrollable_frame',
    'customtkinter.windows.ctk_toplevel',
    'customtkinter.font_manager',
    'customtkinter.appearance_mode',
    'customtkinter.theme_manager',
    
    # Image processing
    'PIL',
    'PIL.Image',
    'PIL.ImageTk',
    'PIL.ImageDraw',
    'PIL._tkinter_finder',
    
    # Discord
    'discord',
    'discord.ext',
    'discord.ext.commands',
    'discord.ext.tasks',
    'discord.app_commands',
    'discord.ui',
    
    # Standard library (explicit for PyInstaller)
    'multiprocessing',
    'multiprocessing.managers',
    'queue',
    'winreg',
    'packaging',
    'packaging.version',
    'packaging.specifiers',
    'packaging.requirements',
    
    # Computer vision
    'cv2',
    
    # Additional dependencies from playify_bot
    'yt_dlp',
    'spotipy',
    'spotipy.oauth2',
    'spotify_scraper',
    'spotify_scraper.core.exceptions',
    'cachetools',
    'cachetools.ttl',
    'playwright',
    'playwright.async_api',
    'syncedlyrics',
    'lyricsgenius',
    'psutil',
    'dotenv',
    'zstandard',  # Used by discord.py and yt-dlp
    
    # --- Forçage de PyNaCl et CFFI ---
    'nacl',
    'nacl.secret',
    'nacl.utils',
    'nacl.bindings',
    'nacl.hash',
    'nacl.pwhash',
    'nacl.signing',
    'nacl.public',
    'cffi',
    'cffi._cffi_backend',
    '_cffi_backend',
]

# --- Le reste du fichier de build ---
# Ensure PyInstaller can find playify_bot.py in the same directory
# Get the directory where this spec file is located
spec_dir = os.path.dirname(os.path.abspath(SPEC))
a = Analysis(
    ['app.py'],
    pathex=[spec_dir],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[], # Plus besoin du hook avec cette méthode
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='Playify',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='assets/images/playify.ico',
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='Playify',
)
