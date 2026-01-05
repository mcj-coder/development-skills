# Spelling Configuration

How markdown-author integrates with cspell for spelling validation.

## Overview

cspell (Code Spell Checker) validates spelling with:

- Locale-aware dictionaries (en-US, en-GB, etc.)
- Language-specific dictionaries (C#, Python, JavaScript, etc.)
- Custom project dictionaries
- Configurable ignore patterns

markdown-author integrates with cspell to check spelling during markdown writing.

## Configuration File

`cspell.json` in repository root:

```json
{
  "version": "0.2",
  "language": "en-GB",
  "languageSettings": [
    {
      "languageId": ["markdown"],
      "locale": "en-GB, en-US"
    }
  ],
  "words": [
    "agentskills",
    "markdownlint",
    "cspell",
    "Taskboard"
  ],
  "ignorePaths": [
    "node_modules/**",
    "package-lock.json"
  ]
}
```

## Configuration Fields

### version

**Purpose:** cspell configuration format version

**Value:** `"0.2"` (current version)

### language

**Purpose:** Default language/locale for spell checking

**Values:**

- `"en-US"` - American English
- `"en-GB"` - British English
- `"en-CA"` - Canadian English
- `"en-AU"` - Australian English

**Example:**

```json
"language": "en-GB"
```

### languageSettings

**Purpose:** Language-specific settings for different file types

**Structure:**

```json
"languageSettings": [
  {
    "languageId": ["markdown", "mdx"],
    "locale": "en-GB, en-US"
  }
]
```

**languageId:** File types this setting applies to
**locale:** Comma-separated list of accepted locales

**Use case:** Allow both British and American English in markdown files

### words

**Purpose:** Custom dictionary for project-specific terms

**Structure:** Array of strings

```json
"words": [
  "agentskills",
  "Taskboard",
  "workitem",
  "workitems"
]
```

**When to add:**

- Project-specific terminology
- Product names
- Acronyms and abbreviations
- Technical terms not in standard dictionaries

**How markdown-author uses:**
When unknown word detected:

```
⚠ Spelling error: 'agentskills'

Options:
1. Add to cspell.json dictionary ← Updates this array
2. Fix spelling
3. Ignore
```

### ignorePaths

**Purpose:** Files and directories to skip spell checking

**Structure:** Array of glob patterns

```json
"ignorePaths": [
  "node_modules/**",
  "package-lock.json",
  "*.log",
  "dist/**"
]
```

**Common patterns:**

- `node_modules/**` - Dependencies
- `package-lock.json` - Lock files
- `dist/**` - Build output
- `*.min.js` - Minified files

## Language-Specific Dictionaries

cspell includes dictionaries for many programming languages. These are automatically used when spell-checking code fences.

### Available Dictionaries

- **C#:** async, await, var, Task, namespace, etc.
- **Python:** def, async, await, lambda, etc.
- **JavaScript:** const, let, async, await, etc.
- **TypeScript:** interface, type, enum, etc.
- **Go:** func, var, struct, interface, etc.
- **Rust:** fn, mut, impl, trait, etc.
- **Bash:** echo, grep, awk, sed, etc.
- **SQL:** SELECT, INSERT, UPDATE, DELETE, etc.
- **Many more...**

### Example

```markdown
```csharp
// Spell check applied to comments only
public async Task<string> GetDataAsync() // C# keywords not flagged
{
    var result = await httpClient.GetStringAsync(url);
    return result;
}
```

```

**Result:**
- `async`, `await`, `var`, `Task` - Recognized as C# keywords, not flagged
- Comments still checked: typos in comments will be caught

## Spell Checking Behavior

### In Prose

All words checked against:
1. Configured locale dictionary (en-GB, en-US, etc.)
2. Custom dictionary (words array in cspell.json)

### In Code Fences

Words checked against:
1. Language-specific dictionary (csharp, python, etc.)
2. Configured locale dictionary (for comments, strings)
3. Custom dictionary

**Example:**
```python
def calculate_total(items):
    """Calcuate the total price"""  # Typo: Calcuate
    return sum(item.price for item in items)  # Keywords OK
```

**Result:**

```
⚠ Spelling error in comment: 'Calcuate'
  Did you mean: Calculate

✓ Python keywords recognized: def, sum, for, in, return
```

### In Links

URLs and file paths not spell-checked:

```markdown
[Documentation](https://github.com/repo/veryLongRepoNameNotChecked)
```

### In Inline Code

Code spans checked but with more lenient rules:

```markdown
The `validateToken` function checks the JWT signature.
```

- `validateToken` - Camel case recognized, not flagged
- Acronyms in code spans tolerated

## Adding Words to Dictionary

markdown-author skill prompts when unknown word detected:

```
⚠ Spelling error: 'agentskills'

Options:
1. Add to cspell.json dictionary (recommended for project terms)
2. Fix spelling
3. Ignore (not recommended)
```

**Choosing Option 1 updates cspell.json:**

Before:

```json
{
  "words": []
}
```

After:

```json
{
  "words": ["agentskills"]
}
```

**Guidelines for adding words:**

- ✅ Project-specific terms (agentskills, Taskboard)
- ✅ Product names (GitHub, Azure, PostgreSQL)
- ✅ Acronyms (BDD, TDD, CI/CD)
- ✅ Technical terms not in dictionary (monorepo, worktree)
- ❌ Common words (use Fix spelling instead)
- ❌ Typos (fix the typo, don't add to dictionary)

## Common Spelling Issues

### Camel Case

**Issue:** `validateToken` flagged as unknown
**Solution:** cspell handles camel case - usually not flagged
**If flagged:** Add to dictionary or use proper spacing in prose

### Hyphenated Terms

**Issue:** `pre-commit` may be flagged
**Solution:** Add to dictionary as used in project

### Acronyms

**Issue:** `BDD`, `TDD`, `CI/CD` flagged
**Solution:** Add commonly used acronyms to dictionary

### British vs American English

**Issue:** `colour` vs `color`, `organise` vs `organize`
**Solution:** Configure both locales:

```json
"languageSettings": [
  {
    "languageId": ["markdown"],
    "locale": "en-GB, en-US"
  }
]
```

## Locale Differences

### en-GB (British English)

- colour, favour, behaviour
- organise, realise, analyse
- centre, theatre
- licence (noun), license (verb)

### en-US (American English)

- color, favor, behavior
- organize, realize, analyze
- center, theater
- license (both noun and verb)

### Mixed Locale Strategy

For international projects, accept both:

```json
"locale": "en-GB, en-US"
```

**Advantages:**

- Contributors can use their native spelling
- No forced conversion
- Spell check passes for both variants

**Disadvantages:**

- Inconsistent spelling across document
- May prefer to standardize on one variant

## Integration with Pre-Commit Hooks

cspell runs in pre-commit hooks via lint-staged:

```json
"lint-staged": {
  "**/*.md": [
    "prettier --write",
    "markdownlint-cli2 --fix",
    "cspell"
  ]
}
```

**markdown-author skill complements hooks:**

- Skill catches during writing
- Hooks catch during commit
- Both use same cspell.json configuration
- No conflicts between skill and hooks

## Troubleshooting

### False Positives

**Symptom:** Valid word flagged as misspelled
**Solution:**

1. Verify word spelling
2. Check if word in correct locale dictionary
3. Add to custom dictionary if project-specific

### Words Not Flagged

**Symptom:** Obvious typo not caught
**Solution:**

1. Verify cspell.json exists and is valid
2. Check word not in custom dictionary
3. Verify locale configuration matches content

### Configuration Not Loading

**Symptom:** Changes to cspell.json not reflected
**Solution:**

1. Verify JSON syntax (use JSON validator)
2. Restart markdown-author skill (configuration cached)
3. Check file location (must be in repository root)

## See Also

- cspell documentation: <https://cspell.org/>
- [Validation Rules Reference](validation-rules.md)
- [Editor Integration](editor-integration.md)
