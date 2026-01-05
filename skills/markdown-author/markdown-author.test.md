# markdown-author - BDD Tests

## Baseline (No Skill Present)

### RED Scenario 1: Line length violations written

**Given:** Agent writes markdown paragraph with 150-character lines
**When:** Content written without markdown-author skill
**Then:** Lines exceed 120 character limit
**And:** Pre-commit hook fails with MD013 errors

### RED Scenario 2: Code fences missing language

**Given:** Agent writes code block without language specification
**When:** Content written without markdown-author skill
**Then:** Code fence has no language (```\n instead of```bash\n)
**And:** Pre-commit hook fails with MD040 errors

### RED Scenario 3: Heading hierarchy violations

**Given:** Agent writes h1 followed immediately by h3
**When:** Content written without markdown-author skill
**Then:** Heading hierarchy skip occurs (h1 → h3)
**And:** Pre-commit hook fails with MD001 errors

### RED Scenario 4: Spelling errors written

**Given:** Agent writes "recieve" instead of "receive"
**When:** Content written without markdown-author skill
**Then:** Misspelled word written to file
**And:** Pre-commit hook fails with cspell errors

## Baseline Observations (Simulated)

Without the skill, typical agent behavior:

- Writes long lines without considering 120 char limit
- Creates code fences with ``` instead of ```bash
- Jumps heading levels (h1 → h3) without hierarchy check
- Writes typos and domain-specific terms without spell check
- Pre-commit hooks fail, forcing --no-verify bypasses
- Broken windows accumulate (69+ errors in issue #56)

## Assertions (Expected to Fail Until Skill Exists)

- `.markdownlint.json` verification occurs on first use
- `cspell.json` verification occurs on first use
- Configuration files auto-created with defaults if missing
- Line length auto-breaks at word boundaries before 120 chars
- Heading hierarchy auto-adjusts to maintain proper structure
- Code fences block until language specified
- Spelling errors block until fixed or added to dictionary
- Auto-fix summary logged after writing complete
- Pre-commit hooks pass for skill-written markdown

## GREEN Scenarios (With Skill)

### GREEN Scenario 1: Line length auto-fixed

**Given:** markdown-author skill loaded
**When:** Agent composes paragraph with 150-character line
**Then:** Skill breaks line at 115 characters (word boundary before 120)
**And:** Written content has proper line breaks
**And:** Pre-commit hook passes

**Evidence:**

```markdown
Original (150 chars):
This is a very long line that exceeds the 120 character limit and should be automatically broken at word boundaries to maintain readability standards.

Auto-fixed:
This is a very long line that exceeds the 120 character limit and should be
automatically broken at word boundaries to maintain readability standards.
```

### GREEN Scenario 2: Code fence language prompted

**Given:** markdown-author skill loaded
**When:** Agent attempts to write code fence without language
**Then:** Skill blocks with message: "Code fence requires language. Options: bash, javascript, python, csharp, text, etc."
**And:** Agent specifies "bash"
**And:** Written content has ```bash
**And:** Pre-commit hook passes

**Evidence:**

```
⚠ Markdown validation error:
  Code fence requires language specification

Options: bash, javascript, python, csharp, text

Agent selects: bash

Result:
```bash
npm install
```

```

### GREEN Scenario 3: Heading hierarchy auto-corrected

**Given:** markdown-author skill loaded with existing h1 heading
**When:** Agent attempts to write h3 heading next
**Then:** Skill auto-adjusts to h2
**And:** Written content has proper hierarchy (h1 → h2)
**And:** Pre-commit hook passes

**Evidence:**
```markdown
Existing structure:
# Main Title

Agent attempts:
### Details Section

Auto-corrected to:
## Details Section
```

### GREEN Scenario 4: Spelling error caught and fixed

**Given:** markdown-author skill loaded with cspell.json
**When:** Agent writes "recieve"
**Then:** Skill blocks with message: "Spelling error: 'recieve'. Did you mean: 'receive'?"
**And:** Agent corrects to "receive"
**And:** Written content has correct spelling
**And:** Pre-commit hook passes

**Evidence:**

```
⚠ Spelling error detected:
  Line 12: Unknown word 'recieve'

Suggestions: receive

Agent corrects: recieve → receive
```

### GREEN Scenario 5: Configuration auto-created

**Given:** Repository missing .markdownlint.json
**When:** markdown-author skill loads for first time
**Then:** Skill creates .markdownlint.json with defaults
**And:** File contains line_length: 120
**And:** Subsequent markdown writing uses configuration

**Evidence:**

```bash
$ ls .markdownlint.json
ls: .markdownlint.json: No such file or directory

$ [Agent loads markdown-author skill]

$ ls .markdownlint.json
.markdownlint.json

$ cat .markdownlint.json
{
  "default": true,
  "MD013": {
    "line_length": 120,
    "code_blocks": false,
    "tables": false
  },
  ...
}
```

### GREEN Scenario 6: Custom dictionary term added

**Given:** markdown-author skill loaded
**When:** Agent writes "agentskills" (project term)
**Then:** Skill blocks with message: "Unknown word 'agentskills'. Add to cspell.json dictionary?"
**And:** Agent chooses "add to dictionary"
**And:** Skill updates cspell.json words array
**And:** Term accepted in future writes

**Evidence:**

```json
// Before
{
  "words": []
}

// After
{
  "words": ["agentskills"]
}
```

### GREEN Scenario 7: Multiple auto-fixes applied

**Given:** markdown-author skill loaded
**When:** Agent writes content with: long lines, h1→h3 jump, trailing spaces
**Then:** All issues auto-fixed silently
**And:** Summary logged:

```
✓ Markdown validated and auto-fixed:
  - Adjusted 2 lines exceeding 120 characters
  - Fixed heading hierarchy (h3 → h2)
  - Stripped trailing spaces (3 instances)
```

## PRESSURE Scenarios (Edge Cases)

### PRESSURE Scenario 1: Malformed configuration

**Given:** .markdownlint.json has invalid JSON (missing closing brace)
**When:** markdown-author skill loads
**Then:** Skill fails gracefully with clear error
**And:** Suggests fixing or deleting configuration
**And:** Falls back to basic validation (line length, code fences)

**Evidence:**

```
⚠ markdown-author skill error: Unable to parse .markdownlint.json
  Line 5: Unexpected end of JSON input

Fix syntax or delete file to regenerate.
Falling back to basic validation.
```

### PRESSURE Scenario 2: Very long code block

**Given:** Code block with 200-character lines
**When:** Writing with markdown-author skill
**Then:** Skill respects code_blocks: false setting
**And:** Does not break lines in code fence
**And:** Content written as-is

**Evidence:**

```markdown
```bash
# This command line is intentionally very long and exceeds 120 characters but should not be broken because it's in a code fence with code_blocks: false setting
npm install @very/long/package/name --save-dev --legacy-peer-deps --no-audit --no-fund --prefer-offline
```

```

### PRESSURE Scenario 3: Table formatting

**Given:** Table with 150-character rows
**When:** Writing with markdown-author skill
**Then:** Skill respects tables: false setting
**And:** Does not break table rows
**And:** Content written as-is

**Evidence:**
```markdown
| Column 1                          | Column 2                          | Column 3                          | Column 4                          |
| This row intentionally exceeds 120 characters to test that table rows are not broken when tables: false setting is configured | Value | Value | Value |
```

### PRESSURE Scenario 4: Multiple blocking violations

**Given:** Content has spelling error AND missing code fence language
**When:** Writing with markdown-author skill
**Then:** Skill blocks on first violation (spelling)
**And:** After fix, blocks on second violation (code fence)
**And:** Handles violations sequentially

**Evidence:**

```
⚠ Spelling error: 'architecure' → Fix
⚠ Code fence missing language → Add 'python'
✓ All violations resolved
```

### PRESSURE Scenario 5: Inline code spans with long lines

**Given:** Paragraph with inline code spans totaling 150 chars
**When:** Writing with markdown-author skill
**Then:** Skill breaks line at word boundaries
**And:** Preserves inline code span syntax
**And:** Line breaks occur outside code spans

**Evidence:**

```markdown
Original (155 chars):
The function `validateToken()` checks the JWT signature, while `verifyExpiration()` ensures the token hasn't expired and `checkPermissions()` validates access rights.

Auto-fixed:
The function `validateToken()` checks the JWT signature, while
`verifyExpiration()` ensures the token hasn't expired and
`checkPermissions()` validates access rights.
```

### PRESSURE Scenario 6: Spelling in code fences

**Given:** Code fence with language-specific keywords (csharp)
**When:** Writing with markdown-author skill
**Then:** Skill respects cspell language dictionaries
**And:** C# keywords (async, await, var) not flagged as spelling errors
**And:** Actual typos in comments still caught

**Evidence:**

```csharp
// This method recives data asynchronously
public async Task<string> GetDataAsync()
{
    var result = await httpClient.GetStringAsync(url);
    return result;
}
```

```
⚠ Spelling error in comment: 'recives' → receives
✓ C# keywords (async, await, var, Task) correctly recognized
```

### PRESSURE Scenario 7: Editing middle of document

**Given:** Agent edits section in middle of existing document
**When:** Adding new h2 heading between existing h2 and h3
**Then:** Skill analyzes full document structure
**And:** Auto-selects appropriate heading level (h2)
**And:** Maintains hierarchy throughout document

**Evidence:**

```markdown
Existing:
# Title
## Section 1
### Subsection

Agent adds between Section 1 and Subsection:
## New Section 2  ← Correctly identified as h2

Result maintains hierarchy:
# Title
## Section 1
## New Section 2
### Subsection
```

## Integration Scenarios

### Integration Scenario 1: Full workflow with skill

**Given:** New markdown file to create
**When:** Agent writes with markdown-author skill
**Then:** Configuration verified on first use
**And:** All formatting auto-fixed
**And:** Blocking violations prompted
**And:** Final content passes markdownlint-cli2
**And:** Final content passes cspell
**And:** Pre-commit hook passes without errors
**And:** Zero --no-verify bypasses needed

### Integration Scenario 2: Skill + pre-commit hooks

**Given:** markdown-author skill active
**When:** Agent writes markdown file
**And:** Commits changes
**Then:** Skill prevents violations during writing
**And:** Pre-commit hooks run as safety net
**And:** Both skill and hooks pass
**And:** No conflicts between skill fixes and hook expectations

### Integration Scenario 3: Mixed markdown sources

**Given:** Repository with skill-written and manually-written markdown
**When:** Pre-commit hooks run
**Then:** Skill-written markdown passes hooks
**And:** Manually-written markdown may fail hooks
**And:** Hooks catch what skill didn't see (manual edits)

## Success Criteria

The skill is successful when:

1. ✅ Zero MD013 violations in skill-written markdown
2. ✅ Zero MD040 violations in skill-written markdown
3. ✅ Zero MD001 violations in skill-written markdown
4. ✅ Zero cspell errors in skill-written markdown (or added to dictionary)
5. ✅ Configuration auto-created if missing
6. ✅ Auto-fixes logged in summary
7. ✅ Blocking prompts for structural decisions
8. ✅ Pre-commit hooks pass for skill-written markdown
9. ✅ --no-verify bypasses reduced to near-zero
