# Persona-Switching Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Create a skill that enables multi-identity Git/GitHub workflows with
role-specific personas.

**Architecture:** Skill provides setup flow for target repos (generates playbook
and shell config) and runtime guidance for persona switching during
issue-driven-delivery phases. Templates use placeholder variables replaced
during setup.

**Tech Stack:** Markdown (SKILL.md), Bash (shell templates), YAML (frontmatter)

**Issue:** #153
**Design:** [2026-01-08-persona-switching-design.md](2026-01-08-persona-switching-design.md)

## Review Resolutions

Specialist reviews identified the following issues to address:

| ID     | Priority  | Issue                           | Resolution                  |
| ------ | --------- | ------------------------------- | --------------------------- |
| SEC-C1 | Critical  | No credential storage guidance  | Add Security Considerations |
| ASE-I1 | Important | Missing skill announcement      | Add to SKILL.md overview    |
| SEC-I2 | Important | File permissions not specified  | Add chmod 600 to setup      |
| TA-I1  | Important | Bootstrap integration undefined | Create follow-up ticket     |
| TA-I2  | Important | Windows support unclear         | Document bash-only scope    |

## Task 1: Create BDD Test File

**Files:** `skills/persona-switching/persona-switching.test.md`

Create BDD test file with RED scenarios (baseline failures) and GREEN scenarios
(expected behaviour). Include verification checklist for skill structure.

**Deliverable:** Test file with RED/GREEN scenarios following repo test patterns.

## Task 2: Create SKILL.md Main Specification

**Files:** `skills/persona-switching/SKILL.md`

Create main skill specification with:

- Frontmatter (name, description)
- Overview with skill announcement pattern (ASE-I1)
- Prerequisites including bash/zsh requirement (TA-I2)
- Detection logic and triggers
- Setup flow (role discovery, profile config, generation)
- Runtime usage (use_persona, show_persona)
- Ownership model and delegation mechanics
- Integration with issue-driven-delivery
- Common mistakes and red flags

**Deliverable:** Complete SKILL.md following agentskills.io format.

## Task 3: Create Shell Config Template

**Files:** `skills/persona-switching/references/persona-config-template.sh`

Create shell template with:

- Template variables: `{{REPO_NAME}}`, `{{SECURITY_PROFILES}}`, `{{PERSONAS}}`
- Security profile definitions (contributor, maintainer, admin)
- `use_persona` function with gh auth switch and git config
- `show_persona` function for verification
- File permission note (chmod 600) per SEC-I2

**Deliverable:** Bash template with placeholder variables.

## Task 4: Create Playbook Template

**Files:** `skills/persona-switching/references/playbook-template.md`

Create playbook template with:

- Frontmatter with triggers (session start, switch persona, phase transition)
- Template variables: `{{REPO_NAME}}`, `{{PERSONA_TABLE}}`, `{{PROFILE_TABLE}}`
- Quick reference commands
- Setup instructions with file permissions (SEC-I2)
- Security considerations section (SEC-C1):
  - GPG passphrase caching (gpg-agent)
  - GitHub token storage (gh handles)
  - Shell history considerations
- Troubleshooting section

**Deliverable:** Playbook template with security considerations.

## Task 5: Create Security Profiles Reference

**Files:** `skills/persona-switching/references/security-profiles.md`

Document security profile configuration:

- Default profiles (contributor, maintainer, admin)
- Configuration format
- Customization guidance
- Token scoping recommendations (SEC-I1)

**Deliverable:** Security profiles documentation.

## Task 6: Create Delegation Patterns Reference

**Files:** `skills/persona-switching/references/delegation-patterns.md`

Document when to use persona switch vs sub-agent delegation:

- Decision matrix by duration and complexity
- Persona switch examples
- Sub-agent delegation examples
- "Dev Complete" gate pattern

**Deliverable:** Delegation patterns documentation.

## Task 7: Create Workflow Integration Reference

**Files:** `skills/persona-switching/references/workflow-integration.md`

Document issue-driven-delivery integration:

- Phase-persona mapping table
- Ownership by task type
- Automatic suggestion examples
- Label integration

**Deliverable:** Workflow integration documentation.

## Task 8: Update README.md Skill List

**Files:** `README.md`

Add persona-switching to the skills list:

```markdown
- `persona-switching` - Multi-identity Git/GitHub workflows with role personas
```

**Deliverable:** Updated README.md.

## Task 9: Run Linting Validation

Run `npm run lint` and fix any issues.

**Deliverable:** Clean lint output.

## Task 10: Post Evidence and Create PR

Post implementation evidence to issue #153 and create PR.

**Deliverable:** PR created with evidence posted.

## Task 11: Create Follow-Up Ticket for Bootstrap Integration

Create follow-up issue for `repo-best-practices-bootstrap` integration (TA-I1).

**Deliverable:** Follow-up issue created.

## Acceptance Criteria Mapping

| Acceptance Criteria                          | Task      |
| -------------------------------------------- | --------- |
| Skill at `skills/persona-switching/SKILL.md` | Task 2    |
| Playbook template created                    | Task 4    |
| Playbook has proper frontmatter              | Task 4    |
| GPG signature validity preserved             | Task 2, 3 |
| Author name customizable                     | Task 3    |
| gh CLI switches accounts                     | Task 3    |
| BDD tests validate behaviour                 | Task 1    |
| Setup instructions included                  | Task 4    |
