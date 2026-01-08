# PR Reviews with Inline Comments

## Overview

Pull request reviews should use inline comments to associate feedback with specific code
locations. This provides clearer, more actionable feedback than general comments.

## Iterative Review Process

PRs are often iterative. When reviewing:

1. **Check all comments are addressed** - Don't approve until ALL previous review comments
   have been resolved, not just the first iteration
2. **Re-review after changes** - Each push requires re-validation to prevent regression
   or new issues being introduced
3. **Verify fixes** - Don't assume fixes are correct; verify they actually address the feedback

## Selecting Reviewers by Change Type

| Change Type           | Primary Personas                                                |
| --------------------- | --------------------------------------------------------------- |
| New feature           | Tech Lead, Senior Developer, QA Engineer                        |
| Bug fix               | Senior Developer, QA Engineer                                   |
| Security-related      | Security Reviewer, Security Architect                           |
| Performance           | Performance Engineer, Senior Developer                          |
| Documentation         | Documentation Specialist, Agent Skill Engineer                  |
| Skill changes         | Agent Skill Engineer, Documentation Specialist, **QA Engineer** |
| Infrastructure/DevOps | DevOps Engineer, Cloud Architect                                |
| Architecture changes  | Tech Lead, Technical Architect                                  |

### Skill Changes Require Concrete Validation

For skill changes, hypothetical review alone is insufficient. Include **QA Engineer** to ensure:

- **Concrete testing**: Behavior changes require actual test execution, not just review
- **Dogfooding**: New skill behavior should be tested in real scenarios
- **Script/prompt verification**: Changes to prompts or scripts need execution validation
- **Regression prevention**: Verify existing behavior still works after changes

## Review Event Types

| Event             | When to Use                                     |
| ----------------- | ----------------------------------------------- |
| `APPROVE`         | Changes are good, ready to merge                |
| `REQUEST_CHANGES` | Blocking issues that must be fixed before merge |
| `COMMENT`         | Feedback only, no blocking decision             |

## Inline Comment Fields

| Field        | Required | Description                                 |
| ------------ | -------- | ------------------------------------------- |
| `path`       | Yes      | File path relative to repo root             |
| `line`       | Yes      | Line number for single-line comment         |
| `start_line` | No       | Start of multi-line range (use with `line`) |
| `body`       | Yes      | Comment content (markdown supported)        |

## Platform-Specific CLI Commands

### GitHub

**Basic review:**

```bash
# Simple review with overall comment
gh pr review <PR_NUMBER> --comment --body "Review feedback here"

# Approve
gh pr review <PR_NUMBER> --approve --body "LGTM - changes look good"

# Request changes
gh pr review <PR_NUMBER> --request-changes --body "Please address the issues below"
```

**Review with inline comments:**

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews \
  --method POST \
  -f body="## Overall Assessment

Summary of review findings." \
  -f event="REQUEST_CHANGES" \
  -f comments='[
    {
      "path": "path/to/file.md",
      "line": 42,
      "body": "Feedback for this specific line."
    }
  ]'
```

**View PR and diff:**

```bash
gh pr view <PR_NUMBER>
gh pr diff <PR_NUMBER>
```

### Azure DevOps

**Basic review:**

```bash
# Add reviewer
az repos pr reviewer add --id <PR_ID> --reviewers <EMAIL>

# Vote on PR (approve=10, approve-with-suggestions=5, wait-for-author=0, reject=-5, no-vote=-10)
az repos pr set-vote --id <PR_ID> --vote approve
```

**Review with inline comments (threads):**

```bash
# Create a comment thread on specific line
az repos pr thread create \
  --id <PR_ID> \
  --path "path/to/file.md" \
  --line 42 \
  --comment "Feedback for this specific line."
```

### GitLab

**Basic review:**

```bash
# View MR
glab mr view <MR_NUMBER>

# Approve MR
glab mr approve <MR_NUMBER>
```

**Review with inline comments (discussions):**

```bash
# Create discussion on specific line
glab api projects/:id/merge_requests/:iid/discussions \
  --method POST \
  -f body="Feedback for this line" \
  -f position[base_sha]="<base_sha>" \
  -f position[head_sha]="<head_sha>" \
  -f position[start_sha]="<start_sha>" \
  -f position[position_type]="text" \
  -f position[new_path]="path/to/file.md" \
  -f position[new_line]="42"
```

## Review Process

### Step 1: Understand the Changes

1. Read the PR/MR description and linked issues
2. View the diff to understand scope of changes
3. Identify which personas should review based on change type

### Step 2: Identify Feedback Points

1. Note specific line numbers where you have feedback
2. Categorize feedback as blocking vs suggestions
3. Prepare constructive alternatives for issues found

### Step 3: Post Review with Inline Comments

1. Use platform-specific CLI to post review
2. Associate each piece of feedback with specific line(s)
3. Include overall assessment and decision (approve/request changes/comment)

### Step 4: Follow Up

1. Monitor for author's responses
2. Re-review after changes are pushed
3. Verify fixes actually address the feedback

## Persona-Based Review Template

When conducting reviews as a specific persona, structure your review:

```markdown
## [Persona Name] Review

### Overall Assessment: [APPROVE | REQUEST_CHANGES | COMMENT]

[1-2 sentence summary]

### Findings

#### [Category 1]

- Line X: [Feedback]
- Lines Y-Z: [Feedback]

#### [Category 2]

- Line A: [Feedback]

### Blocking Issues

[List any issues that must be resolved before merge]

### Suggestions (Non-blocking)

[Optional improvements that could be addressed later]
```

## Retrospective for Persona Reviews

After persona-delegated reviews:

1. Assess process compliance (TDD, issue-driven, skills-first)
2. Evaluate quality of review output
3. Document issues if 2+ Important or any Critical findings
4. Create corrective action tickets if needed

### Before Creating Corrective Action Tickets

**Check for duplicates first** using platform search:

- GitHub: `gh issue list --state all --search "keyword"`
- Azure DevOps: `az boards query --wiql "SELECT [ID] FROM WorkItems WHERE [Title] CONTAINS 'keyword'"`
- Jira: `jira issue list --query "summary ~ 'keyword'"`

If a related issue exists:

- **Link to existing issue** instead of creating a duplicate
- Add a comment to the existing issue with the new finding
- Reference the PR where the issue was discovered

## Best Practices

1. **Be specific**: Reference exact line numbers and file paths
2. **Explain why**: Don't just say "change this" - explain the reasoning
3. **Prioritize**: Distinguish blocking issues from suggestions
4. **Be constructive**: Offer alternatives, not just criticism
5. **Use inline comments**: Associate feedback with specific code locations
6. **Follow up**: Verify fixes address the feedback

## Common Mistakes

### Mistake 1: General Comments Only

**Anti-pattern**: Posting all feedback as a single comment

**Better**: Use inline comments to associate feedback with specific lines

### Mistake 2: Missing Context

**Anti-pattern**: "This is wrong"

**Better**: "This could cause a null reference exception when `user` is undefined (line 42). Consider adding a guard clause."

### Mistake 3: Wrong Review Event

**Anti-pattern**: Using `COMMENT` for blocking issues

**Better**: Use `REQUEST_CHANGES` when issues must be fixed before merge

### Mistake 4: Approving with Unresolved Comments

**Anti-pattern**: Approving when previous review comments haven't been addressed

**Better**: Check all previous comments are resolved before approving
