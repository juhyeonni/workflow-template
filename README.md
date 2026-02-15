# Workflow Template

A project template that enforces a **6-phase development workflow** with integrated diagram creation via Figma MCP. Works with both **Claude Code** and **Cursor**.

## 6-Phase Workflow

Every feature/task goes through these phases in order:

```
Phase 1: Requirements Definition     (user confirmation required)
    |
Phase 2: Design                      (Use Case + Process Flow diagrams via Figma MCP)
    |
Phase 3: Edge Case Analysis          (user confirmation required)
    |
Phase 4: Implementation              (TDD: RED -> GREEN -> REFACTOR)
    |
Phase 5: Debug & Verification
    |
Phase 6: Release                     (PR with full phase checklist)
```

## Supported Editors

| Editor | Config Directory | Instructions |
|--------|-----------------|--------------|
| **Claude Code** | `.claude/` | `CLAUDE.md` + `.claude/skills/` |
| **Cursor** | `.cursor/` | `.cursor/rules/*.mdc` + `.cursor/skills/` |

Both configurations are included and kept in sync. Use whichever editor you prefer.

## Quick Start

### Option 1: Clone directly

```bash
git clone https://github.com/juhyeonni/workflow-template.git my-project
cd my-project
bash setup.sh
```

### Option 2: One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/juhyeonni/workflow-template/main/install.sh | bash -s my-project
```

## Directory Structure

```
# Claude Code configuration
.claude/
  CONTEXT.md                    # Project decisions and learnings
  project.json                  # GitHub Project configuration
  memory/                       # Daily development logs
  skills/
    development-workflow/       # 6-phase workflow (core)
    figjam-diagram/             # Diagram creation via Figma MCP
    project-management/         # GitHub issues/PRs workflow
    skill-creator/              # Guide for creating new skills

# Cursor configuration
.cursor/
  SKILLS-INITIALIZATION.md      # Master skills/rules registry
  project.json                  # GitHub Project configuration
  rules/
    project-conventions.mdc     # Always-on: code conventions
    workflow-enforcement.mdc    # Always-on: 6-phase enforcement
    diagram-specialist.mdc      # On-demand: diagram creation
  skills/
    development-workflow/       # Same skills as .claude/
    figjam-diagram/
    project-management/
    skill-creator/

# Shared
docs/
  workflow/{feature}/           # Per-feature workflow documents
    01-requirements.md
    02-design.md
    03-edge-cases.md
  diagrams/
    mermaid/                    # Mermaid source files (.mmd)
    plans/                      # Diagram plans (.plan.md)
CLAUDE.md                       # Main project instructions
```

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `development-workflow` | "start working", "new feature" | 6-phase workflow enforcement |
| `figjam-diagram` | "create diagram", "draw flowchart" | Diagram creation via Figma MCP |
| `project-management` | Creating issues/PRs | GitHub workflow management |
| `skill-creator` | "create new skill" | Skill authoring guide |

## Cursor Rules

| Rule | Always Apply | Purpose |
|------|-------------|---------|
| `project-conventions.mdc` | Yes | Code/file conventions, English output |
| `workflow-enforcement.mdc` | Yes | Enforces 6-phase workflow |
| `diagram-specialist.mdc` | No | Diagram creation technical guide |

## Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated
- [Claude Code](https://claude.ai/code) or [Cursor](https://cursor.com/) configured
- [Figma MCP](https://www.figma.com/developers) (optional, for diagram creation in Phase 2)

## Setup Placeholders

| Placeholder | Set By | Location |
|-------------|--------|----------|
| `{PROJECT_NAME}` | setup.sh | CLAUDE.md |
| `{REPOSITORY}` | setup.sh | CLAUDE.md, skills |
| `{test_command}` | setup.sh | CLAUDE.md, skills |
| `{lint_command}` | setup.sh | CLAUDE.md, skills |
| `{NOTIFICATION_TARGET}` | setup.sh | CLAUDE.md |

## Post-Setup

1. Initialize git: `git init && git add . && git commit -m 'Initial commit'`
2. Create repo: `gh repo create <name> --private --source=. --push`
3. Create GitHub Project: `gh project create --owner @me --title '<name>'`
4. Configure Figma MCP for diagram creation (optional)
5. Start working: say "let's start working"

## How It Works

1. You say "new feature: user authentication"
2. AI reads `development-workflow` skill
3. **Phase 1**: Asks requirements questions, documents them
4. **Phase 2**: Creates Use Case + Process Flow diagrams via Figma MCP
5. **Phase 3**: Analyzes edge cases, gets your confirmation
6. **Phase 4**: Writes tests first (TDD), then implements
7. **Phase 5**: Verifies everything passes
8. **Phase 6**: Creates PR with full phase checklist

## Claude Code vs Cursor

| Feature | Claude Code | Cursor |
|---------|------------|--------|
| Skills | `.claude/skills/*/SKILL.md` | `.cursor/skills/*/SKILL.md` |
| Rules | Embedded in `CLAUDE.md` | `.cursor/rules/*.mdc` |
| Always-on rules | `CLAUDE.md` Core Rules section | `alwaysApply: true` in `.mdc` |
| Conditional rules | Skill triggers | `alwaysApply: false` in `.mdc` |
| Master index | `CLAUDE.md` | `.cursor/SKILLS-INITIALIZATION.md` |

---

*Delete or modify this README after setup.*
