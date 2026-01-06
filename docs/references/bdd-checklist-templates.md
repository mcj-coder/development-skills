# BDD Checklist Templates

## Overview

This document provides templates for creating BDD (Behavior-Driven Development) verification checklists.
BDD checklists serve as "tests" for documentation and process changes, following TDD principles.

## When to Use BDD Checklists

**Always use BDD checklists when:**

- Making documentation changes
- Applying process skills
- Implementing workflow changes
- Creating or modifying guidelines

**TDD Flow:**

1. **RED:** Write failing BDD checklist (assertions fail against current state)
2. **GREEN:** Implement changes until all checklist items pass
3. **REFACTOR:** Clean up and optimize (if needed)

## Verification Types

### Concrete Changes

**Definition:** Changes that modify repository files (code, configuration, documentation).

**Verification Requirement:** Must demonstrate skill was **applied in THIS repository**.

**Evidence Type:** Applied evidence with commit SHAs and file links.

### Process-Only Changes

**Definition:** Changes that guide workflow without modifying repository files.

**Verification Requirement:** Analytical verification showing process was followed.

**Evidence Type:** Analytical verification with issue comment links and decision records.

## Template 1: Concrete Changes Checklist

Use this template when implementing changes that modify repository files.

### RED Phase (Before Implementation)

```markdown
## RED: Failing Checklist (Before Implementation)

- [ ] File `path/to/file.ext` exists
- [ ] File contains section/class/function `specific-element`
- [ ] Documentation includes guidance on `specific-topic`
- [ ] Configuration enables `specific-setting`
- [ ] Code implements `specific-behavior`

**Failure Notes:**

- Current state description
- Why each assertion fails
- What's missing or incorrect
```

### GREEN Phase (After Implementation)

```markdown
## GREEN: Passing Checklist (After Implementation)

- [x] File `path/to/file.ext` exists
- [x] File contains section/class/function `specific-element`
- [x] Documentation includes guidance on `specific-topic`
- [x] Configuration enables `specific-setting`
- [x] Code implements `specific-behavior`

**Applied Evidence:**

- File created/modified: [link to commit SHA]
- Specific changes: [link to specific lines in file]
- Verification command output: [if applicable]
```

### Example 1: Adding Markdown Linting Configuration

**RED (Before):**

```markdown
## RED: Failing Checklist

- [ ] File `.markdownlint.json` exists
- [ ] Configuration sets `line-length` rule to 120
- [ ] Configuration enables `no-trailing-spaces` rule
- [ ] Configuration ignores `node_modules` directory

**Failure Notes:**

- File does not exist yet
- No markdown linting configured in repository
```

**GREEN (After):**

```markdown
## GREEN: Passing Checklist

- [x] File `.markdownlint.json` exists
- [x] Configuration sets `line-length` rule to 120
- [x] Configuration enables `no-trailing-spaces` rule
- [x] Configuration ignores `node_modules` directory

**Applied Evidence:**

- Created `.markdownlint.json`: https://github.com/org/repo/blob/a7f3c2e/.markdownlint.json
- Commit SHA: a7f3c2e
- Linting now enforced in pre-commit hook: https://github.com/org/repo/blob/a7f3c2e/.husky/pre-commit
```

### Example 2: Updating Documentation Guidelines

**RED (Before):**

```markdown
## RED: Failing Checklist

- [ ] CONTRIBUTING.md includes "Documentation Standards" section
- [ ] Section explains when to create ADRs
- [ ] Section explains exclusions.md usage
- [ ] Section references human-centric terminology requirement

**Failure Notes:**

- CONTRIBUTING.md exists but missing documentation standards section
- No guidance on ADR vs exclusions distinction
- Skill-name usage not addressed
```

**GREEN (After):**

