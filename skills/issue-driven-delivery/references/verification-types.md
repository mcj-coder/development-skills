# Verification Types

## Overview

All work requires verification before claiming completion. The type of verification
depends on whether the work modifies repository files.

## Concrete Changes

**Definition:** Changes that modify repository files (code, configuration, documentation).

**Verification Requirement:** Must demonstrate skill was **applied in THIS repository**.

**Evidence Type:** Applied evidence with commit SHAs and file links.

**Example:**

```text
TDD skill applied:
- Failing test: https://github.com/org/repo/blob/a1b2c3d/tests/feature.test.ts
- Implementation: https://github.com/org/repo/blob/d4e5f6g/src/feature.ts
- Passing test: verified via `npm test` output
```

### Concrete Changes Checklist

```markdown
## Verification Checklist (Concrete Changes)

- [ ] Change committed to repository
- [ ] Commit SHA recorded as evidence
- [ ] File links point to specific lines/sections
- [ ] Verification command output included (if applicable)
- [ ] All assertions verifiable by inspection
```

## Process-Only Changes

**Definition:** Changes that guide workflow without modifying repository files.

**Verification Requirement:** Analytical verification showing process was followed.

**Evidence Type:** Analytical verification with issue comment links and decision records.

**Must state:** "This is analytical verification (process-only)"

**Example:**

```text
Brainstorming skill applied:
- Requirements clarified: https://github.com/org/repo/issues/123#issuecomment-456
- Alternatives discussed: https://github.com/org/repo/issues/123#issuecomment-457
- Decision recorded: https://github.com/org/repo/issues/123#issuecomment-458

This is analytical verification (process-only).
```

### Process-Only Checklist

```markdown
## Verification Checklist (Process-Only)

- [ ] Process followed as documented
- [ ] Issue/PR comment links provided as evidence
- [ ] Decision records captured in issue thread
- [ ] "This is analytical verification (process-only)" stated
- [ ] Next steps identified (if applicable)
```

## How to Determine Verification Type

Ask: "Did this work modify files in the repository?"

| Answer | Verification Type | Evidence Required                     |
| ------ | ----------------- | ------------------------------------- |
| Yes    | Concrete changes  | Commit SHAs, file links               |
| No     | Process-only      | Issue comment links, decision records |

## Mixed Work

Some work involves both types:

1. **Process-Only:** Brainstorm design → analytical verification
2. **Concrete:** Implement code → applied evidence with commits
3. **Process-Only:** Code review → analytical verification

Use appropriate verification for each phase.

## Evidence Quality

### Good Evidence

- Immutable commit SHA links
- Specific file locations (line numbers)
- Direct issue comment links
- Command output (if applicable)

### Poor Evidence

- "Updated the file" (no link)
- "Fixed it" (no specifics)
- Branch name links (mutable)
- "Everything works" (not verifiable)
