# sync-blocked-status - BDD Tests

## Overview

Tests for the GitHub Actions workflow that automatically unblocks dependent issues when their
blocking issues are closed.

**Related Files:**

- `.github/workflows/auto-unblock.yml` - Installed workflow
- `skills/issue-driven-delivery/templates/sync-blocked-status.yml` - Template workflow
- `scripts/issue-driven-delivery/unblock-dependents.sh` - Core script
- `docs/playbooks/blocked-sync.md` - Configuration playbook

## Baseline (No Workflow Present)

### Pressure Scenario 1: Stale Blocked Status

Given blocking issue #A is closed
When no automatic unblocking exists
Then dependent issue #B remains labeled "blocked" indefinitely
And team must manually discover #A was resolved
And #B delivery is delayed unnecessarily

### Pressure Scenario 2: Incomplete Multi-Blocker Updates

Given issue #C is blocked by #A, #B, #D
When #A is closed manually
Then team updates #C to remove #A from blockers
And team forgets to check if other blockers remain
And #C is unblocked prematurely OR stays blocked incorrectly

### Pressure Scenario 3: Hidden Dependency Chains

Given complex dependency graph exists
When multiple blockers close in sequence
Then manual tracking becomes error-prone
And blocked issues are forgotten or missed
And backlog health degrades over time

## Baseline Observations (Simulated)

Without the workflow, typical problems include:

- "I didn't know #A was resolved - #B could have started days ago."
- "We accidentally unblocked #C but it's still waiting on #D."
- "Our backlog has issues marked blocked that are no longer actually blocked."
- "Nobody remembered to update the blocked-by comment when blockers closed."

## Assertions (Workflow Behavior)

### Trigger Assertions

- [ ] Workflow triggers on `issues.closed` event
- [ ] Workflow does NOT trigger on `issues.opened` event
- [ ] Workflow does NOT trigger on `issues.labeled` event
- [ ] Workflow does NOT trigger on `issues.edited` event

### Detection Logic Assertions

- [ ] Script searches for issues with "Blocked by #N" pattern
- [ ] Script verifies issues have "blocked" label
- [ ] Script excludes the closed issue itself from results
- [ ] Script handles case-insensitive "Blocked by" pattern
- [ ] Script handles comma-separated blocker lists ("Blocked by #1, #2, #3")

### Single Blocker Assertions

- [ ] When sole blocker closes, "blocked" label is removed
- [ ] Comment "Auto-unblocked: #N completed" is posted
- [ ] Timestamp is included in unblock comment

### Multi-Blocker Assertions

- [ ] When one of multiple blockers closes, label remains
- [ ] Comment is posted listing remaining blockers
- [ ] Format: "Blocker #N resolved. Still blocked by: #X, #Y"

### Manual Block Assertions

- [ ] Manual blocks (external, waiting for, approval) are NOT auto-unblocked
- [ ] Warning is logged for manual blocks
- [ ] Issue state is preserved for manual review

### Edge Case Assertions

- [ ] No issues blocked: Script completes with info message
- [ ] Circular dependencies: Detected and reported with resolution suggestions
- [ ] Graph mode: ASCII output to terminal, Mermaid when piped

## Scenarios

### Scenario 1: Single Blocker - Full Unblock

Given issue #A is open with label "blocked"
And issue #A body contains "Blocked by: #100"
And issue #100 is the only blocker
When issue #100 is closed
Then workflow triggers with event action "closed"
And script finds #A blocked by #100
And script removes "blocked" label from #A
And script posts comment "Auto-unblocked: #100 completed [timestamp]"

**Verification:**

```bash
# Before: Create blocked issue
gh issue create --title "Dependent task" --body "Blocked by: #100" --label "blocked"

# After: Close blocker and verify
gh issue close 100
# Wait for workflow
gh issue view A --json labels,comments \
  --jq '{labels: .labels[].name, comment: .comments[-1].body}'
# Expected: No "blocked" label, comment with "Auto-unblocked"
```

### Scenario 2: Multiple Blockers - Partial Unblock

