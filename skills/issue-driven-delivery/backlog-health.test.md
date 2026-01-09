# backlog-health - BDD Tests

## Overview

Tests for the backlog health report script that identifies issues needing attention
including missing labels, stale issues, extended blocks, and potential duplicates.

**Related Files:**

- `.github/workflows/backlog-health.yml` - Installed workflow
- `scripts/backlog-health.sh` - Installed script
- `skills/issue-driven-delivery/templates/backlog-health.sh` - Template script
- `skills/issue-driven-delivery/templates/backlog-health.yml` - Template workflow
- `docs/playbooks/backlog-health.md` - Configuration playbook

## Baseline (No Health Report Present)

### Pressure Scenario 1: Silent Label Gaps

Given a repository has 50+ open issues
When no health report exists
Then missing labels are only discovered during state transitions
And issues may sit unlabeled for weeks before detection
And state validation catches problems too late in the workflow

### Pressure Scenario 2: Stale Issue Accumulation

Given issues are opened but work is deferred
When no proactive staleness detection exists
Then issues accumulate without activity for months
And backlog grows unwieldy with abandoned work
And grooming sessions discover stale issues reactively

### Pressure Scenario 3: Extended Blocking Unnoticed

Given issues become blocked by dependencies
When no monitoring tracks block duration
Then issues remain blocked for weeks without escalation
And blocked work causes cascading delays
And team is unaware of systemic blocking patterns

### Pressure Scenario 4: Duplicate Work

Given similar issues are created by different team members
When no duplicate detection runs proactively
Then duplicate work is not discovered until implementation
And wasted effort occurs on redundant features
And issue linking happens too late

### Pressure Scenario 5: New Feature State Drift

Given issues are created with `state:new-feature` label
When no monitoring tracks state duration
Then issues remain in new-feature state indefinitely
And grooming backlog contains ancient unprocessed work
And team capacity is hidden by phantom issues

## Baseline Observations (Simulated)

Without the health report, typical problems include:

- "We found 15 issues without any labels during grooming."
- "This issue has been blocked for 6 weeks and nobody noticed."
- "Two teams worked on the same feature because issues weren't linked."
- "Half our backlog hasn't been touched in 90 days."
- "We have 30 issues still in new-feature state from last quarter."

## Assertions (Script Behavior)

### Configuration Assertions

- [ ] Script accepts `STALE_DAYS` environment variable (default: 30)
- [ ] Script accepts `BLOCKED_DAYS` environment variable (default: 14)
- [ ] Script accepts `NEW_FEATURE_DAYS` environment variable (default: 7)
- [ ] Script validates configuration values are positive integers
- [ ] Invalid configuration produces clear error and exits with code 2

### Health Check Category Assertions

- [ ] Script checks for issues missing required labels for their state
- [ ] Script checks for issues in `state:new-feature` longer than threshold
- [ ] Script checks for issues with `needs-info` label (unanswered questions)
- [ ] Script checks for issues with `blocked` label longer than threshold
- [ ] Script checks for issues with similar titles (potential duplicates)
- [ ] Script checks for issues with no activity longer than threshold

### Output Format Assertions

- [ ] Output is valid markdown
- [ ] Output contains summary statistics section
- [ ] Output contains separate sections for each health category
- [ ] Output contains recommendations section
- [ ] Each issue row includes issue number, title, and relevant date
- [ ] Output is written to `backlog-health-report.md` file

### Exit Code Assertions

- [ ] Script exits with code 0 when no issues found (healthy)
- [ ] Script exits with code 1 when only warnings found
- [ ] Script exits with code 2 when alerts or errors found
- [ ] Script exits with code 2 on configuration error

### Error Handling Assertions

- [ ] Script handles empty repository (no issues) gracefully
- [ ] Script handles API errors with warning annotations
- [ ] Script continues checking remaining categories if one check fails
- [ ] Script uses `::warning::` annotations for API failures

## Scenarios

### Scenario 1: Missing Labels Detection

Given repository has issues in various states
And issue #N has `state:implementation` but no `component:*` label
And issue #M has `state:verification` but no `work-type:*` label
When backlog health script runs
Then report includes "Missing Labels" section
And issue #N is listed with missing component label noted
And issue #M is listed with missing work-type label noted
And exit code is 1 (warnings)

**Verification:**

```bash
# Setup: Create test issue without proper labels
gh issue create --title "Test missing labels" --body "Test" --label "state:implementation"
# Note issue number

# Run script
./scripts/backlog-health.sh
echo "Exit code: $?"
# Expected: 1

# Check output
cat backlog-health-report.md | grep "Missing Labels"
# Expected: Section exists with issue listed
```

### Scenario 2: Stale State Detection

Given issue #N has `state:new-feature` label
And issue #N was created more than NEW_FEATURE_DAYS ago
When backlog health script runs
Then report includes "Stale State" section
And issue #N is listed with days in new-feature state
And recommendation suggests moving to grooming or closing

**Verification:**

```bash
# Run script with low threshold for testing
NEW_FEATURE_DAYS=1 ./scripts/backlog-health.sh

# Check output
cat backlog-health-report.md | grep "Stale State"
# Expected: Section exists with old new-feature issues
```

### Scenario 3: Extended Block Detection

Given issue #N has `blocked` label
And issue #N has been blocked for more than BLOCKED_DAYS
When backlog health script runs
Then report includes "Extended Blocks" section with Alert severity
And issue #N is listed with days blocked
And exit code is 2 (alerts)

**Verification:**

```bash
# Run script with low threshold
BLOCKED_DAYS=1 ./scripts/backlog-health.sh
echo "Exit code: $?"
# Expected: 2 (alert severity)

cat backlog-health-report.md | grep "Extended Blocks"
# Expected: Section exists
```

