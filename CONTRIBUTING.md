# Contributing to Development Skills

## Overview

This repository hosts skill specifications that integrate with the Superpowers skills system. Skills are
agent-facing documentation that helps AI agents apply proven techniques, patterns, and processes.

## Prerequisites

- Familiarity with [Superpowers](https://github.com/obra/superpowers)
- Understanding of [agentskills.io specification](https://agentskills.io/specification)
- Node.js installed for running Superpowers bootstrap
- Understanding of RED-GREEN-REFACTOR methodology (TDD for documentation)

## Quick Start

1. **Read the documentation:**
   - [docs/getting-started.md](docs/getting-started.md) - Project setup and onboarding
   - [docs/architecture-overview.md](docs/architecture-overview.md) - Architectural patterns
   - [docs/coding-standards.md](docs/coding-standards.md) - Code and documentation standards

2. **Check work item tracking:**
   - Taskboard: <https://github.com/mcj-coder/development-skills/issues>
   - All non-read-only work must be tied to an issue

3. **Follow the workflow:**
   - See [README.md](README.md) for repository standards
   - See [AGENTS.md](AGENTS.md) for agent-specific rules

## Creating Skills

### Process Overview

Skills must be created following the **writing-skills RED-GREEN-REFACTOR methodology**:

1. **Create Issue** - Use `.github/ISSUE_TEMPLATE/skill-spec.md` template
2. **RED Phase** - Run baseline tests WITHOUT skill, document failures verbatim
3. **GREEN Phase** - Write minimal skill addressing those specific failures
4. **REFACTOR Phase** - Close loopholes, add rationalizations table, re-verify

**CRITICAL:** No skill without failing test first. This is the Iron Law.

### Detailed Guidance

See the `superpowers:writing-skills` SKILL.md for comprehensive guidance on:

- When to create skills vs when not to
- Testing methodology and pressure scenarios
- Progressive loading and token efficiency
- Rationalization tables and red flags
- Cross-referencing and DRY principles

### Issue Template

All skill specifications must use `.github/ISSUE_TEMPLATE/skill-spec.md` which includes:

- Frontmatter specification (YAML format)
- RED phase baseline scenarios (3+ with pressure combinations)
- GREEN phase concrete BDD scenarios (real inputs/outputs)
- REFACTOR phase rationalization closing
- Superpowers cross-references (DRY)
- Brainstorming integration points
- Documentation requirements
- Progressive loading strategy

## Documentation Standards

### Human-Centric Principle

**Skill names are agent implementation details.** When documenting, use human-readable terminology.

When applying skills, update human-centric documentation:

- Architecture patterns → `docs/architecture-overview.md`
- Code standards → `docs/coding-standards.md`
- Testing approach → `docs/testing-strategy.md`
- Onboarding → `docs/getting-started.md`

**Don't create skill-specific documentation files** (e.g., no `docs/conventions/architecture-testing.md`).

### Documentation Locations

| Content Type          | Location                        | Notes                        |
| --------------------- | ------------------------------- | ---------------------------- |
| Architecture patterns | `docs/architecture-overview.md` | Use industry terminology     |
| Code style, naming    | `docs/coding-standards.md`      | Aggregated standards         |
| Testing approach      | `docs/testing-strategy.md`      | Tools, patterns, strategy    |
| Onboarding            | `docs/getting-started.md`       | New developer guide          |
| Excluded patterns     | `docs/exclusions.md`            | Concise opt-outs list        |
| Major decisions       | `docs/adr/`                     | ADRs for significant choices |
| Skill specs           | `skills/{skill-name}/SKILL.md`  | Agent-facing only            |

### Recording Opt-Outs

When users decline patterns/practices:

1. **Update `docs/exclusions.md`:**
   - Human-readable pattern name (primary)
   - Agent skill mapping (for agent reference)
   - Reason, date, scope
   - When to reconsider

2. **Keep it concise** (1-3 sentences per exclusion)

3. **Use human terminology:**
   - ✅ "Automated architecture boundary enforcement"
   - ❌ "architecture-testing skill"

### Creating ADRs

Use ADRs for major decisions only:

- Choosing frameworks or major libraries
- Significant architectural changes
- Major tooling decisions

**Not for:** Every skill application or minor configuration choice.

Format: Follow [MADR](https://adr.github.io/madr/) format (see `docs/adr/0000-use-adrs.md`).

## Branching and Pull Requests

### Branching Strategy

- **GitHub Flow** - Feature branches from `main`
- **Never commit directly to `main`**
- Feature branches for issues: `feature/issue-{number}-{brief-description}`
- Sub-task branches from feature branches: `feature/issue-{number}-subtask-{description}`

### Commit Messages

- **Conventional Commits** format
- Concise and descriptive
- Include footer reference when appropriate: `Refs: #123`

Examples:

```text
feat: add architecture-testing skill spec

Add skill for automated architecture boundary enforcement
following RED-GREEN-REFACTOR methodology.

Refs: #1
```

### Pull Request Process

1. **Rebase on latest `main`** before creating PR
2. **Choose merge strategy:**
   - Excessive commits for scope → **Squash and merge**
   - Otherwise → **Fast-forward only**
3. **Squash commit messages** must be Conventional Commits with ticket reference

### Quality Gates

Before submitting PR:

- ✅ Zero warnings or errors (clean build principle)
- ✅ All tests pass (BDD checklists verified)
- ✅ Documentation updated (human-centric docs)
- ✅ Exclusions/conventions recorded if applicable
- ✅ ADR created if major decision made

## TDD Requirements

### Code and Documentation

TDD is mandatory for **all changes, including documentation**.

**Documentation TDD:**

1. Create BDD checklist of expected statements
2. Checklist must fail against current docs before edits
3. Record failure reason
4. Only after failing checklist may editing begin

**Skill TDD (RED-GREEN-REFACTOR):**

1. **RED:** Run baseline scenarios WITHOUT skill, document failures
2. **GREEN:** Write minimal skill, verify scenarios pass
3. **REFACTOR:** Close loopholes, add rationalizations, re-verify

No exceptions to TDD policy. This includes "simple" changes.

## Testing Skills

Skills must be tested with:

- **Baseline scenarios** (agent without skill) - Document natural behaviour
- **Pressure scenarios** (time, sunk cost, exhaustion) - Test under stress
- **Concrete BDD scenarios** (exact inputs/outputs) - Verify correctness
- **Rationalization identification** - Capture excuses agents use

See `superpowers:writing-skills` for complete testing methodology.

## Questions and Support

- **Documentation questions:** Check [docs/](docs/) directory
- **Skill examples:** Review existing skills in [skills/](skills/)
- **Past decisions:** See [docs/adr/](docs/adr/)
- **Exclusions:** Check [docs/exclusions.md](docs/exclusions.md)
- **Process questions:** Open discussion issue

## Repository Standards

All contributors must follow standards in:

- [README.md](README.md) - Repository standards and workflow
- [AGENTS.md](AGENTS.md) - Agent-specific execution rules
- [docs/coding-standards.md](docs/coding-standards.md) - Detailed standards

## Security

- **No secrets or API keys** in commits
- **Keep prerequisites explicit** in documentation
- **Review security implications** of automated patterns

## License

See repository LICENSE file.
