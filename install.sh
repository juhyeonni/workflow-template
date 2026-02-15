#!/bin/bash

# Workflow Template One-Line Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/{user}/workflow-template/main/install.sh | bash -s <project-name>

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Workflow Template Installer ===${NC}"
echo ""

# Check project name
PROJECT_NAME=${1:-""}
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  echo "Example: $0 my-project"
  exit 1
fi

# Check if directory exists
if [ -d "$PROJECT_NAME" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists"
  exit 1
fi

# Check for git
if ! command -v git &> /dev/null; then
  echo "Error: git is required but not installed"
  exit 1
fi

# Clone template
echo "Cloning workflow template..."
git clone --depth 1 https://github.com/juhyeonni/workflow-template.git "$PROJECT_NAME"

# Clean git history
cd "$PROJECT_NAME"
rm -rf .git

# Initialize fresh git
git init

echo ""
echo -e "${GREEN}Template installed to: $PROJECT_NAME${NC}"
echo ""

# Run setup if interactive
if [ -t 0 ]; then
  echo "Running interactive setup..."
  echo ""
  bash setup.sh
else
  echo "Run setup manually:"
  echo "  cd $PROJECT_NAME && bash setup.sh"
fi
