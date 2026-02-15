#!/bin/bash

# Workflow Template Setup Script
# Replaces placeholders with actual project values

set -e

echo "=== Workflow Template Setup ==="
echo ""

# Get project name
read -p "Project name: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
  echo "Error: Project name is required"
  exit 1
fi

# Get project description
read -p "Project description (one line): " PROJECT_DESC
PROJECT_DESC=${PROJECT_DESC:-"Project description"}

# Editor Selection
echo ""
echo "=== Editor Selection ==="
echo "1) Claude Code  (.claude/)"
echo "2) Cursor       (.cursor/)"
echo "3) Both"
echo ""
read -p "Select editor [1-3]: " EDITOR_CHOICE

case $EDITOR_CHOICE in
  1) USE_CLAUDE=true;  USE_CURSOR=false ;;
  2) USE_CLAUDE=false; USE_CURSOR=true  ;;
  3) USE_CLAUDE=true;  USE_CURSOR=true  ;;
  *) USE_CLAUDE=true;  USE_CURSOR=false ;;
esac

# Notification target
read -p "Notification target (e.g., Telegram ID, Slack channel, or press Enter to skip): " NOTIFICATION_TARGET
NOTIFICATION_TARGET=${NOTIFICATION_TARGET:-"{NOTIFICATION_TARGET}"}

# Tech Stack Selection
echo ""
echo "=== Tech Stack Selection ==="
echo "1) Node.js + TypeScript"
echo "2) React + TypeScript"
echo "3) Python"
echo "4) Go"
echo "5) Other / Skip"
echo ""
read -p "Select tech stack [1-5]: " TECH_CHOICE

case $TECH_CHOICE in
  1)
    RUNTIME="Node.js"
    FRAMEWORK="-"
    LANGUAGE="TypeScript"
    TEST_FRAMEWORK="Vitest"
    DEV_INSTALL="npm install"
    DEV_RUN="npm run dev"
    DEV_BUILD="npm run build"
    TEST_CMD="npm test"
    LINT_CMD="npm run lint"
    ;;
  2)
    RUNTIME="Node.js"
    FRAMEWORK="React"
    LANGUAGE="TypeScript"
    TEST_FRAMEWORK="Vitest"
    DEV_INSTALL="npm install"
    DEV_RUN="npm run dev"
    DEV_BUILD="npm run build"
    TEST_CMD="npm test"
    LINT_CMD="npm run lint"
    ;;
  3)
    RUNTIME="Python"
    FRAMEWORK="-"
    LANGUAGE="Python"
    TEST_FRAMEWORK="pytest"
    DEV_INSTALL="pip install -r requirements.txt"
    DEV_RUN="python main.py"
    DEV_BUILD="python -m build"
    TEST_CMD="pytest"
    LINT_CMD="ruff check ."
    ;;
  4)
    RUNTIME="Go"
    FRAMEWORK="-"
    LANGUAGE="Go"
    TEST_FRAMEWORK="go test"
    DEV_INSTALL="go mod download"
    DEV_RUN="go run ."
    DEV_BUILD="go build ."
    TEST_CMD="go test ./..."
    LINT_CMD="golangci-lint run"
    ;;
  *)
    RUNTIME="-"
    FRAMEWORK="-"
    LANGUAGE="-"
    TEST_FRAMEWORK="-"
    DEV_INSTALL="# install dependencies"
    DEV_RUN="# run dev server"
    DEV_BUILD="# build for production"
    TEST_CMD="# run tests"
    LINT_CMD="# lint check"
    ;;
esac

# Test setup option (Node.js only)
SETUP_TESTS="n"
if [[ "$TECH_CHOICE" == "1" || "$TECH_CHOICE" == "2" ]]; then
  echo ""
  read -p "Setup test environment with Vitest? [y/N]: " SETUP_TESTS
  SETUP_TESTS=${SETUP_TESTS:-n}
fi

# Figma MCP setup
echo ""
echo "=== Figma MCP (for diagram creation) ==="
read -p "Do you have Figma MCP configured? [y/N]: " HAS_FIGMA
HAS_FIGMA=${HAS_FIGMA:-n}

# Get GitHub username
echo ""
echo "Detecting GitHub username..."
GH_USER=$(gh api user --jq '.login' 2>/dev/null || echo "")
if [ -z "$GH_USER" ]; then
  read -p "GitHub username: " GH_USER