Given issue #B is open with label "blocked"
And issue #B body contains "Blocked by: #100, #101, #102"
And issue #100 is one of three blockers
When issue #100 is closed
Then workflow triggers
And script finds #B blocked by #100
And script detects other blockers (#101, #102)
And script keeps "blocked" label on #B
And script posts "Blocker #100 resolved. Still blocked by: #101, #102"

**Verification:**

```bash
# Check issue still has blocked label and updated comment
gh issue view B --json labels,comments \
  --jq '{labels: .labels[].name, lastComment: .comments[-1].body}'
# Expected: "blocked" label present, comment shows remaining blockers
```

### Scenario 3: No Dependent Issues

Given issue #100 is closed
And no other issues contain "Blocked by: #100"
When workflow triggers
Then script searches for blocked issues
And script finds no matches
And script logs "No issues blocked by #100"
And no comments are posted

### Scenario 4: Manual Block - Skip Auto-Unblock

Given issue #C is open with label "blocked"
And issue #C body contains "Blocked by: #100 (waiting for external approval)"
When issue #100 is closed
Then workflow triggers
And script detects manual blocker keyword "waiting for"
And script logs warning "has manual blocker - skipping auto-unblock"
And "blocked" label remains on #C
And no comment is posted

**Manual block keywords:**

- "waiting for"
- "external"
- "approval"
- "client"
- "vendor"
- "third party"

### Scenario 5: Circular Dependency Detection

Given issue #A body contains "Blocked by: #B"
And issue #B body contains "Blocked by: #C"
And issue #C body contains "Blocked by: #A"
When script runs with --graph flag
Then circular dependency is detected
And warning is logged with cycle path: "#A #B #C #A"
And resolution suggestions are provided
And rework cost is estimated (LOW/MEDIUM/HIGH)

### Scenario 6: Issue Without Blocked Label - Ignored

Given issue #D body contains "Blocked by: #100" in text
And issue #D does NOT have "blocked" label
When issue #100 is closed
Then workflow triggers
And script searches for blocked issues
And script verifies each candidate has "blocked" label
And script skips #D (no blocked label)

### Scenario 7: Dry Run Mode

Given script is run without --apply flag
When processing blocked issues
Then script outputs "[DRY-RUN] Would remove 'blocked' label"
And script outputs "[DRY-RUN] Would add comment"
And no actual changes are made
And final message says "Use --apply to make changes"

### Scenario 8: Graph Output - Terminal

Given script is run with --graph flag
And output is to terminal (TTY)
When processing issue #100
Then ASCII dependency graph is displayed
And graph shows closed issue as root
And graph shows dependent issues with status
And connectors use Unicode box-drawing characters

### Scenario 9: Graph Output - Piped

Given script is run with --graph flag
And output is piped (not TTY)
When processing issue #100
Then Mermaid graph syntax is output
And format is "graph TD" with node definitions
And edges show blocker relationships

## Edge Cases

### Edge Case 1: Recently Closed Issues Auto-Detection

Given no issue number is provided to script
When script runs without arguments
Then script auto-detects issues closed within last hour
And processes all detected issues
And logs count of issues found

### Edge Case 2: Comment Pattern Variations

Given issues use different "Blocked by" formats
When script parses blocking info
Then "Blocked by: #100" is matched
And "Blocked by #100" (no colon) is matched
And "blocked by #100" (lowercase) is matched
And "Blocked by #100, #101" (comma list) is matched

### Edge Case 3: API Rate Limiting

Given GitHub API rate limits are approached
When script makes API calls
Then errors are handled gracefully
And script continues with available data
And warning is logged if calls fail

### Edge Case 4: Invalid Issue References

Given "Blocked by #99999" references non-existent issue
When script processes blockers
Then script handles missing issue gracefully
And does not fail with API error

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Blocker Issue:** #N (closed issue)
**Dependent Issue:** #M (blocked issue)
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Workflow Run:** [run ID or link]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the workflow or script:

- [ ] Workflow triggers only on issues.closed
- [ ] Script finds blocked issues correctly
- [ ] Single blocker: label removed, comment posted
- [ ] Multiple blockers: label kept, comment updated
- [ ] Manual blocks are not auto-unblocked
- [ ] Circular dependencies are detected
- [ ] Graph output works (terminal and piped)
- [ ] Dry run mode works correctly
- [ ] No breaking changes to script arguments
- [ ] Error handling is graceful
