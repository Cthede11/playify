# Playify Development Guide

This guide will help you set up a development environment for Playify and contribute to the project.

## Prerequisites

- Python 3.11 or higher
- Git
- FFmpeg installed and in PATH
- Discord Bot Token
- (Optional) Spotify API credentials
- (Optional) Genius API token

## Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Cthede11/playify.git
cd playify
```

### 2. Create Virtual Environment

```bash
python -m venv venv
# On Windows:
venv\Scripts\activate
# On Linux/Mac:
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment

Create a `.env` file in the project root (or use the GUI app's config):

```env
DISCORD_TOKEN=your_bot_token_here
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
GENIUS_TOKEN=your_genius_token
AUTO_UPDATE=true
```

### 5. Run the Bot

For development, you can run the bot directly:

```bash
# Using the GUI app (recommended for Windows)
python app/app.py

# Or run the bot directly (for testing)
python app/playify_bot.py
```

## Project Structure

```
playify/
├── app/
│   ├── app.py              # GUI application
│   ├── playify_bot.py      # Main bot code
│   └── requirements.txt    # Bot dependencies
├── i18n/                   # Internationalization files
├── docs/                   # Documentation
├── requirements.txt        # Root dependencies
└── Dockerfile             # Docker configuration
```

## Adding a New Music Provider

1. **Create provider function** in `app/playify_bot.py`:
   ```python
   async def process_provider_url(url: str, guild_id: int):
       # Extract track/playlist info
       # Return list of (track_name, artist_name) tuples
       pass
   ```

2. **Add URL regex** to detect provider links:
   ```python
   provider_regex = re.compile(r'provider\.com/...')
   ```

3. **Integrate in `/play` command**:
   ```python
   if provider_regex.match(query):
       platform_tracks = await process_provider_url(query, guild_id)
       await handle_platform_playlist(platform_tracks, "Provider Name")
   ```

4. **Test thoroughly** with various URL formats and edge cases.

## Common Troubleshooting

### Bot Not Connecting to Voice

- Verify bot has `Connect`, `Speak`, and `Use Voice Activity` permissions
- Check that intents are enabled in Discord Developer Portal
- Ensure `voice_states` intent is enabled in code

### FFmpeg Not Found

- Install FFmpeg and add to system PATH
- Or place `ffmpeg.exe` in `app/bin/` directory
- Verify with `ffmpeg -version` command

### yt-dlp Extraction Fails

- Update yt-dlp: `pip install --upgrade yt-dlp`
- Check if provider changed their API
- Review error logs for specific failure reasons

### Database Errors

- Ensure `playify_state.db` is writable
- Check file permissions in `%LOCALAPPDATA%\Playify\`
- Verify SQLite is working: `python -c "import sqlite3; print('OK')"`

## Code Style Guidelines

- Follow PEP 8 style guide
- Use type hints where possible
- Document functions with docstrings
- Keep functions focused and single-purpose
- Use async/await for I/O operations

## Testing

Run linting:
```bash
flake8 app/playify_bot.py
black --check app/playify_bot.py
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test thoroughly
5. Submit a pull request with a clear description

## Adding New Commands

1. Use `@bot.tree.command()` decorator
2. Add command description and parameter descriptions
3. Implement proper error handling
4. Use ephemeral responses for user-specific interactions
5. Add rate limiting for high-cost commands
6. Update help command documentation

## Security Best Practices

- Always validate user input (URLs, filenames, etc.)
- Use parameterized SQL queries (already implemented)
- Sanitize external content (song titles, etc.) to prevent mention spam
- Never trust user-provided file paths
- Use temp directories with generated names for uploads

## Performance Tips

- Use `asyncio.to_thread()` for blocking operations
- Cache frequently accessed data (track metadata)
- Prefetch next track's stream URL
- Batch process large playlists
- Limit concurrent FFmpeg processes

## Questions?

- Check existing issues on GitHub
- Join the Discord server: https://discord.gg/JeH8g6g3cG
- Read the main README.md for user-facing documentation

