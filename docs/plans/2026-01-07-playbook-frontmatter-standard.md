# Playbook Frontmatter Standard Implementation Plan

**Issue:** #99
**Date:** 2026-01-07
**Status:** Draft

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

1. **Frontmatter Standard section** with required fields table
2. **Field specifications:**
   - `name`: kebab-case identifier (e.g., `incident-response`)
   - `description`: General context about what the playbook covers (1-2 sentences)
   - `summary`: Actionable process overview sufficient to apply without full read
   - `triggers`: YAML list of explicit conditions when playbook applies
3. **Trigger format guidance:**
   - Use lowercase, action-oriented phrases
   - Be specific enough for agents to pattern-match
   - Include common variations (e.g., "production incident" and "prod outage")
4. **Agent workflow guidance:**
   - When to read triggers vs full playbook
   - How to select between multiple matching playbooks
5. **Example playbook template** with all fields populated

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
- [ ] Documents `name` field with kebab-case format requirement
- [ ] Documents `description` field with context guidance
- [ ] Documents `summary` field with actionable format requirement
- [ ] Documents `triggers` field as YAML list with examples
- [ ] Includes trigger format guidance (lowercase, action-oriented)
- [ ] Provides agent workflow guidance (trigger matching, selection)
- [ ] Includes complete example playbook template

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
