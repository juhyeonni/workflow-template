#!/bin/sh

# Workflow Template One-Line Installer
#
# Usage:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/juhyeonni/workflow-template/main/install.sh)"
#
# With project name:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/juhyeonni/workflow-template/main/install.sh)" -- my-project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

REPO_URL="https://github.com/juhyeonni/workflow-template.git"

print_banner() {
  echo ""
  printf "${BLUE}${BOLD}\n"
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║       Workflow Template Installer        ║"
  echo "  ║     6-Phase Development Workflow         ║"
  echo "  ╚══════════════════════════════════════════╝"
  printf "${NC}\n"
}

error() {
  printf "${RED}Error: %s${NC}\n" "$1" >&2
  exit 1
}

info() {
  printf "${BLUE}%s${NC}\n" "$1"
}

success() {
  printf "${GREEN}%s${NC}\n" "$1"
}

warn() {
  printf "${YELLOW}%s${NC}\n" "$1"
}

# Check dependencies
check_deps() {
  if ! command -v git >/dev/null 2>&1; then
    error "git is required but not installed. Install it first."
  fi
  if ! command -v gh >/dev/null 2>&1; then
    warn "Warning: GitHub CLI (gh) not found. Some setup features will be limited."
    warn "Install: https://cli.github.com/"
    echo ""
  fi
}

main() {
  print_banner
  check_deps

  # Get project name from argument or prompt
  PROJECT_NAME="${1:-}"
  if [ -z "$PROJECT_NAME" ]; then
    printf "Project name: "
    read -r PROJECT_NAME
  fi

  if [ -z "$PROJECT_NAME" ]; then
    error "Project name is required"
  fi

  # Validate project name (alphanumeric, hyphens, underscores)
  if ! echo "$PROJECT_NAME" | grep -qE '^[a-zA-Z0-9_-]+$'; then
    error "Invalid project name. Use only letters, numbers, hyphens, and underscores."
  fi

  # Check if directory already exists
  if [ -d "$PROJECT_NAME" ]; then
    error "Directory '$PROJECT_NAME' already exists"
  fi

  # Clone
  info "Cloning workflow template..."
  git clone --depth 1 "$REPO_URL" "$PROJECT_NAME" 2>/dev/null || error "Failed to clone repository"

  cd "$PROJECT_NAME"

  # Remove template git history
  rm -rf .git

  # Run interactive setup
  info "Starting interactive setup..."
  echo ""
  bash setup.sh

  # Initialize fresh git repo
  if [ ! -d ".git" ]; then
    git init -q
    git add -A
    git commit -q -m "Initial commit from workflow-template"
    success "Git repository initialized with initial commit."
  fi

  echo ""
  printf "${GREEN}${BOLD}\n"
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║            Setup Complete!               ║"
  echo "  ╚══════════════════════════════════════════╝"
  printf "${NC}\n"
  echo ""
  printf "  ${BOLD}cd %s${NC} and start developing!\n" "$PROJECT_NAME"
  echo ""
  printf "  Say ${BOLD}'let's start working'${NC} to begin the 6-phase workflow.\n"
  echo ""
}

# Run main with all arguments passed after --
main "$@"
