# Coding Standards

This document defines the coding standards, conventions, and quality requirements for this repository.

## File Naming and Structure

### Naming Conventions

- **Directories and files:** kebab-case (e.g., `skill-creator/`, `writing-skills/`)
- **Skill names:** letters, numbers, and hyphens only (no parentheses, special characters)
- **Documentation files:** Descriptive names with `.md` extension

### File Organization

- **One concept per file:** Keep files small and focused
- **Skill structure:**

  ```text
  skills/
    skill-name/
      SKILL.md              # Main specification (required)
      references/           # Heavy reference material (optional)
      supporting-file.*     # Tools, examples (only if needed)
  ```

- **Documentation structure:**

  ```text
  docs/
    *.md                    # Human-readable topic docs
    adr/                    # Architecture Decision Records
  ```

### Progressive Loading

Skills must support progressive loading:

- **Main SKILL.md:** <300 words for frequently-loaded skills, <500 for others
- **Heavy content:** Move to `references/` subdirectory
- **Cross-references:** Link to existing skills instead of duplicating

## Documentation Standards

### Markdown

- **Formatting:** Use `.editorconfig` settings
- **Line length:** Soft wrap acceptable, prioritize readability
- **Headings:** Use ATX style (`#`, `##`, etc.)
- **Lists:** Consistent bullet/numbering style
- **Code blocks:** Always specify language for syntax highlighting

### Skill Specifications

