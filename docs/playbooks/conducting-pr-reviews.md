---
name: conducting-pr-reviews
description: |
  Process for conducting pull request reviews with persona-based perspectives
  and inline code comments for actionable feedback.
summary: |
  1. Identify relevant personas for the change type
  2. Read the PR diff and understand the changes
  3. Post review with inline comments on specific lines
  4. Use appropriate review decision (approve/request changes/comment)
  5. Conduct retrospective for persona-delegated reviews
triggers:
  - pr review requested
  - pull request needs review
  - review pr from persona perspective
  - request code review
---

# Conducting PR Reviews

> **Note**: This playbook provides repo-specific guidance for GitHub. A platform-agnostic
> skill for PR reviews with inline comments is planned - see #152 for status.

## Overview

This playbook guides agents and humans through conducting effective PR reviews using
persona-based perspectives and GitHub's inline comment capabilities.

### Iterative Review Process

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

## Posting Reviews with Inline Comments

### Basic Review (General Comment Only)

```bash
# Simple review with overall comment
gh pr review <PR_NUMBER> --comment --body "Review feedback here"

# Approve
gh pr review <PR_NUMBER> --approve --body "LGTM - changes look good"

# Request changes
gh pr review <PR_NUMBER> --request-changes --body "Please address the issues below"
```

### Review with Inline Comments (Recommended)

Use the GitHub API to post reviews with line-specific feedback:

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
      "body": "Consider moving this to a reference document for progressive disclosure."
    },
    {
      "path": "path/to/another-file.ts",
      "start_line": 10,
      "line": 15,
      "body": "This block could be simplified using a helper function."
    }
  ]'
```

### Event Types

| Event             | When to Use                                     |
| ----------------- | ----------------------------------------------- |
| `APPROVE`         | Changes are good, ready to merge                |
| `REQUEST_CHANGES` | Blocking issues that must be fixed before merge |
| `COMMENT`         | Feedback only, no blocking decision             |

### Inline Comment Fields

| Field        | Required | Description                                 |
| ------------ | -------- | ------------------------------------------- |
| `path`       | Yes      | File path relative to repo root             |
| `line`       | Yes      | Line number for single-line comment         |
| `start_line` | No       | Start of multi-line range (use with `line`) |
| `body`       | Yes      | Comment content (markdown supported)        |

## Review Process

### Step 1: Understand the Changes

```bash
# View PR details
gh pr view <PR_NUMBER>

# View the diff
gh pr diff <PR_NUMBER>

# View specific files
gh pr diff <PR_NUMBER> -- path/to/file.md
```

### Step 2: Identify Line Numbers for Feedback

When reviewing, note specific line numbers where you have feedback:

```bash
# Get diff with line numbers
gh pr diff <PR_NUMBER> | head -100
```

### Step 3: Construct Review with Inline Comments

Build your review JSON with specific line references:

```bash
# Example: Review with multiple inline comments
gh api repos/owner/repo/pulls/123/reviews \
  --method POST \
  -f body="## Tech Lead Review

### Overall: Request Changes

Good approach but needs refinement in error handling." \
  -f event="REQUEST_CHANGES" \
  -f comments='[
    {
      "path": "src/api/handler.ts",
      "line": 45,
      "body": "**Error Handling**: This catch block swallows errors silently. Consider logging or re-throwing."
    },
    {
      "path": "src/api/handler.ts",
      "start_line": 60,
      "line": 75,
      "body": "**Complexity**: This function does too much. Consider extracting validation into a separate function."
    },
    {
      "path": "docs/api.md",
      "line": 12,
      "body": "**Documentation**: Add example response for error cases."
    }
  ]'
```

### Step 4: Post the Review

Execute the API call and verify success:

```bash
# The response will include the review ID
# Check the PR in GitHub to see inline comments
```

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

Per CLAUDE.md, after persona-delegated reviews:

1. Assess process compliance (TDD, issue-driven, skills-first)
2. Evaluate quality of review output
3. Document issues if 2+ Important or any Critical findings
4. Create GitHub issues for corrective actions if needed

### Before Creating Issues

**Check for duplicates first**:

```bash
# Search for existing issues with similar scope
gh issue list --state open --search "keyword from finding"
gh issue list --state all --search "keyword from finding"
```

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

## See Also

- `docs/roles/README.md` - Persona definitions and selection guide
- `CLAUDE.md` - Retrospective requirements for persona reviews
- `skills/issue-driven-delivery/SKILL.md` - PR workflow integration
- #152 - Platform-agnostic PR review skill (planned)
