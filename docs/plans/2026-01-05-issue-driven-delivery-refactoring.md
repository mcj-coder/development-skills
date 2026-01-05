# Issue-Driven Delivery Refactoring Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor `github-issue-driven-delivery` to be ticketing-system agnostic with state tracking and component tagging.

**Architecture:** Rename skill, replace GitHub-specific terminology with
platform-agnostic terms, add platform resolution logic (GitHub/Azure
DevOps/Jira), implement work item state tracking (new feature → refinement →
implementation → verification), and add component/type tagging requirements.

**Tech Stack:** Markdown skill specs, BDD tests, platform-agnostic terminology

## Platform-Specific Elements Identified

From `skills/github-issue-driven-delivery/SKILL.md`:

1. **Skill name**: `github-issue-driven-delivery` → `issue-driven-delivery`
2. **Terminology**:
   - "GitHub issue" → "work item" or "ticket"
   - "issue comments" → "work item comments"
   - "issue sub-tasks" → "work item sub-tasks"
   - "gh CLI" → "ticketing CLI" (gh/ado/jira)
   - "GitHub URLs" → "ticketing system URLs"
3. **Prerequisites**: "gh CLI" → "ticketing system CLI (gh/ado/jira)"
4. **Commands**: All `gh` examples need multi-platform versions
5. **Missing features**: State tracking, component tagging

## BDD Checklist (RED → GREEN)

### Baseline (RED - must fail initially)

- [x] Skill renamed from `github-issue-driven-delivery` to `issue-driven-delivery`
  - Evidence: commit e24d114, directory renamed, YAML frontmatter updated
- [x] YAML frontmatter uses agnostic description (no "GitHub" mentioned)
  - Evidence: skills/issue-driven-delivery/SKILL.md:2-3
- [x] Prerequisites section lists platform CLIs: gh, ado, jira
  - Evidence: skills/issue-driven-delivery/SKILL.md:14
- [x] Platform resolution section added (infer from taskboard URL)
  - Evidence: skills/issue-driven-delivery/SKILL.md:22-32
- [x] "GitHub issue" replaced with "work item" throughout
  - Evidence: commit f7ba47f
- [x] "issue comments" replaced with "work item comments" throughout
  - Evidence: commit f7ba47f
- [x] "gh CLI" replaced with "ticketing CLI" throughout
  - Evidence: commit f7ba47f
- [x] Quick Reference table shows all three platforms (GitHub, Azure DevOps, Jira)
  - Evidence: commit 863abb0, skills/issue-driven-delivery/SKILL.md:186-225
- [x] State tracking section added with lifecycle states
  - Evidence: commit 924c23b, skills/issue-driven-delivery/SKILL.md:34-72
- [x] Component tagging section added
  - Evidence: commit ea3aec9, skills/issue-driven-delivery/SKILL.md:74-115
- [x] Work item state updates documented for each phase:
  - [x] New feature state - Evidence: line 40
  - [x] Refinement state (during planning/approval) - Evidence: lines 41, 69, 81
  - [x] Implementation state (during execution) - Evidence: lines 42, 70, 87
  - [x] Verification state (during testing/review) - Evidence: lines 43, 71, 89
- [x] Component/type tagging requirements documented
  - Evidence: lines 102-115
- [x] Example shows tagging work items with component labels
  - Evidence: Quick Reference tables show "Set state" and "Add component" commands
- [x] Test file renamed to `issue-driven-delivery.test.md`
  - Evidence: commit e24d114
- [x] Tests updated to reference agnostic terminology
  - Evidence: commit d593387
- [x] All references in other files updated (AGENTS.md, README.md, etc.)
  - Evidence: commit 593b23d, updated agent-workitem-automation/SKILL.md and README.md

### Platform Resolution Design

Use same pattern as `agent-workitem-automation`:

| Platform     | Domain patterns                     | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

### State Tracking Design

Work item lifecycle states:

