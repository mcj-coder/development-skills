# Skill Structure Validation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan
> task-by-task.

**Goal:** Automate validation of skill structure to prevent regressions and ensure new skills meet
format requirements.

**Architecture:** Node.js validation script (matching repo conventions) that parses skill
directories, validates required files/sections/frontmatter, and reports errors with actionable
messages. Integrated into CI and available as npm script.

**Tech Stack:** Node.js (CommonJS for consistency with existing scripts), fs/path standard library

---

## Task 1: Create Validation Script Foundation

Files:

- Create: `scripts/validate-skill-structure.cjs`

### Step 1.1: Create script with skill directory enumeration

```javascript
#!/usr/bin/env node
/**
 * Skill Structure Validation Script
 *
 * Validates that all skills in the repository follow the structure
 * defined in docs/SKILL-FORMAT.md.
 *
 * @see docs/SKILL-FORMAT.md
 * @see docs/retrospectives/2026-01-16-skills-repository-improvement-plan.md
 */

const fs = require("fs");
const path = require("path");

const SKILLS_DIR = path.join(__dirname, "..", "skills");

/**
 * @typedef {Object} ValidationError
 * @property {string} skill - Skill name
 * @property {string} file - File path relative to skill directory
 * @property {string} message - Error message
 * @property {number} [line] - Line number if applicable
 */

/**
 * Get all skill directories
 * @returns {string[]} Array of skill directory names
 */
function getSkillDirectories() {
  return fs
    .readdirSync(SKILLS_DIR, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => dirent.name)
    .sort();
}

/**
 * Main entry point
 */
function main() {
  const skills = getSkillDirectories();
  console.log(`Validating ${skills.length} skills...\n`);

  /** @type {ValidationError[]} */
  const errors = [];

  for (const skill of skills) {
    const skillErrors = validateSkill(skill);
    errors.push(...skillErrors);
  }

  if (errors.length === 0) {
    console.log(`\n✓ All ${skills.length} skills passed validation`);
    process.exit(0);
  } else {
    console.log(`\n✗ Found ${errors.length} validation errors:\n`);
    for (const error of errors) {
      const location = error.line ? `:${error.line}` : "";
      console.log(
        `  ${error.skill}/${error.file}${location}: ${error.message}`,
      );
    }
    process.exit(1);
  }
}

/**
 * Validate a single skill directory
 * @param {string} skillName - Name of the skill directory
 * @returns {ValidationError[]} Array of validation errors
 */
function validateSkill(skillName) {
  // TODO: Implement in subsequent tasks
  return [];
}

main();
```

### Step 1.2: Run script to verify it enumerates skills

Run: `node scripts/validate-skill-structure.cjs`

Expected: Output showing "Validating 55 skills..." and "All 55 skills passed validation"

### Step 1.3: Commit foundation

```bash
git add scripts/validate-skill-structure.cjs
git commit -m "feat(scripts): add skill structure validation foundation

Refs: #388"
```

---

## Task 2: Add Required File Validation

Files:

- Modify: `scripts/validate-skill-structure.cjs`

### Step 2.1: Add file existence checks

Add after `validateSkill` function stub:

```javascript
/**
 * Validate a single skill directory
 * @param {string} skillName - Name of the skill directory
 * @returns {ValidationError[]} Array of validation errors
 */
function validateSkill(skillName) {
  const skillDir = path.join(SKILLS_DIR, skillName);
  /** @type {ValidationError[]} */
  const errors = [];

  // Required: SKILL.md
  const skillMdPath = path.join(skillDir, "SKILL.md");
  if (!fs.existsSync(skillMdPath)) {
    errors.push({
      skill: skillName,
      file: "SKILL.md",
      message: "Missing required file SKILL.md",
    });
  }

  // Required: *.test.md (at least one)
  const testFiles = fs
    .readdirSync(skillDir)
    .filter((f) => f.endsWith(".test.md"));
  if (testFiles.length === 0) {
    errors.push({
      skill: skillName,
      file: "*.test.md",
      message: "Missing required test file (*.test.md)",
    });
  }

  // Conditional: references/README.md if references/ exists
  const refsDir = path.join(skillDir, "references");
  if (fs.existsSync(refsDir) && fs.statSync(refsDir).isDirectory()) {
    const refsReadme = path.join(refsDir, "README.md");
    if (!fs.existsSync(refsReadme)) {
      errors.push({
        skill: skillName,
        file: "references/README.md",
        message: "Missing README.md in references/ directory",
      });
    }
  }

  // Continue to section validation if SKILL.md exists
  if (fs.existsSync(skillMdPath)) {
    const content = fs.readFileSync(skillMdPath, "utf-8");
    errors.push(...validateSkillContent(skillName, content));
  }

  return errors;
}

/**
 * Validate SKILL.md content
 * @param {string} skillName - Name of the skill
 * @param {string} content - Content of SKILL.md
 * @returns {ValidationError[]} Array of validation errors
 */
function validateSkillContent(skillName, content) {
  // TODO: Implement in subsequent tasks
  return [];
}
```

