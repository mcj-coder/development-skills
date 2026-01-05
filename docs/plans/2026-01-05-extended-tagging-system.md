# Extended Tagging System Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Extend component tagging in issue-driven-delivery to include priority, blocked status, and work type tags
with automated enforcement and repository documentation templates.

**Architecture:** Expand the existing component-tagging reference document with three new tagging dimensions
(priority, blocked, work type), update enforcement rules to make these mandatory where applicable, and provide
platform-specific implementation guidance with specialized issue templates.

**Tech Stack:** Markdown documentation, GitHub/Azure DevOps/Jira CLI examples, issue templates

---

## Task 1: Create BDD Test for Extended Tagging

**Files:**

- Create: `skills/issue-driven-delivery/issue-driven-delivery-extended-tagging.test.md`

### Step 1: Write BDD scenarios for extended tagging

Create test file with RED (failing) and GREEN (passing) scenarios:

````markdown
# Extended Tagging BDD Tests

## RED Scenario 1: Missing Priority Tag

**Context:** Agent closes work item without priority tag

**Without extended tagging skill:**

```text
Agent closes issue #123
Issue has: component:skill, work-type:enhancement
Issue missing: priority tag
Result: Issue closed successfully (no enforcement)
```
````

**Expected with extended tagging (should fail initially):**

- [ ] Agent checks for priority tag before closing
- [ ] Agent stops with error: "Missing mandatory priority tag"
- [ ] Agent suggests appropriate priority based on issue content

````text

### Step 2: Add scenarios for all tag types

Add RED scenarios for:
- Missing work type tag
- Blocked tag without comment
- Blocked work item that gets unassigned
- Missing auto-assignment on creation

### Step 3: Commit BDD test

```bash
git add skills/issue-driven-delivery/issue-driven-delivery-extended-tagging.test.md
git commit -m "test(skill): add BDD tests for extended tagging (RED baseline)"
````

---

## Task 2: Document Priority Taxonomy

**Files:**

- Modify: `skills/issue-driven-delivery/references/component-tagging.md`

### Step 1: Add Priority Tagging section

Insert after line 43 (after Automatic Tagging section):

```markdown
## Priority Tagging

Every work item should have a priority tag indicating urgency and importance.

### Priority Levels

| Level | Name         | Description                                     | Examples                                  |
| ----- | ------------ | ----------------------------------------------- | ----------------------------------------- |
| P0    | Critical     | System down, data loss, security breach         | Production outage, security vulnerability |
| P1    | High         | Major functionality broken, blocking other work | Core feature broken, build failing        |
| P2    | Medium       | Important but not urgent, has workarounds       | Enhancement, non-critical bug             |
| P3    | Low          | Nice to have, minimal impact                    | Minor UI improvement, typo fix            |
| P4    | Nice-to-have | Future consideration, low priority              | Feature idea, optimization                |

### When to Apply

- **P0-P1**: Requires immediate attention, should be worked on now
- **P2**: Normal priority, part of regular backlog
- **P3-P4**: Low priority, work on when time permits

### Platform-Specific Implementation

**GitHub:**

- Labels: `priority:p0`, `priority:p1`, `priority:p2`, `priority:p3`, `priority:p4`

**Azure DevOps:**

- Tags: `P0`, `P1`, `P2`, `P3`, `P4`
- OR use Priority field: Critical, High, Medium, Low

**Jira:**

- Priority field: Highest, High, Medium, Low, Lowest
- OR labels: `priority-p0`, `priority-p1`, etc.
```

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS with no markdown errors

### Step 3: Commit priority taxonomy

```bash
git add skills/issue-driven-delivery/references/component-tagging.md
git commit -m "docs(skill): add priority taxonomy (P0-P4) to component tagging"
```

---

## Task 3: Document Work Type Taxonomy

**Files:**

- Modify: `skills/issue-driven-delivery/references/component-tagging.md`

### Step 1: Add Work Type Tagging section

Insert after Priority Tagging section:

```markdown
## Work Type Tagging

Every work item must be tagged with its work type. This enables filtering by type of work and helps with metrics tracking.

