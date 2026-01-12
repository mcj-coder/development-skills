# Spell Checking Configuration

## Recommended Configuration

Create `.cspell.json` in repository root:

```json
{
  "version": "0.2",
  "language": "en",
  "words": [
    "markdownlint",
    "cspell",
    "frontmatter",
    "brownfield",
    "greenfield"
  ],
  "ignorePaths": ["node_modules/**", ".git/**", "dist/**", "*.lock"],
  "dictionaries": ["softwareTerms", "typescript", "node"]
}
```

## Technical Dictionary

Add project-specific terms to the `words` array:

- Framework names (React, Angular, PostgreSQL)
- Domain terminology (microservices, API)
- Acronyms used in project (ADR, CI, CD)
- Tool names (markdownlint, cspell, husky)

## Ignoring Files

Use `ignorePaths` to exclude:

- Generated files (dist/, build/)
- Dependencies (node_modules/, vendor/)
- Lock files (package-lock.json, yarn.lock)
- Third-party documentation

## Installation

```bash
# npm
npm install --save-dev cspell

# Yarn
yarn add --dev cspell
```

## Running

```bash
# Check all markdown files
npx cspell "**/*.md"

# Check specific directory
npx cspell "docs/**/*.md"

# Add words interactively
npx cspell --words-only "**/*.md" | sort -u
```

## Handling Unknown Words

When spell check flags a word:

1. **Typo** - Fix the spelling
2. **Technical term** - Add to `words` array in `.cspell.json`
3. **Project-specific** - Add to `words` array
4. **False positive** - Add inline comment `<!-- cspell:ignore word -->`

## Pre-commit Hook

```bash
npx cspell --no-progress $(git diff --cached --name-only --diff-filter=ACM | grep '\.md$')
```

## CI Integration

See [Validation Configuration](validation-configuration.md) for GitHub Actions workflow.
