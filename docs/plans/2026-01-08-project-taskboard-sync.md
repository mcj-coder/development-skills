# Project/Taskboard Sync Implementation Plan

**Issue:** #143
**Date:** 2026-01-08
**Status:** Draft

## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |

## Overview

Create automation to keep GitHub Project board status in sync with issue state labels.
This ensures the project board accurately reflects issue states without manual intervention.

**Context:** The "Development Skills Kanban" project (ID: 1) has the following status options:

- Backlog
- Ready
- In Progress
- In Review
- Done
- Blocked

## Scope

### In Scope

- Template GitHub Actions workflow for project status sync
- Installed workflow for this repository
- Playbook documenting usage and configuration
- README.md quick reference update

### Out of Scope

- Azure DevOps / Jira implementations (future ticket if needed)
- Custom field sync beyond status
- Bi-directional sync (project → labels)

## Label to Project Status Mapping

| Issue Label            | Project Status | Rationale                        |
| ---------------------- | -------------- | -------------------------------- |
| `state:new-feature`    | Backlog        | New issues start in backlog      |
| `state:grooming`       | Backlog        | Grooming is still backlog triage |
| `state:refinement`     | In Progress    | Active planning work             |
| `state:implementation` | In Progress    | Active development work          |
| `state:verification`   | In Review      | Testing and review phase         |
| `blocked`              | Blocked        | Work cannot proceed              |
| Issue closed           | Done           | Work complete                    |

**Priority Rules:**

1. `blocked` label takes precedence (if blocked, status is "Blocked" regardless of state label)
2. State labels determine status when not blocked
3. Issue closure always sets "Done"

## Implementation Tasks

### Task 1: Create Template Workflow

Create `skills/issue-driven-delivery/templates/sync-project-status.yml` with:

- Trigger on: `issues.labeled`, `issues.unlabeled`, `issues.closed`
- GraphQL mutation to update project item status
- Support for configurable project number and field ID
- Documentation comments for customization

**Deliverable:** `skills/issue-driven-delivery/templates/sync-project-status.yml`

### Task 2: Install Workflow in Repository

Create `.github/workflows/sync-project-status.yml` customized for this repository:

- Project number: 1
- Status field ID: `PVTSSF_lAHODwOqvM4BMHg5zg7ffAs`
- Status option IDs:
  - Backlog: `f75ad846`
  - Ready: `66ca5d38`
  - In Progress: `47fc9ee4`
  - In Review: `27598e5f`
  - Done: `98236657`
  - Blocked: `f78f6bd3`

**Deliverable:** `.github/workflows/sync-project-status.yml`

### Task 3: Create Playbook

Create `docs/playbooks/project-sync.md` with:

- Overview and purpose
- Configuration instructions
- Troubleshooting guide
- Mermaid diagram showing sync flow

**Deliverable:** `docs/playbooks/project-sync.md`

### Task 4: Update README.md

Add quick reference entry in the Skills section or a new Automation section.

**Deliverable:** Updated README.md

### Task 5: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                                         | Task   |
| ----------------------------------------------------------- | ------ |
| Template workflow in skill's `templates/` folder            | Task 1 |
| Customized workflow installed in `.github/workflows/`       | Task 2 |
| Workflow triggers on label changes and issue state changes  | Task 2 |
| Project board status updates correctly for each label       | Task 2 |
| README.md updated with quick reference                      | Task 4 |
| `docs/playbooks/project-sync.md` created with usage details | Task 3 |
| All linting passes (`npm run lint`)                         | Task 5 |

## BDD Verification Checklist

### Task 1: Template Workflow

- [ ] File exists at `skills/issue-driven-delivery/templates/sync-project-status.yml`
- [ ] YAML is valid (no syntax errors)
- [ ] Contains trigger configuration for issues events
- [ ] Contains configurable variables section
- [ ] Contains GraphQL mutation for project update

### Task 2: Installed Workflow

- [ ] File exists at `.github/workflows/sync-project-status.yml`
- [ ] Project ID configured for this repo
- [ ] Status field IDs match current project configuration
- [ ] Workflow validates successfully

### Task 3: Playbook

- [ ] File exists at `docs/playbooks/project-sync.md`
- [ ] Has valid frontmatter with name, description, triggers
- [ ] Contains Mermaid diagram
- [ ] Documents configuration steps
- [ ] Lists troubleshooting scenarios

### Task 4: README Update

- [ ] README.md references the sync workflow
- [ ] Quick reference is in appropriate section

### Task 5: Validation

- [ ] `npm run lint` passes with no errors

## Review Personas

| Phase          | Reviewers                         | Focus                |
| -------------- | --------------------------------- | -------------------- |
| Refinement     | Tech Lead, Documentation Spec     | Plan completeness    |
| Implementation | DevOps Engineer, Senior Developer | Workflow correctness |
| Approval       | Tech Lead                         | Strategic alignment  |

## Evidence Requirements

**Task 1:**

- Commit SHA for template workflow
- File link to `skills/issue-driven-delivery/templates/sync-project-status.yml`

**Task 2:**

- Commit SHA for installed workflow
- File link to `.github/workflows/sync-project-status.yml`
- Workflow run ID showing successful execution (if testable)

**Task 3:**

- Commit SHA for playbook
- File link to `docs/playbooks/project-sync.md`

**Task 4:**

- Commit SHA for README update
- Diff showing added reference

**Task 5 (Validation):**

- Lint output showing clean build (0 errors)

## Review History

<!-- Populated during refinement and implementation -->
