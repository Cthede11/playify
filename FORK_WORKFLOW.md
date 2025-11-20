# Fork Workflow Guide for Playify

## Current Setup ✅
- **Origin (Your Fork)**: `https://github.com/Cthede11/playify.git`
- **Upstream (Original)**: `https://github.com/alan7383/playify.git`
- **Current Branch**: `main`

## Workflow for Making Changes

### 1. **Always Work on Your Fork (Origin)**
Your changes should always go to your fork, not the original repo.

```powershell
# Make sure you're on your fork's main branch
git checkout main

# Verify you're tracking your fork
git remote -v
# Should show origin = Cthede11/playify
```

### 2. **Before Starting New Work - Sync with Upstream (Optional)**
If you want to get the latest changes from the original repo:

```powershell
# Fetch latest changes from original repo
git fetch upstream

# Check what's different
git log HEAD..upstream/main --oneline

# If you want to merge upstream changes into your fork:
git merge upstream/main
# Or create a new branch for the merge:
git checkout -b sync-upstream
git merge upstream/main
git checkout main
git merge sync-upstream
```

### 3. **Making Changes**
1. Create a new branch for your feature:
   ```powershell
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to files

3. Commit your changes:
   ```powershell
   git add .
   git commit -m "Description of your changes"
   ```

4. Push to YOUR fork (origin):
   ```powershell
   git push origin feature/your-feature-name
   # Or if on main:
   git push origin main
   ```

### 4. **Verify You're Pushing to the Right Place**
Before pushing, always check:
```powershell
git remote -v
# origin should be YOUR fork (Cthede11/playify)
# upstream should be the original (alan7383/playify)
```

### 5. **Daily Workflow Checklist**
- ✅ `git status` - Check current state
- ✅ `git remote -v` - Verify remotes are correct
- ✅ Work on feature branch or main
- ✅ Commit to your fork (origin)
- ✅ Push to your fork (origin)

## Important Commands

### Check if you're ahead/behind upstream:
```powershell
git fetch upstream
git log HEAD..upstream/main --oneline  # What you're missing
git log upstream/main..HEAD --oneline   # What you have that they don't
```

### See current branch and remotes:
```powershell
git branch -vv  # Shows tracking branches
git remote -v   # Shows all remotes
```

### If you accidentally commit to wrong remote:
```powershell
# Don't panic! Just push to the correct remote:
git push origin main  # Push to YOUR fork
```

## Quick Reference

| Action | Command |
|--------|---------|
| Check remotes | `git remote -v` |
| Check status | `git status` |
| Fetch upstream | `git fetch upstream` |
| Push to YOUR fork | `git push origin <branch>` |
| Push to original (DON'T) | `git push upstream <branch>` ❌ |

## Your Fork vs Original

- **Your Fork (origin)**: Where YOUR changes go
- **Original (upstream)**: Where you pull updates from (read-only for you)

Always push to `origin`, never to `upstream` unless you have write access to the original repo.