1. **New Feature**: Initial state when work item created
2. **Refinement**: During planning, brainstorming, requirements gathering
   - Set when plan is being created
   - Transition when plan approved
3. **Implementation**: During active development
   - Set when plan approved and execution begins
   - Maintained through all sub-task execution
4. **Verification**: During testing, review, and validation
   - Set when implementation complete, verification begins
   - Maintained until all acceptance criteria met
5. **Complete**: Final state when work item closed

**Platform-specific state implementations:**

- **GitHub**: Use labels (`state:new`, `state:refinement`, `state:implementation`, `state:verification`)
- **Azure DevOps**: Use work item state field (New → Active → Resolved → Closed)
- **Jira**: Use issue status (To Do → In Planning → In Progress → In Review → Done)

### Component Tagging Design

**Requirement**: Every work item must be tagged with the component or component type it impacts.

**Examples by repository type:**

- **Skills repository** (this repo): Use `skill` label for skill-related work
- **Application repository**: Use component labels like `api`, `ui`, `database`, `auth`
- **Multi-project repository**: Use project labels like `project-a`, `project-b`

**Platform-specific tagging implementations:**

- **GitHub**: Use labels (e.g., `skill`, `component:api`, `type:documentation`)
- **Azure DevOps**: Use tags or area path
- **Jira**: Use components or labels

**Enforcement:**

- Verify component tag exists before closing work item
- Error if work item has no component tag
- Suggest appropriate component based on file changes

## Task 1: Create BDD plan with RED baseline

**Files:**

- Create: `docs/plans/2026-01-05-issue-driven-delivery-refactoring.md`

### Step 1: Write the failing test (BDD checklist)

Create this plan file with all BDD checklist items unchecked.

### Step 2: Verify RED (must fail before edits)

Confirm each checklist item is currently false (skill still named
github-issue-driven-delivery, no platform resolution, no state tracking, no
component tagging).

### Step 3: Commit plan

```bash
git add docs/plans/2026-01-05-issue-driven-delivery-refactoring.md
git commit -m "docs(plans): add issue-driven-delivery refactoring plan"
git push
```

## Task 2: Rename skill directory and files

**Files:**

- Rename: `skills/github-issue-driven-delivery/` → `skills/issue-driven-delivery/`
- Rename: `skills/issue-driven-delivery/github-issue-driven-delivery.test.md` → `skills/issue-driven-delivery/issue-driven-delivery.test.md`

### Step 1: Rename directory

```bash
git mv skills/github-issue-driven-delivery skills/issue-driven-delivery
```

### Step 2: Rename test file

```bash
git mv skills/issue-driven-delivery/github-issue-driven-delivery.test.md skills/issue-driven-delivery/issue-driven-delivery.test.md
```

### Step 3: Update SKILL.md name field

Change YAML frontmatter from `github-issue-driven-delivery` to `issue-driven-delivery`.

### Step 4: Commit

```bash
git add -A
git commit -m "refactor(skill): rename github-issue-driven-delivery to issue-driven-delivery"
git push
```

## Task 3: Update SKILL.md with platform-agnostic terminology

**Files:**

- Edit: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Update YAML frontmatter

```yaml
---
name: issue-driven-delivery
description: Use when work is tied to a ticketing system work item and requires comment approval, sub-task tracking, or CLI-based delivery workflows.
---
```

### Step 2: Update title and overview

- "GitHub Issue Driven Delivery" → "Issue-Driven Delivery"
- "Use GitHub issues as the source of truth" → "Use work items as the source of truth"

### Step 3: Update Prerequisites section

```markdown
## Prerequisites

- Ticketing system CLI installed and authenticated (gh for GitHub, ado for Azure DevOps, jira for Jira).
```

### Step 4: Update When to Use section

Replace GitHub-specific language with agnostic terms.

### Step 5: Add Platform Resolution section

```markdown
## Platform Resolution

Infer platform from the taskboard URL (from README.md Work Items section):

| Platform     | Domain patterns                     | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

If the URL is not recognised, stop and ask the user to confirm the platform.
```

