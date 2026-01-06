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

- `issue-driven-delivery` (requires ticketing CLI: gh/ado/jira)
- `agent-workitem-automation` (requires work item system CLI)
- `requirements-gathering` - For creating work items with requirements (no design docs)
- `skills-first-workflow` (requires Superpowers)
- `markdown-author` - Proactive markdown linting and spelling validation during writing

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
