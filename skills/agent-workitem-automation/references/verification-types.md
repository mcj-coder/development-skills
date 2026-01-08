# Verification Types

## Concrete Changes

**Definition:** Changes that modify repository files (code, configuration, documentation).

**Requirements:**

- Applied evidence with commit SHAs and file links
- Example: "TDD applied: failing test [SHA1], implementation [SHA2]"

**Checklist:**

- [ ] Change committed to repository
- [ ] Commit SHA recorded as evidence
- [ ] File links point to specific lines/sections

## Process-Only Changes

**Definition:** Changes that guide workflow without modifying repository files.

**Requirements:**

- Analytical verification with issue comment links
- Must state: "This is analytical verification (process-only)"

**Checklist:**

- [ ] Process followed as documented
- [ ] Issue/PR comment links provided as evidence
- [ ] "This is analytical verification (process-only)" stated

## How to Determine

Ask: "Did this work modify files in the repository?"

- Yes → Concrete changes verification
- No → Process-only verification
