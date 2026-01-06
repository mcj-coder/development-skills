# Platform Organization Options

## Overview

Different platforms have different capabilities for organizing epics, child tickets, and
dependencies. This reference covers options for each platform and how to capture the decision
in an ADR.

## GitHub Options

### Option A: GitHub Projects (Recommended)

```text
┌─────────────────────────────────────────────────────────────────┐
│ GitHub Projects                                                 │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Project board with linked issues                  │
│ Children    = Issues linked to project                          │
│ Dependencies= "Blocked by #X" in issue body + task lists        │
│ Grouping    = Project columns or custom fields                  │
│ Limitation  = No native blocker enforcement                     │
└─────────────────────────────────────────────────────────────────┘
```

**CLI Commands:**

```bash
# Create epic issue
gh issue create --title "Epic: [Title]" --body "[body with Mermaid graph]"

# Create child issue
gh issue create --title "[Child Title]" --body "Blocked by #[epic]

[body content]"

# Link to project (if using Projects)
gh project item-add [PROJECT_NUMBER] --owner [OWNER] --url [ISSUE_URL]
```

### Option B: Labels + Milestones

```text
┌─────────────────────────────────────────────────────────────────┐
│ Labels + Milestones                                             │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Milestone grouping issues                         │
│ Children    = Issues assigned to milestone                      │
│ Dependencies= "Blocked by #X" in issue body                     │
│ Grouping    = Labels (e.g., "epic:auth-system")                 │
│ Limitation  = Less visual than Projects                         │
└─────────────────────────────────────────────────────────────────┘
```

**CLI Commands:**

```bash
# Create milestone for epic
gh api repos/{owner}/{repo}/milestones -f title="[Epic Title]"

# Create issue with milestone
gh issue create --title "[Title]" --milestone "[Epic Title]" --label "epic:[name]"
```

### Option C: Tracking Issue

```text
┌─────────────────────────────────────────────────────────────────┐
│ Tracking Issue                                                  │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Parent issue with task list checkboxes            │
│ Children    = Issues linked in parent body                      │
│ Dependencies= Checkbox order + "blocked by" references          │
│ Grouping    = All child issues linked in parent body            │
│ Limitation  = Manual checkbox maintenance                       │
└─────────────────────────────────────────────────────────────────┘
```

**CLI Commands:**

```bash
# Create tracking issue with task list
gh issue create --title "[Epic Title]" --body "## Tasks

- [ ] #[child1] - [Title]
- [ ] #[child2] - [Title]
- [ ] #[child3] - [Title]

[Mermaid graph]"
```

## Azure DevOps Options

### Option A: Epic Work Item Type (Recommended)

```text
┌─────────────────────────────────────────────────────────────────┐
│ Epic Work Item                                                  │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Work item type "Epic"                             │
│ Children    = Features/User Stories linked as children          │
│ Dependencies= Predecessor/Successor links                       │
│ Grouping    = Native hierarchy in backlog                       │
│ Limitation  = Requires Epic work item type enabled              │
└─────────────────────────────────────────────────────────────────┘
```

**CLI Commands:**

```bash
# Create epic
az boards work-item create --type "Epic" --title "[Title]"

# Create child and link
az boards work-item create --type "User Story" --title "[Title]"
az boards work-item relation add --id [CHILD_ID] --relation-type "Parent" --target-id [EPIC_ID]

# Add dependency
az boards work-item relation add --id [ID] --relation-type "Predecessor" --target-id [BLOCKER_ID]
```

### Option B: Features + User Stories

```text
┌─────────────────────────────────────────────────────────────────┐
│ Features + User Stories                                         │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Feature work item                                 │
│ Children    = User Stories linked to Feature                    │
│ Dependencies= Predecessor/Successor links                       │
│ Grouping    = Feature hierarchy                                 │
│ Limitation  = One less hierarchy level available                │
└─────────────────────────────────────────────────────────────────┘
```

## Jira Options

### Option A: Epic Issue Type (Recommended)

```text
┌─────────────────────────────────────────────────────────────────┐
│ Epic Issue Type                                                 │
├─────────────────────────────────────────────────────────────────┤
│ Epic        = Issue type "Epic"                                 │
│ Children    = Stories/Tasks with Epic Link                      │
│ Dependencies= Issue links (blocks/is blocked by)                │
│ Grouping    = Epic swimlane in board                            │
│ Limitation  = Epic Link field required                          │
└─────────────────────────────────────────────────────────────────┘
```

**CLI Commands:**

```bash
# Create epic
jira issue create --type Epic --summary "[Title]"

# Create child with epic link
jira issue create --type Story --summary "[Title]" --parent [EPIC_KEY]

# Add blocker link
jira issue link [ISSUE_KEY] [BLOCKER_KEY] "is blocked by"
```

## ADR Template

After user selects platform organization, create ADR:

```markdown
# ADR: Ticket Organization for [Repository Name]

## Status

Accepted

## Context

This repository uses [Platform] for issue tracking. When decomposing large work items into
multiple tickets, we need a consistent approach for organizing epics, child tickets, and
dependencies.

## Decision

We will use **[Selected Option]** for ticket organization:

- **Epic representation:** [How epics are created]
- **Child tickets:** [How children are linked]
- **Dependencies:** [How blockers are tracked]
- **Grouping:** [How related tickets are grouped]

## Team Context

- Sprint duration: [X days]
- Ideal ticket size: [X days]
- Threshold for decomposition: [X requirements / X acceptance criteria]

## Consequences

### Positive

- [Benefit 1]
- [Benefit 2]

### Negative

- [Limitation 1]
- [Workaround if any]

## References

- Platform documentation: [link]
- Related skills: requirements-gathering, issue-driven-delivery
```

## ADR File Location

Save to: `docs/adr/NNNN-ticket-organization.md`

Where NNNN is the next sequential ADR number in the repository.

## Checking for Existing ADR

```bash
# Check if ADR exists
ls docs/adr/*ticket-organization* 2>/dev/null

# If found, read and apply decisions
# If not found, prompt user for platform options
```
