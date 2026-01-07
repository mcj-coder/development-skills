---
name: skill-design-philosophy
description: |
  Apply when designing new skills, reviewing skill implementations,
  or questioning how skills should interact with target repositories
  and who owns ongoing process decisions.
decision: Design skills to bootstrap opinionated defaults, then defer to documented decisions in target repositories.
status: accepted
---

# 1. Skill Design Philosophy

Date: 2026-01-07
Deciders: development-skills maintainers
Tags: process, skills, architecture

## Context and Problem Statement

This repository contains skills that help agents bootstrap best practices (TDD, issue-driven
workflows, documentation standards, etc.) for greenfield and brownfield projects. However,
there is ambiguity about the boundary between skill responsibility and target repository
ownership.

Key questions that arise:

- Once a process is established in a target repo, who owns it?
- Should agents constantly re-apply skills, or defer to documented decisions?
- How do agents know when a decision has been captured?
- How should skills remain platform and agent agnostic while providing opinionated defaults?

## Decision Drivers

- **Agent/platform agnostic**: Skills should work with any agent (Claude, Codex, etc.) and
  any platform (GitHub, Azure DevOps, GitLab)
- **Self-documenting target repos**: Target repositories should capture decisions so they
  become discoverable without skill knowledge
- **Reduced agent noise**: Agents shouldn't constantly re-prompt for decisions that have
  already been made
- **Composable skills**: Skills should remain independent and non-overlapping to enable
  multi-skill application
- **Reusable across projects**: Skills should provide value across many repositories without
  requiring per-project customization

## Considered Options

### Option 1: Skills Always Apply

Skills are re-evaluated every time they might be relevant, regardless of existing decisions.

**Pros:**

- Ensures latest best practices are always applied
- No risk of stale decisions

**Cons:**

- Decision fatigue from repeated prompts
- Undermines target repo autonomy
- Agents may override intentional deviations

### Option 2: Skills Bootstrap Only

Skills apply once during initial setup, then never re-apply.

**Pros:**

- Clear ownership transfer to target repo
- No repeated prompts

**Cons:**

- Prevents beneficial skill evolution from reaching existing projects
- No mechanism for intentional reconsideration
- Hard boundary creates adoption friction

### Option 3: Hybrid Bootstrap + Defer to Documented Decisions

Skills define processes with opinionated defaults. Target repos capture decisions. Agents
defer to documented decisions unless explicitly prompted to reconsider.

**Pros:**

- Clear responsibility boundary between skills and target repos
- Respects target repo autonomy while enabling skill updates
- Explicit override mechanism for intentional reconsideration
- Reduces noise while preserving flexibility

**Cons:**

- Requires discipline to capture decisions in target repos
- Initial setup requires more documentation effort
- Detection mechanism adds agent complexity

## Decision Outcome

Chosen option: **"Hybrid Bootstrap + Defer to Documented Decisions"**, because it provides
the best balance between skill guidance and target repository autonomy while maintaining
explicit override capabilities.

### The Hybrid Bootstrap Pattern

1. **Skills define process with opinionated defaults** - Skills establish best practices,
   recommended workflows, and default configurations
2. **Target repo captures decisions** - Once applied, decisions are documented in the target
   repository (ADR, playbook, AGENTS.md, or standards file)
3. **Documented decisions become "the way"** - The target repo's documentation becomes the
   source of truth for that project
4. **Agents defer to documented decisions** - Unless explicitly prompted, agents respect
   existing documented decisions

### Detection Mechanism

Agents detect existing decisions by checking these locations in the target repository:

| Location                   | Decision Types                                 |
| -------------------------- | ---------------------------------------------- |
| `docs/adr/`                | Major architectural decisions, tooling choices |
| `docs/playbooks/`          | Operational procedures with explicit triggers  |
| `AGENTS.md`                | Agent execution rules, workflow requirements   |
| `docs/coding-standards.md` | Coding practices, testing conventions          |
| `docs/ways-of-working/`    | Process documentation, team workflows          |
| `docs/exclusions.md`       | Patterns explicitly declined                   |

**What constitutes a "documented decision":**

A decision is considered documented when it explicitly answers the core question the skill
addresses. For example:

- TDD skill asks: "Do we write tests first?"
- Sufficient: "This project follows TDD with RED/GREEN/REFACTOR workflow"
- Insufficient: "We write tests" (doesn't specify when or how)

**Reference:** The existing Documentation Mapping table in `AGENTS.md` provides additional
guidance on file-to-concept mappings.

### Capture Pattern Guidance

When a skill is applied and a decision is made, capture it in the appropriate location:

| Decision Type                          | Capture Location              |
| -------------------------------------- | ----------------------------- |
| Major architecture or tooling decision | ADR in `docs/adr/`            |
| Operational procedure with triggers    | Playbook in `docs/playbooks/` |
| Agent execution rule or workflow       | `AGENTS.md`                   |
| Coding practice or convention          | `docs/coding-standards.md`    |
| Declined pattern with reason           | `docs/exclusions.md`          |

### Re-application Triggers

Agents should defer to documented decisions by default. However, these explicit phrases
override deference behavior and trigger re-application:

- "Re-apply {skill-name}"
- "Reconsider {process-name}"
- "Reset {pattern} to skill defaults"
- "Run {skill-name} again"

Without these explicit triggers, agents should respect existing documented decisions and
not re-prompt for decisions already captured.

## Consequences

### Good

- **Target repos become self-documenting** - All process decisions are captured in
  discoverable locations within the repository
- **Reduced decision fatigue** - Agents don't constantly re-prompt for known decisions
- **Skills remain reusable** - Same skill works across many projects without modification
- **Clear responsibility boundary** - Skills own "best practice guidance", repos own
  "our implementation"
- **Explicit override capability** - Intentional reconsideration is always possible

### Neutral

- **Requires discipline** - Team must consistently capture decisions when skills are applied
- **Stale decision risk** - Target repos may accumulate decisions that no longer apply;
  requires periodic review (future enhancement opportunity)

### Bad

- **Initial documentation overhead** - First-time setup requires more documentation effort
  than informal approaches
- **Detection complexity** - Agents must implement detection logic for documented decisions

## Examples

### TDD Skill Example

**Skill establishes:**

- RED/GREEN/REFACTOR workflow
- Write failing tests before implementation
- BDD checklists for documentation changes

**Target repo captures in `docs/coding-standards.md`:**

```markdown
## Test-Driven Development

This project follows TDD for all code changes:

1. **RED**: Write a failing test that defines the expected behavior
2. **GREEN**: Implement minimum code to make the test pass
3. **REFACTOR**: Clean up while keeping tests green

For documentation changes, BDD checklists serve as tests. Create a failing checklist
before making changes, verify it passes after.
```

**Agent behavior after capture:**

- Agent detects TDD decision in `docs/coding-standards.md`
- Agent follows documented TDD workflow without re-prompting for TDD adoption
- Agent only reconsiders if user says "Reconsider TDD approach"

### Issue-Driven Workflow Example

**Skill establishes:**

- All non-read-only work requires a Taskboard issue
- Traceability through commit references
- Evidence requirements at state transitions

**Target repo captures in `AGENTS.md`:**

```markdown
## Agent Execution Rules

- **No changes without a Taskboard issue.** All non-read-only work must be tied
  to a Taskboard issue before starting work. Create the issue first, then begin.
- **Read-only work** (no ticket required): Code viewing, analysis, research
- **Non-read-only work** (ticket required): File edits, commits, PRs, branches
```

**Agent behavior after capture:**

- Agent detects issue-driven rule in `AGENTS.md`
- Agent requires issue before making changes (as documented)
- Agent doesn't re-prompt about whether to use issue-driven workflow

### Platform Choice Example

**Skill defines (platform agnostic):**

- "Use a CI/CD platform for automated builds"
- Options: GitHub Actions, Azure DevOps Pipelines, GitLab CI, Jenkins

**Target repo captures in ADR:**

```yaml
---
name: use-github-actions
description: |
  Apply when configuring CI/CD pipelines or discussing build automation.
decision: Use GitHub Actions for all CI/CD pipelines.
status: accepted
---
```

**Agent behavior after capture:**

- Agent detects CI/CD decision in `docs/adr/`
- Agent configures workflows for GitHub Actions specifically
- Agent doesn't prompt about which CI/CD platform to use

## Anti-Patterns

These behaviors indicate the skill design philosophy is not being followed:

1. **Constant re-prompting** - Skill repeatedly asks about decisions already documented
   in target repo (detection mechanism not working or not implemented)

2. **Ignoring documentation** - Agent applies skill defaults despite documented decisions
   in target repo (deference pattern not implemented)

3. **Skill-specific documentation** - Creating files like `docs/conventions/tdd-skill.md`
   instead of human-centric locations like `docs/coding-standards.md` (violates
   human-centric documentation principle)

4. **Partial capture** - Documenting "we use TDD" without specifying the actual workflow,
   leaving ambiguity that causes repeated clarification requests

## Links

- [AGENTS.md Documentation Mapping](../../AGENTS.md#documentation-standards-for-agents) -
  Existing guidance on human-centric documentation locations
- [ADR-0000: Use ADRs](0000-use-adrs.md) - Establishes ADR format for this repository
