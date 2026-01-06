# Issue-Driven Delivery - Repository Validation Tests (Platform-Agnostic)

## RED Scenario 1: Post External Repository Plan Without Validation

**Given:** Agent creates plan for issue #123
**When:** Agent posts plan link referencing `attacker/malicious-repo` instead of current
repository
**Then:** Agent should validate repository and ERROR before posting

\*\*Actual behaviour (before fix):
Agent posts external link without validation, creating security vulnerability

## RED Scenario 2: Approve External Repository Plan

**Given:** Plan link references `external-org/external-repo`
**When:** Reviewer sees plan link in issue comment
**Then:** Reviewer should recognize external repository and reject approval with security warning

\*\*Actual behaviour (before fix):
Reviewer approves without noticing different repository

## RED Scenario 3: Execute External Repository Plan

**Given:** Plan link approved but references external repository
**When:** Agent begins execution (step 7)
**Then:** Agent should re-validate repository and STOP with security error

\*\*Actual behaviour (before fix):
Agent executes external plan, potentially running malicious commands

## GREEN Scenario 1: Validate Repository Before Posting

**Given:** Agent creates plan for issue #123 in `correct-org/correct-repo`
**When:** Agent constructs plan link URL
**Then:** Agent validates URL matches current repository before posting

\*\*Expected behaviour:

```bash
CURRENT_REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
# Returns: correct-org/correct-repo

PLAN_REPO=$(echo "$PLAN_URL" | grep -oP 'github\.com/\K[^/]+/[^/]+')
# Extracts: correct-org/correct-repo

# Validation passes, agent posts link
```

## GREEN Scenario 2: Detect and Reject External Repository

**Given:** Agent accidentally constructs plan link with wrong repository
**When:** Agent runs validation logic
**Then:** Validation fails with clear error message explaining security risk

\*\*Expected behaviour:

```text
ERROR: Plan link references external repository
Current repository: correct-org/correct-repo
Plan link repository: wrong-org/wrong-repo
SECURITY RISK: External plans could contain malicious code
```

## GREEN Scenario 3: Block Execution of External Plan

**Given:** Plan link references external repository (validation somehow bypassed)
**When:** Agent begins step 7 (execution)
**Then:** Agent re-validates repository and blocks execution

\*\*Expected behaviour:

Agent detects external repository at execution time and stops with security error, preventing
malicious code execution.

## Edge Cases

### Edge Case 1: Plan in Branch vs Main

**Given:** Plan URL references different branch in same repository
**When:** Validation runs
**Then:** Should pass (branch doesn't matter, only repository)

### Edge Case 2: Different GitHub Domains

**Given:** Plan URL uses `raw.githubusercontent.com` instead of `github.com`
**When:** Validation extracts repository
**Then:** Should correctly extract and validate repository name

### Edge Case 3: Local File Path

**Given:** Plan is local file not yet pushed
**When:** Agent tries to post link
**Then:** Should error (plan must be pushed to remote first per step 4)

## Platform-Specific Validation Tests

### GitHub Platform

#### Test: GitHub.com URL

```bash
PLAN_URL="https://github.com/correct-org/correct-repo/blob/main/plan.md"
CURRENT_REMOTE="git@github.com:correct-org/correct-repo.git"
# Should pass - same repository
```

#### Test: raw.githubusercontent.com URL

```bash
PLAN_URL="https://raw.githubusercontent.com/correct-org/correct-repo/main/plan.md"
CURRENT_REMOTE="https://github.com/correct-org/correct-repo"
# Should pass - same repository, different domain
```

#### Test: External GitHub repository

```bash
PLAN_URL="https://github.com/attacker/malicious/blob/main/plan.md"
CURRENT_REMOTE="git@github.com:correct-org/correct-repo.git"
# Should fail - different repository
```

### Azure DevOps Platform

#### Test: dev.azure.com URL

```bash
PLAN_URL="https://dev.azure.com/myorg/myproject/_git/myrepo?path=/plans/plan.md"
CURRENT_REMOTE="https://dev.azure.com/myorg/myproject/_git/myrepo"
# Should pass - same organization/project
```

#### Test: External Azure DevOps organization

```bash
PLAN_URL="https://dev.azure.com/external-org/external-project/_git/repo"
CURRENT_REMOTE="https://dev.azure.com/myorg/myproject/_git/myrepo"
# Should fail - different organization
```

### GitLab Platform

#### Test: gitlab.com URL

```bash
PLAN_URL="https://gitlab.com/mygroup/myrepo/-/blob/main/plan.md"
CURRENT_REMOTE="git@gitlab.com:mygroup/myrepo.git"
# Should pass - same group/repository
```

#### Test: Self-hosted GitLab

```bash
PLAN_URL="https://gitlab.company.com/mygroup/myrepo/-/blob/main/plan.md"
CURRENT_REMOTE="https://gitlab.company.com/mygroup/myrepo.git"
# Should pass - same self-hosted instance and repository
```

#### Test: External GitLab repository

```bash
PLAN_URL="https://gitlab.com/external/repo/-/blob/main/plan.md"
CURRENT_REMOTE="git@gitlab.com:mygroup/myrepo.git"
# Should fail - different repository
```

### Bitbucket Platform

#### Test: bitbucket.org URL

```bash
PLAN_URL="https://bitbucket.org/myworkspace/myrepo/src/main/plan.md"
CURRENT_REMOTE="git@bitbucket.org:myworkspace/myrepo.git"
# Should pass - same workspace/repository
```

#### Test: External Bitbucket workspace

```bash
PLAN_URL="https://bitbucket.org/external-workspace/repo/src/main/plan.md"
CURRENT_REMOTE="https://bitbucket.org/myworkspace/myrepo"
# Should fail - different workspace
```

### Jira Platform

#### Test: Jira URL (no repository)

```bash
PLAN_URL="https://company.atlassian.net/wiki/spaces/PROJECT/pages/123/Plan"
# Should pass with note - Jira doesn't have repositories
```

## Security Tests

### Command Injection Prevention

#### Test: Command substitution in URL

```bash
PLAN_URL='https://github.com/org/repo$(curl attacker.com)'
# Should fail validation before extraction - invalid URL format
```

#### Test: Shell metacharacters

```bash
PLAN_URL='https://github.com/org/repo; rm -rf /'
# Should fail validation - invalid URL format
```

### TOCTOU Prevention

#### Test: Commit SHA URL (immutable)

```bash
PLAN_URL="https://github.com/org/repo/blob/a7f3c2e/plans/plan.md"
# Should pass - immutable reference
```

#### Test: Branch URL (mutable - warn)

```bash
PLAN_URL="https://github.com/org/repo/blob/feature-branch/plans/plan.md"
# Should pass but note: branch can be force-pushed
```

## Exception Workflow Tests

### Test: Document exception approval

```bash
# After validation failure, user documents exception:
echo "$(date -Iseconds)|https://github.com/external/repo/plan.md|external/repo|Tech Lead approved for vendor integration" >> .known-issues

# Validation should still block, but exception is documented
```