### Work Type Taxonomy

| Type           | Description                                   | Example Issues                             |
| -------------- | --------------------------------------------- | ------------------------------------------ |
| new-feature    | New functionality that didn't exist before    | Add dark mode, implement OAuth             |
| enhancement    | Improvement to existing functionality         | Improve search performance, add filtering  |
| bug            | Defect that needs fixing                      | Fix login error, resolve crash             |
| tech-debt      | Technical debt remediation                    | Refactor legacy code, upgrade dependencies |
| documentation  | Documentation changes only                    | Update README, add API docs                |
| refactoring    | Code restructuring without behaviour change   | Extract methods, rename variables          |
| infrastructure | Build, deploy, CI/CD, tooling changes         | Add GitHub Actions, configure linting      |
| chore          | Maintenance tasks not affecting functionality | Update dependencies, fix typos             |

### Work Type Guidelines

**new-feature vs enhancement:**

- new-feature: Adds capability that didn't exist (e.g., "Add user authentication")
- enhancement: Improves existing capability (e.g., "Add password strength indicator to existing login")

**bug vs tech-debt:**

- bug: Visible defect affecting users now
- tech-debt: Code quality issue that could cause problems later

**refactoring vs chore:**

- refactoring: Restructures code logic/architecture
- chore: Updates dependencies, configs, build scripts

### Platform-Specific Implementation

**GitHub:**

- Labels: `work-type:new-feature`, `work-type:bug`, `work-type:tech-debt`, etc.
- Can also use: `new-feature`, `bug`, `tech-debt` (simpler, already in use)

**Azure DevOps:**

- Work Item Type: Bug, User Story, Task, Technical Debt
- OR tags: `new-feature`, `enhancement`, `bug`, etc.

**Jira:**

- Issue Type: Story, Bug, Task, Technical Debt
- OR labels: `work-type-feature`, `work-type-bug`, etc.
```

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit work type taxonomy

```bash
git add skills/issue-driven-delivery/references/component-tagging.md
git commit -m "docs(skill): add work type taxonomy (8 types) to component tagging"
```

---

## Task 4: Document Blocked Status Workflow

**Files:**

- Modify: `skills/issue-driven-delivery/references/component-tagging.md`

### Step 1: Add Blocked Status section

Insert after Work Type Tagging section:

```markdown
## Blocked Status Tagging

Work items that are blocked (cannot proceed) must be tagged and require a comment explaining what's blocking them.

### When to Apply Blocked Tag

Apply `blocked` tag when:

- Waiting for external dependency (API, service, library)
- Blocked by another work item that must complete first
- Blocked by decision needed from stakeholder
- Blocked by missing information or access

### Requirements for Blocked Tag

1. **Add blocked tag/label**
2. **Post comment explaining blocker** with:
   - What is blocking this work
   - Blocker ID (if another work item: link to it)
   - What's needed to unblock
   - Who can help unblock

3. **Keep work item assigned**
   - Blocked work must remain assigned (accountability)
   - Can reassign to someone else if appropriate
   - Cannot unassign (prevents abandonment)

### Clearing Blocked Status

When blocker is resolved:

1. Post comment confirming blocker resolved
2. Remove blocked tag/label
3. Update work item state to resume work

### Platform-Specific Implementation

**GitHub:**

- Label: `blocked`
- Comment with blocker details
- Use "blocked by #123" syntax for work item blockers

**Azure DevOps:**

- Tag: `blocked`
- Comment with blocker details
- Can use "Related Work" links for blockers

**Jira:**

