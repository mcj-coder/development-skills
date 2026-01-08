# development-skills

This repository hosts skill specs and guidance that interoperate with the
Superpowers skills system. It is intentionally lightweight and avoids
duplicating the upstream skill library.

## Work Items

Taskboard: <https://github.com/mcj-coder/development-skills/issues>

## Purpose

- Backlog and specification of new skills to be implemented.
- Documentation and references for skills that integrate with Superpowers.
- A place to record decisions without copying the upstream skills.

## Installation

Install this skill library by creating a symlink from your agent's skill directory
to this repository.

### Prerequisites

- Git (for cloning)
- Superpowers installed ([installation guide](https://github.com/obra/superpowers#installation))

### Clone the Repository

**Unix/macOS:**

```bash
git clone https://github.com/mcj-coder/development-skills.git ~/repos/development-skills
```

**Windows PowerShell:**

```powershell
git clone https://github.com/mcj-coder/development-skills.git $env:USERPROFILE\repos\development-skills
```

### Create Skills Directory

Create the skills directory if it does not exist:

**Unix/macOS:**

```bash
mkdir -p ~/.claude/skills   # For Claude Code
mkdir -p ~/.codex/skills    # For Codex
```

**Windows PowerShell:**

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills" -Force   # For Claude Code
New-Item -ItemType Directory -Path "$env:USERPROFILE\.codex\skills" -Force    # For Codex
```

### Create Symlink

**Unix/macOS (Claude Code):**

```bash
ln -s ~/repos/development-skills ~/.claude/skills/development-skills
```

**Unix/macOS (Codex):**

```bash
ln -s ~/repos/development-skills ~/.codex/skills/development-skills
```

**Windows (Claude Code) - Run as Administrator:**

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\development-skills" -Target "$env:USERPROFILE\repos\development-skills"
```

**Windows (Codex) - Run as Administrator:**

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.codex\skills\development-skills" -Target "$env:USERPROFILE\repos\development-skills"
```

> **Note:** On Windows, creating symlinks requires Administrator privileges or
> Developer Mode enabled.

### Verify Installation

Confirm the symlink was created and skills are discoverable:

**Unix/macOS:**

```bash
ls -la ~/.claude/skills/development-skills   # Claude Code
ls -la ~/.codex/skills/development-skills    # Codex
```

**Windows PowerShell:**

```powershell
dir "$env:USERPROFILE\.claude\skills\development-skills"   # Claude Code
dir "$env:USERPROFILE\.codex\skills\development-skills"    # Codex
```

**Test skill loading:** In your agent, try loading `development-skills:skills-first-workflow`

## Repository Standards (All Contributors)

**CRITICAL**: Follow a clean build principle. When changes are committed there
should be 0 warnings or errors. During development there should be no unresolved
warnings such as during git commits or package management operations. Warnings
must be resolved immediately.

### TDD Behaviour (Including Documentation)

TDD is mandatory for all changes, including documentation. This repo does not
allow "verify after" changes.

- **No production change without a failing test first.**
- For docs, the "test" is a BDD checklist of expected statements. The checklist
  must fail against current docs before edits begin.
- Record the failure reason (missing section, missing rule, incorrect wording)
  before editing.
- Only after the failing checklist is established may implementation begin.

**Verification Types:**

- **Concrete changes** (code, config, documentation files): Require applied evidence
  with commit SHAs and file links. See [BDD Checklist Templates](docs/references/bdd-checklist-templates.md)
  for concrete changes template.
- **Process-only** (planning, reviews, requirements): Analytical verification acceptable
  with issue comment links. See [BDD Checklist Templates](docs/references/bdd-checklist-templates.md)
  for process-only template.

**How to determine:** Did the work modify files in the repository? Yes = Concrete, No = Process-only.

## Skills-First Workflow

This repository enforces a **skills-first workflow** where prerequisite skills must be loaded before implementation begins.

**See [AGENTS.md](AGENTS.md) for:**

- Complete skills-first workflow enforcement rules
- Prerequisites loading order
- Bootstrap instructions for Superpowers
- Process skills required before implementation

## Coding Style & Naming Conventions

Follow a clean, documentation-first style.

- Ensure `.editorconfig` formatting is enforced.
- Linting and Static Analysis Tools must be run and passing cleanly before
  committing.
- Naming: use kebab-case for directories and files (for example, `skill-creator/`).
- Keep files small and scoped; prefer one concept per file.

## Testing Guidelines

There is no testing framework in place, so skills testing will need to be
"simulated". Tests should be defined in a BDD manner with a list of easily
understood assertions to prove success.

When tests are added, colocate them in the skills folder:

- Use clear file naming (for example, `skill-name.test.md` or `skill-name.test.js`).

## Branching and Commits

- Use the GitHub Flow branching strategy.
- Use concise Conventional Commit messages.
- All tickets should be implemented within a separate transient branch.
- Sub-tasks should be implemented in a branch from the main ticket feature
  branch.
- When a sub-task is verified and complete the related branch should be merged
  back into the feature branch.
- When a ticket has all sub-tasks completed and verified it should be merged
  back into the default branch via PR.
- Before closing a PR, rebase on the latest default branch.
- If commit count is excessive for the PR scope, use **squash and merge**.
  Otherwise, rebase and use **fast-forward only** merge.
- Squash commit messages must be Conventional Commits with a concise description
  of the PR changes. Add a footer reference to the relevant ticket when
  appropriate (for example, `Refs: #123`).

## Security & Configuration Tips

- Do not commit secrets or API keys.
- Keep prerequisites explicit (for example, "superpowers installed") in `README.md`.

## Skill Format Standard

**MANDATORY**: All skills in this repository MUST follow the
[agentskills.io specification](https://agentskills.io/specification).

Requirements for all skills:

- Skills must be in their own directory under `skills/`
- Each skill must have a `SKILL.md` file following the agentskills.io format
- Each skill must have a colocated test file (e.g., `skill-name.test.md`)
- Skills must include BDD-style tests with RED/GREEN scenarios
- Skills must be interoperable with the Superpowers skill system
- Reference the agentskills.io specification for any formatting questions

## Skills

- `automated-standards-enforcement` - P0 foundational for automated quality (linting, spelling, SAST)
- `issue-driven-delivery` (requires ticketing CLI: gh/ado/jira)
- `agent-workitem-automation` (requires work item system CLI)
- `persona-switching` - P2 multi-identity Git/GitHub workflows with role-based personas
- `requirements-gathering` - For creating work items with requirements (no design docs)
- `skills-first-workflow` (requires Superpowers)
- `markdown-author` - Proactive markdown linting and spelling validation during writing
- `walking-skeleton-delivery` - P3 delivery skill for minimal E2E architecture validation
- `testcontainers-integration-tests` - P1 integration testing with real infrastructure via Testcontainers
- `technical-debt-prioritisation` - P3 delivery skill for evidence-based debt prioritisation

## Documentation

This repository follows standard InnerSource/OpenSource documentation practices:

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute and create skills
- **[docs/getting-started.md](docs/getting-started.md)** - Developer onboarding and project setup
- **[docs/architecture-overview.md](docs/architecture-overview.md)** - Architectural patterns, boundaries, and structure
- **[docs/coding-standards.md](docs/coding-standards.md)** - Code style, naming conventions, and patterns
- **[docs/testing-strategy.md](docs/testing-strategy.md)** - Testing approach, tools, and patterns
- **[docs/exclusions.md](docs/exclusions.md)** - Explicitly excluded patterns and suppressions
- **[docs/roles/](docs/roles/)** - Team role definitions for code reviews and expert perspectives
- **[docs/adr/](docs/adr/)** - Architecture Decision Records for major decisions

### For Agents

- **Skills are in [skills/](skills/)** - Agent-facing skill specifications
- **Check [docs/exclusions.md](docs/exclusions.md)** before suggesting patterns that may have been declined
- **Document using human terminology** - When applying skills, update human-readable docs
  (architecture-overview.md, coding-standards.md, etc.) not skill-specific files
- **See [AGENTS.md](AGENTS.md)** for agent-specific execution rules and documentation standards

## Automation

GitHub Actions workflows that automate repository processes:

| Workflow                                                             | Trigger                   | Description                                        |
| -------------------------------------------------------------------- | ------------------------- | -------------------------------------------------- |
| [auto-unblock.yml](.github/workflows/auto-unblock.yml)               | Issue closed              | Removes `blocked` label from dependent issues      |
| [detect-duplicates.yml](.github/workflows/detect-duplicates.yml)     | Issue opened              | Detects potentially duplicate issues on creation   |
| [sync-project-status.yml](.github/workflows/sync-project-status.yml) | Issue label/state changes | Syncs issue state labels to Project board status   |
| [validate-labels.yml](.github/workflows/validate-labels.yml)         | Issue label/state changes | Validates required labels before state transitions |

See [docs/playbooks/](docs/playbooks/) for detailed setup and usage instructions.