```markdown
## GREEN: Passing Checklist

- [x] CONTRIBUTING.md includes "Documentation Standards" section
- [x] Section explains when to create ADRs
- [x] Section explains exclusions.md usage
- [x] Section references human-centric terminology requirement

**Applied Evidence:**

- Updated CONTRIBUTING.md: https://github.com/org/repo/blob/b8e4d3f/CONTRIBUTING.md#L45-L67
- Commit SHA: b8e4d3f
- Documentation Standards section added: lines 45-67
```

## Template 2: Process-Only Checklist

Use this template when applying process skills that don't modify repository files.

### RED Phase (Before Application)

```markdown
## RED: Failing Checklist (Before Application)

- [ ] Requirements clarified in issue comments
- [ ] Alternative approaches considered
- [ ] Decision documented with rationale
- [ ] Stakeholders notified
- [ ] Next steps identified

**Failure Notes:**

- Issue lacks clarifying questions
- No discussion of alternatives
- Decision not yet made
```

### GREEN Phase (After Application)

```markdown
## GREEN: Passing Checklist (After Application)

- [x] Requirements clarified in issue comments
- [x] Alternative approaches considered
- [x] Decision documented with rationale
- [x] Stakeholders notified
- [x] Next steps identified

**Analytical Evidence:**

- Requirements clarified: [issue comment link]
- Alternatives discussed: [issue comment link]
- Decision recorded: [issue comment link]
- Notification sent: [issue comment link]
- Next steps: [issue comment link]

**Process Verification:**

This is analytical verification (process-only). No repository files modified.
Skill applied through issue discussion and decision-making process.
```

### Example 3: Brainstorming for Feature Design

**RED (Before):**

```markdown
## RED: Failing Checklist

- [ ] Feature requirements captured in issue
- [ ] User stories identified
- [ ] Alternative designs explored
- [ ] Technical constraints documented
- [ ] Recommendation provided

**Failure Notes:**

- Issue contains feature request but lacks detail
- No exploration of alternatives yet
- Technical constraints not discussed
```

**GREEN (After):**

```markdown
## GREEN: Passing Checklist

- [x] Feature requirements captured in issue
- [x] User stories identified
- [x] Alternative designs explored
- [x] Technical constraints documented
- [x] Recommendation provided

**Analytical Evidence:**

- Requirements captured: https://github.com/org/repo/issues/123#issuecomment-456
- User stories: https://github.com/org/repo/issues/123#issuecomment-457
- Design alternatives: https://github.com/org/repo/issues/123#issuecomment-458
- Constraints: https://github.com/org/repo/issues/123#issuecomment-459
- Recommendation: https://github.com/org/repo/issues/123#issuecomment-460

**Process Verification:**

This is analytical verification (process-only). Brainstorming skill applied
through structured discussion in issue comments. No code or documentation
changes required at this phase.
```

### Example 4: Code Review Process Application

**RED (Before):**

```markdown
## RED: Failing Checklist

- [ ] PR reviewed for correctness
- [ ] Architecture alignment verified
- [ ] Security concerns identified
- [ ] Performance considerations noted
- [ ] Review feedback provided in PR comments

**Failure Notes:**

- PR not yet reviewed
- No review comments posted
```

**GREEN (After):**

```markdown
## GREEN: Passing Checklist

- [x] PR reviewed for correctness
- [x] Architecture alignment verified
- [x] Security concerns identified
- [x] Performance considerations noted
- [x] Review feedback provided in PR comments

**Analytical Evidence:**

- Correctness review: https://github.com/org/repo/pull/45#discussion_r123
- Architecture check: https://github.com/org/repo/pull/45#discussion_r124
- Security analysis: https://github.com/org/repo/pull/45#discussion_r125
- Performance notes: https://github.com/org/repo/pull/45#discussion_r126

**Process Verification:**

This is analytical verification (process-only). Code review skill applied
through PR comment thread. Repository changes are in the PR being reviewed,
not from the review process itself.
```

## Choosing the Right Template

### Use Concrete Changes Template When

