# check-issue-reference - BDD Tests

## Overview

Tests for the commit message validation that ensures all commits reference a GitHub issue for
traceability.

**Related Files:**

- `.husky/commit-msg` - Git hook that runs commitlint
- `commitlint.config.cjs` - Commitlint configuration with custom rule
- `scripts/commitlint-issue-reference.cjs` - Custom issue reference rule
- `.github/workflows/check-issue-reference.yml` - CI workflow for PR validation
- `skills/issue-driven-delivery/templates/check-issue-reference.yml` - Template workflow
- `docs/playbooks/standards-compliance.md` - Configuration playbook

## Baseline (No Validation Present)

### Pressure Scenario 1: Untraceable Changes

Given a developer commits without issue reference
When changes are merged
Then no audit trail connects code to requirements
And debugging "why was this changed?" becomes difficult
And compliance reviews cannot verify authorisation

### Pressure Scenario 2: Lost Context

Given multiple developers work on various features
When commits lack issue references
Then commit history provides no business context
And onboarding developers struggle to understand changes
And code archaeology becomes guesswork

### Pressure Scenario 3: Metrics Blind Spots

Given management wants to track development velocity
When commits don't reference issues
Then velocity metrics are incomplete
And issue cycle time cannot be calculated
And process improvements lack data

## Baseline Observations (Simulated)

Without issue reference validation, typical problems include:

- "I don't know which issue this change was for."
- "We can't track how many commits it took to resolve this bug."
- "The commit message says what changed but not why."
- "Compliance audit failed because we can't prove authorisation for changes."

## Assertions (Validation Behaviour)

### Pre-Commit Hook Assertions

- [ ] Hook triggers on every commit attempt
- [ ] Hook validates commit message format
- [ ] Hook blocks commits without valid issue reference
- [ ] Hook allows bypass with `--no-verify` flag
- [ ] Hook provides clear error message with expected format

### Issue Reference Pattern Assertions

- [ ] `Refs: #123` is accepted (single reference)
- [ ] `Refs: #123, #456` is accepted (multiple references)
- [ ] `Fixes: #123` is accepted (closing reference)
- [ ] `(#123)` in subject is accepted (PR convention)
- [ ] Reference anywhere in message body is accepted
- [ ] Reference must use `#` followed by digits

### Exception Assertions

- [ ] Merge commits are exempt (start with "Merge")
- [ ] Revert commits are exempt (start with "Revert")
- [ ] Initial commits are exempt (message is "Initial commit")
- [ ] Dependabot commits are exempt (author contains "dependabot")
- [ ] Release/version commits are exempt (contains "release" or "version")

### CI Workflow Assertions

- [ ] Workflow triggers on pull_request events
- [ ] Workflow checks all commits in PR
- [ ] Workflow fails if any commit lacks reference
- [ ] Workflow skips exempt commit types
- [ ] Workflow provides summary of validation results

## Scenarios

### Scenario 1: Valid Reference - Refs Format

Given a developer writes a commit message
When the message contains "Refs: #123"
Then the commit-msg hook passes
And the commit is created successfully

**Example:**

```text
feat(api): add user authentication endpoint

Implement JWT-based authentication for the API.

Refs: #123
```

**Verification:**

```bash
# Test commit message validation
echo "feat: test feature

Refs: #100" | npx commitlint
# Expected: No errors
```

### Scenario 2: Valid Reference - Fixes Format

Given a developer writes a commit message
When the message contains "Fixes: #456"
Then the commit-msg hook passes
And the issue #456 will be closed on merge

**Example:**

```text
fix(auth): resolve token expiry race condition

Fixes: #456
```

### Scenario 3: Valid Reference - PR Convention

Given a developer writes a commit message
When the subject contains "(#789)"
Then the commit-msg hook passes
And the reference is recognised in the title

**Example:**

```text
feat(ui): add dark mode toggle (#789)

Implement system preference detection and manual override.
```

### Scenario 4: Invalid - No Reference

Given a developer writes a commit message
When the message contains no issue reference
Then the commit-msg hook fails
And error message shows expected format
And commit is not created

**Example (fails):**

```text
feat(api): add new endpoint

This adds a new API endpoint for user profiles.
```

**Expected error:**

```text
✖   Commit message must reference an issue (e.g., Refs: #123)
```

### Scenario 5: Invalid - Wrong Format

Given a developer writes a commit message
When the message contains "Issue 123" (no # symbol)
Then the commit-msg hook fails
And error message clarifies correct format

**Example (fails):**

```text
feat: implement feature

Issue 123
```

### Scenario 6: Exception - Merge Commit

Given a merge commit is created
When the message starts with "Merge"
Then issue reference validation is skipped
And the commit is allowed

**Example (allowed):**

```text
Merge branch 'feat/user-auth' into main
```

### Scenario 7: Exception - Revert Commit

Given a revert commit is created
When the message starts with "Revert"
Then issue reference validation is skipped
And the commit is allowed

**Example (allowed):**

```text
Revert "feat(api): add broken endpoint"

This reverts commit abc123.
```

### Scenario 8: Exception - Dependabot

Given a Dependabot creates a commit
When the commit author contains "dependabot"
Then issue reference validation is skipped
And automated dependency updates proceed

**Note:** CI workflow checks author; local hook cannot verify this.

### Scenario 9: Multiple References

Given a developer references multiple issues
When the message contains "Refs: #100, #101, #102"
Then all references are recognised
And commit is allowed

### Scenario 10: CI - PR with Valid Commits

Given a pull request with 3 commits
When all commits contain valid issue references
Then CI workflow passes
And PR can be merged

### Scenario 11: CI - PR with Invalid Commit

Given a pull request with 3 commits
When one commit lacks issue reference
Then CI workflow fails
And PR shows failing check
And commit requiring fix is identified

## Edge Cases

### Edge Case 1: Reference in Footer Only

Given a commit message has reference only in footer
When footer contains "Refs: #123"
Then validation passes (footer is valid location)

### Edge Case 2: Multiple Refs Statements

Given a commit message has multiple Refs lines
When body contains "Refs: #100" and "Refs: #200"
Then validation passes (any valid reference suffices)

### Edge Case 3: Case Sensitivity

Given "refs: #123" (lowercase) in message
When validation runs
Then it should pass (case-insensitive matching)

### Edge Case 4: Co-Authored Commits

Given a commit with Co-Authored-By footer
When the commit also has "Refs: #123"
Then both footers are preserved
And validation passes

### Edge Case 5: Squash Merge Messages

Given a PR is squash-merged
When GitHub generates the squash message
Then the PR number "(#N)" in subject satisfies requirement

## Test Evidence Format

For each test scenario, record:

```markdown
### Test: [Scenario Name]

**Date:** YYYY-MM-DD
**Commit:** [commit SHA or test commit]
**Message:** [commit message tested]
**Expected:** [expected outcome]
**Actual:** [actual outcome]
**Status:** PASS/FAIL
```

## Regression Checklist

Use this checklist when modifying the validation:

- [ ] Hook triggers on commit attempt
- [ ] `Refs: #N` format accepted
- [ ] `Fixes: #N` format accepted
- [ ] `(#N)` in subject accepted
- [ ] Missing reference is rejected
- [ ] Wrong format (no #) is rejected
- [ ] Merge commits are exempt
- [ ] Revert commits are exempt
- [ ] Dependabot commits are exempt (CI only)
- [ ] CI workflow validates all PR commits
- [ ] Error messages are clear
- [ ] `--no-verify` bypass works
