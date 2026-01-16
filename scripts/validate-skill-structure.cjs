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

main();
