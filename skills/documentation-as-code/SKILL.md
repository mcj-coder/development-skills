---
name: documentation-as-code
description: Use when user creates/modifies/reviews documentation (Markdown, ADRs, plans, READMEs). Applies same rigor as code with lint, spell, format validation, review processes, and CI automation.
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