### Step 6: Update Core Workflow section

Replace all instances of:

- "GitHub issue" → "work item"
- "issue comments" → "work item comments"
- "gh availability" → "ticketing CLI availability"
- "issue sub-tasks" → "work item sub-tasks"

### Step 7: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "refactor(skill): make terminology platform-agnostic"
git push
```

## Task 4: Add state tracking to SKILL.md

**Files:**

- Edit: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Add State Tracking section after Platform Resolution

```markdown
## Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility:

### Lifecycle States

1. **New Feature**: Initial state when work item created
2. **Refinement**: During planning, brainstorming, requirements gathering
3. **Implementation**: During active development and execution
4. **Verification**: During testing, review, and validation
5. **Complete**: Final state when work item closed

### State Transitions

- **New → Refinement**: When plan creation begins
- **Refinement → Implementation**: When plan is approved
- **Implementation → Verification**: When all sub-tasks complete and testing begins
- **Verification → Complete**: When all acceptance criteria met and work item closed

### Platform-Specific Implementation

**GitHub**: Use state labels

- `state:new-feature`, `state:refinement`, `state:implementation`, `state:verification`

**Azure DevOps**: Use work item state field

- New → Active (Refinement) → Resolved (Implementation/Verification) → Closed

**Jira**: Use issue status

- To Do → In Planning → In Progress → In Review → Done

### When to Update State

- Set `state:refinement` when creating the plan
- Set `state:implementation` immediately after plan approval
- Set `state:verification` when implementation complete and testing begins
- Set `state:complete` / close work item only after all acceptance criteria met
```

### Step 2: Update Core Workflow to reference state updates

Add state update steps to the Core Workflow section:

```markdown
3a. Set work item state to `refinement` when beginning plan creation.
4a. After posting plan link, work item remains in `refinement` state.
7a. After plan approval, set work item state to `implementation`.
8a. When all sub-tasks complete, set work item state to `verification`.
10a. When verification complete and acceptance criteria met, close work item (state: complete).
```

### Step 3: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add work item state tracking lifecycle"
git push
```

## Task 5: Add component tagging to SKILL.md

**Files:**

- Edit: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Add Component Tagging section after State Tracking

```markdown
## Component Tagging

Every work item must be tagged with the component or component type it impacts.

### Tagging Strategy

**Skills repository**: Use `skill` label/tag
**Application repository**: Use component labels like `api`, `ui`, `database`, `auth`
**Multi-project repository**: Use project labels like `project-a`, `project-b`

### Platform-Specific Implementation

**GitHub**: Use labels

- Example: `skill`, `component:api`, `type:documentation`

**Azure DevOps**: Use tags or area path

- Example tags: `skill`, `api`, `ui`
- Example area path: `ProjectName\API\Authentication`

**Jira**: Use components or labels

- Example components: Skills, API, UI
- Example labels: skill, api-component, documentation

### Enforcement

- Verify component tag exists before closing work item
- Stop with error if work item has no component tag
- Suggest appropriate component based on file changes

### Automatic Tagging

When creating a new work item, analyze the repository structure and suggest appropriate component tags:

- If `skills/` directory exists → suggest `skill` tag
- If `src/api/` exists → suggest `api` tag
- If `docs/` changes → suggest `documentation` tag
```

### Step 2: Update Core Workflow to include component tagging

Add component tagging steps:

```markdown
2a. Verify work item has appropriate component tag. If missing, add component tag based on work scope.
20a. Before closing work item, verify component tag exists. Error if missing.
```

### Step 3: Update Evidence Checklist

Add component tagging to checklist:

```markdown
- Work item tagged with appropriate component (e.g., `skill` for skills repositories).
```

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "feat(skill): add component tagging requirements"
git push
```

## Task 6: Update Quick Reference with multi-platform examples

**Files:**

- Edit: `skills/issue-driven-delivery/SKILL.md`

### Step 1: Replace Quick Reference table

Replace the GitHub-only Quick Reference with multi-platform version:

```markdown
## Quick Reference

