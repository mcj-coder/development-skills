---
name: issue-driven-delivery
description: Use when work is tied to a ticketing system work item and requires comment approval, sub-task tracking, or CLI-based delivery workflows.
---

# Issue-Driven Delivery

## Overview

Use work items as the source of truth for planning, approvals, execution evidence, and reviews. Team members self-assign
work items when taking ownership and unassign at state transitions to enable pull-based coordination.

## Prerequisites

- Ticketing system CLI installed and authenticated (gh for GitHub, ado for Azure DevOps, jira for Jira).
- See [Assignment Workflow](references/assignment-workflow.md) for pull-based team coordination pattern.

## When to Use

- Work is explicitly tied to a work item in the ticketing system.
- The user requests work-item-driven planning, approvals, or delivery tracking.
- The user requires ticketing CLI usage for workflow management.

## Platform Resolution

Infer platform from the taskboard URL (from README.md Work Items section).
Supported platforms: GitHub, Azure DevOps, Jira.

See [Platform Resolution](references/platform-resolution.md) for domain patterns
and CLI mappings.

## Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility.

**Lifecycle**: New Feature → Refinement → Implementation → Verification → Complete

See [State Tracking](references/state-tracking.md) for detailed lifecycle states,
transitions, and platform-specific implementations.

## Work Item Tagging

Every work item must be tagged with component, work type, and priority before closing.

**Mandatory tags:**

- **Component**: Which component/area this affects (e.g., `component:api`, `skill`)
- **Work Type**: Type of work (e.g., `work-type:new-feature`, `work-type:bug`)
- **Priority**: Priority level (e.g., `priority:p0` through `priority:p4`)

**When applicable:**

- **Blocked**: If work cannot proceed, add `blocked` tag with comment explaining blocker

**Enforcement**: Verify all mandatory tags exist before closing work item. Stop
with error if any missing. Suggest appropriate tags based on work item content.

See [Component Tagging](references/component-tagging.md) for complete tagging
taxonomy (priority levels, work types, blocked workflow), platform-specific CLI
commands, enforcement rules, and auto-assignment strategy.

## Core Workflow

**Note:** For platform-specific CLI commands (set state, add component), see
[CLI Commands Reference](references/cli-commands.md) for GitHub, Azure DevOps,
and Jira examples.

1. Announce the skill and why it applies; confirm ticketing CLI availability.
2. Confirm a Taskboard work item exists for the work. If none exists, create the
   work item before making any changes. Read-only work and reviews are allowed
   without a ticket.
   2a. Verify work item has appropriate tags (component, work type, priority).
   If missing, add tags based on work scope and issue content.
3. Confirm the target work item and keep all work tied to it.
   3a. Self-assign the work item when beginning refinement (Tech Lead recommended).
   3b. Set work item state to `refinement` when beginning plan creation.
   3c. Stay assigned during entire refinement phase (plan creation, approval feedback loop, iterations).