Skills must follow [agentskills.io specification](https://agentskills.io/specification):

**Required YAML frontmatter:**

```yaml
---
name: skill-name-with-hyphens # Only letters, numbers, hyphens
description: Use when {triggering conditions ONLY - third person, <500 chars}
---
```

**Description rules (Critical for Claude Search Optimization):**

- Start with "Use when..." to focus on triggering conditions
- Include specific symptoms, situations, and contexts
- **NEVER summarize the skill's process or workflow** (agents may follow description instead of reading full skill)
- Keep under 500 characters if possible
- Third person voice

**Required sections:**

- Overview (what is this, core principle)
- When to Use (triggers and symptoms)
- Core Pattern or Implementation
- Quick Reference (table or list)
- Common Mistakes
- Evidence/verification requirements

**Optional but recommended:**

- Red Flags list (for discipline skills)
- Rationalizations table (for discipline skills)
- Real-World Impact examples

### Human-Centric Documentation

When updating documentation as result of applying skills:

- **Use human terminology:** "Clean Architecture", not "architecture-testing"
- **Update appropriate doc:** `architecture-overview.md`, `coding-standards.md`, `testing-strategy.md`
- **Don't create skill-specific files:** No `conventions/architecture-testing.md`
- **Aggregate related info:** Group by topic, not by skill

## Code Quality Requirements

### Clean Build Principle

**CRITICAL:** Zero warnings or errors when committing changes.

**During development:**

- No unresolved warnings in git commits or package operations
- Warnings must be resolved immediately, not deferred
- Failed quality checks block commits

**Before committing:**

- Linting passes cleanly
- Static analysis passes cleanly
- All tests pass (BDD checklists verified)
- Documentation updated and consistent

### Warning and Error Remediation (2x Rule)

**Objective threshold for fixing vs documenting issues:**

When warnings, errors, or standards violations occur:

1. **Investigate root cause** (don't just ignore or suppress)
2. **Estimate fix time** vs remaining work time
3. **Apply 2x threshold:**
   - If fix time < 2x remaining work → Fix immediately
   - If fix time ≥ 2x remaining work → Document in `docs/known-issues.md` with justification
4. **Verify resolution** (warning gone or properly documented)

**Example:** Remaining work = 30 minutes. Fix takes 15 minutes. Ratio = 0.5x. **Fix immediately.**

**Common rationalizations to reject:**

- "It's just a warning, not an error" → Warnings indicate problems
- "This is normal behaviour" → Normal warnings still indicate configuration issues
- "Can fix it later" → "Later" rarely happens; fix unless >2x impact
- "No time now" → Must calculate 2x ratio first, not subjective
- "That's scope creep" → Fixing issues is part of the work

**Documentation requirement:**

- **Fixed issues:** Update this file with configuration/pattern applied
- **Deferred issues (>2x threshold):** Create tech-debt issue with:
  - Issue description and impact
  - Fix time estimate showing >2x threshold exceeded
  - Steps to replicate
  - Priority and timeline for resolution
  - Label: `tech-debt`
- **Explicitly approved exclusions:** Document in `docs/known-issues.md` ONLY if:
  - User/stakeholder explicitly approved not fixing
  - Justification for permanent exclusion documented
  - Regular issues should be tickets, not known-issues entries

### Pre-Completion Review Checklist

Before declaring work complete, verify against repository standards:

1. **Code quality:** Tests exist, documentation updated, follows patterns
2. **Linting:** No warnings or errors
3. **Standards:** Matches conventions in README, CONTRIBUTING, this file
4. **Repository:** Feature branch used, issue updated, PR created if required
5. **Apply 2x rule** to any violations found
6. **Fix or document** each issue
7. **Then** declare complete

### Test-Driven Development

TDD is mandatory for all changes, including documentation.

**For features/bug fixes:**

1. Write failing test first
2. Write minimal code to pass test
3. Refactor while keeping tests green
4. No code without failing test first

**For documentation:**

1. Create BDD checklist of expected statements
2. Verify checklist fails against current docs
3. Record failure reason (missing section, incorrect wording)
4. Edit documentation to make checklist pass
5. No documentation edits without failing checklist first

**No "verify after" changes:** Tests/checklists must fail before implementation.

### Skill Development Standards

**RED-GREEN-REFACTOR methodology:**

1. **RED Phase - Baseline Testing:**
   - Run scenarios WITHOUT skill present
   - Document agent behaviour verbatim
   - Identify rationalizations and failure patterns
   - 3+ pressure scenarios (time, sunk cost, exhaustion combinations)

2. **GREEN Phase - Minimal Implementation:**
   - Write skill addressing specific baseline failures
   - Verify concrete BDD scenarios pass
   - Include exact expected inputs/outputs

3. **REFACTOR Phase - Close Loopholes:**
   - Identify new rationalizations
   - Add explicit counters
   - Build rationalizations table
   - Create red flags list
   - Re-verify under pressure

**Iron Law:** No skill without failing test first. No exceptions.

## Git Conventions

### Branching Strategy

**GitHub Flow:**

- Feature branches from `main`: `feature/issue-{number}-{brief-description}`
- Sub-task branches from feature: `feature/issue-{number}-subtask-{description}`
- Never commit directly to `main`
- Delete branches after merge

### Commit Messages

**Conventional Commits format:**

```text
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring (no behaviour change)
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```text
feat(skills): add architecture-testing skill spec

Add skill for automated architecture boundary enforcement
following RED-GREEN-REFACTOR methodology.

Refs: #1
```

```text
docs: update coding standards with TDD requirements

Add explicit TDD requirements for documentation changes
and skill development process.

Refs: #42
```

### Merge Strategy

**Before merging:**

1. Rebase on latest `main`
2. Resolve all conflicts
3. Verify clean build
4. Ensure all checks pass

**Merge approach:**

- **Squash and merge:** If excessive commits for scope
- **Fast-forward only:** Otherwise (preferred for clean history)

**Squash commit messages:**

- Must be Conventional Commits format
- Concise description of PR changes
- Include ticket reference in footer: `Refs: #123`

## Security Standards

### Secrets Management

- **Never commit secrets** or API keys
- Use environment variables for sensitive config
- Add sensitive files to `.gitignore`
- Review PRs for accidental secrets

### Prerequisites Documentation

- **Keep prerequisites explicit:** List all required tools, access, credentials
- Document where to obtain access
- Specify version requirements

## DRY Principle (Don't Repeat Yourself)

### Cross-Referencing Skills

Instead of duplicating content, cross-reference:

```markdown
**REQUIRED SUB-SKILL:** superpowers:test-driven-development
**REQUIRED SUB-SKILL:** superpowers:verification-before-completion

For detailed TDD methodology, see superpowers:test-driven-development.
```

### Documentation Cross-References

Link to existing documentation instead of repeating:

- ✅ "See [architecture-overview.md](architecture-overview.md) for architectural patterns"
- ❌ Copying architecture patterns into multiple files

### Token Efficiency

**Frequently-loaded content must be concise:**

- Getting-started workflows: <150 words each
- Frequently-loaded skills: <200 words total
- Other skills: <500 words

**Techniques:**

- Move heavy details to `references/` subdirectory
- Cross-reference existing skills/docs
- Compress examples (remove verbosity)
- Eliminate redundancy

## Naming Conventions

### Active Voice, Verb-First

**For skills and processes:**

- ✅ `creating-skills` (not `skill-creation`)
- ✅ `condition-based-waiting` (not `async-test-helpers`)
- ✅ `using-git-worktrees` (not `git-worktree-usage`)

**Gerunds (-ing) for processes:**

- `testing-skills`, `debugging-with-logs`, `writing-plans`
- Active voice describes the action being taken

### Descriptive and Searchable

**Use words users would search for:**

- Error messages: "Hook timed out", "ENOTEMPTY"
- Symptoms: "flaky", "hanging", "zombie"
- Tools: Actual command names, library names
- Patterns: Industry-standard terminology

## Code Examples

### Quality Over Quantity

**One excellent example beats many mediocre ones.**

**Good examples are:**

- Complete and runnable (no placeholders)
- Well-commented explaining WHY (not just what)
- From real scenarios (not contrived)
- Show pattern clearly
- Ready to adapt (concrete, not generic template)

**Don't:**

- Implement in 5+ languages
- Create fill-in-the-blank templates
- Write contrived toy examples
- Add examples that don't demonstrate the core pattern

### Language Choice

Choose most relevant language for the domain:

- Testing techniques → TypeScript/JavaScript
- System debugging → Shell/Python
- Data processing → Python
- .NET patterns → C#

## Flowchart Usage

**Use flowcharts ONLY for:**

- Non-obvious decision points
- Process loops where agents might stop too early
- "When to use A vs B" decisions

**Never use flowcharts for:**

- Reference material (use tables, lists)
- Code examples (use markdown blocks)
- Linear instructions (use numbered lists)
- Labels without semantic meaning (`step1`, `helper2`)

**Format:** Graphviz DOT notation

## See Also

- [docs/architecture-overview.md](architecture-overview.md) - Architectural patterns and structure
- [docs/testing-strategy.md](testing-strategy.md) - Testing approach
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution process
- [README.md](../README.md) - Repository standards overview
- [AGENTS.md](../AGENTS.md) - Agent-specific rules
