# Git Tag Versioning Guide

This guide explains how to version your `app_hub_upgrader` package using git tags.

## Why Use Git Tags?

Git tags allow you to:

- Mark specific versions of your package
- Enable users to reference specific versions from git
- Track releases in your repository
- Maintain version history

## Semantic Versioning

Follow [Semantic Versioning](https://semver.org/) format: `MAJOR.MINOR.PATCH`

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (1.1.0): New features, backward compatible
- **PATCH** (1.0.1): Bug fixes, backward compatible

## Creating Git Tags

### Step 1: Update Version in pubspec.yaml

Before creating a tag, update the version in `pubspec.yaml`:

```yaml
version: 1.0.0+1 # Format: version+build_number
```

### Step 2: Commit Your Changes

```bash
git add .
git commit -m "Release version 1.0.0"
```

### Step 3: Create a Git Tag

#### Annotated Tag (Recommended)

```bash
# Create annotated tag with message
git tag -a v1.0.0 -m "Release version 1.0.0"

# Or with detailed release notes
git tag -a v1.0.0 -m "Release version 1.0.0

- Initial release
- Check for app version updates from API
- Display customizable update dialog
- Support for forced updates"
```

#### Lightweight Tag

```bash
git tag v1.0.0
```

**Note:** Annotated tags are recommended because they include metadata (author, date, message).

### Step 4: Push Tags to Remote

```bash
# Push a specific tag
git push origin v1.0.0

# Push all tags
git push origin --tags
```

## Tag Naming Conventions

### Recommended Format

- Use `v` prefix: `v1.0.0`
- Match pubspec.yaml version: If `pubspec.yaml` has `version: 1.0.0+1`, tag as `v1.0.0`
- Use semantic versioning: `v1.0.0`, `v1.0.1`, `v1.1.0`, `v2.0.0`

### Examples

```bash
# Patch release (bug fix)
git tag -a v1.0.1 -m "Fix: Resolved update dialog issue"

# Minor release (new feature)
git tag -a v1.1.0 -m "Feature: Added custom dialog themes"

# Major release (breaking changes)
git tag -a v2.0.0 -m "Breaking: Updated API configuration"
```

## Using the Package from Git

Users can reference your package by git tag in their `pubspec.yaml`:

### Using Specific Tag

```yaml
dependencies:
  app_hub_upgrader:
    git:
      url: https://github.com/aifgrouplaos/app_hub_upgrader.git
      ref: v1.0.0 # Specific version tag
```

### Using Latest from Branch

```yaml
dependencies:
  app_hub_upgrader:
    git:
      url: https://github.com/aifgrouplaos/app_hub_upgrader.git
      ref: main # Latest from main branch
```

### Using Commit Hash

```yaml
dependencies:
  app_hub_upgrader:
    git:
      url: https://github.com/aifgrouplaos/app_hub_upgrader.git
      ref: abc123def456 # Specific commit hash
```

## Complete Release Workflow

### Example: Releasing Version 1.0.0

```bash
# 1. Update version in pubspec.yaml
# version: 1.0.0+1

# 2. Update CHANGELOG.md
# Add release notes for version 1.0.0

# 3. Commit changes
git add pubspec.yaml CHANGELOG.md
git commit -m "Prepare release 1.0.0"

# 4. Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# 5. Push commits and tags
git push origin main
git push origin v1.0.0

# 6. (Optional) Create GitHub release
# Go to GitHub → Releases → Draft a new release
# Select tag v1.0.0 and add release notes
```

## Managing Tags

### List All Tags

```bash
git tag -l
git tag -l "v1.*"  # List tags matching pattern
```

### View Tag Details

```bash
git show v1.0.0
```

### Delete a Tag (Local)

```bash
git tag -d v1.0.0
```

### Delete a Tag (Remote)

```bash
git push origin --delete v1.0.0
# Or
git push origin :refs/tags/v1.0.0
```

### Update Existing Tag

If you need to update a tag (before pushing):

```bash
# Delete local tag
git tag -d v1.0.0

# Create new tag at same commit
git tag -a v1.0.0 -m "Updated release message"

# Force push (use with caution)
git push origin v1.0.0 --force
```

## Best Practices

### ✅ Do

- Create tags for all releases
- Use semantic versioning
- Include release notes in tag messages
- Push tags immediately after creating them
- Keep tag names consistent (use `v` prefix)
- Match tag version with pubspec.yaml version

### ❌ Don't

- Delete tags that have been pushed (unless necessary)
- Use tags for development/testing
- Create tags without committing changes first
- Use inconsistent tag naming

## Version Workflow Example

```bash
# Current version: 1.0.0

# Bug fix release
# 1. Update pubspec.yaml: version: 1.0.1+1
# 2. Fix bug
# 3. Update CHANGELOG.md
# 4. Commit: git commit -m "Fix: Bug description"
# 5. Tag: git tag -a v1.0.1 -m "Release 1.0.1"
# 6. Push: git push origin main && git push origin v1.0.1

# Feature release
# 1. Update pubspec.yaml: version: 1.1.0+1
# 2. Add feature
# 3. Update CHANGELOG.md
# 4. Commit: git commit -m "Feature: New feature description"
# 5. Tag: git tag -a v1.1.0 -m "Release 1.1.0"
# 6. Push: git push origin main && git push origin v1.1.0
```

## Quick Reference Commands

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release message"

# List tags
git tag -l

# Push specific tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# View tag
git show v1.0.0

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0
```

## Integration with CI/CD

You can automate tag creation in CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Create Git Tag
  if: startsWith(github.ref, 'refs/heads/main')
  run: |
    git tag -a v${{ env.VERSION }} -m "Release ${{ env.VERSION }}"
    git push origin v${{ env.VERSION }}
```

## Troubleshooting

### Tag Already Exists

If you try to create a tag that already exists:

```bash
# Delete and recreate
git tag -d v1.0.0
git tag -a v1.0.0 -m "Release message"
```

### Tag Not Showing on Remote

```bash
# Make sure you pushed the tag
git push origin v1.0.0

# Or push all tags
git push origin --tags
```

### Wrong Tag Created

```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag (if pushed)
git push origin --delete v1.0.0

# Create correct tag
git tag -a v1.0.0 -m "Correct release message"
git push origin v1.0.0
```

## Resources

- [Git Tagging Documentation](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [Semantic Versioning](https://semver.org/)
- [Flutter Package Dependencies](https://dart.dev/tools/pub/deps)
