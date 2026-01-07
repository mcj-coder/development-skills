# Playbook Frontmatter Standard Implementation Plan

**Issue:** #99
**Date:** 2026-01-07
**Status:** Draft (Rev 2 - addressing review feedback)

## Overview

Establish YAML frontmatter standard for playbook documents that enables agents to identify
and apply relevant processes based on explicit triggers. This follows the pattern
established in #97 (roles) and #98 (ADRs).

## Scope

### In Scope

- Define YAML frontmatter schema for playbooks
- Create `docs/playbooks/` directory structure
- Document frontmatter specification in `docs/playbooks/README.md`
- Provide example playbook template

### Out of Scope

- Creating actual playbooks (future work)
- Automated trigger matching tooling
- Playbook execution validation

## Implementation Tasks

### Task 1: Create Playbooks Directory and README

Create `docs/playbooks/README.md` documenting:

1. **Frontmatter Standard section** with required fields table and canonical field order:
   `name` → `description` → `summary` → `triggers`

2. **Field specifications with clear distinctions:**
   - `name`: kebab-case identifier (e.g., `incident-response`)
   - `description`: What this playbook covers (context, not action). 1-2 sentences.
   - `summary`: Actionable step-by-step overview. Must contain all critical steps
     so agents can execute using only summary. Format: numbered/bulleted steps.
   - `triggers`: YAML list of explicit conditions when playbook applies

3. **Trigger format guidance with pattern matching rules:**
   - Lowercase with spaces, present tense (e.g., "production incident detected")
   - Include synonym variations (e.g., "prod outage", "service down")
   - Matching rule: case-insensitive substring matching against context
   - Anti-patterns: "help" (too vague), "something wrong" (not specific)

4. **Agent workflow guidance (progressive disclosure):**
   - Step 1: Scan all playbook triggers
   - Step 2: Load summaries for matches
   - Step 3: Select most applicable (see conflict resolution)
   - Step 4: Execute from summary
   - Step 5: Load full body only if summary references details needed

5. **Conflict resolution for multiple matching playbooks:**
   - Most specific trigger wins
   - If tie, prefer more recent playbook
   - Agents may apply multiple non-conflicting playbooks sequentially

6. **Additional sections (matching roles/ADRs pattern):**
   - Playbook Index (empty initially, with guidance on maintaining)
   - Creating New Playbooks (when to create, quick reference steps)
   - Validation (pre-commit hooks, CI, manual)
   - Troubleshooting (common issues and resolutions)

7. **Example playbook template** with all fields populated, plus good/bad examples

**Deliverable:** `docs/playbooks/README.md`

### Task 2: Run Linting Validation

1. Run `npm run lint` to validate YAML and markdown
2. Fix any formatting issues
3. Verify markdown structure intact

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                             | Task   |
| ----------------------------------------------- | ------ |
| Frontmatter schema documented in README         | Task 1 |
| `docs/playbooks/` directory created with README | Task 1 |
| `triggers` field is YAML list format            | Task 1 |
| `summary` field contains actionable overview    | Task 1 |
| Example playbook template provided              | Task 1 |
| Frontmatter specification is valid YAML         | Task 2 |

## BDD Verification Checklist

### Task 1: Playbooks README Creation

- [ ] `docs/playbooks/` directory exists
- [ ] README.md exists at `docs/playbooks/README.md`
- [ ] Contains Frontmatter Standard section with required fields table
- [ ] Specifies canonical field order: name → description → summary → triggers
- [ ] Documents `name` field with kebab-case format requirement
- [ ] Documents `description` field (context, not action)
- [ ] Documents `summary` field (actionable steps, executable from summary alone)
- [ ] Documents `triggers` field as YAML list with examples
- [ ] Includes trigger format guidance (lowercase, present tense, anti-patterns)
- [ ] Includes trigger matching rules (case-insensitive substring)
- [ ] Provides agent workflow guidance (5-step progressive disclosure)
- [ ] Documents conflict resolution rules for multiple matches
- [ ] Includes Playbook Index section (empty with guidance)
- [ ] Includes Creating New Playbooks section
- [ ] Includes Validation section
- [ ] Includes Troubleshooting section
- [ ] Includes complete example template with good/bad examples

### Task 2: Validation

- [ ] `npm run lint` passes with no errors
- [ ] No YAML parsing errors
- [ ] Markdown structure valid

## Review Personas

| Phase          | Reviewers                                      | Focus                                 |
| -------------- | ---------------------------------------------- | ------------------------------------- |
| Refinement     | Documentation Specialist, Agent Skill Engineer | Schema clarity, agent usability       |
| Implementation | Documentation Specialist, Agent Skill Engineer | Content quality, frontmatter validity |
| Approval       | Tech Lead                                      | Standards compliance, completeness    |

## Evidence Requirements

- Commit SHAs for each task completion
- File links to created/modified files
- Lint output showing clean build
- Review comments linked in issue thread

## Review Feedback Addressed (Rev 2)

### Documentation Specialist Feedback

| Issue                                  | Resolution                                                     |
| -------------------------------------- | -------------------------------------------------------------- |
| C1: description vs summary unclear     | Added clear distinction: context vs actionable steps           |
| C2: Missing field ordering             | Added canonical order: name → description → summary → triggers |
| I1: Missing validation section         | Added to required sections                                     |
| I2: No troubleshooting guidance        | Added to required sections                                     |
| I3: Agent workflow underspecified      | Added 5-step progressive disclosure workflow                   |
| I4: Missing index section              | Added Playbook Index requirement                               |
| I5: No creating new playbooks guidance | Added Creating New Playbooks section requirement               |

### Agent Skill Engineer Feedback

| Issue                                | Resolution                                             |
| ------------------------------------ | ------------------------------------------------------ |
| C1: Missing trigger pattern matching | Added matching rule: case-insensitive substring        |
| C2: No conflict resolution           | Added 3-rule conflict resolution                       |
| C3: Summary actionability unclear    | Clarified: must contain all critical steps, executable |
| I1: No integration with roles        | Deferred to future (optional field)                    |
| I2: No status field                  | Deferred to future (optional field)                    |
| I3: Progressive disclosure unclear   | Added explicit 5-step workflow                         |
| I4: No trigger granularity guidance  | Added present tense, anti-patterns guidance            |
