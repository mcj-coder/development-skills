---
name: markdown-author
description: Use when writing or editing markdown to proactively enforce linting rules and spelling standards, preventing violations before commit.
---

# Markdown Author

## Overview

Proactively enforce markdown linting rules and spelling standards during writing, preventing violations before they're committed. Auto-fix formatting issues, block for structural decisions requiring context.

Git hooks remain as safety net for non-skill markdown changes.

## Prerequisites

- `.markdownlint.json` configuration (created automatically if missing)
- `cspell.json` spelling configuration (created automatically if missing)
- markdownlint-cli2 and cspell installed (via package.json)

## When to Use

- Writing new markdown files (.md)
- Editing existing markdown files
- Creating documentation, README files, plans
- Writing skill specifications

**Do not use for:**
- Non-markdown files
- Generated markdown (tool output)
- Third-party markdown (node_modules, etc.)

## Configuration Verification (First Use)

On first use in repository, verify configurations exist:

1. **Check `.markdownlint.json`:**
   - If exists: Parse and validate JSON
   - If missing: Create with defaults:
     ```json
     {
       "default": true,
       "MD013": {
         "line_length": 120,
         "code_blocks": false,
         "tables": false
       },
       "MD024": { "siblings_only": true },
       "MD033": false,
       "MD041": false
     }
     ```
   - If malformed: Error with message to fix or delete

2. **Check `cspell.json`:**
   - If exists: Parse and validate JSON
   - If missing: Create with defaults:
     ```json
     {
       "version": "0.2",
       "language": "en-US",
       "words": [],
       "ignorePaths": ["node_modules/**", "package-lock.json"]
     }
     ```
   - If malformed: Error with message to fix or delete

