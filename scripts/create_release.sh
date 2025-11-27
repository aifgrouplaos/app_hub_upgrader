#!/bin/bash

# Script to create a git tag for a new release
# Usage: ./scripts/create_release.sh [version] [message]
# Example: ./scripts/create_release.sh 1.0.0 "Initial release"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from argument or pubspec.yaml
if [ -z "$1" ]; then
    # Extract version from pubspec.yaml
    VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
    echo -e "${YELLOW}No version specified, using version from pubspec.yaml: $VERSION${NC}"
else
    VERSION=$1
fi

# Validate version format (semantic versioning)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use semantic versioning (e.g., 1.0.0)${NC}"
    exit 1
fi

# Get message from argument or use default
if [ -z "$2" ]; then
    MESSAGE="Release version $VERSION"
else
    MESSAGE="$2"
fi

TAG="v$VERSION"

echo -e "${GREEN}Creating release tag: $TAG${NC}"
echo -e "Message: $MESSAGE"
echo ""

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo -e "${RED}Error: Tag $TAG already exists${NC}"
    echo -e "${YELLOW}To delete and recreate: git tag -d $TAG && git push origin --delete $TAG${NC}"
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create annotated tag
git tag -a "$TAG" -m "$MESSAGE"

echo -e "${GREEN}Tag $TAG created successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the tag: git show $TAG"
echo "  2. Push the tag: git push origin $TAG"
echo "  3. Or push all tags: git push origin --tags"
echo ""
echo -e "${YELLOW}To push now, run: git push origin $TAG${NC}"

