# Plan Refinements and Additional Details

This document contains refinements and additional implementation details for the Playify Comprehensive Improvements Plan.

## 1. Auto-Update System Refinements

### 1.1 Rollback Safety
- **Backup Strategy**: Before installing update, move current installation folder to `.bak` backup
- **Error Handling**: 
  - Catch failed downloads or GitHub API rate limits
  - Skip auto-restart if update fails
  - Log errors and notify admins
  - Restore from backup if update installation fails
- **Configuration**: Add `AUTO_UPDATE=false` flag in `.env` to disable auto-update
- **Impact**: Prevents broken deploys due to partial updates or mid-playback crashes

### 1.2 Update Check Frequency
- Make update check interval configurable (default: every 30-60 minutes)
- Add global cooldown if hosted with multiple shards to prevent concurrent checks

## 2. Thumbnail Replacement Details

### 2.1 Video ID Extraction
- Extract `video_id` from `fetch_video_info_with_retry()` result:
  - Use `id` field directly if available
  - Parse from `webpage_url` if `id` not present (YouTube URLs contain video ID)
- For YouTube: Use `https://img.youtube.com/vi/<video_id>/hqdefault.jpg`
- For other providers: Use `thumbnail` field from yt-dlp if available

### 2.2 Fallback Behavior
- If thumbnail unavailable or provider doesn't return one, default to Playify logo
- Handle errors gracefully (invalid URLs, missing thumbnails)

## 3. Caching Implementation Details

### 3.1 Cache Configuration
- Use `cachetools.TTLCache(maxsize=500, ttl=3600)`:
  - `maxsize=500`: Store up to 500 track metadata entries
  - `ttl=3600`: Cache entries expire after 1 hour
- Cache key: URL or normalized query string
- Cache value: Full track metadata dictionary

### 3.2 Cache Scope
- Scope cache per bot instance (in-memory only, not persisted)
- For clustered hosting or sharding: Keep in-memory only (not shared across instances)
- Clear cache on bot restart

## 4. Guild Settings Persistence

### 4.1 Database Schema
- Option A (JSON blob): Extend existing `guild_settings` table with JSON column
  - Faster to implement
  - Single row per guild
  - Good for simple settings
- Option B (Normalized table): Create new `guild_setting_values` table
  - Easier to query/debug
  - Better for complex settings with many keys
  - Schema: `(guild_id, setting_key, value)`
- **Recommendation**: Start with JSON blob, migrate to normalized if needed

## 5. Slash Command Restructure Warning

### 5.1 Breaking Change
- **Important**: Grouped subcommands (e.g., `/queue show`) will change the API signature
- Must delete and re-register all slash commands with Discord
- Warn existing users this is a breaking change in release notes

### 5.2 Migration Strategy
- **Option A (Recommended)**: Implement aliasing during transition
  - Keep old commands with deprecated response pointing to new grouped commands
  - Example: `/queue` shows deprecation message and suggests `/queue show`
  - Remove old commands after transition period (e.g., 1-2 releases)
- **Option B**: Direct migration
  - Update all commands at once
  - Document breaking change prominently in release notes
  - Provide migration guide for users

## 6. Optional Rate-Limiting (Recommended)

### 6.1 Per-User Cooldowns
- Implement cooldowns on high-cost commands:
  - `/play`: 3-5 seconds per user
  - `/search`: 3-5 seconds per user
  - `/lyrics`: 5-10 seconds per user
- Use `discord.ext.commands.cooldown` decorator or custom rate limiter
- Store cooldown state in memory (per-user, per-command)

### 6.2 Global Cooldowns
- Auto-update check: Prevent concurrent checks if hosted with multiple shards
- API rate limiting: Respect provider API limits (YouTube, Spotify, etc.)

### 6.3 Implementation
- Not in original checklist but highly recommended for production
- Prevents API bans and CPU spikes from abuse
- Consider making cooldown durations configurable per-guild

## 7. Additional Implementation Notes

### 7.1 Error Handling
- All update operations should have comprehensive error handling
- Log all errors with context (guild_id, user_id, command, etc.)
- Never silently fail on critical operations

### 7.2 Testing Considerations
- Test update mechanism in staging environment first
- Test graceful shutdown with active playback
- Test reconnection after update with multiple guilds
- Test rate limiting under load

### 7.3 Documentation Updates
- Update README with new command structure (if breaking changes)
- Document auto-update behavior and configuration
- Document rate limiting behavior
- Update development guide with new patterns