fi
echo "GitHub user: $GH_USER"

# Get repository name
read -p "Repository name (default: $PROJECT_NAME): " REPO_NAME
REPO_NAME=${REPO_NAME:-$PROJECT_NAME}
REPOSITORY="$GH_USER/$REPO_NAME"

# Get GitHub Project number
echo ""
echo "Fetching your GitHub Projects..."
gh project list --owner @me 2>/dev/null || echo "Could not fetch projects (gh CLI not configured)"
echo ""
read -p "GitHub Project number (or press Enter to skip): " PROJECT_NUMBER

# --- Remove unused editor directory ---
echo ""
echo "Configuring editor setup..."

if [ "$USE_CLAUDE" = false ]; then
  echo "Removing .claude/ (not selected)..."
  rm -rf .claude
  rm -f CLAUDE.md
fi

if [ "$USE_CURSOR" = false ]; then
  echo "Removing .cursor/ (not selected)..."
  rm -rf .cursor
fi

# --- Replace placeholders in CLAUDE.md (if kept) ---
if [ "$USE_CLAUDE" = true ]; then
  echo "Updating CLAUDE.md..."
  sed -i "s/{PROJECT_NAME}/$PROJECT_NAME/g" CLAUDE.md
  sed -i "s/{One-line project description}/$PROJECT_DESC/g" CLAUDE.md
  sed -i "s|{REPOSITORY}|$REPOSITORY|g" CLAUDE.md
  sed -i "s/{NOTIFICATION_TARGET}/$NOTIFICATION_TARGET/g" CLAUDE.md
  sed -i "s|{dev_install_command}|$DEV_INSTALL|g" CLAUDE.md
  sed -i "s|{dev_run_command}|$DEV_RUN|g" CLAUDE.md
  sed -i "s|{dev_build_command}|$DEV_BUILD|g" CLAUDE.md
  sed -i "s|{test_command}|$TEST_CMD|g" CLAUDE.md
  sed -i "s|{lint_command}|$LINT_CMD|g" CLAUDE.md

  if [ "$RUNTIME" != "-" ]; then
    sed -i "s/| Runtime   | -          |/| Runtime   | $RUNTIME |/g" CLAUDE.md
    sed -i "s/| Framework | -          |/| Framework | $FRAMEWORK |/g" CLAUDE.md
    sed -i "s/| Language  | -          |/| Language  | $LANGUAGE |/g" CLAUDE.md
    sed -i "s/| Test      | -          |/| Test      | $TEST_FRAMEWORK |/g" CLAUDE.md
  fi

  echo "Updating .claude/ skill files..."
  find .claude/skills -name "*.md" -exec sed -i "s|{REPOSITORY}|$REPOSITORY|g" {} +
  find .claude/skills -name "*.md" -exec sed -i "s|{test_command}|$TEST_CMD|g" {} +
  find .claude/skills -name "*.md" -exec sed -i "s|{lint_command}|$LINT_CMD|g" {} +
  find .claude/skills -name "*.md" -exec sed -i "s|{typecheck_command}|# typecheck|g" {} +
fi

if [ "$USE_CURSOR" = true ]; then
  echo "Updating .cursor/ skill and rule files..."
  find .cursor/skills -name "*.md" -exec sed -i "s|{REPOSITORY}|$REPOSITORY|g" {} +
  find .cursor/skills -name "*.md" -exec sed -i "s|{test_command}|$TEST_CMD|g" {} +
  find .cursor/skills -name "*.md" -exec sed -i "s|{lint_command}|$LINT_CMD|g" {} +
  find .cursor/skills -name "*.md" -exec sed -i "s|{typecheck_command}|# typecheck|g" {} +
  find .cursor/rules -name "*.mdc" -exec sed -i "s|{REPOSITORY}|$REPOSITORY|g" {} +
fi

# Setup test environment if requested
if [[ "$SETUP_TESTS" =~ ^[Yy]$ ]]; then
  echo "Setting up test environment..."
  mkdir -p tests

  if [ -d "templates" ]; then
    cp templates/vitest.config.ts.template vitest.config.ts 2>/dev/null || true
    cp templates/tests/example.test.ts.template tests/example.test.ts 2>/dev/null || true
  fi

  if [ ! -f "package.json" ]; then
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "description": "$PROJECT_DESC",
  "type": "module",
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint ."
  },
  "devDependencies": {
    "vitest": "^2.0.0",
    "@vitest/coverage-v8": "^2.0.0",
    "typescript": "^5.0.0"
  }
}
EOF
    echo "Created package.json"
  fi

  echo "Test environment setup complete!"