- Label: `blocked`
- OR custom status: "Blocked"
- Comment with blocker details
- Use "blocks"/"is blocked by" link types
```

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit blocked status workflow

```bash
git add skills/issue-driven-delivery/references/component-tagging.md
git commit -m "docs(skill): add blocked status workflow with comment requirement"
```

---

## Task 5: Update Enforcement Rules

**Files:**

- Modify: `skills/issue-driven-delivery/references/component-tagging.md`

### Step 1: Replace Enforcement section

Replace existing "Enforcement" section (lines 29-33) with comprehensive rules:

````markdown
## Enforcement Rules

### Mandatory Tags (Before Closing)

**Always required:**

- **Component tag**: Which component/area this affects
- **Work type tag**: Type of work (new-feature, bug, etc.)
- **Priority tag**: Priority level (P0-P4)

**Required when applicable:**

- **Blocked tag**: If work is currently blocked (with comment)

### Enforcement Actions

**Before closing work item:**

1. Verify all mandatory tags exist
2. If blocked tag exists, verify blocking comment exists
3. Stop with error if any mandatory tag missing
4. Suggest appropriate tags based on:
   - File changes (for component)
   - Issue title/body (for work type)
   - Severity/urgency keywords (for priority)

**For blocked work items:**

1. Verify work item is assigned
2. Prevent unassignment (can reassign, cannot unassign)
3. Verify blocking comment exists
4. Error if blocked tag without comment

### Error Messages

**Missing component tag:**

```text
ERROR: Cannot close work item without component tag.
Suggestion: Based on file changes, consider: 'component:api', 'skill'
```

**Missing work type tag:**

```text
ERROR: Cannot close work item without work type tag.
Suggestion: Based on issue title, consider: 'work-type:bug', 'work-type:enhancement'
```

**Missing priority tag:**

```text
ERROR: Cannot close work item without priority tag.
Suggestion: Based on issue severity, consider: 'priority:p2' (Medium)
```

**Blocked without comment:**

```text
ERROR: Work item tagged as 'blocked' but no blocking comment found.
Required: Post comment explaining what is blocking this work.
```

**Blocked work item unassigned:**

```text
ERROR: Cannot unassign blocked work item.
Blocked work must remain assigned for accountability.
To proceed: Either (1) remove blocked tag if no longer blocked, or (2) reassign to another person.
```
````

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit enforcement rules

```bash
git add skills/issue-driven-delivery/references/component-tagging.md
git commit -m "docs(skill): update enforcement rules for all tag types"
```

---

## Task 6: Add Auto-Assignment Strategy

**Files:**

- Modify: `skills/issue-driven-delivery/references/component-tagging.md`

### Step 1: Replace Automatic Tagging section

Replace existing "Automatic Tagging" section (lines 35-43) with expanded strategy:

````markdown
## Automatic Tag Assignment

When creating a new work item, analyze content and suggest (or auto-apply) appropriate tags.

### Component Tag Suggestions

Analyze repository structure and file changes:

- If `skills/` directory exists → suggest `skill`
- If `src/api/` exists → suggest `api` or `component:api`
- If `docs/` changes → suggest `documentation`
- If `ui/` or `frontend/` → suggest `ui` or `component:ui`
- If `database/` or `db/` → suggest `database`

### Work Type Suggestions

Analyze issue title and body for keywords:

**new-feature:**

- Keywords: "add", "create", "implement", "new", "feature"
- Pattern: "Add [feature]", "Implement [capability]"

**enhancement:**

- Keywords: "improve", "enhance", "optimize", "extend", "update"
- Pattern: "Improve [existing feature]", "Enhance [capability]"

**bug:**

- Keywords: "fix", "bug", "error", "crash", "broken", "issue"
- Pattern: "Fix [problem]", "Bug: [description]"

**tech-debt:**

- Keywords: "refactor", "technical debt", "legacy", "clean up", "upgrade"
- Pattern: "Refactor [component]", "Clean up [area]"

**documentation:**

- Keywords: "document", "docs", "readme", "guide", "documentation"
- File changes: Only `.md` files

**infrastructure:**

- Keywords: "ci", "cd", "build", "deploy", "pipeline", "automation"
- File changes: `.github/`, `ci/`, `.gitlab-ci.yml`

**chore:**

- Keywords: "chore", "maintenance", "dependency", "update deps"
- Pattern: "Chore: [task]", "Update [dependency]"

### Priority Suggestions

Analyze issue severity indicators:

**P0 (Critical):**

- Keywords: "critical", "urgent", "emergency", "production down", "data loss", "security"

**P1 (High):**

- Keywords: "high priority", "blocking", "important", "major"

**P2 (Medium):**

- Keywords: "enhancement", "improvement" (with no urgency indicators)
- Default priority if no indicators

**P3 (Low):**

- Keywords: "minor", "low priority", "nice to have"

**P4 (Nice-to-have):**

- Keywords: "future", "someday", "idea", "consider"

### Auto-Assignment Behaviour

**On issue creation:**

1. Detect platform (GitHub, Azure DevOps, Jira)
2. Analyze issue title, body, and file changes
3. Suggest tags with confidence level:
   - High confidence (>80%): Auto-apply tag
   - Medium confidence (50-80%): Suggest in comment
   - Low confidence (<50%): List options for manual selection

**Example auto-assignment comment:**

```

