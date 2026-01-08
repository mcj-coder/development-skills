---
name: conducting-pr-reviews
description: |
  GitHub-specific process for conducting pull request reviews with persona-based
  perspectives and inline code comments.
summary: |
  1. Identify relevant personas for the change type
  2. Read the PR diff with `gh pr diff`
  3. Post review with inline comments via GitHub API
  4. Use appropriate review decision (approve/request changes/comment)
  5. Conduct retrospective for persona-delegated reviews
triggers:
  - pr review requested
  - pull request needs review
  - review pr from persona perspective
  - request code review
---

# Conducting PR Reviews (GitHub)

This playbook is customized for GitHub. For platform-agnostic guidance, see
`skills/issue-driven-delivery/references/pr-reviews.md`.

## Iterative Review Process

1. **Check all comments are addressed** - Don't approve until ALL previous review
   comments have been resolved
2. **Re-review after changes** - Each push requires re-validation
3. **Verify fixes** - Don't assume fixes are correct; verify them

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

## GitHub CLI Commands

### Basic Review

```bash
# Comment only
gh pr review <PR_NUMBER> --comment --body "Review feedback here"

# Approve
gh pr review <PR_NUMBER> --approve --body "LGTM"

# Request changes
gh pr review <PR_NUMBER> --request-changes --body "Please address issues below"
```

### View PR Details

```bash
gh pr view <PR_NUMBER>
gh pr diff <PR_NUMBER>
```

### Review with Inline Comments

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
      "body": "Feedback for this line."
    }
  ]'
```

### Check for Duplicate Issues

```bash
gh issue list --state open --search "keyword"
gh issue list --state all --search "keyword"
```

## Event Types

| Event             | When to Use                                     |
| ----------------- | ----------------------------------------------- |
| `APPROVE`         | Changes are good, ready to merge                |
| `REQUEST_CHANGES` | Blocking issues that must be fixed before merge |
| `COMMENT`         | Feedback only, no blocking decision             |

## Inline Comment Fields

| Field        | Required | Description                     |
| ------------ | -------- | ------------------------------- |
| `path`       | Yes      | File path relative to repo root |
| `line`       | Yes      | Line number for comment         |
| `start_line` | No       | Start of multi-line range       |
| `body`       | Yes      | Comment content (markdown)      |

## Retrospective

After persona-delegated reviews:

1. Assess process compliance
2. Evaluate quality of review output
3. Document issues if 2+ Important or Critical findings
4. Create corrective action tickets if needed (check for duplicates first)

## See Also

- `skills/issue-driven-delivery/references/pr-reviews.md` - Platform-agnostic reference
- `docs/roles/README.md` - Persona definitions