fi

# Create project.json if project number provided
if [ -n "$PROJECT_NUMBER" ]; then
  echo "Creating project.json..."

  PROJECT_INFO=$(gh project view $PROJECT_NUMBER --owner @me --format json 2>/dev/null || echo "{}")
  PROJECT_ID=$(echo "$PROJECT_INFO" | jq -r '.id // ""')
  PROJECT_URL=$(echo "$PROJECT_INFO" | jq -r '.url // ""')

  PROJECT_JSON=$(cat << EOF
{
  "github": {
    "project": {
      "number": $PROJECT_NUMBER,
      "id": "$PROJECT_ID",
      "url": "$PROJECT_URL",
      "owner": "@me"
    },
    "repository": "$REPOSITORY"
  }
}
EOF
)

  if [ "$USE_CLAUDE" = true ]; then
    echo "$PROJECT_JSON" > .claude/project.json
  fi
  if [ "$USE_CURSOR" = true ]; then
    echo "$PROJECT_JSON" > .cursor/project.json
  fi

  echo "GitHub Project configured: #$PROJECT_NUMBER"
else
  echo "Skipping GitHub Project configuration (can be set later)"
fi

# Create workflow directories
mkdir -p docs/workflow
mkdir -p docs/diagrams/mermaid
mkdir -p docs/diagrams/plans

# Remove template files
rm -f .claude/project.json.template 2>/dev/null
rm -f .cursor/project.json.template 2>/dev/null
rm -rf templates

# Clean up setup files
echo ""
echo "Cleaning up template files..."
rm -rf .git
rm -f README.md
rm -f install.sh
rm -f setup.sh

# --- Summary ---
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Project: $PROJECT_NAME"
echo "Repository: $REPOSITORY"

EDITOR_LABEL=""
if [ "$USE_CLAUDE" = true ] && [ "$USE_CURSOR" = true ]; then
  EDITOR_LABEL="Claude Code + Cursor"
elif [ "$USE_CLAUDE" = true ]; then
  EDITOR_LABEL="Claude Code"
else
  EDITOR_LABEL="Cursor"
fi
echo "Editor: $EDITOR_LABEL"

echo ""
echo "Next steps:"
echo "  1. git init && git add . && git commit -m 'Initial commit'"
echo "  2. gh repo create $REPO_NAME --private --source=. --push"
if [ -z "$PROJECT_NUMBER" ]; then
  echo "  3. Create GitHub Project: gh project create --owner @me --title '$PROJECT_NAME'"
  if [ "$USE_CLAUDE" = true ]; then
    echo "  4. Create .claude/project.json with project details"
  fi
  if [ "$USE_CURSOR" = true ]; then
    echo "  4. Create .cursor/project.json with project details"
  fi
fi
if [[ ! "$HAS_FIGMA" =~ ^[Yy]$ ]]; then
  echo ""
  echo "  Figma MCP Setup (for diagram creation in Phase 2):"
  echo "  - Create a Figma account and configure Figma MCP"
  echo "  - See: https://www.figma.com/developers"
fi
echo ""
echo "Start developing:"
echo "  Say: 'let's start working' or 'new feature'"
echo "  The AI will guide you through the 6-phase workflow:"
echo "    Phase 1: Requirements -> Phase 2: Design (Diagrams)"
echo "    Phase 3: Edge Cases -> Phase 4: Implementation (TDD)"
echo "    Phase 5: Debug -> Phase 6: Release"
echo ""
echo "Important files:"
if [ "$USE_CLAUDE" = true ]; then
  echo "  CLAUDE.md              - Project instructions (read first)"
  echo "  .claude/CONTEXT.md     - Project decisions and learnings"
  echo "  .claude/skills/        - Workflow skills"
fi
if [ "$USE_CURSOR" = true ]; then
  echo "  .cursor/SKILLS-INITIALIZATION.md  - Skills/rules registry"
  echo "  .cursor/rules/         - Always-on and conditional rules"
  echo "  .cursor/skills/        - Workflow skills"
fi
if [[ "$SETUP_TESTS" =~ ^[Yy]$ ]]; then
  echo "  vitest.config.ts       - Test configuration"
  echo "  tests/                 - Test files"
fi
