# Automated Standards Enforcement - Implementation Plan

**Issue:** #3
**Goal:** Create foundational P0 skill for automated quality enforcement
(linting, spelling, tests, SAST, security) that applies by default to all repos
**Status:** Planning (Refinement)

## BDD Checklist (RED to GREEN)

### Baseline (RED - must fail initially) to GREEN (Implementation Complete)

- [ ] Skill exists at `skills/automated-standards-enforcement/SKILL.md`
- [ ] BDD tests exist at `skills/automated-standards-enforcement/automated-standards-enforcement.test.md`
- [ ] SKILL.md has YAML frontmatter with name and description (CSO compliant)
- [ ] Main SKILL.md is under 300 words (progressive loading)
- [ ] References folder contains:
  - [ ] `references/tool-comparison.md`
  - [ ] `references/language-configs.md`
  - [ ] `references/ide-integration.md`
  - [ ] `references/git-hooks-setup.md`
  - [ ] `references/ci-configuration.md`
- [ ] Skill references `superpowers:verification-before-completion`
- [ ] Skill references `superpowers:test-driven-development`
- [ ] Default application (P0 foundational) documented
- [ ] Opt-out mechanism documented
- [ ] Clean build policy (zero warnings) defined
- [ ] Brownfield support (baseline existing violations) documented
- [ ] Cross-platform tooling (VS Code, Rider, Visual Studio) referenced
- [ ] README.md lists automated-standards-enforcement skill

### RED Verification (Before Implementation)

Run these checks to confirm baseline failures:

```bash
# Check skill doesn't exist
ls skills/automated-standards-enforcement/SKILL.md  # Should fail
ls skills/automated-standards-enforcement/automated-standards-enforcement.test.md  # Should fail

# Check README doesn't mention skill
grep "automated-standards-enforcement" README.md  # Should return nothing
```

## Task Breakdown (TDD Methodology)

### Task 1: Create BDD Test File (RED Baseline)

**File:** `skills/automated-standards-enforcement/automated-standards-enforcement.test.md`

**Content:**

- RED scenarios: Pressure scenarios from issue specification
  - Time Constraint + New Project
  - Sunk Cost + Messy Codebase
  - Authority + Production Rush
- GREEN scenarios: Expected behaviour with skill present
  - New Repository with Full Standards
  - Brownfield - Adding Standards to Existing Repo
  - Cross-Platform Team with IDE Integration
- Pressure scenarios with rationalizations

**Acceptance Criteria:**

- [ ] RED scenarios describe baseline failures with rationalizations
- [ ] GREEN scenarios describe expected behaviour
- [ ] Evidence checklists included
- [ ] Brownfield approach validated

### Task 2: Create Main SKILL.md (<300 words)

**File:** `skills/automated-standards-enforcement/SKILL.md`

**Content:**

- YAML frontmatter (CSO compliant - description with triggering conditions only)
- Overview: Purpose and default application
- When to Use: Trigger conditions from issue
- Opt-Out Rule: Explicit refusal mechanism
- Required Superpowers References
- Core Workflow (high-level - details in references)
- Quick Reference Table (standard to tool mapping)
- Clean Build Policy
- Brownfield Approach (brief)
- Red Flags list
- Cross-references to detailed references

**Token Budget:**

- Target: <300 words
- Heavy details moved to references/

**Acceptance Criteria:**

- [ ] Under 300 words
- [ ] YAML frontmatter CSO compliant
- [ ] Core workflow documented
- [ ] References superpowers skills
- [ ] Clean build policy stated
- [ ] Brownfield approach mentioned (details in references)

### Task 3: Create Tool Comparison Reference

**File:** `skills/automated-standards-enforcement/references/tool-comparison.md`

**Content:**

- Linting tools by language (ESLint, Pylint, Ruff, dotnet-format)
- Formatting tools (Prettier, Black, dotnet-format)
- Spelling tools (cspell, typos)
- Security tools (SAST, dependency scanning)
- Selection criteria for each category

**Acceptance Criteria:**

- [ ] Covers major language ecosystems
- [ ] Includes selection criteria
- [ ] Preference for cross-platform tools noted

### Task 4: Create Language Configs Reference

**File:** `skills/automated-standards-enforcement/references/language-configs.md`

**Content:**

- TypeScript/JavaScript configuration examples
- Python configuration examples
- .NET configuration examples
- Configuration file patterns (prefer files over CLI flags)

**Acceptance Criteria:**

- [ ] Config examples for 3+ ecosystems
- [ ] File-based configuration preferred
- [ ] Integration with IDEs mentioned

### Task 5: Create IDE Integration Reference

**File:** `skills/automated-standards-enforcement/references/ide-integration.md`

