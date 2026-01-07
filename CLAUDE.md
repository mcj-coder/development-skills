# CLAUDE.md - Agent Onboarding

## Required Reading

Before ANY work in this repository, you MUST:

1. Read `README.md` completely
2. Read `AGENTS.md` completely
3. Acknowledge by stating: "I have read and understood README.md and AGENTS.md for development-skills"

**Do not proceed with any task until you have completed these steps and stated the acknowledgement.**

---

## Critical Standards (Summary)

These are non-negotiable. Full details in AGENTS.md.

### TDD is Mandatory

- ALL changes require TDD - code, config, AND documentation
- No "verify after" - write failing test/checklist FIRST
- Documentation uses BDD checklists as tests

### Issue-Driven Workflow

- No changes without a GitHub issue (read-only work exempt)
- Reference issues in commits, PRs, and comments
- Never commit directly to `main` - use feature branches

### Skills-First Execution

- Load `development-skills:skills-first-workflow` before any task
- Check for applicable skills BEFORE implementation
- Process skills (TDD, debugging) take priority over implementation skills

### Clean Build Principle

- Zero tolerance for warnings or errors
- All linting must pass before committing
- Run: `npm run lint` to verify

---

## Skill Priority Model

When skills conflict, higher priority wins:

| Priority | Category                 | Examples                             |
| -------- | ------------------------ | ------------------------------------ |
| P0       | Safety & Integrity       | Security, traceability, issue-driven |
| P1       | Quality & Correctness    | Clean builds, test validity          |
| P2       | Consistency & Governance | Conventions, versioning              |
| P3       | Delivery & Flow          | Incremental execution, DX            |

### Verification Requirements

- **Concrete changes** (code/config): Provide applied evidence (commit SHAs, file links)
- **Process-only changes**: Provide analytical evidence (issue comment links)
- Never claim "complete" without running verification commands first

### Documentation Standards

- Use human-readable terminology in `/docs`, not skill names
- Check `docs/exclusions.md` before suggesting patterns
- Use ADRs for major architectural decisions

---

## Persona-Based Task Delegation

### Available Personas

Specialized expert personas are defined in `docs/roles/*.md`:

| Category         | Personas                                                            |
| ---------------- | ------------------------------------------------------------------- |
| Development      | Tech Lead, Senior Developer, QA Engineer                            |
| Security         | Security Reviewer, Security Architect                               |
| Performance      | Performance Engineer                                                |
| Infrastructure   | DevOps Engineer, Cloud Architect                                    |
| Product & Design | Product Owner, UX Expert, Accessibility Expert                      |
| Documentation    | Documentation Specialist, Technical Architect, Agent Skill Engineer |

### Delegation Rules

1. **Use subagents for specialized tasks** - Delegate to the most appropriate persona
   to reduce context pollution in the main conversation
2. **Select the right model** for the task:
   - `opus` - Complex architectural decisions, security reviews, nuanced analysis
   - `sonnet` - General development, code review, implementation
   - `haiku` - Quick lookups, simple validations, formatting tasks
3. **Codex is available locally** - Use for parallel tasks or when local execution is preferred
4. **Load the persona** - Read the relevant `docs/roles/<persona>.md` before executing the delegated task

### Mandatory Retrospective

After EVERY persona-delegated task completes:

1. **Conduct retrospective review** covering:
   - Process compliance (Did the persona follow TDD, issue-driven workflow, skills-first?)
   - Quality of result (Does output meet the persona's standards?)
   - Identified issues or improvements

2. **Present summary to user**:
   - Task completed and outcome
   - Retrospective findings (compliance, quality, issues)

3. **If meaningful issues found**:
   - Write retrospective to `docs/retrospectives/YYYY-MM-DD-<topic>.md`
   - Create GitHub issues for corrective actions
   - Reference retrospective in issue description

### Retrospective Template

```markdown
# Retrospective: [Task Description]

**Date**: YYYY-MM-DD
**Persona**: [Role name]
**Task**: [Brief description]

## Process Compliance

- [ ] TDD followed
- [ ] Issue referenced
- [ ] Skills-first observed
- [ ] Clean build maintained

## Quality Assessment

[Assessment of output quality against persona standards]

## Issues Identified

[List any problems, with severity]

## Corrective Actions

- [ ] Issue #XX: [Description]
```

---

## Bootstrap Requirements

If Superpowers is not already installed:

1. Install Superpowers skill library first
2. Clone this repo to your agent's default skills location
3. Verify skills are discoverable before proceeding

## Quick Reference

| Resource                        | Purpose                                       |
| ------------------------------- | --------------------------------------------- |
| `README.md`                     | Repository standards, skill list, format spec |
| `AGENTS.md`                     | Complete agent execution rules (18K words)    |
| `CONTRIBUTING.md`               | Contribution process                          |
| `docs/roles/*.md`               | Expert persona definitions                    |
| `docs/architecture-overview.md` | Architectural patterns                        |
| `docs/coding-standards.md`      | Code and doc standards                        |
| `docs/testing-strategy.md`      | BDD/TDD methodology                           |
| `docs/exclusions.md`            | Patterns explicitly declined                  |
| `docs/retrospectives/`          | Task retrospective records                    |

## Quality Commands

```bash
npm run lint          # Run all linting
npm run lint:fix      # Auto-fix issues
```

---

_This file ensures agents are properly onboarded. For complete rules, always refer to AGENTS.md._
