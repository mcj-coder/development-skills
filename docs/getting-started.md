# Getting Started

This guide helps you get started with the development-skills repository, whether you're creating skills,
contributing documentation, or using skills with your agent system.

## What is This Repository?

This repository hosts **skill specifications** that integrate with the Superpowers skills system. Skills
are agent-facing documentation that helps AI agents apply proven techniques, patterns, and processes.

**Purpose:**

- Backlog and specification of new skills
- Documentation and guidance for Superpowers-compatible skills
- Record decisions without duplicating upstream skills

**Not a code repository:** This is primarily documentation and specifications.

## Prerequisites

### Required

- **Git:** For version control and collaboration
- **GitHub account:** For issues, PRs, and collaboration
- **Text editor:** Any markdown-capable editor (VS Code, Vim, etc.)
- **Basic markdown knowledge:** All documentation is markdown

### For Using Skills with Agents

- **Superpowers:** <https://github.com/obra/superpowers>
- **Node.js:** For running Superpowers bootstrap
- **Agent system:** Claude Code, Codex, or compatible system

### For Creating Skills

- **Understanding of agentskills.io spec:** <https://agentskills.io/specification>
- **Familiarity with TDD:** RED-GREEN-REFACTOR methodology
- **Agent access:** For baseline and verification testing

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/mcj-coder/development-skills.git
cd development-skills
```

### 2. Read the Documentation

**Start here:**

- [README.md](../README.md) - Repository overview and standards
- [CONTRIBUTING.md](../CONTRIBUTING.md) - How to contribute
- [docs/architecture-overview.md](architecture-overview.md) - Architecture and structure

**Then review:**

- [docs/coding-standards.md](coding-standards.md) - Standards and conventions
- [docs/testing-strategy.md](testing-strategy.md) - How skills are tested
- [docs/exclusions.md](exclusions.md) - What's been opted out

### 3. Check the Taskboard

All work is tracked via GitHub issues:

- **Taskboard:** <https://github.com/mcj-coder/development-skills/issues>
- Review open issues before starting new work
- Create issue for new skills or significant changes

### 4. Explore Existing Skills

Browse the `skills/` directory to see examples:

```bash
ls skills/
cat skills/github-issue-driven-delivery/SKILL.md
cat skills/agent-workitem-automation/SKILL.md
```

## Repository Structure

```text
development-skills/
├── README.md                    # Overview and quick reference
├── AGENTS.md                    # Agent-specific rules
├── CONTRIBUTING.md              # How to contribute
├── docs/                        # Human-readable documentation
│   ├── adr/                     # Architecture Decision Records
│   ├── exclusions.md            # Opted-out patterns
│   ├── architecture-overview.md # Architecture and structure
│   ├── coding-standards.md      # Standards and conventions
│   ├── testing-strategy.md      # Testing approach
│   └── getting-started.md       # This file
├── skills/                      # Agent-facing skill specifications
│   └── {skill-name}/
│       ├── SKILL.md             # Main specification
│       └── references/          # Optional heavy reference
└── .github/
    └── ISSUE_TEMPLATE/          # Issue templates
        └── skill-spec.md        # Skill specification template
```

## Common Tasks

### Creating a New Skill

1. **Create issue** using `.github/ISSUE_TEMPLATE/skill-spec.md`:

   ```bash
   # Via GitHub UI or gh CLI
   gh issue create --template skill-spec.md
   ```

2. **Follow RED-GREEN-REFACTOR:**
   - **RED:** Run baseline tests WITHOUT skill, document failures
   - **GREEN:** Write minimal skill, verify it works
   - **REFACTOR:** Close loopholes, add rationalizations

3. **Create skill directory:**

   ```bash
   mkdir -p skills/my-new-skill
   ```

4. **Write SKILL.md** following agentskills.io specification

5. **Document in human terms:**
   - Update `docs/architecture-overview.md` if architectural pattern
   - Update `docs/coding-standards.md` if coding convention
   - Update `docs/testing-strategy.md` if testing approach

6. **Submit PR** following branching strategy

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed process.

### Updating Documentation

1. **Create BDD checklist** of expected changes

2. **Verify checklist fails** against current docs

3. **Make changes** to satisfy checklist

4. **Verify checklist passes**

5. **Submit PR**

**Important:** TDD applies to documentation. No edits without failing checklist first.

### Recording an Opt-Out

When you decline a pattern/practice:

1. **Update `docs/exclusions.md`:**

   ```markdown
   ### Pattern Name (Human-Readable)

   - **Agent Skill:** `skill-name`
   - **Description:** What pattern is being excluded
   - **Status:** Excluded
   - **Reason:** Why it doesn't apply
   - **Date:** YYYY-MM-DD
   - **Scope:** Project-wide | Component-specific | Temporary
   ```

2. **Submit PR** with clear rationale

3. **Agents will check this file** before re-prompting

### Creating an ADR

For major decisions (framework choices, architectural changes):

1. **Copy ADR template:**

   ```bash
   cp docs/adr/0000-use-adrs.md docs/adr/NNNN-my-decision.md
   ```

2. **Fill in sections:**
   - Context and Problem Statement
   - Decision Drivers
   - Considered Options
   - Decision Outcome
   - Consequences

3. **Submit PR**

See [docs/adr/0000-use-adrs.md](adr/0000-use-adrs.md) for guidelines.

## Branching Strategy

### Creating a Feature Branch

```bash
# Ensure you're on main and up to date
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/issue-42-add-new-skill
```

### Creating Sub-Task Branch

```bash
# From feature branch
git checkout feature/issue-42-add-new-skill
git checkout -b feature/issue-42-subtask-baseline-tests
```

### Before Committing

**Checklist:**

- [ ] Zero warnings or errors (clean build)
- [ ] All BDD checklists pass
- [ ] Documentation updated
- [ ] Conventional Commit message ready

### Submitting PR

```bash
# Rebase on latest main
git checkout main
git pull origin main
git checkout feature/issue-42-add-new-skill
git rebase main

