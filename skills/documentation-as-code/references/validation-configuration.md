# Validation Configuration

## GitHub Actions Workflow

Create `.github/workflows/docs-validation.yml`:

```yaml
name: Documentation Validation

on:
  pull_request:
    paths:
      - "docs/**"
      - "**/*.md"

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Install dependencies
        run: npm ci

      - name: Markdown Lint
        run: npx markdownlint-cli2 "**/*.md"

      - name: Spell Check
        run: npx cspell "**/*.md" --no-progress

      - name: Link Check
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          use-quiet-mode: "yes"
          config-file: ".markdown-link-check.json"
```

## Link Check Configuration

Create `.markdown-link-check.json`:

```json
{
  "ignorePatterns": [
    { "pattern": "^https://localhost" },
    { "pattern": "^https://127.0.0.1" }
  ],
  "replacementPatterns": [],
  "httpHeaders": [],
  "timeout": "10s",
  "retryOn429": true,
  "retryCount": 3,
  "fallbackRetryDelay": "5s"
}
```

## Package.json Scripts

Add validation scripts:

```json
{
  "scripts": {
    "lint:md": "markdownlint-cli2 \"**/*.md\"",
    "lint:md:fix": "markdownlint-cli2 --fix \"**/*.md\"",
    "spell": "cspell \"**/*.md\" --no-progress",
    "validate:docs": "npm run lint:md && npm run spell"
  }
}
```

## Pre-commit Integration

With lint-staged in `package.json`:

```json
{
  "lint-staged": {
    "*.md": ["markdownlint-cli2 --fix", "cspell --no-progress"]
  }
}
```

## Required Dependencies

```bash
npm install --save-dev markdownlint-cli2 cspell
```

## Validation Levels

| Level    | Checks                    | Use Case             |
| -------- | ------------------------- | -------------------- |
| Basic    | Spell, lint               | Most projects        |
| Standard | + link validation         | Documentation-heavy  |
| Strict   | + structure, completeness | Public documentation |

## Single Command Run

```bash
npm run validate:docs
```