🏷️ **Suggested tags:**

**Auto-applied (high confidence):**

- `skill` (repository has `skills/` directory)
- `work-type:enhancement` (title: "Extend component tagging...")
- `priority:p2` (no urgency indicators, standard enhancement)

**Please verify** these tags are appropriate, or update if needed.
```
````

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit auto-assignment strategy

```bash
git add skills/issue-driven-delivery/references/component-tagging.md
git commit -m "docs(skill): add comprehensive auto-assignment strategy"
```

---

## Task 7: Create Repository Documentation Template

**Files:**

- Create: `skills/issue-driven-delivery/references/repo-tagging-template.md`

### Step 1: Create template document

````markdown
# Work Item Tagging Requirements

This document defines the tagging requirements for work items (issues, tickets) in this repository.

## Overview

All work items must be tagged with appropriate labels/tags before closing. This enables:

- Filtering and searching by component, type, priority
- Identifying blocked work
- Tracking metrics by work type
- Better backlog management

## Tag Types

### Component Tags (Mandatory)

Every work item must identify which component or area it affects.

**Available components:**

- `component:api` - Backend API changes
- `component:ui` - Frontend/UI changes
- `component:database` - Database schema or queries
- `component:auth` - Authentication/authorization
- `component:docs` - Documentation
- _[Add your repository-specific components]_

### Work Type Tags (Mandatory)

Every work item must have a work type tag.

**Available work types:**

- `work-type:new-feature` - New functionality
- `work-type:enhancement` - Improvement to existing feature
- `work-type:bug` - Defect fix
- `work-type:tech-debt` - Technical debt remediation
- `work-type:documentation` - Documentation only
- `work-type:refactoring` - Code restructuring (no behaviour change)
- `work-type:infrastructure` - Build/deploy/CI/CD changes
- `work-type:chore` - Maintenance tasks

### Priority Tags (Mandatory)

Every work item must have a priority level.

**Available priorities:**

- `priority:p0` - **Critical**: System down, data loss, security breach
- `priority:p1` - **High**: Major functionality broken, blocking
- `priority:p2` - **Medium**: Important but not urgent
- `priority:p3` - **Low**: Nice to have, minimal impact
- `priority:p4` - **Nice-to-have**: Future consideration

### Blocked Status (When Applicable)

If work cannot proceed, apply blocked tag and post comment explaining blocker.

**Blocked tag:**

- `blocked`

**Requirements when blocked:**

1. Post comment with: what's blocking, blocker ID, how to unblock
2. Keep work item assigned (cannot unassign blocked work)
3. To clear: post comment confirming unblocked, remove tag

## Enforcement

**Before closing work item:**

- ✅ Component tag exists
- ✅ Work type tag exists
- ✅ Priority tag exists
- ✅ If blocked tag: comment explaining blocker exists
- ✅ If blocked: work item is assigned

**Enforcement errors:**

- Missing any mandatory tag → Cannot close
- Blocked without comment → Cannot close
- Blocked and unassigned → Cannot proceed

## Quick Reference

| Tag Type  | Mandatory        | When              | Example             |
| --------- | ---------------- | ----------------- | ------------------- |
| Component | ✅ Yes           | Always            | `component:api`     |
| Work Type | ✅ Yes           | Always            | `work-type:bug`     |
| Priority  | ✅ Yes           | Always            | `priority:p2`       |
| Blocked   | ⚠️ If applicable | When work blocked | `blocked` + comment |

## Platform Implementation

_[Add platform-specific instructions for GitHub/Azure DevOps/Jira based on your repository]_

**GitHub:**

```bash
# Add labels when creating issue
gh issue create --label "component:api,work-type:bug,priority:p1"