### GitHub (gh CLI)

| Step          | Action                      | Command                                        |
| ------------- | --------------------------- | ---------------------------------------------- |
| Set state     | Add/update label            | `gh issue edit <id> --add-label "state:impl"`  |
| Add component | Add label                   | `gh issue edit <id> --add-label "skill"`       |
| Plan approval | Comment with plan link      | `gh issue comment <id> --body "Plan: <url>"`   |
| Sub-tasks     | Add task list items         | `gh issue edit <id> --body-file tasks.md`      |
| Evidence      | Comment with links and logs | `gh issue comment <id> --body "Evidence: ..."` |
| Next steps    | Create work item            | `gh issue create --title "..." --body "..."`   |
| PR            | Open PR                     | `gh pr create --title "..." --body "..."`      |
| PR feedback   | Track PR comments           | `gh pr view <id> --comments`                   |

### Azure DevOps (ado CLI)

| Step          | Action                     | Command                                                  |
| ------------- | -------------------------- | -------------------------------------------------------- |
| Set state     | Update state field         | `ado workitems update --id <id> --state "Active"`        |
| Add component | Add tag                    | `ado workitems update --id <id> --tags "skill"`          |
| Plan approval | Add comment with plan link | `ado workitems comment <id> "Plan: <url>"`               |
| Sub-tasks     | Create child work items    | `ado workitems create --type Task --parent <id>`         |
| Evidence      | Add comment with links     | `ado workitems comment <id> "Evidence: ..."`             |
| Next steps    | Create work item           | `ado workitems create --type "User Story" --title "..."` |
| PR            | Open PR                    | `ado repos pr create --title "..." --description "..."`  |
| PR feedback   | Track PR comments          | `ado repos pr show --id <id> --comments`                 |

### Jira (jira CLI)

| Step          | Action                     | Command                                            |
| ------------- | -------------------------- | -------------------------------------------------- |
| Set state     | Transition issue           | `jira issue move <id> "In Progress"`               |
| Add component | Add component or label     | `jira issue edit <id> --component "Skills"`        |
| Plan approval | Add comment with plan link | `jira issue comment <id> "Plan: <url>"`            |
| Sub-tasks     | Create sub-tasks           | `jira issue create --type Subtask --parent <id>`   |
| Evidence      | Add comment with links     | `jira issue comment <id> "Evidence: ..."`          |
| Next steps    | Create issue               | `jira issue create --type Story --summary "..."`   |
| PR            | Open PR                    | (Depends on code hosting: GitHub, Bitbucket, etc.) |
| PR feedback   | Track PR                   | (Use code hosting CLI)                             |
```

### Step 2: Commit

```bash
git add skills/issue-driven-delivery/SKILL.md
git commit -m "docs(skill): add multi-platform CLI examples"
git push
```

## Task 7: Update tests for agnostic terminology

**Files:**

- Edit: `skills/issue-driven-delivery/issue-driven-delivery.test.md`

### Step 1: Update title

```markdown
# issue-driven-delivery - BDD Tests (RED)
```

### Step 2: Update test scenarios

Replace "GitHub" and "gh" references with platform-agnostic terms:

- "GitHub issue" → "work item"
- "gh" → "ticketing CLI"

### Step 3: Add state tracking assertions

```markdown
## Assertions (Expected to Fail Until Skill Exists)

...existing assertions...