### Step 2.2: Run script to verify file validation works

Run: `node scripts/validate-skill-structure.cjs`

Expected: Output showing validation passing (all skills have required files)

### Step 2.3: Commit file validation

```bash
git add scripts/validate-skill-structure.cjs
git commit -m "feat(scripts): add required file validation

Validates SKILL.md, *.test.md, and references/README.md existence.

Refs: #388"
```

---

## Task 3: Add Frontmatter Validation

Files:

- Modify: `scripts/validate-skill-structure.cjs`

### Step 3.1: Add frontmatter parsing and validation

Replace `validateSkillContent` function:

```javascript
/**
 * Validate SKILL.md content (frontmatter and sections)
 * @param {string} skillName - Name of the skill
 * @param {string} content - Content of SKILL.md
 * @returns {ValidationError[]} Array of validation errors
 */
function validateSkillContent(skillName, content) {
  /** @type {ValidationError[]} */
  const errors = [];
  const lines = content.split("\n");

  // Parse frontmatter
  const frontmatter = parseFrontmatter(content);

  // Required frontmatter: name
  if (!frontmatter.name) {
    errors.push({
      skill: skillName,
      file: "SKILL.md",
      message: "Missing required frontmatter field: name",
      line: 1,
    });
  } else if (frontmatter.name !== skillName) {
    errors.push({
      skill: skillName,
      file: "SKILL.md",
      message: `Frontmatter 'name' (${frontmatter.name}) does not match directory name (${skillName})`,
      line: frontmatter.nameLine,
    });
  }

  // Required frontmatter: description
  if (!frontmatter.description) {
    errors.push({
      skill: skillName,
      file: "SKILL.md",
      message: "Missing required frontmatter field: description",
      line: 1,
    });
  }

  // Validate required sections
  errors.push(...validateRequiredSections(skillName, lines));

  return errors;
}

/**
 * Parse YAML frontmatter from markdown content
 * @param {string} content - Markdown content
 * @returns {{name?: string, nameLine?: number, description?: string, descriptionLine?: number}}
 */
function parseFrontmatter(content) {
  const lines = content.split("\n");
  const result = {};

  if (lines[0] !== "---") {
    return result;
  }

  let endIndex = -1;
  for (let i = 1; i < lines.length; i++) {
    if (lines[i] === "---") {
      endIndex = i;
      break;
    }
  }

  if (endIndex === -1) {
    return result;
  }

  // Simple YAML parsing for name and description
  for (let i = 1; i < endIndex; i++) {
    const line = lines[i];
    const nameMatch = line.match(/^name:\s*(.+)/);
    if (nameMatch) {
      result.name = nameMatch[1].trim();
      result.nameLine = i + 1; // 1-indexed
    }
    const descMatch = line.match(/^description:\s*(.+)/);
    if (descMatch) {
      result.description = descMatch[1].trim();
      result.descriptionLine = i + 1;
    }
  }

  return result;
}

/**
 * Validate required sections exist in SKILL.md
 * @param {string} skillName - Name of the skill
 * @param {string[]} lines - Lines of SKILL.md
 * @returns {ValidationError[]} Array of validation errors
 */
function validateRequiredSections(skillName, lines) {
  // TODO: Implement in next task
  return [];
}
```

### Step 3.2: Run script to verify frontmatter validation works

Run: `node scripts/validate-skill-structure.cjs`

Expected: All skills pass (frontmatter is valid across all skills)

### Step 3.3: Commit frontmatter validation

```bash
git add scripts/validate-skill-structure.cjs
git commit -m "feat(scripts): add frontmatter validation

Validates name and description fields, ensures name matches directory.

Refs: #388"
```

---

## Task 4: Add Required Section Validation

Files:

- Modify: `scripts/validate-skill-structure.cjs`

### Step 4.1: Add section validation

Replace `validateRequiredSections` function:

