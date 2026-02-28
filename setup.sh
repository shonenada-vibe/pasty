#!/bin/bash
# setup.sh — Bootstrap the Pasty project
# Usage: bash setup.sh

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "=== Pasty Project Setup ==="

# Check Swift is available
if ! command -v swift &> /dev/null; then
    echo "ERROR: Swift not found. Install Xcode or Swift toolchain."
    exit 1
fi

echo "Swift version: $(swift --version 2>&1 | head -1)"

# Create directory structure
echo "Creating directory structure..."
mkdir -p Sources/Pasty/Models
mkdir -p Sources/Pasty/Managers
mkdir -p Sources/Pasty/Views
mkdir -p Tests/PastyTests
mkdir -p Resources
mkdir -p PROGRESS

# Initialize git if not already a repo
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    cat > .gitignore << 'EOF'
.build/
.swiftpm/
*.xcodeproj
*.xcworkspace
DerivedData/
.DS_Store
EOF
    echo "Created .gitignore"
fi

# Check if Package.swift exists
if [ -f Package.swift ]; then
    echo "Package.swift already exists, skipping..."
else
    echo "NOTE: Package.swift will be created during the 'project-setup' task."
fi

# Verify build (only if Package.swift exists)
if [ -f Package.swift ]; then
    echo "Building project..."
    swift build
    echo "Build successful!"
else
    echo "Skipping build (no Package.swift yet)."
fi

echo ""
echo "=== Setup Complete ==="
echo "Next: Start working on tasks in tasks.json"
echo "  1. Read CLAUDE.md for the agent workflow"
echo "  2. Read PROJECT_CONTEXT.md for architecture details"
echo "  3. Begin with task 'project-setup'"
