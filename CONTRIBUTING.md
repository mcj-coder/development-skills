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

### PR Evidence Requirements

**All test plan items must include evidence links.** This is enforced by DangerJS and will block
merge if not satisfied.

**Required format:**

```markdown
- [x] Feature implemented ([file.ts:L15-L30](https://github.com/.../files#diff-...))
- [x] Tests pass ([CI check](https://github.com/.../actions/runs/.../job/...))
- [x] Linting passes ([CI run](https://github.com/.../actions/runs/...))
```

**Evidence link types:**

| Type           | Format                | Example                          |
| -------------- | --------------------- | -------------------------------- |
| File reference | `([path:lines](url))` | `([src/api.ts:L10-L20](link))`   |
| CI run         | `([CI check](url))`   | `([CI check](actions/runs/123))` |
| Commit         | `([commit](url))`     | `([abc123](commit/abc123))`      |

**Resources:**

- PR template: `.github/PULL_REQUEST_TEMPLATE.md`
- Exemplar PR with proper evidence: [#263](https://github.com/mcj-coder/development-skills/pull/263)

### Code Review Guidelines

**Substantive reviews required.** Empty "LGTM" approvals are flagged by DangerJS. Reviews must
include meaningful feedback (minimum 50 characters).

**What to include in review comments:**

- Files reviewed and verified
- Potential issues checked (edge cases, security, performance)
- Specific observations (positive or constructive)
- Questions or concerns that were resolved

**Exemplar review format:**

```text
Reviewed [files]. Verified:
- [Specific check 1]
- [Specific check 2]

[Any observations or minor suggestions]

Approved - no blocking issues found.
```

**Exemplar review:**

> Reviewed dangerfile.js and CONTRIBUTING.md. Verified the review depth check
> logic is correct and MIN_REVIEW_BODY_LENGTH of 50 chars is reasonable.
> Checked regex patterns for potential edge cases - none found.
> Documentation clearly explains the new requirement. Approved.

### Quality Gates

Before submitting PR:

- ✅ Zero warnings or errors (clean build principle)
- ✅ All tests pass (BDD checklists verified)
- ✅ Documentation updated (human-centric docs)
- ✅ Exclusions/conventions recorded if applicable
- ✅ ADR created if major decision made

### Pre-Merge Checklist

Before completing a merge, verify ALL of the following:

**Review Completion:**

- [ ] All reviewer comment threads resolved (marked as resolved in GitHub UI)
- [ ] Reviewer feedback addressed with code changes or explanations
- [ ] Re-review requested if significant changes made after initial review

**Test Plan Verification:**

- [ ] Test plan checkboxes in PR body updated with completion evidence
- [ ] Each test item marked complete with evidence (commit SHA, file path, or output)
- [ ] No unchecked test plan items remain

**Final Verification:**

- [ ] `npm run lint` passes with 0 errors, 0 warnings
- [ ] All CI checks pass (if configured)
- [ ] Branch is up-to-date with target branch

**Documentation:**

- [ ] Commit message follows Conventional Commits format
- [ ] Issue reference included in commit message footer
- [ ] PR description accurately reflects final changes

Failing to complete this checklist before merge creates process gaps that require retrospective
corrective actions.

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

### TDD Commit Sequencing

Test files MUST be committed separately from implementation files to demonstrate TDD compliance.

**Required sequence:**

1. **Commit 1 (Test First):** Create test file with RED/GREEN/PRESSURE scenarios
   - Test file documents expected behavior before implementation exists
   - Commit message: `test: add BDD scenarios for {feature}`

2. **Commit 2 (Implementation):** Create implementation that makes tests pass
   - Implementation addresses the scenarios defined in test file
   - Commit message: `feat: implement {feature}`

**Why this matters:**

- Demonstrates actual TDD workflow (test → implement)
- Creates audit trail of test-first approach
- Prevents "write tests after" anti-pattern

**Anti-pattern to avoid:**

```text
# WRONG: Single commit with both files
git add tests/feature.test.md src/feature.md
git commit -m "feat: add feature with tests"

# CORRECT: Separate commits
git add tests/feature.test.md
git commit -m "test: add BDD scenarios for feature"
git add src/feature.md
git commit -m "feat: implement feature"
```

## Testing Skills

Skills must be tested with:

- **Baseline scenarios** (agent without skill) - Document natural behaviour
- **Pressure scenarios** (time, sunk cost, exhaustion) - Test under stress
- **Concrete BDD scenarios** (exact inputs/outputs) - Verify correctness
- **Rationalization identification** - Capture excuses agents use

See `superpowers:writing-skills` for complete testing methodology.

### Test Execution Evidence

Tests must include evidence of execution, not just existence. Document test results.

**Required evidence:**

1. **For BDD scenario tests:**
   - Mark each scenario checkbox as complete when verified
   - Include evidence inline (commit SHA, file path, or command output)
   - Example: `- [x] GREEN-1: Router recommends requirements-gathering (verified in SKILL.md:35-43)`

2. **For lint/build verification:**
   - Include actual command output in PR or issue comments
   - Example: `npm run lint` output showing "0 errors, 0 warnings"

3. **For integration tests:**
   - Document which test cases passed
   - Include test execution output or summary

**Evidence format examples:**

```markdown
## Test Execution Evidence

### BDD Scenarios

- [x] GREEN-1: Verified in commit abc123
- [x] GREEN-2: Verified - see output below
- [x] PRESSURE-1: Verified with edge case input

### Lint Verification

npm run lint output:
All matched files use Prettier code style!
Summary: 0 error(s)
```

**Why this matters:**

- Proves tests were actually run, not just written
- Creates audit trail for quality verification
- Enables future reference to confirm what was tested

## Retrospective Workflow

Retrospectives follow the same PR workflow as all other changes. No exceptions.

### Requirements

1. **Always use feature branch + PR** for retrospective documents
   - Never commit retrospectives directly to `main`
   - Never use `--admin` flag to bypass branch protection

2. **Branch naming:** `docs/retrospective-{issue-number}` or `docs/retrospective-{date}-{topic}`

3. **PR process:**
   - Create PR with retrospective document
   - Request review if significant issues identified
   - Follow pre-merge checklist before completing

### Corrective Actions

When retrospectives identify issues requiring action:

1. **Create GitHub issues** for each corrective action
   - Reference the retrospective document in issue description
   - Assign appropriate priority and labels

2. **Update retrospective** with issue references
   - Format: `- [ ] **Status**: PENDING - Tracked in #XXX`

3. **Do not mark actions complete** until evidence exists
   - Evidence: Commit SHA, PR number, or file path
   - Format when complete: `- [x] **Status**: COMPLETE - Resolved in #XXX`

### Anti-Patterns

**Wrong:**

```text
# Direct commit to main (bypasses review)
git checkout main
git add docs/retrospectives/retro.md
git commit -m "docs: add retrospective"
```

**Correct:**

```text
# Feature branch + PR workflow
git checkout -b docs/retrospective-140
git add docs/retrospectives/retro.md
git commit -m "docs: add retrospective for #140"
git push -u origin docs/retrospective-140
gh pr create --title "docs: retrospective for #140"
```

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