- Work item state is updated through lifecycle (new feature → refinement → implementation → verification → complete).
- Work item is tagged with appropriate component (e.g., `skill` for skills repositories).
- State is set to `refinement` during planning.
- State is set to `implementation` after plan approval.
- State is set to `verification` when implementation complete.
- Work item cannot be closed without component tag.
```

### Step 4: Commit

```bash
git add skills/issue-driven-delivery/issue-driven-delivery.test.md
git commit -m "test(skill): update tests for agnostic terminology and new features"
git push
```

## Task 8: Update references in other files

**Files:**

- Edit: `AGENTS.md` (if it references github-issue-driven-delivery)
- Edit: `README.md` (if it references github-issue-driven-delivery)
- Edit: `skills/agent-workitem-automation/SKILL.md` (references github-issue-driven-delivery)

### Step 1: Search for references

```bash
grep -r "github-issue-driven-delivery" .
```

### Step 2: Update each reference

Replace `github-issue-driven-delivery` with `issue-driven-delivery` in all files found.

### Step 3: Commit

```bash
git add -A
git commit -m "refactor: update all references to renamed skill"
git push
```

## Task 9: Update BDD checklist with evidence

**Files:**

- Edit: `docs/plans/2026-01-05-issue-driven-delivery-refactoring.md`

### Step 1: Check each BDD item and mark complete

Go through the BDD checklist and mark each item as complete with evidence links:

```markdown
- [x] Skill renamed from `github-issue-driven-delivery` to `issue-driven-delivery`
  - Evidence: commit SHA
- [x] YAML frontmatter uses agnostic description (no "GitHub" mentioned)
  - Evidence: skills/issue-driven-delivery/SKILL.md:1-3
    ...etc...
```

### Step 2: Commit

```bash
git add docs/plans/2026-01-05-issue-driven-delivery-refactoring.md
git commit -m "docs(plan): update BDD checklist with evidence"
git push
```

## Task 10: Create PR and link to issue #47

**Files:**

- None (gh CLI operations)

### Step 1: Create PR

```bash
gh pr create --title "Refactor to ticketing-system-agnostic issue-driven-delivery" --body "$(cat <<'EOF'
## Summary

Refactors `github-issue-driven-delivery` to be ticketing-system agnostic with state tracking and component tagging.

## Changes

- Renamed skill from `github-issue-driven-delivery` to `issue-driven-delivery`
- Replaced all GitHub-specific terminology with platform-agnostic terms
- Added platform resolution logic (GitHub/Azure DevOps/Jira)
- Added work item state tracking (new feature → refinement → implementation → verification)
- Added component tagging requirements
- Updated Quick Reference with multi-platform CLI examples
- Updated tests for new behaviour

## Evidence

- Plan: https://github.com/mcj-coder/development-skills/blob/feat/issue-47-ticketing-agnostic-delivery/docs/plans/2026-01-05-issue-driven-delivery-refactoring.md
- All BDD checklist items complete with evidence

Closes #47

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

### Step 2: Link PR to issue

The "Closes #47" in PR body will auto-link and auto-close the issue on merge.

### Step 3: Post evidence comment on issue #47

```bash
gh issue comment 47 --body "$(cat <<'EOF'
## Implementation Complete

All acceptance criteria met:

- [x] Skill renamed to `issue-driven-delivery`
- [x] All GitHub-specific references replaced with platform-agnostic terminology
- [x] State tracking workflow documented
- [x] Component tagging requirements documented
- [x] Examples show multiple platforms (GitHub, Azure DevOps, Jira)
- [x] Tests updated to reflect new behaviour
- [x] Evidence of successful refactoring

PR: (will be filled after PR created)
Plan: https://github.com/mcj-coder/development-skills/blob/feat/issue-47-ticketing-agnostic-delivery/docs/plans/2026-01-05-issue-driven-delivery-refactoring.md
EOF
)"
```

## Verification Checklist

Before claiming complete, verify:

- [ ] All BDD checklist items marked complete with evidence
- [ ] Skill renamed successfully (directory, files, YAML frontmatter)
- [ ] No "GitHub" or "gh" in generic sections (only in platform-specific examples)
- [ ] Platform resolution logic added
- [ ] State tracking fully documented
- [ ] Component tagging fully documented
- [ ] Quick Reference shows all three platforms
- [ ] Tests updated and passing
- [ ] All references in other files updated
- [ ] PR created and linked to issue #47
- [ ] Evidence posted on issue #47
