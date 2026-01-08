# detect-duplicates - BDD Tests

## Overview

Tests for the GitHub Actions workflow that detects potentially duplicate issues when new issues are created.

**Related Files:**

- `.github/workflows/detect-duplicates.yml` - Installed workflow
- `skills/issue-driven-delivery/templates/detect-duplicates.yml` - Template workflow
- `docs/playbooks/duplicate-detection.md` - Configuration playbook

## Baseline (No Workflow Present)

### Pressure Scenario 1: Undetected Duplicates

Given a new issue is created with similar scope to existing issues
When no duplicate detection exists
Then duplicate work is started unintentionally
And effort is wasted on already-addressed problems
And issue backlog grows with redundant entries

### Pressure Scenario 2: Manual Duplicate Search

Given a team member creates a new issue
When duplicate checking is manual
Then search quality varies by person
And some duplicates are missed entirely
And grooming takes longer to verify uniqueness

### Pressure Scenario 3: Late Duplicate Discovery

Given duplicate issues both reach implementation
When similarity is discovered late
Then work must be consolidated or discarded
And coordination overhead increases
And team frustration grows

## Baseline Observations (Simulated)

Without the workflow, typical problems include:

- "I didn't know this issue already existed."
- "We worked on the same thing in two different issues."
- "Grooming takes forever because we have to search for duplicates manually."
- "Our backlog has several issues that look very similar."

## Assertions (Workflow Behavior)

### Trigger Assertions

- [ ] Workflow triggers on `issues.opened` event
- [ ] Workflow does NOT trigger on `issues.edited` event
- [ ] Workflow does NOT trigger on `issues.labeled` event
- [ ] Workflow does NOT trigger on `issues.closed` event

### Detection Logic Assertions

- [ ] Workflow extracts keywords from issue title
- [ ] Stop words are filtered from search terms
- [ ] Short words (< 3 characters) are filtered
- [ ] Search queries open issues only
- [ ] Search excludes the triggering issue

### Comment Behavior Assertions

- [ ] Comment is posted when potential duplicates found
- [ ] Comment includes links to potential duplicate issues
- [ ] Comment includes issue titles for context
- [ ] No comment posted when no duplicates found
- [ ] Comment indicates it was auto-generated

### Edge Case Assertions

- [ ] Very short titles (< 3 keywords) skip detection
- [ ] Many matches (> 5) are truncated with note
- [ ] Exact title match is strongly highlighted
- [ ] Self-match (same issue) is excluded

## Scenarios

### Scenario 1: Duplicate Detected - Similar Title

Given issue #A exists with title "Add user authentication feature"
And issue #A is open
When new issue #B is created with title "Implement user authentication"
Then workflow triggers with event action "opened"
And workflow extracts keywords: "user", "authentication"
And workflow searches open issues for these terms
And workflow finds issue #A as potential match
And workflow posts comment on issue #B listing #A

**Verification:**

```bash
# Before: Create test issue with similar title
gh issue create --title "Implement user authentication" --body "Test issue"

# After: Check for duplicate detection comment
gh issue view N --json comments --jq '.comments[].body' | grep -i "Potential Duplicates"
# Expected: Comment with link to similar issue
```

### Scenario 2: No Duplicates Found

Given no existing issues match the new issue's keywords
When new issue #N is created with title "Unique feature not seen before"
Then workflow triggers with event action "opened"
And workflow extracts keywords: "unique", "feature", "seen", "before"
And workflow searches open issues
And workflow finds no matches
And NO comment is posted

### Scenario 3: Title Too Short

Given new issue #N is created with title "Fix bug"
When workflow triggers
Then workflow extracts keywords: "fix", "bug"
And both words are too common/short for reliable matching
And workflow skips duplicate detection
And NO comment is posted
And workflow logs "Title too short for reliable detection"

### Scenario 4: Many Matches Found

Given 10 existing open issues contain keyword "automation"
When new issue #N is created with title "New automation script"
Then workflow triggers
And workflow finds 10 potential matches
And workflow posts comment with TOP 5 matches only
And comment includes note "Showing 5 of 10 potential matches"

### Scenario 5: Exact Title Match

Given issue #A exists with title "Add dark mode support"
When new issue #B is created with title "Add dark mode support"
Then workflow triggers
And workflow detects exact title match
And workflow posts comment highlighting exact match
And comment emphasizes "Exact title match found"

### Scenario 6: Closed Issues Ignored

Given issue #A exists with title "Add export feature" but is CLOSED
When new issue #B is created with title "Add export feature"
Then workflow triggers
And workflow searches OPEN issues only
And workflow does NOT find #A (closed)
And workflow behavior depends on other open matches

### Scenario 7: Stop Words Filtered

Given new issue is created with title "The quick implementation of a feature"
When workflow extracts keywords
Then "the", "of", "a" are filtered as stop words
And "quick", "implementation", "feature" are used for search
And search is more targeted

### Scenario 8: Self-Match Excluded

Given workflow triggers for new issue #N
When search results include issue #N itself
Then issue #N is excluded from results
And only OTHER issues are reported as potential duplicates

## Edge Cases

### Edge Case 1: Issue Created and Immediately Edited

Given new issue #N is created
And issue #N is edited within seconds
When workflow runs for "opened" event
Then workflow processes original title at creation time
And edit event does NOT trigger duplicate detection

### Edge Case 2: Rate Limiting

Given GitHub API rate limits are approached
When duplicate detection workflow runs
Then workflow handles rate limit gracefully
And workflow outputs warning if limited
And workflow does not fail hard

### Edge Case 3: Special Characters in Title

Given new issue is created with title "Bug: 'null' error in API (v2.0)"
When workflow extracts keywords
Then special characters are handled safely
And search terms are properly escaped
And workflow does not error

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Issue:** #N (test issue)
**Title:** [issue title]
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Workflow Run:** [run ID or link]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the workflow:

- [ ] Workflow triggers only on issues.opened
- [ ] Keywords are extracted correctly
- [ ] Stop words are filtered
- [ ] Search targets open issues only
- [ ] Self-match is excluded
- [ ] Comment is posted when matches found
- [ ] No comment when no matches
- [ ] Comment format is correct
- [ ] Edge cases handled gracefully
- [ ] No breaking changes to template configuration
