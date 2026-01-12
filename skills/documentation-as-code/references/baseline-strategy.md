# Baseline Strategy for Brownfield Documentation

## Overview

When adding documentation-as-code to existing repositories, use a baseline approach
to avoid blocking current work while preventing new violations.

## Process

### 1. Run Baseline Validation

```bash
# Generate baseline reports
npx markdownlint-cli2 "**/*.md" 2>&1 | tee validation-reports/markdownlint-baseline.txt
npx cspell "**/*.md" --no-progress 2>&1 | tee validation-reports/cspell-baseline.txt
```

### 2. Document Existing Issues

Create `docs/validation-baseline.md`:

```markdown
# Documentation Validation Baseline

**Date:** YYYY-MM-DD

## Summary

| Check    | Issues Found |
| -------- | ------------ |
| Linting  | 23           |
| Spelling | 47           |
| Links    | 8            |

## Suppression Strategy

- Technical terms added to dictionary: 32
- Actual typos to fix: 15 (Priority 1)
- Formatting issues: 23 (Priority 2)
- Broken links: 8 (Priority 1)
```

### 3. Create Suppression Files

`.markdownlintignore` for files with known issues:

```text
# Legacy documentation with known formatting issues
docs/legacy/**
CHANGELOG.md
```

### 4. Configure CI for New Changes Only

Option A: Check only modified files in PR:

```yaml
- name: Lint Changed Files
  run: |
    git diff --name-only origin/main...HEAD -- '*.md' | xargs -r npx markdownlint-cli2
```

Option B: Suppress baseline issues:

```yaml
- name: Markdown Lint (Baseline)
  run: npx markdownlint-cli2 "**/*.md" || true
  continue-on-error: true
```

### 5. Incremental Cleanup Plan

Prioritize fixes:

| Priority | Category     | Example             | Timeline    |
| -------- | ------------ | ------------------- | ----------- |
| P1       | Broken links | Dead external links | This sprint |
| P1       | Actual typos | Public-facing docs  | This sprint |
| P2       | Formatting   | Heading hierarchy   | Next sprint |
| P3       | Line length  | Legacy docs         | Ongoing     |

## Tracking Progress

Update baseline document monthly:

```markdown
## Progress

| Date       | Linting | Spelling | Links |
| ---------- | ------- | -------- | ----- |
| 2024-01-15 | 23      | 47       | 8     |
| 2024-02-15 | 18      | 32       | 3     |
| 2024-03-15 | 10      | 15       | 0     |
```

## Graduation

Remove baseline suppression when:

1. All Priority 1 issues resolved
2. New docs consistently passing
3. Team comfortable with validation workflow

Then enforce strict validation on all files.