3. **Load rule configuration:**
   - Read enabled rules from `.markdownlint.json`
   - Read spelling locale and custom dictionary from `cspell.json`
   - Cache for session (don't re-read for each file)

## Core Workflow

### Before Writing Markdown

1. Load markdown-author skill if not already loaded
2. Verify configurations exist (first use only)
3. Read `.markdownlint.json` to determine enabled rules
4. Read `cspell.json` for spelling configuration

### During Writing

For each markdown content section:

1. **Analyze document structure:**
   - Identify existing heading levels
   - Determine appropriate next heading level
   - Note any lists, blockquotes, tables

2. **Compose content with validation:**
   - Check line length as writing (120 char default)
   - Validate heading hierarchy
   - Check spelling against cspell configuration
   - Detect code fences without language

3. **Apply auto-fixes silently:**
   - Break long lines at word boundaries
   - Adjust heading levels to maintain hierarchy
   - Strip trailing whitespace
   - Normalize list spacing
   - Fix emphasis/link syntax

4. **Block for structural decisions:**
   - Code fence missing language → Prompt for language
   - Spelling error → Fix or add to dictionary
   - Duplicate heading → Rename or confirm

5. **Log summary after writing:**
   ```
   ✓ Markdown validated and auto-fixed:
     - Adjusted 3 lines exceeding 120 characters
     - Fixed heading hierarchy (h3 → h2)
     - Added 1 term to cspell dictionary
   ```

### After Writing

1. Write validated markdown to file
2. Git hooks run as safety net (markdownlint-cli2, cspell)
3. If hooks fail, investigate why skill didn't catch violation

## Validation Rules

See [Validation Rules Reference](references/validation-rules.md) for complete list.

### Auto-Fixable Rules

**Applied silently without interruption:**

- **MD001:** Heading hierarchy - Auto-adjust levels to maintain proper structure
- **MD013:** Line length - Break at word boundaries, respect code/table exclusions
- **MD009:** Trailing spaces - Strip automatically
- **MD010:** Hard tabs - Replace with spaces
- **MD012:** Multiple blank lines - Collapse to single
- **MD030/MD032:** List spacing - Normalize
- **All formatting rules:** Applied per .markdownlint.json configuration

### Blocking Rules

**Require agent decision:**

- **MD040:** Code fence language - Agent must specify (bash, python, csharp, text, etc.)
- **MD024:** Duplicate headings - Agent must rename or confirm
- **MD045:** Image alt text - Agent must provide
- **Spelling errors:** Agent must fix or add to cspell.json dictionary

## Error Handling

### Configuration Errors

**Malformed JSON:**
```
Error: .markdownlint.json is invalid JSON
  Line 5: Unexpected token }

Fix syntax or delete file to regenerate with defaults.
```

**Missing required fields:**
```
Error: cspell.json missing 'version' field

Add field or delete file to regenerate with defaults.
```

### Blocking Violations

**Code fence without language:**
```
⚠ Markdown validation error:
  Line 45: Code fence requires language specification

Current:
```
npm install
```

Options:
- bash (recommended for shell commands)
- text (for plain text)
- json, yaml, markdown, etc.

What language should this code fence use?
```

**Spelling error:**
```
⚠ Spelling error detected:
  Line 12: Unknown word 'agentskills'

Options:
1. Add to cspell.json custom dictionary (recommended for project terms)
2. Fix spelling
3. Ignore (not recommended)

How should this be handled?
```

**Duplicate heading:**
```
⚠ Duplicate heading detected:
  Line 67: "## Implementation" already exists at line 34

This may cause navigation issues. Options:
1. Rename to "## Implementation Details"
2. Rename to "## Implementation (Phase 2)"
3. Keep as-is (not recommended)

How should this be resolved?
```

### Graceful Degradation

If configuration error prevents full validation:

```
⚠ markdown-author skill error: Unable to parse .markdownlint.json
  Falling back to basic validation (line length, code fences only)

Full linting will run in pre-commit hook.
Consider fixing configuration: .markdownlint.json
```

## Example

### Writing New Documentation

```markdown
User: "Create architecture documentation"

Agent: [Loads markdown-author skill]
Agent: [Verifies .markdownlint.json exists]
Agent: [Verifies cspell.json exists]
Agent: [Begins composing architecture.md]

Content composed:
# Architecture Overview

This document describes the system architecure...
[Spell check detects: architecure → architecture]

⚠ Spelling error: 'architecure'. Did you mean: 'architecture'?
Agent: [Corrects to 'architecture']

The application uses a microservices approach with the following componets:
[Spell check detects: componets → components]

⚠ Spelling error: 'componets'. Did you mean: 'components'?
Agent: [Corrects to 'components']

### API Gateway

[Heading hierarchy: h1 → h3, auto-corrects to h2]

## API Gateway

Handles all incoming requests and routes to appropriate services. The gateway validates authentication tokens, applies rate limiting, and logs all requests for monitoring purposes.
[Line length: 165 chars, auto-breaks at word boundary]

Handles all incoming requests and routes to appropriate services. The gateway
validates authentication tokens, applies rate limiting, and logs all requests
for monitoring purposes.

```python
def validate_token(token):
    return jwt.decode(token)
```
[Code fence has language: python ✓]

✓ Markdown validated and auto-fixed:
  - Fixed 2 spelling errors
  - Adjusted heading hierarchy (h3 → h2)
  - Broke 1 line exceeding 120 characters
```

### Editing Existing Markdown

```markdown
Agent: [Loads markdown-author skill]
Agent: [Reads existing document structure: h1, h2, h2, h3]
Agent: [Plans to add new section at same level as last h2]

Adding new content:
## New Feature

[Heading level: h2 - correct for sibling section ✓]

Implementation details follow...
[Validation passes, writes to file]
```

## Common Mistakes

- Writing markdown without loading skill first
- Ignoring blocking violations (spelling, code fence language)
- Proceeding when configuration malformed
- Not adding project-specific terms to cspell.json dictionary
- Disabling rules in config without understanding impact
- Using --no-verify to bypass pre-commit hooks (skill should catch issues first)

## Red Flags - STOP

- "I'll skip the code fence language, it's obvious"
- "Spelling check is too strict, I'll ignore it"
- "Line length doesn't matter, I'll disable the rule"
- "I'll fix the linting errors later"
- "The configuration is broken but I'll write anyway"
- "--no-verify is faster, I'll use that"

## Rationalizations (and Reality)

| Excuse                                      | Reality                                                  |
| ------------------------------------------- | -------------------------------------------------------- |
| "Line length doesn't affect readability"    | 120 chars is readability standard, pre-commit will fail  |
| "Code fence language is obvious from code"  | Syntax highlighting requires explicit language           |
| "Spelling errors are minor"                 | Breaks cspell pre-commit hook, blocks entire commit      |
| "I'll fix linting issues in next commit"    | Creates broken window, forces --no-verify bypasses       |
| "Configuration is too strict"               | Rules exist for consistency, modify config if needed     |
| "Pre-commit hooks will catch it"            | Hooks are safety net, skill prevents issues proactively  |

## See Also

- [Validation Rules Reference](references/validation-rules.md) - Complete markdownlint rule list
- [Spelling Configuration](references/spelling-configuration.md) - cspell setup and custom dictionary
- [Editor Integration](references/editor-integration.md) - VS Code and other editor setup
- Pre-commit hooks: `.husky/pre-commit` and `package.json` lint-staged configuration
- markdownlint rules: https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md