```javascript
/**
 * Validate required sections exist in SKILL.md
 * @param {string} skillName - Name of the skill
 * @param {string[]} lines - Lines of SKILL.md
 * @returns {ValidationError[]} Array of validation errors
 */
function validateRequiredSections(skillName, lines) {
  /** @type {ValidationError[]} */
  const errors = [];

  // Required sections per SKILL-FORMAT.md
  const requiredSections = [
    { pattern: /^## Overview$/i, name: "Overview" },
    { pattern: /^## When to Use$/i, name: "When to Use" },
    { pattern: /^## Core Workflow$/i, name: "Core Workflow" },
  ];

  for (const section of requiredSections) {
    const lineIndex = lines.findIndex((line) => section.pattern.test(line));
    if (lineIndex === -1) {
      errors.push({
        skill: skillName,
        file: "SKILL.md",
        message: `Missing required section: ## ${section.name}`,
      });
    }
  }

  return errors;
}
```

### Step 4.2: Run script to verify section validation works

Run: `node scripts/validate-skill-structure.cjs`

Expected: All 55 skills pass validation

### Step 4.3: Commit section validation

```bash
git add scripts/validate-skill-structure.cjs
git commit -m "feat(scripts): add required section validation

Validates Overview, When to Use, and Core Workflow sections exist.

Refs: #388"
```

---

## Task 5: Add npm Script

Files:

- Modify: `package.json`

### Step 5.1: Add validate:skills script to package.json

In `package.json`, add to the "scripts" section:

```json
"validate:skills": "node scripts/validate-skill-structure.cjs"
```

### Step 5.2: Run npm script to verify it works

Run: `npm run validate:skills`

Expected: Output showing all 55 skills passed validation

### Step 5.3: Commit npm script

```bash
git add package.json
git commit -m "feat(package): add validate:skills npm script

Refs: #388"
```

---

## Task 6: Add CI Job

Files:

- Modify: `.github/workflows/ci.yml`

### Step 6.1: Add skill-validation job to CI workflow

Add after the `lint` job in ci.yml:

```yaml
skill-validation:
  name: Skill Structure Validation
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: "20"
        cache: "npm"

    - name: Install dependencies
      run: npm ci

    - name: Validate skill structure
      run: npm run validate:skills
```

### Step 6.2: Run lint to verify workflow syntax

Run: `npm run lint`

Expected: All checks pass

### Step 6.3: Commit CI job

```bash
git add .github/workflows/ci.yml
git commit -m "feat(ci): add skill structure validation job

Validates all skills have required files, frontmatter, and sections.

Refs: #388"
```

---

## Task 7: Final Verification and Documentation

Files:

- Modify: Issue #388 (add evidence)

### Step 7.1: Run full validation

Run: `npm run validate:skills`

Expected: "All 55 skills passed validation"

### Step 7.2: Run lint to ensure all changes are valid

Run: `npm run lint`

Expected: All checks pass

### Step 7.3: Update issue with evidence

Add comment to issue #388 with:

- Screenshot/output of `npm run validate:skills` passing
- Link to CI workflow file changes

### Step 7.4: Create PR

```bash
git push -u origin feat/skill-structure-validation
gh pr create --title "feat: Add skill structure validation script and CI job" --body "$(cat <<'EOF'
## Summary

Implements the structure validation automation recommended in the retrospective.

- Adds `scripts/validate-skill-structure.cjs` to validate skill structure
- Validates: SKILL.md exists, test file exists, frontmatter fields, required sections
- Adds `npm run validate:skills` script
- Adds CI job to enforce validation on PRs

## Issues

- Closes #388

## Test Plan

- [ ] `npm run validate:skills` passes for all 55 skills
- [ ] `npm run lint` passes
- [ ] CI passes

## Verification

- Validation output: [link to issue comment]
- CI run: [link to PR checks]
EOF
)"
```

---

## Summary

| Task | Description                   | Files                                |
| ---- | ----------------------------- | ------------------------------------ |
| 1    | Create script foundation      | scripts/validate-skill-structure.cjs |
| 2    | Add file existence validation | scripts/validate-skill-structure.cjs |
| 3    | Add frontmatter validation    | scripts/validate-skill-structure.cjs |
| 4    | Add section validation        | scripts/validate-skill-structure.cjs |
| 5    | Add npm script                | package.json                         |
| 6    | Add CI job                    | .github/workflows/ci.yml             |
| 7    | Final verification and PR     | Issue #388, PR                       |