### Scenario 4: Stale Issue Detection

Given issue #N has no activity for more than STALE_DAYS
And issue #N is still open
When backlog health script runs
Then report includes "Stale Issues" section
And issue #N is listed with days since last activity
And last activity date is shown

**Verification:**

```bash
# Run script
STALE_DAYS=7 ./scripts/backlog-health.sh

# Check output
cat backlog-health-report.md | grep "Stale Issues"
# Expected: Section exists with inactive issues
```

### Scenario 5: Healthy Backlog - No Issues

Given all open issues have proper labels for their state
And no issues are blocked beyond threshold
And no issues are stale beyond threshold
When backlog health script runs
Then report shows summary with zero counts
And each category section shows "No issues found"
And exit code is 0 (healthy)

**Verification:**

```bash
# Run script on well-maintained backlog
./scripts/backlog-health.sh
echo "Exit code: $?"
# Expected: 0

cat backlog-health-report.md | grep "0 issues"
# Expected: Summary shows healthy counts
```

### Scenario 6: Unanswered Questions Detection

Given issue #N has `needs-info` label
And issue #N has been waiting for response
When backlog health script runs
Then report includes "Unanswered Questions" section
And issue #N is listed as needing response

**Verification:**

```bash
# Setup: Add needs-info label to test issue
gh issue edit N --add-label "needs-info"

# Run script
./scripts/backlog-health.sh

# Check output
cat backlog-health-report.md | grep "Unanswered Questions"
# Expected: Section exists with issue listed
```

### Scenario 7: Custom Thresholds

Given repository has specific staleness requirements
When script runs with custom environment variables:

- `STALE_DAYS=60`
- `BLOCKED_DAYS=7`
- `NEW_FEATURE_DAYS=3`

Then thresholds are applied correctly
And issues within new thresholds are reported
And issues outside new thresholds are not flagged

**Verification:**

```bash
# Run with custom thresholds
STALE_DAYS=60 BLOCKED_DAYS=7 NEW_FEATURE_DAYS=3 ./scripts/backlog-health.sh

# Verify thresholds were applied
cat backlog-health-report.md | head -20
# Expected: Configuration section shows custom values
```

### Scenario 8: Workflow Manual Trigger

Given workflow is configured with `workflow_dispatch`
When user manually triggers workflow from Actions tab
Then workflow runs successfully
And report is generated as artifact
And workflow summary shows health check results

**Verification:**

```bash
# Trigger workflow manually
gh workflow run backlog-health.yml

# Wait for completion
sleep 30
gh run list --workflow=backlog-health.yml --limit=1 --json status,conclusion

# Download artifact
gh run download --name backlog-health-report
cat backlog-health-report.md
```

### Scenario 9: Scheduled Workflow Run

Given workflow is configured with weekly schedule
When scheduled trigger fires (Monday 9 AM UTC)
Then workflow runs automatically
And report reflects current backlog state
And artifact is retained for 90 days

**Verification:**

```bash
# Check workflow runs for scheduled trigger
gh run list --workflow=backlog-health.yml --json event,createdAt \
  --jq '.[] | select(.event=="schedule")'
# Expected: Shows scheduled runs
```

## Edge Cases

### Edge Case 1: Empty Repository

Given repository has zero open issues
When backlog health script runs
Then script completes successfully
And report shows "No open issues" message
And exit code is 0 (healthy)

### Edge Case 2: Large Backlog

Given repository has 500+ open issues
When backlog health script runs
Then script handles pagination correctly
And all issues are analyzed
And script completes within timeout (10 minutes)

### Edge Case 3: API Rate Limiting

Given GitHub API rate limit is nearly exhausted
When backlog health script runs
Then script detects low rate limit
And script outputs warning annotation
And script continues with available data or gracefully degrades

### Edge Case 4: Network Failure

Given network connectivity is interrupted during script
When a `gh` command fails
Then script catches the error
And script outputs warning for failed check
And script continues with remaining checks
And final report notes incomplete data

### Edge Case 5: Invalid Configuration Values

Given `STALE_DAYS` is set to negative number
When backlog health script runs
Then script outputs configuration error
And script exits with code 2 immediately
And no partial report is generated

### Edge Case 6: Non-Numeric Configuration

Given `BLOCKED_DAYS` is set to "abc"
When backlog health script runs
Then script outputs "must be numeric" error
And script exits with code 2

### Edge Case 7: Issue With No Labels

Given issue #N has zero labels (completely unlabeled)
When backlog health script runs
Then issue #N appears in "Missing Labels" section
And issue is flagged for all missing label types based on age

### Edge Case 8: Recently Created Issues

Given issue #N was created 1 day ago
And default thresholds apply (7 days for new-feature)
When backlog health script runs
Then issue #N is NOT flagged as stale
And issue #N is NOT flagged for state duration (within threshold)

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Repository:** [repo name]
**Configuration:** [environment variables used]
**Action:** [what was done]
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Exit Code:** [script exit code]
**Report Link:** [link to generated report or artifact]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the script or workflow:

- [ ] All 6 health categories are checked
- [ ] Default thresholds work correctly (30/14/7 days)
- [ ] Custom thresholds are applied when set
- [ ] Exit codes correctly reflect severity (0/1/2)
- [ ] Markdown output is valid and formatted
- [ ] GitHub annotations are output correctly
- [ ] Workflow permissions are minimal (issues:read, contents:read)
- [ ] Workflow timeout is set (10 minutes)
- [ ] Manual trigger works via workflow_dispatch
- [ ] Schedule trigger is configured correctly
- [ ] Error handling degrades gracefully
- [ ] Configuration validation catches invalid values
- [ ] Large backlogs are handled within timeout
- [ ] Empty repositories are handled gracefully