# Add labels to existing issue
gh issue edit 123 --add-label "priority:p2"
```
````

**Azure DevOps:**

```bash
# Add tags to work item
az boards work-item update --id 123 --fields System.Tags="component:api; work-type:bug; priority:p1"
```

**Jira:**

```bash
# Add labels to issue
jira issue update PROJ-123 --labels "component:api,work-type:bug,priority:p1"
```

## Customization

These are **strong recommendations** for this repository. If you need different tags/structure:

1. Document your custom approach in this file
2. Update enforcement rules to match
3. Ensure consistency across all work items

## Questions?

See [issue-driven-delivery skill documentation](link-to-skill) for complete details on work item management
and tagging strategy.

<!-- markdownlint-disable MD040 -->

`````

<!-- markdownlint-enable MD040 -->

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit repository template

```bash
git add skills/issue-driven-delivery/references/repo-tagging-template.md
git commit -m "docs(skill): add repository tagging requirements template"
```

---

## Task 8: Create Work-Type Issue Templates

**Files:**

- Create: `skills/issue-driven-delivery/references/issue-templates.md`

### Step 1: Create issue templates reference

````markdown
# Work-Type-Specific Issue Templates

This document provides issue templates for different work types to ensure consistent structure and required information.

## GitHub Issue Templates

GitHub supports YAML-based issue templates in `.github/ISSUE_TEMPLATE/` directory.

### Bug Report Template

**File:** `.github/ISSUE_TEMPLATE/bug-report.yml`

```yaml
name: Bug Report
description: Report a defect or error
labels: ["work-type:bug", "priority:p2"]
body:
  - type: markdown
    attributes:
      value: |
        ## Bug Report
        Please provide details about the bug you encountered.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: Clear description of the bug
      placeholder: What happened?
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: Step-by-step instructions to reproduce the bug
      placeholder: |
        1. Go to...
        2. Click on...
        3. See error...
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behaviour
      description: What should have happened?
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behaviour
      description: What actually happened?
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P0 - Critical (system down, data loss)
        - P1 - High (major functionality broken)
        - P2 - Medium (important but has workarounds)
        - P3 - Low (minor issue)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```
`````

### Feature Request Template

**File:** `.github/ISSUE_TEMPLATE/feature-request.yml`

```yaml
name: Feature Request
description: Propose new functionality
labels: ["work-type:new-feature", "priority:p3"]
body:
  - type: markdown
    attributes:
      value: |
        ## Feature Request
        Describe the new feature you'd like to see.

  - type: textarea
    id: problem
    attributes:
      label: Problem Statement
      description: What problem does this solve?
      placeholder: As a [user], I need [capability] so that [benefit]
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How should this work?
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: What other approaches did you consider?

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (blocking other work)
        - P2 - Medium (important enhancement)
        - P3 - Low (nice to have)
        - P4 - Nice-to-have (future consideration)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```

### Enhancement Template

**File:** `.github/ISSUE_TEMPLATE/enhancement.yml`

```yaml
name: Enhancement
description: Improve existing functionality
labels: ["work-type:enhancement", "priority:p2"]
body:
  - type: markdown
    attributes:
      value: |
        ## Enhancement
        Describe how you'd like to improve existing functionality.

  - type: textarea
    id: current
    attributes:
      label: Current Behaviour
      description: How does it work now?
    validations:
      required: true

  - type: textarea
    id: proposed
    attributes:
      label: Proposed Improvement
      description: How should it work?
    validations:
      required: true

  - type: textarea
    id: benefit
    attributes:
      label: Benefit
      description: Why is this improvement valuable?
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (significant improvement)
        - P2 - Medium (moderate improvement)
        - P3 - Low (minor improvement)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```

### Tech Debt Template

**File:** `.github/ISSUE_TEMPLATE/tech-debt.yml`

```yaml
name: Technical Debt
description: Address technical debt or code quality
labels: ["work-type:tech-debt", "priority:p3"]
body:
  - type: markdown
    attributes:
      value: |
        ## Technical Debt
        Describe the technical debt that needs addressing.

  - type: textarea
    id: issue
    attributes:
      label: Technical Debt Description
      description: What is the technical debt?
      placeholder: Describe the code quality issue, outdated pattern, or architectural concern
    validations:
      required: true

  - type: textarea
    id: impact
    attributes:
      label: Impact
      description: Why does this matter?
      placeholder: How does this affect maintainability, performance, or development?
    validations:
      required: true

  - type: textarea
    id: approach
    attributes:
      label: Proposed Approach
      description: How should this be addressed?

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (causing active problems)
        - P2 - Medium (should address soon)
        - P3 - Low (address when convenient)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Infrastructure
        - Other
    validations:
      required: true