- Creating or modifying code files
- Adding or changing configuration files
- Writing or updating documentation
- Modifying build scripts or CI/CD workflows
- Changing schema or database migrations
- Adding or updating test files

**Key Indicator:** Can you point to a commit SHA showing the change?

### Use Process-Only Template When

- Conducting brainstorming sessions
- Performing code reviews
- Gathering requirements
- Making decisions in issue discussions
- Planning without implementation
- Analyzing existing code

**Key Indicator:** Does the work happen in issue/PR comments without modifying repository files?

## Common Patterns

### Pattern 1: Skill Application Chain

Some work involves both process-only and concrete phases:

1. **Process-Only:** Brainstorm feature design (analytical verification)
2. **Concrete:** Implement feature (applied evidence with commits)
3. **Process-Only:** Code review (analytical verification)

Use appropriate template for each phase.

### Pattern 2: Documentation of Process Decisions

When a process decision results in documentation:

1. **Process-Only:** Discuss and decide in issue (analytical verification)
2. **Concrete:** Document decision in ADR or exclusions.md (applied evidence)

First phase uses process-only template, second phase uses concrete template.

### Pattern 3: Multi-File Changes

For changes spanning multiple files:

```markdown
## RED: Failing Checklist

- [ ] File 1 exists with content X
- [ ] File 2 exists with content Y
- [ ] File 3 references File 1 correctly
- [ ] All files follow naming convention
```

Single checklist can cover multiple files if they're part of one logical change.

## Best Practices

### Writing Effective Checklists

1. **Be Specific:** "File contains X" not "File updated"
2. **Be Testable:** Assertions must be verifiable by inspection
3. **Be Complete:** Cover all acceptance criteria
4. **Be Atomic:** Each item should be independently verifiable

### RED Phase Requirements

1. **Must fail against current state:** Verify checklist actually fails
2. **Document why:** Failure notes explain current state
3. **Commit before changes:** RED checklist committed before implementation

### GREEN Phase Requirements

1. **Must pass after changes:** Verify checklist actually passes
2. **Include evidence:** Links to commits, files, or comments
3. **State verification type:** Applied evidence or analytical verification

### Evidence Quality

**Good Evidence:**

- Immutable commit SHA links
- Specific file locations (line numbers)
- Direct issue comment links
- Command output (if applicable)

**Poor Evidence:**

- "Updated the file" (no link)
- "Fixed it" (no specifics)
- Branch name links (mutable)
- "Everything works" (not verifiable)

## Integration with TDD Workflow

### For Code Changes

1. Write failing test (traditional TDD)
2. Write failing BDD checklist (documentation/integration TDD)
3. Implement code
4. Verify tests pass
5. Verify BDD checklist passes
6. Commit with evidence

### For Documentation Changes

1. Write failing BDD checklist
2. Verify checklist fails
3. Update documentation
4. Verify checklist passes
5. Commit with evidence

### For Process Application

1. Write failing BDD checklist
2. Apply process skill (issue discussions, reviews)
3. Verify checklist passes
4. Document analytical evidence
5. Record process verification note

## Troubleshooting

### "I'm not sure if this is concrete or process-only"

Ask: "Will this work modify files in the repository?"

- Yes → Concrete changes template
- No → Process-only template

### "My change is both concrete and process"

Create separate checklists for each phase:

- `task-name-brainstorm-bdd.md` (process-only)
- `task-name-implementation-bdd.md` (concrete)

### "The checklist is too long"

Break into multiple tasks if checklist exceeds ~10 items. Each task gets its own checklist.

### "How detailed should failure notes be?"

Enough to explain why each assertion fails. One sentence per failing item is usually sufficient.

## References

- TDD principles: README.md "TDD Behaviour" section
- Applied evidence requirement: AGENTS.md line 12-15
- Issue-driven workflow: skills/issue-driven-delivery/SKILL.md
- Verification before completion: superpowers:verification-before-completion