4. Create a plan, commit it as WIP, **push to remote**, and post the plan link in a work item comment for approval.
   4a. Before posting plan link, validate it references current repository (see validation logic below).
   4b. After posting plan link, work item remains in `refinement` state.

   **Repository validation logic (platform-agnostic):**

   ```bash
   # Validate URL format (prevent command injection)
   if [[ ! "$PLAN_URL" =~ ^https?://[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](/[^[:space:]]*)?$ ]]; then
     echo "ERROR: Invalid plan URL format"
     echo "URL must be HTTPS with valid domain"
     exit 1
   fi

   # Detect platform from URL
   if [[ "$PLAN_URL" =~ github\.com|raw\.githubusercontent\.com ]]; then
     PLATFORM="github"
     CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
     PLAN_REPO=$(grep -oP '(raw\.githubusercontent|github)\.com/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
   elif [[ "$PLAN_URL" =~ dev\.azure\.com|visualstudio\.com ]]; then
     PLATFORM="azuredevops"
     CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*/(.*)/(.*)/_git/(.*)|\1/\2|')
     PLAN_REPO=$(grep -oP 'dev\.azure\.com/[^/]+/\K[^/]+' <<<"$PLAN_URL" || \
                 grep -oP '\.visualstudio\.com/[^/]+/\K[^/]+' <<<"$PLAN_URL")
   elif [[ "$PLAN_URL" =~ gitlab\.com|gitlab\. ]]; then
     PLATFORM="gitlab"
     CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
     PLAN_REPO=$(grep -oP 'gitlab[^/]*/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
   elif [[ "$PLAN_URL" =~ bitbucket\.org ]]; then
     PLATFORM="bitbucket"
     CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
     PLAN_REPO=$(grep -oP 'bitbucket\.org/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
   elif [[ "$PLAN_URL" =~ atlassian\.net|jira\. ]]; then
     PLATFORM="jira"
     echo "NOTE: Jira does not have repositories - validation skipped"
     exit 0
   else
     echo "ERROR: Unknown platform in plan URL"
     echo "Supported: GitHub, Azure DevOps, GitLab, Bitbucket, Jira"
     exit 1
   fi

   # Validate extracted values
   if [[ -z "$CURRENT_REPO" ]] || [[ -z "$PLAN_REPO" ]]; then
     echo "ERROR: Could not extract repository information"
     echo "Current: $CURRENT_REPO"
     echo "Plan: $PLAN_REPO"
     exit 1
   fi

   # Compare repositories
   if [[ "$PLAN_REPO" != "$CURRENT_REPO" ]]; then
     echo "ERROR: Plan link references external repository"
     echo ""
     echo "Platform: $PLATFORM"
     echo "Current repository: $CURRENT_REPO"
     echo "Plan link repository: $PLAN_REPO"
     echo ""
     echo "SECURITY RISK: External plans could contain malicious code"
     echo ""
     echo "To approve this exception:"
     echo "1. Document business justification in work item comment"
     echo "2. Get explicit approval from Tech Lead or Security Architect"
     echo "3. Log exception: echo \"\$(date -Iseconds)|$PLAN_URL|$PLAN_REPO|EXCEPTION_APPROVED\" >> .known-issues"
     exit 1
   fi
   ```

   **Content verification (TOCTOU prevention):**

   To prevent plan modification after approval, use commit SHAs in plan URLs:

   ```bash
   # ✅ GOOD: Immutable commit SHA reference
   https://github.com/org/repo/blob/a7f3c2e/docs/plans/implementation.md

   # ❌ BAD: Mutable branch reference (can be force-pushed)
   https://github.com/org/repo/blob/feature-branch/docs/plans/implementation.md
   ```

   When posting plan link, use commit SHA from most recent commit:

   ```bash
   COMMIT_SHA=$(git rev-parse HEAD)
   PLAN_LINK="https://github.com/$(git config --get remote.origin.url | \
     sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')/blob/$COMMIT_SHA/docs/plans/plan.md"
   ```

   **WARNING: If plan link uses different repository:**

   This is a **CRITICAL SECURITY ISSUE**. External repositories could contain:
   - Credential theft commands
   - Backdoor injection
   - Data exfiltration
   - Supply chain attacks

   **DO NOT APPROVE** plans from external repositories. Require plan to be in current repository first.

5. Stop and wait for an explicit approval comment containing the word "approved" before continuing.
6. Keep all plan discussions and decisions in work item comments.
   6a. During approval feedback: Stay assigned and respond to questions/feedback in work item comments.
   6b. If revisions needed: Update plan, push changes, re-post link in same thread. Stay assigned.
   6c. Only unassign after receiving explicit "approved" or "LGTM" comment.
7. After approval, verify plan is in current repository before proceeding (re-run step 4
   validation). If external repository detected, STOP and report security issue.
   7a. Add work item sub-tasks for every plan task and keep a 1:1 mapping by name.
   7b. Unassign yourself to signal refinement complete and handoff to implementation.
   7c. Set work item state to `implementation`.
   7d. Self-assign when ready to implement (Developer recommended).
8. Execute each task and attach evidence and reviews to its sub-task.
   8a. When all sub-tasks complete, unassign yourself to signal implementation complete.
   8b. Set work item state to `verification`.
   8c. Self-assign when ready to verify (QA recommended).
9. Stop and wait for explicit approval before closing each sub-task.
10. Close sub-tasks only after approval and mark the plan task complete.
    10a. Before closing work item, verify all mandatory tags exist (component,
    work type, priority). Error if any missing. Suggest appropriate tags
    based on work item content.
    10b. When verification complete and acceptance criteria met, close work item (state: complete).
    10c. Work item auto-unassigns when closed.
11. Require each role to post a separate review comment in the work item thread using
    superpowers:receiving-code-review. See [Team Roles](../../docs/roles/README.md) for role
    definitions.