```

## Azure DevOps Work Item Templates

Azure DevOps uses Work Item Type definitions (XML or Process Template).

### Custom Work Item Types

**Bug:**

- Fields: Title, Description, Steps to Reproduce, Expected Result, Actual Result
- Required tags: Component, Priority
- Default priority: P2

**User Story (for new-feature):**

- Fields: Title, Description, Acceptance Criteria
- Required tags: Component, Priority
- Default priority: P3

**Task (for enhancement, chore):**

- Fields: Title, Description
- Required tags: Component, Work Type, Priority
- Default priority: P2

**Technical Debt:**

- Fields: Title, Description, Impact, Proposed Solution
- Required tags: Component, Priority
- Default priority: P3

## Jira Issue Types

Jira uses Issue Type Schemes to define templates.

### Configure Issue Types

**Bug:**

- Fields: Summary, Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour
- Required: Component, Priority
- Default priority: Medium

**Story (for new-feature):**

- Fields: Summary, Description, Acceptance Criteria
- Required: Component, Priority
- Default priority: Low

**Task (for enhancement, chore, infrastructure):**

- Fields: Summary, Description
- Required: Component, Work Type Label, Priority
- Default priority: Medium

**Technical Debt:**

- Fields: Summary, Description, Impact, Remediation Plan
- Required: Component, Priority
- Default priority: Low

## Template Customization

These templates are **strong recommendations**. Customize based on your needs:

1. Copy relevant template for your platform
2. Adjust component options to match your repository
3. Modify fields based on your workflow
4. Ensure work-type and priority tags/fields are included
5. Document customizations in your repository

## Implementation Steps

**For GitHub:**

1. Create `.github/ISSUE_TEMPLATE/` directory
2. Add `.yml` template files for each work type
3. Configure `config.yml` to customize issue creation experience

**For Azure DevOps:**

1. Access Organization Settings → Process
2. Create custom process or customize existing
3. Add/modify work item types
4. Configure fields and rules

**For Jira:**

1. Access Project Settings → Issue Types
2. Create custom issue types or use defaults
3. Configure fields for each type
4. Set up issue type schemes

<!-- markdownlint-disable MD040 -->

`````

<!-- markdownlint-enable MD040 -->

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit issue templates

```bash
git add skills/issue-driven-delivery/references/issue-templates.md
git commit -m "docs(skill): add work-type-specific issue templates"
```

---

## Task 9: Update CLI Commands Reference

**Files:**

- Modify: `skills/issue-driven-delivery/references/cli-commands.md`

### Step 1: Add multi-tag operations section

Add at end of file:

````markdown
## Multi-Tag Operations

Examples of adding multiple tags at once for complete work item tagging.

### GitHub: Create Issue with All Tags

