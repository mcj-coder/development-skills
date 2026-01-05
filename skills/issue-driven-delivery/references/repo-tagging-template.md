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
- `component:auth` - Authentication/authorisation
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

## Customisation

These are **strong recommendations** for this repository. If you need different tags/structure:

1. Document your custom approach in this file
2. Update enforcement rules to match
3. Ensure consistency across all work items

## Questions?

See [issue-driven-delivery skill documentation](link-to-skill) for complete details on work item management and
tagging strategy.
