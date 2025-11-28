# Quick Git Tag Guide

## Create Your First Tag (v1.0.0)

Since your current version is `1.0.0+1`, here's how to create the first release tag:

### Option 1: Using the Script (Recommended)

```bash
# From project root
./scripts/create_release.sh 1.0.0 "Initial release"
git push origin v1.0.0
```

### Option 2: Manual Commands

```bash
# 1. Make sure all changes are committed
git add .
git commit -m "Prepare release 1.0.0"

# 2. Create annotated tag
git tag -a v1.0.1 -m "Release version 1.0.0

- Added initialize function.
- Supported global navigator key for dialog.
- Added Update dialog config.
- Optimized and Fixed bug."

# 3. Push tag to remote
git push origin v1.0.0
```

## Quick Commands

```bash
# Create tag
git tag -a v1.0.0 -m "Release message"

# Push tag
git push origin v1.0.0

# List tags
git tag -l

# View tag
git show v1.0.0
```

## For Future Releases

```bash
# Patch release (1.0.0 → 1.0.1)
# 1. Update pubspec.yaml: version: 1.0.1+1
# 2. Update CHANGELOG.md
# 3. Commit changes
# 4. Create tag: git tag -a v1.0.1 -m "Release 1.0.1"
# 5. Push: git push origin v1.0.1

# Minor release (1.0.0 → 1.1.0)
# 1. Update pubspec.yaml: version: 1.1.0+1
# 2. Update CHANGELOG.md
# 3. Commit changes
# 4. Create tag: git tag -a v1.1.0 -m "Release 1.1.0"
# 5. Push: git push origin v1.1.0
```

See `GIT_VERSIONING.md` for complete documentation.