```bash
# Create new issue with complete tagging
gh issue create \
  --title "Fix login validation bug" \
  --body "User login fails when..." \
  --label "component:auth,work-type:bug,priority:p1"

# Edit existing issue to add all tags
gh issue edit 123 \
  --add-label "component:api,work-type:enhancement,priority:p2"

# Add blocked status with comment
gh issue edit 123 --add-label "blocked"
gh issue comment 123 --body "Blocked by: Waiting for API key from external service. Contact: John Doe"
```
`````

### Azure DevOps: Create Work Item with Tags

```bash
# Create bug with tags
az boards work-item create \
  --title "Fix login validation" \
  --type Bug \
  --fields \
    System.Tags="component:auth; work-type:bug; priority:p1" \
    System.Description="User login fails when..."

# Update existing work item
az boards work-item update --id 123 \
  --fields System.Tags="component:api; work-type:enhancement; priority:p2"

# Add blocked status
az boards work-item update --id 123 \
  --fields System.Tags="component:api; work-type:bug; priority:p1; blocked"

# Add comment explaining blocker
az boards work-item discussion add --id 123 \
  --comment "Blocked by: Waiting for API key from external service."
```

### Jira: Create Issue with Labels

```bash
# Create issue with labels
jira issue create \
  --project PROJ \
  --type Bug \
  --summary "Fix login validation" \
  --description "User login fails when..." \
  --labels "component:auth,work-type:bug,priority:p1"

# Update existing issue
jira issue update PROJ-123 \
  --labels "component:api,work-type:enhancement,priority:p2"

# Add blocked status
jira issue update PROJ-123 --labels "+blocked"
jira issue comment PROJ-123 \
  --comment "Blocked by: Waiting for API key from external service."
```

## Tag Verification Before Closing

### GitHub: Check Tags Before Closing

```bash
# View issue labels
gh issue view 123 --json labels --jq '.labels[].name'

# Expected output:
# component:api
# work-type:bug
# priority:p2

# Verify all mandatory tags present
if ! gh issue view 123 --json labels --jq '.labels[].name' | grep -q "component:"; then
  echo "ERROR: Missing component tag"
  exit 1
fi

if ! gh issue view 123 --json labels --jq '.labels[].name' | grep -q "work-type:"; then
  echo "ERROR: Missing work-type tag"
  exit 1
fi

if ! gh issue view 123 --json labels --jq '.labels[].name' | grep -q "priority:"; then
  echo "ERROR: Missing priority tag"
  exit 1
fi

# If all checks pass, safe to close
gh issue close 123 --comment "All tasks complete, all tags verified."
```

### Azure DevOps: Check Tags Before Closing

```bash
# Get work item tags
az boards work-item show --id 123 --query fields.SystemTags

# Verify tags manually or with script
TAGS=$(az boards work-item show --id 123 --query fields.SystemTags -o tsv)

if [[ ! "$TAGS" =~ "component:" ]]; then
  echo "ERROR: Missing component tag"
  exit 1
fi

# Close if verified
az boards work-item update --id 123 --state "Closed"
```

### Jira: Check Labels Before Closing

```bash
# Get issue labels
jira issue view PROJ-123 --format json | jq '.fields.labels[]'

# Close if verified
jira issue update PROJ-123 --transition "Done"
```

<!-- markdownlint-disable MD040 -->

````

<!-- markdownlint-enable MD040 -->

### Step 2: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 3: Commit CLI commands update

```bash
git add skills/issue-driven-delivery/references/cli-commands.md
git commit -m "docs(skill): add multi-tag CLI operations and verification"
```

---

## Task 10: Update Main SKILL.md

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Update Component Tagging section

Replace Component Tagging section (lines 41-49) with:

```markdown
## Organizational Tagging

Every work item must be tagged with component, work type, and priority tags. Blocked work items require additional tagging.

**Enforcement**: Verify all mandatory tags exist before closing work item. Stop with error if missing.

See [Component Tagging](references/component-tagging.md) for:

- Component tagging strategy
- Priority taxonomy (P0-P4)
- Work type taxonomy (8+ types)
- Blocked status workflow
- Platform-specific implementation
- Automatic tag suggestions
- Enforcement rules

See [Repository Tagging Template](references/repo-tagging-template.md) for documentation template to use in your repositories.

