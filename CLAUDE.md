# {PROJECT_NAME}

{One-line project description}

## Skills (Required Reading)

**Before starting any work, read the relevant skill:**

| When | Skill | Path |
|------|-------|------|
| Starting any feature/task | `development-workflow` | `.claude/skills/development-workflow/SKILL.md` |
| Creating diagrams (Phase 2) | `figjam-diagram` | `.claude/skills/figjam-diagram/SKILL.md` |
| Working on issues/PRs | `project-management` | `.claude/skills/project-management/SKILL.md` |
| Creating new skills | `skill-creator` | `.claude/skills/skill-creator/SKILL.md` |

### Skill Triggers

- **"let's start working"** / **"new feature"** / **"start task"** -> Read `development-workflow`, begin Phase 1
- **"create diagram"** / **"draw flowchart"** -> Read `figjam-diagram`, follow 7-step process
- **Creating/updating issues** -> Read `project-management`
- **Creating new skills** -> Read `skill-creator`

## 6-Phase Development Workflow

**Every feature/task MUST follow all 6 phases in order:**

```
Phase 1: Requirements Definition     <- user confirmation required
    |
Phase 2: Design (Diagrams)           <- user confirmation required
    |
Phase 3: Edge Case Analysis          <- user confirmation required
    |
Phase 4: Implementation (TDD)
    |
Phase 5: Debug & Verification
    |
Phase 6: Release
```

**NEVER skip phases. NEVER start coding before Phase 3 is complete.**

## Project Configuration

GitHub Project settings are stored in `.claude/project.json`.

```bash
cat .claude/project.json
```

## Quick Commands

```bash
# Development (customize these for your project)
{dev_install_command}         # Install dependencies
{dev_run_command}             # Development mode
{dev_build_command}           # Build for production
{test_command}                # Run tests
{lint_command}                # Lint check

# GitHub
gh issue list -R {REPOSITORY}
gh issue create --title "Title" -R {REPOSITORY}
gh issue close <number> -R {REPOSITORY}
```

## Tech Stack

| Area      | Technology |
| --------- | ---------- |
| Runtime   | -          |
| Framework | -          |
| Language  | -          |
| Test      | -          |

## Milestones

| Version | Focus | Key Issues |
|---------|-------|------------|
| v0.1 | Initial Setup | Setup, Core features |
| v0.2 | - | - |
| v0.3 | - | - |
| v1.0 | Production | Release |

## Notifications

Report to {NOTIFICATION_TARGET}:

```
Starting #N: {title}
Completed #N: {title}
Question: {question}
```

## Core Rules

1. **English only** - All comments, docs, and commits in English
2. **6-Phase workflow** - Every task goes through all 6 phases
3. **Diagrams before code** - Phase 2 (Design) must complete before Phase 4 (Implementation)
4. **Test-first** - Write tests before implementation in Phase 4 (TDD)
5. **Edge cases first** - Phase 3 must complete before Phase 4
6. **GitHub sync** - Always sync with GitHub Projects
7. **Config first** - Read `.claude/project.json` before GitHub operations
8. **Read skills** - Always check relevant skill before major work

## File Organization

```
docs/
  workflow/{feature-name}/
    01-requirements.md        # Phase 1 output
    02-design.md              # Phase 2 output
    03-edge-cases.md          # Phase 3 output
  diagrams/
    mermaid/                  # Mermaid source files (.mmd)
    plans/                    # Diagram plans (.plan.md)
```

## References

- GitHub: https://github.com/{REPOSITORY}
- Issues: `gh issue list -R {REPOSITORY}`
