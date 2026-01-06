# Validation Rules Reference

Complete list of markdownlint rules and how markdown-author handles them.

## Rule Categories

**Auto-Fixable:** Applied silently without blocking
**Blocking:** Requires agent decision before proceeding
**Disabled:** Respects .markdownlint.json disabled rules

## Auto-Fixable Rules

### MD001 - Heading Levels

**Rule:** Headings should increment by one level at a time

**Auto-Fix Behaviour:**

- Analyses existing document structure
- Auto-selects appropriate heading level:
  - New document: Start with h1
  - Existing document: Continue from last heading level
  - Sub-section: Use next level down
- Auto-adjusts invalid jumps (h1 → h3 becomes h1 → h2)

**Example:**

`````markdown
# Title

### Details ← Auto-corrected to: ## Details

````text

### MD003 - Heading Style

**Rule:** Heading style consistency (ATX, setext, etc.)

**Auto-Fix Behaviour:**

- Enforces ATX style (# Heading) by default
- Converts setext to ATX if found

### MD004 - Unordered List Style

**Rule:** Consistent list marker style

**Auto-Fix Behaviour:**

- Normalizes to configured style (dash, asterisk, plus)
- Default: dash (-)

### MD005 - List Indentation

**Rule:** Consistent indentation for nested lists

**Auto-Fix Behaviour:**

- Normalizes to 2-space indentation for nested items

### MD007 - Unordered List Indentation

**Rule:** Proper indentation amount

**Auto-Fix Behaviour:**

- Adjusts indentation to configured amount (default: 2 spaces)

### MD009 - Trailing Spaces

**Rule:** No trailing spaces

**Auto-Fix Behaviour:**

- Strips trailing whitespace from all lines
- Preserves intentional double-space line breaks if detected

### MD010 - Hard Tabs

**Rule:** Use spaces instead of tabs

**Auto-Fix Behaviour:**

- Replaces tabs with spaces (configured spaces per tab)
- Preserves tabs in code fences if language-appropriate

### MD011 - Reversed Link Syntax

**Rule:** Correct link syntax [text](url) not [text](url)

**Auto-Fix Behaviour:**

- Detects reversed syntax
- Auto-corrects to proper format

### MD012 - Multiple Consecutive Blank Lines

**Rule:** No multiple consecutive blank lines

**Auto-Fix Behaviour:**

- Collapses multiple blank lines to single blank line

### MD013 - Line Length

**Rule:** Lines should not exceed configured length (default: 120)

**Auto-Fix Behaviour:**

- Breaks lines at word boundaries before limit
- Respects exclusions:
  - `code_blocks: false` - Don't break code fence lines
  - `tables: false` - Don't break table rows
- Preserves markdown syntax (lists, blockquotes, inline code)

**Example:**

```markdown
Original (150 chars):
This is a very long line that exceeds the 120 character limit and should be automatically broken at word boundaries to maintain readability standards.

Auto-fixed:
This is a very long line that exceeds the 120 character limit and should be
automatically broken at word boundaries to maintain readability standards.
```text

### MD014 - Dollar Signs in Shell Commands

**Rule:** Shell commands should not show $ prompt

**Auto-Fix Behaviour:**

- Removes leading $ from shell command lines in code fences

### MD018 - No Space After Hash on ATX Heading

**Rule:** Require space after # in headings

**Auto-Fix Behaviour:**

- Adds space: `#Heading` → `# Heading`

### MD019 - Multiple Spaces After Hash on ATX Heading

**Rule:** Only one space after # in headings

**Auto-Fix Behaviour:**

- Collapses multiple spaces to single space

### MD022 - Headings Should Be Surrounded By Blank Lines

**Rule:** Blank lines before and after headings

**Auto-Fix Behaviour:**

- Adds blank line before heading if missing
- Adds blank line after heading if missing

### MD023 - Headings Must Start at Beginning of Line

**Rule:** No indentation before headings

**Auto-Fix Behaviour:**

- Removes leading whitespace from headings

### MD026 - Trailing Punctuation in Heading

**Rule:** No trailing punctuation (., !, ?) in headings

**Auto-Fix Behaviour:**

- Removes trailing punctuation from headings

### MD027 - Multiple Spaces After Blockquote Symbol

**Rule:** Only one space after > in blockquotes

**Auto-Fix Behaviour:**

- Collapses multiple spaces to single space

### MD028 - Blank Line Inside Blockquote

**Rule:** No blank lines inside blockquotes

**Auto-Fix Behaviour:**

- Removes blank lines within blockquote blocks

### MD030 - Spaces After List Markers

**Rule:** Consistent spacing after list markers

**Auto-Fix Behaviour:**

- Normalizes to 1 space after marker for single-line items
- Normalizes to 1 space for multi-line items

### MD031 - Fenced Code Blocks Surrounded By Blank Lines

**Rule:** Blank lines before and after code fences

**Auto-Fix Behaviour:**

- Adds blank line before code fence if missing
- Adds blank line after code fence if missing

### MD032 - Lists Surrounded By Blank Lines

**Rule:** Blank lines before and after lists