**Content:**

- VS Code extensions and settings
- JetBrains Rider settings
- Visual Studio analyzers
- EditorConfig for cross-IDE consistency

**Acceptance Criteria:**

- [ ] VS Code covered
- [ ] Rider covered
- [ ] Visual Studio covered
- [ ] EditorConfig explained

### Task 6: Create Git Hooks Setup Reference

**File:** `skills/automated-standards-enforcement/references/git-hooks-setup.md`

**Content:**

- Husky setup (Node projects)
- Husky.Net setup (.NET projects)
- pre-commit framework (Python)
- lint-staged configuration
- Staged-only checks for fast feedback

**Acceptance Criteria:**

- [ ] Multiple hook frameworks covered
- [ ] lint-staged explained
- [ ] Cross-platform considerations noted

### Task 7: Create CI Configuration Reference

**File:** `skills/automated-standards-enforcement/references/ci-configuration.md`

**Content:**

- GitHub Actions examples
- Azure Pipelines examples
- GitLab CI examples
- Full validation vs local (staged-only)
- Clean build enforcement in CI

**Acceptance Criteria:**

- [ ] 3+ CI platforms covered
- [ ] Full vs local validation explained
- [ ] Clean build enforcement shown

### Task 8: Update README.md

**File:** `README.md`

**Changes:**

- Add `automated-standards-enforcement` to skills list
- Description: "P0 foundational skill - automated quality enforcement for all repos"

**Acceptance Criteria:**

- [ ] Skill listed in README.md
- [ ] Clear description with P0 priority noted

### Task 9: Run Linting and Validation

**Commands:**

```bash
npm run lint
```

**Acceptance Criteria:**

- [ ] All linting checks pass
- [ ] No markdownlint errors
- [ ] No spelling errors (cspell)

### Task 10: Verify BDD Checklist GREEN

**Process:**

- Go through each BDD checklist item
- Mark as complete with evidence
- Link to specific files, lines, commits

**Acceptance Criteria:**

- [ ] All BDD items marked complete
- [ ] Evidence provided for each item

## Key Design Decisions

### Progressive Loading Strategy

**Main SKILL.md (<300 words):**

- Core workflow (identify standards, map tools, define enforcement points)
- Quick reference table (standard to tool mapping)
- Clean build policy and exception handling
- Common mistakes and red flags

**references/ folder (on-demand):**

- tool-comparison.md - Comprehensive tool comparison
- language-configs.md - Language-specific configurations
- ide-integration.md - VS Code, Rider, Visual Studio setup
- git-hooks-setup.md - Husky, lint-staged, pre-commit
- ci-configuration.md - GitHub Actions, Azure Pipelines, GitLab CI

### Required Superpowers References

- `superpowers:verification-before-completion` - Verify all checks pass before completion
- `superpowers:test-driven-development` - Unit test standards

### Cross-References

- architecture-testing - Structural validation
- static-analysis-security - Security-specific tooling
- quality-gate-enforcement - CI pipeline integration
- documentation-as-code - Documentation linting

### Clean Build Policy

Zero warnings/errors required. Exceptions documented in `docs/known-issues.md`.

### Brownfield Approach

1. Baseline existing violations
2. Document in docs/known-issues.md
3. Enforce on new/modified code only
4. Incremental remediation plan

## Commit Strategy

Following Conventional Commits:

1. `feat(skill): add automated-standards-enforcement BDD tests`
2. `feat(skill): create automated-standards-enforcement skill`
3. `feat(skill): add tool-comparison reference`
4. `feat(skill): add language-configs reference`
5. `feat(skill): add ide-integration reference`
6. `feat(skill): add git-hooks-setup reference`
7. `feat(skill): add ci-configuration reference`
8. `docs(readme): add automated-standards-enforcement to skills list`
9. `docs(plan): update BDD checklist with evidence`

## Risk Mitigation

**Risk:** Skill too verbose for <300 word target
**Mitigation:** Move all detailed content to references, keep main skill as workflow overview only

**Risk:** Tooling recommendations become outdated
**Mitigation:** Focus on patterns (linting, formatting, spelling) not specific tool versions

**Risk:** Brownfield approach unclear
**Mitigation:** Clear baseline process documented with example docs/known-issues.md template

## Success Criteria

When complete:

- [ ] Agents apply automated-standards-enforcement by default to all repos
- [ ] Clean build policy enforced (zero warnings)
- [ ] Brownfield repos get baseline + incremental remediation
- [ ] Cross-platform tooling works across VS Code, Rider, Visual Studio
- [ ] Progressive loading keeps main skill under 300 words
- [ ] Required superpowers skills are referenced (DRY)
