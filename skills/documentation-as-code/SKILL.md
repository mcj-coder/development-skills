---
name: documentation-as-code
description: Use when user creates/modifies/reviews documentation (Markdown, ADRs, plans, READMEs). Applies same rigor as code with lint, spell, format validation, review processes, and CI automation.
metadata:
  type: Implementation
  priority: P2
---

# Documentation as Code

## Overview

**P1 Quality & Correctness** - Treat documentation with same rigor as source code.

**REQUIRED:** superpowers:verification-before-completion

**Cross-references:** automated-standards-enforcement, ci-cd-conformance

## When to Use

- Creating/modifying Markdown, ADRs, plans, READMEs
- Adding API documentation, architecture decisions
- PR includes documentation changes

## Core Workflow

1. Announce skill and scope
2. Configure validation:
   - markdownlint ([Markdown Linting](references/markdown-linting.md))
   - cSpell ([Spell Checking](references/spell-checking.md))
   - link-check for broken links
3. Enforce templates ([Templates](references/templates.md))
4. Add CI validation (fail PR if validation fails)
5. Define review expectations
6. Run all validation before completion

## Quick Reference

| Check      | Tool                | Enforcement    |
| ---------- | ------------------- | -------------- |
| Formatting | markdownlint        | Pre-commit, CI |
| Spelling   | cSpell              | Pre-commit, CI |
| Links      | markdown-link-check | CI             |
| Structure  | Template validation | Review         |

See [Validation Configuration](references/validation-configuration.md) for setup.

## Verification Commands for Doc-Only Changes

For documentation-only changes, use these commands to verify quality before
completion:

### Local Verification

```bash
# Markdown formatting check
npm run lint:md

# Spell check
npm run spell

# Both checks (combined command)
npm run validate:docs
```

### Specific File Validation

```bash
# Check single file
npx markdownlint-cli2 docs/README.md

# Check documentation directory
npx markdownlint-cli2 "docs/**/*.md"

# Spell check specific files
npx cspell "docs/**/*.md" --no-progress

# Link validation (requires configuration)
npx markdown-link-check docs/README.md
```

### Evidence Capture for Issue Comments

When documenting doc-only verification, post evidence like:

```markdown
## Verification

- [x] `npm run lint:md` passed
- [x] `npm run spell` passed
- [x] All links verified (no broken references)
- Link validation output: [CI check details](link-to-workflow-run)
```

### Brownfield Baseline Verification

For existing docs without validation:

```bash
# Capture baseline violations for documentation
npm run lint:md > lint-baseline.txt 2>&1
npm run spell > spell-baseline.txt 2>&1

# Document findings in baseline file
echo "## Baseline Issues Identified
- Markdown formatting issues: $(wc -l < lint-baseline.txt)
- Spelling issues: $(wc -l < spell-baseline.txt)
" > docs/validation-baseline.md
```

**Key Point:** For doc-only changes, verification evidence is process-only
(analytical). Link to CI output or command results, not commit SHAs.

## Brownfield Approach

1. Run baseline validation
2. Document existing issues
3. Suppress existing violations ([Baseline Strategy](references/baseline-strategy.md))
4. Enforce strict validation on new/modified docs only
5. Create incremental cleanup plan

## Red Flags - STOP

- "Content matters, not formatting"
- "Can fix typos later"
- "Template is optional"
- "Existing docs aren't validated"

**All mean: Apply skill, document exceptions in baseline.**

## Rationalizations Table

| Excuse                            | Reality                                           |
| --------------------------------- | ------------------------------------------------- |
| "Content matters, not formatting" | Poor formatting reduces readability               |
| "Can fix typos later"             | Spell check takes seconds, prevents embarrassment |
| "Template is a guideline"         | Templates ensure consistency and completeness     |
| "Better than no documentation"    | Low-quality docs can mislead worse than none      |