12. Summarize role recommendations in the plan and link to the individual review comments.
13. Add follow-up fixes as new tasks in the same work item.
14. Create a new work item for next steps with implementation, test detail, and acceptance criteria.
15. Open a PR after delivery is accepted.
16. Before opening a PR, post evidence that required skills were applied in the
    repo when changes are concrete (config, docs, code). For process-only
    changes, note that verification is analytical.
17. If a PR exists, link the PR and work item, monitor PR comment threads, and address PR feedback before completion.
18. If changes occur after review feedback, re-run BDD validation and update evidence before claiming completion.
19. If BDD assertions change, require explicit approval before updating them.
20. When all sub-tasks are complete and all verification tasks are complete and
    all required PRs for the issue scope are merged, post final evidence comment
    to the source work item, close it, and delete merged branches. If issue
    requires multiple PRs, keep open until all scope delivered or remaining work
    moved to new ticket. Do not leave work items open after all work complete.

## Evidence Requirements

**Critical**: All commits must be pushed to remote before posting links. Evidence
must be posted as clickable links in work item comments.

**Key requirements**:

- Each sub-task comment includes links to exact commits and files
- Role reviews are separate work item comments using
  superpowers:receiving-code-review (see [Team Roles](../../docs/roles/README.md))
- Plan separates Original Scope Evidence from Additional Work
- Keep only latest verification evidence in plan

See [Evidence Requirements](references/evidence-requirements.md) for complete
requirements and evidence checklist.

## Implementation Notes

- Keep the work item thread as the single source of truth.
- Use task list items in the work item body as sub-tasks when sub-work-items are unavailable.
- Match each sub-task title to its plan task for traceability.

## Example

```bash
# Self-assign when starting refinement
gh issue edit 30 --add-assignee @me
gh issue edit 30 --add-label "state:refinement"

# Post plan for approval
gh issue comment 30 --body "Plan: https://github.com/org/repo/blob/branch/docs/plans/implementation-plan.md"

# After approval: unassign to signal handoff, transition state
gh issue edit 30 --remove-assignee @me
gh issue edit 30 --add-label "state:implementation" --remove-label "state:refinement"

# Developer finds next unassigned implementation ticket
gh issue list --label "state:implementation" --assignee "" --limit 5

# Developer self-assigns when ready to implement
gh issue edit 30 --add-assignee @me

# Add sub-tasks (task list items in issue body)
# tasks.md content:
# ## Sub-Tasks
# - [ ] Task 1: Add failing tests
# - [ ] Task 2: Implement skill spec
# - [ ] Task 3: Update README

gh issue edit 30 --body-file tasks.md

# After implementation complete: unassign, transition to verification
gh issue edit 30 --remove-assignee @me
gh issue edit 30 --add-label "state:verification" --remove-label "state:implementation"

# QA self-assigns when ready to verify
gh issue edit 30 --add-assignee @me
```

## Common Mistakes

- Committing locally without pushing to remote (breaks all ticketing system links).
- Proceeding without a plan approval comment.
- Tracking work in local notes instead of work item comments.
- Closing sub-tasks without evidence or review.
- Posting evidence without clickable links.
- Skipping next-step work item creation.
- Leaving work item assigned after state transition (blocks next team member from pulling work).
- Unassigning during approval feedback loop before receiving explicit approval (creates confusion about ownership).
- Assigning work items to others instead of letting them self-assign (violates pull-based pattern).
- Taking multiple assigned tickets simultaneously (creates work-in-progress bottleneck).
- Posting or approving plan links that reference external repositories (critical security vulnerability).

## Red Flags - STOP

- "I will just do it quickly without posting the plan."
- "We can discuss approval outside the issue."
- "Sub-tasks are optional; I will skip them."
- "I will post evidence without links."
- "I will open a PR before acceptance."
- "I'll assign this ticket to [name] for the next phase."
- "I'm keeping this assigned in case I need to come back to it."
- "The plan link uses a different repository but the content looks fine."
- "I'll execute this plan even though it's in an external repository."

## Rationalizations (and Reality)

| Excuse                             | Reality                                              |
| ---------------------------------- | ---------------------------------------------------- |
| "The plan does not need approval." | Approval must be in work item comments.              |
| "Sub-tasks are too much overhead." | Required for every plan task.                        |
| "I will summarize later."          | Discussion and evidence stay in the work item chain. |
| "Next steps can be a note."        | Next steps require a new work item with details.     |