**Auto-Fix Behaviour:**

- Adds blank line before list if missing
- Adds blank line after list if missing

### MD034 - Bare URL Without Angle Brackets

**Rule:** URLs should be in angle brackets or links

**Auto-Fix Behaviour:**

- Converts bare URLs to proper links: `https://example.com` → `<https://example.com>`

### MD037 - Spaces Inside Emphasis Markers

**Rule:** No spaces inside * or _ emphasis markers

**Auto-Fix Behaviour:**

- Removes spaces: `* text *` → `*text*`

### MD038 - Spaces Inside Code Span

**Rule:** No spaces inside ` code span markers

**Auto-Fix Behaviour:**

- Removes spaces: `` ` code ` `` → `` `code` ``

### MD039 - Spaces Inside Link Text

**Rule:** No spaces inside [ ] link text

**Auto-Fix Behaviour:**

- Removes spaces: `[ text ](url)` → `[text](url)`

### MD047 - Files Should End With Single Newline

**Rule:** File must end with newline character

**Auto-Fix Behaviour:**

- Adds newline at end of file if missing

### MD049 - Emphasis Style

**Rule:** Consistent emphasis style (asterisk vs underscore)

**Auto-Fix Behaviour:**

- Normalizes to configured style (default: asterisk)

### MD050 - Strong Style

**Rule:** Consistent strong style (asterisk vs underscore)

**Auto-Fix Behaviour:**

- Normalizes to configured style (default: asterisk)

## Blocking Rules

### MD024 - No Duplicate Headings

**Rule:** Multiple headings with same content

**Blocking Behaviour:**

- Respects `siblings_only: true` (only check same level)
- Warns if duplicate heading at same level
- Blocks if duplicates would cause navigation issues
- Prompts:

<!-- markdownlint-disable MD031 MD040 -->
````
`````

```

⚠ Duplicate heading detected:
Line 67: "## Implementation" already exists at line 34

Options:

1. Rename to "## Implementation Details"
2. Rename to "## Implementation (Phase 2)"
3. Keep as-is (not recommended)

```

<!-- markdownlint-enable MD031 MD040 -->

### MD040 - Fenced Code Language

**Rule:** Code fences must specify language

**Blocking Behaviour:**

- Detects code fences without language (`instead of`bash)
- Blocks until language specified
- Prompts:

<!-- markdownlint-disable MD031 MD040 -->

````text

⚠ Code fence requires language specification

Options:

- bash (for shell commands)
- javascript, python, csharp, java, go, rust
- json, yaml, xml, markdown
- text (for plain text)

  What language should this code fence use?
  <!-- markdownlint-disable MD040 -->

  ```

  ```

````

<!-- markdownlint-enable MD031 MD040 -->

### MD045 - Images Should Have Alt Text

**Rule:** Images must have alt text for accessibility

**Blocking Behaviour:**

- Detects images without alt text: `![](image.png)`
- Blocks until alt text provided
- Prompts:

  ````text

  ```text
  ````

<!-- markdownlint-enable MD040 -->

⚠ Image missing alt text (accessibility requirement)

Image: image.png

What should the alt text describe?

```text

### MD051 - Link Fragments Should Be Valid

**Rule:** Link anchors must exist in document

**Blocking Behaviour:**

- Validates fragment identifiers (#section-name)
- Blocks if target heading doesn't exist
- Prompts:
<!-- markdownlint-disable MD040 -->

```

⚠ Invalid link fragment: #invalid-section

Target heading not found in document.

Options:

1. Fix fragment to match existing heading
2. Create heading for fragment
3. Remove fragment

```

### Spelling Errors

**Blocking Behaviour:**

- Checks all words against cspell configuration
- Respects language-specific dictionaries in code fences
- Respects custom dictionary in cspell.json
- Blocks until resolved
- Prompts:

```

<!-- markdownlint-enable MD040 -->

⚠ Spelling error: 'agentskills'

Options:

1. Add to cspell.json dictionary (recommended for project terms)
2. Fix spelling
3. Ignore (not recommended)

How should this be handled?

````text

## Disabled Rules

These rules are disabled in the default configuration:

### MD033 - No Inline HTML

**Rule:** No HTML tags in markdown

**Status:** Disabled by default (inline HTML allowed)
**Reason:** Many use cases require HTML (tables, images with specific attributes)

### MD041 - First Line Should Be Top-Level Heading

**Rule:** File must start with h1

**Status:** Disabled by default
**Reason:** Front matter, YAML headers, and other content may precede heading

## Rule Configuration

Rules are configured in `.markdownlint.json`:

```json
{
"default": true,
"MD013": {
  "line_length": 120,
  "code_blocks": false,
  "tables": false
},
"MD024": {
  "siblings_only": true
},
"MD033": false,
"MD041": false
}
```text

- `"default": true` enables all rules by default
- Individual rules can be disabled: `"MD033": false`
- Rules can be configured with parameters: `"MD013": { ... }`

## See Also

- markdownlint rules documentation: <https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md>
- `.markdownlint.json` configuration format
- [Spelling Configuration](spelling-configuration.md)
````
