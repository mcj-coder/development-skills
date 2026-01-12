# Markdown Linting Configuration

## Recommended Configuration

Create `.markdownlint.json` in repository root:

```json
{
  "default": true,
  "MD013": { "line_length": 120, "code_blocks": false },
  "MD033": false,
  "MD041": false,
  "MD024": { "siblings_only": true }
}
```

## Rule Explanations

| Rule  | Purpose             | Default Setting      |
| ----- | ------------------- | -------------------- |
| MD001 | Heading hierarchy   | Enabled              |
| MD013 | Line length         | 120 chars, skip code |
| MD024 | Duplicate headings  | Siblings only        |
| MD033 | Inline HTML         | Disabled (allowed)   |
| MD040 | Code fence language | Enabled              |
| MD041 | First line heading  | Disabled             |

## Auto-Fixable Rules

These are fixed automatically without interruption:

- **MD009** - Trailing spaces (stripped)
- **MD010** - Hard tabs (converted to spaces)
- **MD012** - Multiple blank lines (collapsed)
- **MD030/MD032** - List spacing (normalized)

## Blocking Rules

These require explicit decision:

- **MD040** - Code fence language (must specify: bash, json, yaml, text, etc.)
- **MD024** - Duplicate headings (rename or confirm)
- **MD045** - Image alt text (must provide)

## Installation

```bash
# npm
npm install --save-dev markdownlint-cli2

# Yarn
yarn add --dev markdownlint-cli2
```

## Running

```bash
# Check all markdown files
npx markdownlint-cli2 "**/*.md"

# Fix auto-fixable issues
npx markdownlint-cli2 --fix "**/*.md"
```

## Pre-commit Hook

Add to `.husky/pre-commit` or lint-staged configuration:

```bash
npx markdownlint-cli2 $(git diff --cached --name-only --diff-filter=ACM | grep '\.md$')
```

## CI Integration

See [Validation Configuration](validation-configuration.md) for GitHub Actions workflow.