See [Issue Templates](references/issue-templates.md) for work-type-specific issue templates.
```

### Step 2: Update Core Workflow step 2

Modify step 2 (around line 59) to include tag verification:

```markdown
2. Confirm a Taskboard work item exists for the work. If none exists, create the
   work item before making any changes. Read-only work and reviews are allowed
   without a ticket.
   2a. Verify work item has appropriate component, work type, and priority tags.
   If missing, add tags based on work scope and issue content.
```

### Step 3: Update Core Workflow step 10

Modify step 10 (around line 72) to include comprehensive tag verification:

```markdown
10. Close sub-tasks only after approval and mark the plan task complete.
    10a. Before closing work item, verify all mandatory tags exist: - Component tag (e.g., `component:api`, `skill`) - Work type tag (e.g., `work-type:bug`, `work-type:enhancement`) - Priority tag (e.g., `priority:p2`) - If blocked tag present: verify blocking comment exists and work item is assigned
    10b. Error if any mandatory tag missing.
    10c. When verification complete and acceptance criteria met, close work item (state: complete).
```

### Step 4: Verify markdown formatting

Run: `npm run lint:check`
Expected: PASS

### Step 5: Commit main SKILL.md update

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "docs(skill): update main skill to reference extended tagging system"
```

---

## Task 11: Verify BDD Tests Pass (GREEN)

**Files:**

- Read: `skills/issue-driven-delivery/issue-driven-delivery-extended-tagging.test.md`

### Step 1: Review GREEN scenarios

Open the BDD test file and verify that the documentation now satisfies all GREEN scenarios:

- [ ] Priority taxonomy documented (P0-P4)
- [ ] Work type taxonomy documented (8+ types)
- [ ] Blocked status workflow documented
- [ ] Enforcement rules cover all tag types
- [ ] Blocked work item assignment constraint documented
- [ ] Auto-assignment strategy documented
- [ ] Repository template created
- [ ] Issue templates created
- [ ] Main SKILL.md updated

### Step 2: Update test file with GREEN checkmarks

Mark all GREEN scenarios as passing:

```markdown
## GREEN Scenario 1: Priority Tag Enforcement

**With extended tagging skill:**

✅ Agent checks for priority tag before closing
✅ Agent stops with error if missing
✅ Agent suggests priority based on issue content
✅ Priority taxonomy documented (P0-P4)

[Similar updates for all scenarios]
```

### Step 3: Commit test verification

```bash
git add skills/issue-driven-delivery/issue-driven-delivery-extended-tagging.test.md
git commit -m "test(skill): verify extended tagging BDD tests pass (GREEN)"
```

---

## Task 12: Run Linting and Verification

### Step 1: Run all linting checks

```bash
npm run lint:check
```

Expected: PASS with 0 errors

### Step 2: Run spelling check

```bash
npm run spell-check
```

Expected: PASS with 0 spelling errors

### Step 3: If any errors, fix and re-run

Common issues:

- Line length > 120 characters: wrap lines
- Missing language on code blocks: add language specifier
- Spelling errors: add to cspell.json if technical term, or fix spelling

### Step 4: Commit any fixes

```bash
git add .
git commit -m "fix(skill): resolve linting and spelling errors"
```

---

## Verification Checklist

After completing all tasks, verify:

- [ ] All 11 tasks completed and committed
- [ ] BDD test file exists with RED and GREEN scenarios
- [ ] component-tagging.md has all new sections (priority, work type, blocked, enforcement, auto-assignment)
- [ ] repo-tagging-template.md created
- [ ] issue-templates.md created
- [ ] cli-commands.md updated with multi-tag operations
- [ ] Main SKILL.md updated to reference extended tagging
- [ ] All linting checks pass (prettier, markdownlint, cspell)
- [ ] All commits follow conventional commits format
- [ ] Feature branch ready for PR

## Next Steps

After plan approval and implementation:

1. Push feature branch to remote
2. Create PR referencing issue #60
3. Post PR link in issue #60 for review
4. Address any review feedback
5. Merge PR after approval
6. Close issue #60
7. Delete feature branch
````
