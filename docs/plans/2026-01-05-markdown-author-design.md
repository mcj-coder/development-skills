# Markdown Author Skill Design

**Date:** 2026-01-05
**Status:** Design
**Related Issue:** #63

## Goal

Create a markdown-author skill that proactively enforces markdown linting rules and spelling standards during writing, preventing violations before they're committed.

## Problem Statement

**Current state:** Markdown linting errors frequently occur in commits, requiring pre-commit hook bypasses (issue #56 tracks 69+ pre-existing errors). The repository has markdownlint and cspell configured with pre-commit hooks, but violations are discovered after writing (too late).

**Problem:**

- Linting violations discovered at commit time
- Developers/agents write markdown that violates rules
- Forces --no-verify bypasses
- 69+ pre-existing errors across 12 files
- Common errors: MD013 (line length), MD040 (code fence language), MD060 (table columns)

**Desired state:** A skill that guides markdown authoring with linting rules and spelling checks applied proactively during writing, preventing violations before they occur.

## Requirements

1. **Pre-write validation:** Apply rules BEFORE writing markdown content (git hooks remain as safety net)
2. **All validations:** Structure + format checks, respecting .markdownlint.json configuration
3. **Spelling validation:** Check spelling during writing, respect cspell language dictionaries for code fences
4. **Auto-fix when possible:** Formatting issues fixed automatically, block only for structural decisions
5. **Configuration verification:** Check for config files on first use, create with defaults if missing
6. **Respect configuration:** Read .markdownlint.json for enabled rules and parameters
7. **Language-aware spelling:** Respect cspell's language-specific dictionaries (C#, Python, etc.)

## Design

### Section 1: Overview & Skill Structure

**Skill Name:** `markdown-author`

**Purpose:** Proactively enforce markdown linting rules and spelling standards during writing, preventing violations before they're committed.

**Core Behavior:**

- **On first use:** Verify `.markdownlint.json` and `cspell.json` exist, create with defaults if missing
- **Before writing:** Validate markdown content against linting rules and spelling standards
- **Auto-fix:** Formatting issues (line length, whitespace, list markers)
- **Block:** Structural decisions (heading hierarchy context, code fence language)
- **Safety net:** Git hooks still run to catch non-skill markdown changes

**Configuration Loading:**

- Reads `.markdownlint.json` to determine enabled rules and settings
- Respects disabled rules (e.g., MD033: inline HTML, MD041: first-line heading)
- Reads `cspell.json` for locale, language settings, custom dictionary
- Fails gracefully with clear error if configs are malformed

**Integration Points:**

- Works with Write tool (pre-write validation)
- Works with Edit tool (validate changes)
- Complements pre-commit hooks (hooks catch what skill misses)

### Section 2: Validation Rules & Auto-Fix Behavior

**Rule Handling Strategy:**

The skill handles **ALL markdownlint rules** that are enabled in `.markdownlint.json`. The skill reads the configuration and:

1. **Applies only enabled rules** (respects `"rule": false` disables)
2. **Uses configured parameters** (e.g., `line_length: 120`)
3. **Categorizes each rule** as auto-fixable or blocking

**Auto-Fixable Rules (Formatting):**

- **MD001** - Heading hierarchy (auto-adjust levels)
  - Analyze existing document structure before adding new heading
  - Auto-select appropriate heading level:
    - New document: Start with h1
    - Existing document: Continue from last heading level appropriately
    - Sub-section: Use next level down (h2 under h1, h3 under h2, etc.)
  - Auto-adjust if agent attempts invalid jump (h1 → h3 becomes h1 → h2)
  - Maintain proper hierarchy without blocking

- **MD003** - Heading style consistency
- **MD004** - List style consistency
- **MD005** - List indentation
- **MD007** - Unordered list indentation
- **MD009** - Trailing spaces (strip automatically)
- **MD010** - Hard tabs (replace with spaces)
- **MD011** - Reversed link syntax
- **MD012** - Multiple consecutive blank lines (collapse to single)
- **MD013** - Line length
  - Read configured `line_length` from .markdownlint.json (default: 120)
  - Before writing paragraph, break lines intelligently at word boundaries
  - Respect `code_blocks: false` and `tables: false` (don't break these)
  - Preserve markdown formatting (lists, blockquotes, etc.)
- **MD014** - Dollar signs in shell commands
- **MD018-MD023** - Heading spacing rules
- **MD026** - Trailing punctuation in headings
- **MD027** - Multiple spaces after blockquote
- **MD028** - Blank line inside blockquote
- **MD030** - List marker spacing
- **MD031** - Fenced code blocks surrounded by blank lines
- **MD032** - Lists surrounded by blank lines
- **MD034** - Bare URLs (auto-convert to links)
- **MD037** - Spaces inside emphasis markers
- **MD038** - Spaces inside code spans
- **MD039** - Spaces inside link text
- **MD047** - Files should end with newline
- **MD049-MD050** - Emphasis/strong style consistency

**Blocking Rules (Requires Decision):**

- **MD024** - Duplicate headings
  - Respect `siblings_only: true` from config
  - Warn if duplicate heading at same level (if configured)
  - Only block if duplicates would break document navigation

- **MD040** - Fenced code language
  - Detect code fences without language specification
  - Block with message: "Code fence requires language. Options: bash, javascript, python, csharp, markdown, text, etc."
  - Agent must specify language

- **MD045** - Alt text for images (agent must provide)
- **MD051** - Link fragments (agent must fix broken anchors)
- **Spelling errors**
  - Check against cspell configuration
  - Block with message: "Unknown word 'xyz'. Add to cspell.json words list, or fix typo?"
  - Respect language-specific dictionaries in code fences

**Ignored Rules (Disabled in Config):**

- **MD033** - Inline HTML (already disabled in repository)
- **MD041** - First line heading (already disabled in repository)

**Implementation:**

- Skill dynamically reads `.markdownlint.json` on first use
- Builds rule set based on configuration
- Applies fixes or blocks based on rule category

### Section 3: Workflow Integration & Usage

**When Skill Activates:**

The skill is invoked when:

1. Agent is about to write a new `.md` file
2. Agent is about to edit an existing `.md` file
3. User explicitly requests markdown authoring

**Activation Pattern:**

```
Agent detects markdown writing task
  ↓
Load markdown-author skill (if not already loaded)
  ↓
First use? → Verify configurations
  ↓
Read .markdownlint.json (enabled rules, parameters)
  ↓
Read cspell.json (locale, custom dictionary)
  ↓
Compose markdown content with validation
  ↓
Auto-fix formatting rules
  ↓
Block and prompt for structural decisions
  ↓
Write validated markdown
  ↓
Git hooks run as safety net
```

**Configuration Verification (First Use Only):**

1. **Check for `.markdownlint.json`:**
   - If exists: Parse and validate JSON
   - If missing: Create with repository defaults:

     ```json
     {
       "default": true,
       "MD013": { "line_length": 120, "code_blocks": false, "tables": false },
       "MD024": { "siblings_only": true },
       "MD033": false,
       "MD041": false
     }
     ```

2. **Check for `cspell.json`:**
   - If exists: Parse and validate JSON
   - If missing: Create with sensible defaults:

     ```json
     {
       "version": "0.2",
       "language": "en-US",
       "words": [],
       "ignorePaths": ["node_modules/**", "package-lock.json"]
     }
     ```

3. **Validate configurations:**
   - Ensure markdownlint config is valid JSON
   - Ensure cspell config has required fields
   - Fail with clear error if malformed

**Integration with Write Tool:**

```
Before: Write(markdown_file, content)
After:
  1. Load markdown-author skill
  2. Validate content against rules
  3. Auto-fix formatting violations
  4. Block if structural decision needed
  5. Write(markdown_file, validated_content)
```

**Integration with Edit Tool:**

```
Before: Edit(markdown_file, old_string, new_string)
After:
  1. Load markdown-author skill
  2. Validate new_string against rules
  3. Auto-fix formatting in new_string
  4. Block if structural decision needed
  5. Edit(markdown_file, old_string, validated_new_string)
```

### Section 4: Error Handling & User Feedback

**Error Categories:**

**1. Configuration Errors:**

- **Malformed JSON:** "Error: .markdownlint.json is invalid JSON. Fix syntax or delete to regenerate."
- **Missing required fields:** "Error: cspell.json missing 'version' field. Add or delete to regenerate."
- **Invalid rule configuration:** "Warning: MD013.line_length must be a number. Using default: 120."

**2. Auto-Fixed Violations:**

- **Silent fixes (no interruption):**
  - Line length adjustments
  - Trailing space removal
  - Heading hierarchy adjustments
  - List spacing normalization
- **Log summary after writing:**

  ```
  ✓ Markdown validated and auto-fixed:
    - Adjusted 3 lines exceeding 120 characters
    - Fixed heading hierarchy (h3 → h2)
    - Normalized list spacing (2 instances)
  ```

**3. Blocking Violations (Require Input):**

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

**4. Spelling Suggestions:**

When unknown word detected:

- Check for common typos: "recieve" → "Did you mean: receive?"
- Suggest adding to dictionary if looks like technical term
- Show context: "Line 12: 'We use agentskills for automation'"

**5. Graceful Degradation:**

If skill encounters unexpected errors:

```
⚠ markdown-author skill error: Unable to parse .markdownlint.json
  Falling back to basic validation (line length, code fences only)

  Full linting will run in pre-commit hook.
  Consider fixing configuration: .markdownlint.json
```

**Feedback Principles:**

- **Clear and actionable:** Always suggest specific fixes
- **Context-aware:** Show surrounding lines for clarity
- **Non-intrusive:** Auto-fix silently when possible
- **Educational:** Explain why rules matter when blocking
- **Summarize:** Report all fixes after writing complete

### Section 5: BDD Test Scenarios

**RED Scenarios (Baseline - Without Skill):**

**Scenario 1: Line length violations written**

- **Given:** Agent writes markdown paragraph with 150-character lines
- **When:** Content written without markdown-author skill
- **Then:** Lines exceed 120 character limit
- **And:** Pre-commit hook fails with MD013 errors

**Scenario 2: Code fences missing language**

- **Given:** Agent writes code block without language specification
- **When:** Content written without markdown-author skill
- **Then:** Code fence has no language (```\n instead of```bash\n)
- **And:** Pre-commit hook fails with MD040 errors

**Scenario 3: Heading hierarchy violations**

- **Given:** Agent writes h1 followed immediately by h3
- **When:** Content written without markdown-author skill
- **Then:** Heading hierarchy skip occurs (h1 → h3)
- **And:** Pre-commit hook fails with MD001 errors

**Scenario 4: Spelling errors written**

- **Given:** Agent writes "recieve" instead of "receive"
- **When:** Content written without markdown-author skill
- **Then:** Misspelled word written to file
- **And:** Pre-commit hook fails with cspell errors

**GREEN Scenarios (With Skill):**

**Scenario 1: Line length auto-fixed**

- **Given:** markdown-author skill loaded
- **When:** Agent composes 150-character line
- **Then:** Skill breaks line at 115 characters (word boundary before 120)
- **And:** Written content has proper line breaks
- **And:** Pre-commit hook passes

**Scenario 2: Code fence language prompted**

- **Given:** markdown-author skill loaded
- **When:** Agent attempts to write code fence without language
- **Then:** Skill blocks with message: "Code fence requires language. Options: bash, javascript, python, csharp, text, etc."
- **And:** Agent specifies "bash"
- **And:** Written content has ```bash
- **And:** Pre-commit hook passes

**Scenario 3: Heading hierarchy auto-corrected**

- **Given:** markdown-author skill loaded with existing h1 heading
- **When:** Agent attempts to write h3 heading next
- **Then:** Skill auto-adjusts to h2
- **And:** Written content has proper hierarchy (h1 → h2)
- **And:** Pre-commit hook passes

**Scenario 4: Spelling error caught and fixed**

- **Given:** markdown-author skill loaded with cspell.json
- **When:** Agent writes "recieve"
- **Then:** Skill blocks with message: "Spelling error: 'recieve'. Did you mean: 'receive'?"
- **And:** Agent corrects to "receive"
- **And:** Written content has correct spelling
- **And:** Pre-commit hook passes

**Scenario 5: Configuration auto-created**

- **Given:** Repository missing .markdownlint.json
- **When:** markdown-author skill loads for first time
- **Then:** Skill creates .markdownlint.json with defaults
- **And:** File contains line_length: 120
- **And:** Subsequent markdown writing uses configuration

**Scenario 6: Custom dictionary term added**

- **Given:** markdown-author skill loaded
- **When:** Agent writes "agentskills" (project term)
- **Then:** Skill blocks with message: "Unknown word 'agentskills'. Add to cspell.json dictionary?"
- **And:** Agent chooses "add to dictionary"
- **And:** Skill updates cspell.json words array
- **And:** Term accepted in future writes

**PRESSURE Scenarios (Edge Cases):**

**Scenario 1: Malformed configuration**

- **Given:** .markdownlint.json has invalid JSON
- **When:** markdown-author skill loads
- **Then:** Skill fails gracefully with clear error
- **And:** Suggests fixing or deleting configuration
- **And:** Falls back to basic validation

**Scenario 2: Very long code block**

- **Given:** Code block with 200-character lines
- **When:** Writing with markdown-author skill
- **Then:** Skill respects code_blocks: false setting
- **And:** Does not break lines in code fence
- **And:** Content written as-is

**Scenario 3: Table formatting**

- **Given:** Table with 150-character rows
- **When:** Writing with markdown-author skill
- **Then:** Skill respects tables: false setting
- **And:** Does not break table rows
- **And:** Content written as-is

**Scenario 4: Multiple blocking violations**

- **Given:** Content has spelling error AND missing code fence language
- **When:** Writing with markdown-author skill
- **Then:** Skill blocks on first violation (spelling)
- **And:** After fix, blocks on second violation (code fence)
- **And:** Handles violations sequentially

### Section 6: Implementation Considerations

**Technical Architecture:**

**Skill Components:**

1. **Configuration Loader**
   - Reads and parses `.markdownlint.json`
   - Reads and parses `cspell.json`
   - Validates configuration on first use
   - Caches configuration for session

2. **Rule Engine**
   - Dynamically loads enabled rules from configuration
   - Categorizes rules as auto-fixable vs blocking
   - Applies rule-specific logic and parameters
   - Maintains rule state during validation

3. **Auto-Fixer**
   - Line length breaker (word-boundary aware)
   - Heading hierarchy adjuster (analyzes document structure)
   - Whitespace normalizer
   - List/blockquote formatter
   - Emphasis/link syntax corrector

4. **Validator & Blocker**
   - Code fence language detector
   - Spelling checker (integrates with cspell)
   - Duplicate heading detector
   - Link fragment validator
   - Generates actionable error messages

5. **Configuration Generator**
   - Creates `.markdownlint.json` if missing
   - Creates `cspell.json` if missing
   - Uses repository-appropriate defaults
   - Preserves existing configurations

**Dependencies:**

- **markdownlint-cli2:** Already installed (validates against rules)
- **cspell:** Already installed (spelling validation)
- **Node.js packages.json:** Configurations already in place
- **Git hooks (lint-staged):** Already configured as safety net

**Performance Considerations:**

1. **Configuration caching:** Load config once per session, not per file
2. **Incremental validation:** Validate content as composed, not all at once
3. **Lazy rule loading:** Only instantiate rules that are enabled
4. **Efficient line breaking:** Use regex for word boundaries, avoid character-by-character
5. **Spelling cache:** Leverage cspell's internal caching for repeated words

**Implementation Challenges:**

1. **Line length with complex markdown:**
   - Lists with long items
   - Inline links with long URLs
   - Code spans within prose
   - **Solution:** Break at word boundaries, preserve markdown syntax

2. **Heading hierarchy in partial edits:**
   - Agent edits middle of document
   - Must analyze surrounding context
   - **Solution:** Read full document structure before validation

3. **Spelling in code fences:**
   - Language keywords shouldn't be flagged
   - Variable names may look like typos
   - **Solution:** Respect cspell's language-specific dictionaries

4. **Configuration conflicts:**
   - .markdownlint.json may have incompatible rules
   - User settings may override project settings
   - **Solution:** Project config takes precedence, warn on conflicts

**Limitations:**

1. **Cannot fix all MD040 violations automatically** (needs language decision)
2. **Cannot auto-generate alt text for images** (MD045 needs context)
3. **May break intentionally long lines** in edge cases (can be disabled per-line with <!-- markdownlint-disable -->)
4. **Spelling suggestions may miss domain-specific terms** (requires dictionary updates)

**Integration with Existing Workflow:**

- **Complements pre-commit hooks:** Skill catches during writing, hooks catch during commit
- **Respects .markdownlint-cli2.yaml:** Configuration hierarchy maintained
- **Works with prettier:** Skill runs before prettier formatting
- **Compatible with --no-verify bypasses:** Agents still benefit from skill even if hooks bypassed

## Success Criteria

The design is successful when:

1. ✅ Zero MD013 line length violations in skill-written markdown
2. ✅ Zero MD040 code fence language violations in skill-written markdown
3. ✅ Zero MD001 heading hierarchy violations in skill-written markdown
4. ✅ Zero cspell errors in skill-written markdown (or added to dictionary)
5. ✅ Configuration files auto-created if missing
6. ✅ Auto-fixes applied silently for formatting rules
7. ✅ Blocking prompts for structural decisions
8. ✅ Pre-commit hooks pass for skill-written markdown
9. ✅ Reduces --no-verify bypasses to near-zero

## Open Questions

None - design is ready for review.

## Next Steps

1. Get design approval
2. Create implementation plan with sub-tasks
3. Implement skill spec following agentskills.io format
4. Create BDD test file
5. Test with real markdown writing scenarios
