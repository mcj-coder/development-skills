# Backlog Health Report Script Implementation Plan

**Issue:** #148
**Date:** 2026-01-08
**Status:** Draft

## Approval History

| Phase         | Reviewer  | Decision | Date | Plan Commit | Comment Link |
| ------------- | --------- | -------- | ---- | ----------- | ------------ |
| Plan Approval | Tech Lead | PENDING  | -    | -           | -            |

## Overview

Create a backlog health report script that identifies issues needing attention. The script
will be run on-demand or scheduled to produce a markdown report highlighting problems in
the issue backlog.

## Scope

### In Scope

- Template bash script for backlog health analysis
- Installed script customized for this repository
- GitHub Actions workflow (scheduled + manual trigger)
- BDD test file for regression testing
- Playbook documentation
- README.md quick reference update

### Out of Scope

- Auto-fixing issues (report only)
- Integration with external dashboards
- Historical trending

## Health Check Categories

The report will identify issues in these categories:

| Category             | Detection Logic                                     | Severity |
| -------------------- | --------------------------------------------------- | -------- |
| Missing Labels       | Issues without required labels for their state      | Warning  |
| Stale State          | `state:new-feature` older than N days (default: 7)  | Warning  |
| Unanswered Questions | Issues with `needs-info` label or unanswered `?`    | Warning  |
| Extended Blocks      | `blocked` label for more than N days (default: 14)  | Alert    |
| Potential Duplicates | Similar titles (leverages detect-duplicates output) | Info     |
| Stale Issues         | No activity for N days (default: 30)                | Warning  |

## Configuration

Configurable thresholds via environment variables:

```bash
STALE_DAYS=30           # Days without activity
BLOCKED_DAYS=14         # Days in blocked state
NEW_FEATURE_DAYS=7      # Days issue can be in new-feature state
```

## Output Format

Markdown report with sections:

1. **Summary Statistics** - Counts per category
2. **Missing Labels** - Table of issues with missing labels
3. **Stale State** - Issues stuck in wrong state
4. **Unanswered Questions** - Issues needing response
5. **Extended Blocks** - Long-blocked issues
6. **Potential Duplicates** - Similar issue pairs
7. **Stale Issues** - Inactive issues
8. **Recommendations** - Actionable next steps

## Implementation Tasks

### Task 1: Create BDD Test File (RED Phase)

Create `skills/issue-driven-delivery/backlog-health.test.md` with:

- Baseline scenarios showing pain points without health reports
- Assertions for each health check category
- Test scenarios with verification steps
- Edge cases

**Deliverable:** `skills/issue-driven-delivery/backlog-health.test.md`

### Task 2: Create Template Script

Create `skills/issue-driven-delivery/templates/backlog-health.sh` with:

- Configurable threshold variables
- Functions for each health check category
- Markdown output generation
- Exit code based on severity (0=healthy, 1=warnings, 2=alerts)

**Deliverable:** `skills/issue-driven-delivery/templates/backlog-health.sh`

### Task 3: Create Template Workflow

Create `skills/issue-driven-delivery/templates/backlog-health.yml` with:

- Trigger on: `workflow_dispatch` (manual) + `schedule` (weekly)
- Runs health script and posts as issue comment or artifact
- Configurable report destination

**Deliverable:** `skills/issue-driven-delivery/templates/backlog-health.yml`

### Task 4: Install Script in Repository

Create `scripts/backlog-health.sh` customized for this repository:

- Thresholds configured for repository conventions
- Label patterns configured

**Deliverable:** `scripts/backlog-health.sh`

### Task 5: Install Workflow in Repository

Create `.github/workflows/backlog-health.yml` configured for this repository.

**Deliverable:** `.github/workflows/backlog-health.yml`

### Task 6: Create Playbook

Create `docs/playbooks/backlog-health.md` with:

- Overview and purpose
- Configuration instructions
- Output interpretation guide
- Recommended actions per category
- Integration with grooming process

**Deliverable:** `docs/playbooks/backlog-health.md`

### Task 7: Update README.md

Add quick reference in Automation section.

**Deliverable:** Updated README.md

### Task 8: Run Linting Validation