# Push and create PR
git push origin feature/issue-42-add-new-skill
gh pr create --title "feat: add new-skill specification" --body "..."
```

## Using Skills with Agents

### Bootstrap Superpowers

**Windows (PowerShell):**

```powershell
node $env:USERPROFILE\.codex\superpowers\.codex\superpowers-codex bootstrap
```

**Unix/Linux/Mac:**

```bash
node ~/.codex/superpowers/.codex/superpowers-codex bootstrap
```

### Load Skills

**Via Codex:**

```bash
node ~/.codex/superpowers/.codex/superpowers-codex use-skill skill-name
```

**Via Claude Code:**
Skills are loaded automatically based on context and triggers.

### Check for Exclusions

Before suggesting patterns, agents should:

```bash
# Check if pattern is excluded
grep -i "pattern-name" docs/exclusions.md
```

## Standards to Follow

### Clean Build Principle

**Zero tolerance for warnings:**

- No unresolved warnings in commits
- No errors in git operations
- Linting and static analysis must pass

**Before every commit:**

```bash
# Verify no warnings (conceptual - adapt to your tooling)
# For markdown, check with linter:
# markdownlint docs/**/*.md
```

### TDD for Everything

**Including documentation:**

1. Create failing checklist
2. Make changes
3. Verify checklist passes

**No "verify after" changes allowed.**

### Conventional Commits

```text
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Getting Help

### Documentation

- **Architecture questions:** [docs/architecture-overview.md](architecture-overview.md)
- **Standards questions:** [docs/coding-standards.md](coding-standards.md)
- **Testing questions:** [docs/testing-strategy.md](testing-strategy.md)
- **Process questions:** [CONTRIBUTING.md](../CONTRIBUTING.md)

### Examples

- Browse `skills/` directory for skill examples
- Review `docs/adr/` for decision examples
- Check closed issues for implementation examples

### Questions

- **Open discussion issue** for clarification questions
- **Check existing issues** for similar questions
- **Review ADRs** for context on past decisions

## Common Mistakes to Avoid

### For Skill Creation

- ❌ Writing skill before baseline testing (RED phase)
- ❌ Using abstract BDD scenarios instead of concrete examples
- ❌ Skipping pressure scenarios
- ❌ Not capturing rationalizations verbatim
- ❌ Creating skill-specific documentation (use human-centric docs)

### For Documentation

- ❌ Editing without failing BDD checklist first
- ❌ Using skill names in human documentation
- ❌ Creating scattered files instead of aggregating
- ❌ Leaving warnings unresolved

### For Git Workflow

- ❌ Committing directly to `main`
- ❌ Non-conventional commit messages
- ❌ Pushing without rebasing on main
- ❌ Skipping quality checks

## Next Steps

1. **Read repository standards:** [README.md](../README.md)
2. **Review contribution process:** [CONTRIBUTING.md](../CONTRIBUTING.md)
3. **Explore existing skills:** `skills/` directory
4. **Check taskboard:** <https://github.com/mcj-coder/development-skills/issues>
5. **Pick an issue or create one**
6. **Follow the process**

## See Also

- [README.md](../README.md) - Repository overview
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Detailed contribution guide
- [AGENTS.md](../AGENTS.md) - Agent-specific rules
- [docs/architecture-overview.md](architecture-overview.md) - Architecture
- [docs/coding-standards.md](coding-standards.md) - Standards
- [docs/testing-strategy.md](testing-strategy.md) - Testing