1. Run `npm run lint` to validate all files
2. Fix any formatting issues

**Deliverable:** Clean lint output

## Acceptance Criteria Mapping

| Acceptance Criteria                              | Task   |
| ------------------------------------------------ | ------ |
| Template script in skill's `templates/` folder   | Task 2 |
| Template workflow in skill's `templates/` folder | Task 3 |
| Customized script in `scripts/`                  | Task 4 |
| Customized workflow in `.github/workflows/`      | Task 5 |
| Report identifies missing labels                 | Task 2 |
| Report identifies stale issues                   | Task 2 |
| Report identifies extended blocks                | Task 2 |
| README.md updated with quick reference           | Task 7 |
| Playbook created                                 | Task 6 |
| All linting passes                               | Task 8 |

## BDD Verification Checklist

### Task 1: BDD Test File

- [ ] File exists at `skills/issue-driven-delivery/backlog-health.test.md`
- [ ] Contains baseline scenarios
- [ ] Contains assertions for each health category
- [ ] Contains test scenarios with verification steps

### Task 2: Template Script

- [ ] File exists at `skills/issue-driven-delivery/templates/backlog-health.sh`
- [ ] Script is executable
- [ ] Contains configurable thresholds
- [ ] Generates markdown output
- [ ] Returns appropriate exit codes

### Task 3: Template Workflow

- [ ] File exists at `skills/issue-driven-delivery/templates/backlog-health.yml`
- [ ] YAML is valid
- [ ] Contains workflow_dispatch trigger
- [ ] Contains schedule trigger

### Task 4: Installed Script

- [ ] File exists at `scripts/backlog-health.sh`
- [ ] Script is executable
- [ ] Thresholds configured for repository

### Task 5: Installed Workflow

- [ ] File exists at `.github/workflows/backlog-health.yml`
- [ ] Workflow validates successfully
- [ ] Manual trigger works

### Task 6: Playbook

- [ ] File exists at `docs/playbooks/backlog-health.md`
- [ ] Documents all health categories
- [ ] Contains configuration instructions
- [ ] Contains recommended actions

### Task 7: README Update

- [ ] README.md references backlog-health script
- [ ] Quick reference is in Automation section

### Task 8: Validation

- [ ] `npm run lint` passes with no errors

## Technical Approach

### Script Structure

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
STALE_DAYS="${STALE_DAYS:-30}"
BLOCKED_DAYS="${BLOCKED_DAYS:-14}"
NEW_FEATURE_DAYS="${NEW_FEATURE_DAYS:-7}"

# Functions
check_missing_labels() { ... }
check_stale_state() { ... }
check_unanswered_questions() { ... }
check_extended_blocks() { ... }
check_potential_duplicates() { ... }
check_stale_issues() { ... }
generate_report() { ... }

# Main
main() {
  # Run all checks
  # Generate report
  # Return exit code
}

main "$@"
```

### GitHub CLI Usage

```bash
# Get issues with specific labels
gh issue list --label "state:new-feature" --json number,title,createdAt,labels

# Check issue age
gh issue list --json number,createdAt --jq '.[] | select(...)'
```

## Review Personas

| Phase          | Reviewers                         | Focus               |
| -------------- | --------------------------------- | ------------------- |
| Refinement     | Tech Lead, Documentation Spec     | Plan completeness   |
| Implementation | DevOps Engineer, Senior Developer | Script correctness  |
| Approval       | Tech Lead                         | Strategic alignment |

## Evidence Requirements

**Task 1:**

- Commit SHA for BDD test file
- File link to test file

**Task 2:**

- Commit SHA for template script
- File link to template
- Sample output showing markdown format

**Task 3:**

- Commit SHA for template workflow
- File link to workflow

**Task 4:**

- Commit SHA for installed script
- File link to script
- Test run showing report output

**Task 5:**

- Commit SHA for installed workflow
- File link to workflow
- Manual trigger test run

**Task 6:**

- Commit SHA for playbook
- File link to playbook

**Task 7:**

- Commit SHA for README update
- Diff showing added reference

**Task 8:**

- Lint output showing clean build (0 errors)

## Review History

_No reviews yet._
