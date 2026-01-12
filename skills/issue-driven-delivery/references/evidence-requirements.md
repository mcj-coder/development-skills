# Evidence Requirements

## Evidence Format Standards

### Link Requirements

All evidence MUST be clickable links. Acceptable formats:

| Evidence Type  | Format                     | Example                                         |
| -------------- | -------------------------- | ----------------------------------------------- |
| Commit         | Full SHA URL               | `github.com/org/repo/commit/abc123`             |
| PR             | PR URL                     | `github.com/org/repo/pull/123`                  |
| File permalink | Blob URL with line numbers | `github.com/org/repo/blob/sha/file.ts#L10-L20`  |
| Issue comment  | Comment anchor URL         | `github.com/org/repo/issues/123#issuecomment-X` |
| CI run         | Actions/pipeline URL       | `github.com/org/repo/actions/runs/123`          |
| Review comment | Review comment URL         | `github.com/org/repo/pull/123#discussion_r123`  |
| Screenshot     | Issue-uploaded image       | Upload to issue, not external host              |

### Specificity Requirements

- Link to specific lines/sections, not just files
- Link to specific commits, not branches (branches move)
- Link to specific CI runs, not "latest"
- Screenshots should show relevant portion, not entire screen

### What Is NOT Evidence

- "I tested it" without test output
- "It works" without verification command output
- Branch names (branches are mutable)
- Relative paths without commit context
- External links that may expire

## Checkbox Evidence Format

### Standard Format

```markdown
- [x] Acceptance item ([evidence](link))
```

### Multiple Evidence Links

When an item requires multiple pieces of evidence:

```markdown
- [x] Feature implemented ([commit](link1), [tests](link2))
- [x] Performance validated ([benchmark](link1), [CI run](link2))
```

### Scope Changes

**Added items** (scope increased during implementation):

```markdown
- [x] Original item ([evidence](link))
- [x] New requirement discovered (added: [approval](comment-link), [evidence](impl-link))
```

**Descoped items** (removed from scope):

```markdown
- [ ] ~~Removed item~~ (descoped: [approval](comment-link))
```

### Invalid Formats

These are NOT acceptable:

```markdown
# Bad: No evidence link

- [x] Item completed

# Bad: Evidence without link

- [x] Item completed (tested manually)

# Bad: Pre-checked without evidence

- [x] Will implement this
```

## Evidence by Change Type

### Code Changes

**Required evidence:**

- Commit SHA URL showing the change
- PR URL (if applicable)
- Test output or CI run URL

**Example:**

```markdown
- [x] Add validation function ([commit](github.com/.../commit/abc123), [tests](github.com/.../runs/456))
```

### Documentation Changes

**Required evidence:**

- File permalink with line numbers
- For updates: before/after comparison or diff link

**Example:**

```markdown
- [x] Update API docs ([file](github.com/.../blob/sha/docs/api.md#L10-L50))
```

### Configuration Changes

**Required evidence:**

- Commit showing config change
- Validation command output (screenshot or CI log)

**Example:**

```markdown
- [x] Configure linting rules ([commit](link), [validation](ci-run-link))
```

### Process Changes

**Required evidence:**

- Issue comment links showing decisions
- Meeting notes or ADR links

**Example:**

```markdown
- [x] Architecture decision approved ([ADR](link), [discussion](issue-comment-link))
```

## Evidence Timing

### When to Gather Evidence

1. **During implementation** - Capture commit SHAs as you work
2. **Before PR creation** - All checkboxes should have evidence BEFORE creating PR
3. **After CI passes** - Link to successful CI runs

### Who Gathers Evidence

- **Implementer** gathers all evidence
- **Reviewer** validates evidence exists and is correct
- Reviewer should NOT need to gather evidence for implementer

### Evidence Must Be Valid

- Commits must be pushed before linking
- CI runs must be complete
- Screenshots must be uploaded (not pending)

## Core Requirements

- **All commits must be pushed to remote before posting links** - local commits
  are not accessible via ticketing system URLs.
- Evidence must be posted as clickable links in work item comments (commit URLs,
  blob URLs, logs, or artifacts).
- Each sub-task comment must include links to the exact commits and files that
  satisfy it.
- Role reviews must be separate work item comments using
  superpowers:receiving-code-review, with links captured in the summary.
- Verify ticketing CLI authentication status before creating work items,
  comments, or PRs.
- Link the PR and work item and include PR comment links when a PR exists.
- Post evidence that required skills were applied for concrete changes before
  opening a PR. For process-only changes, record analytical verification.
- If post-review changes occur, re-run BDD validation and update the plan
  evidence.
- In the plan, separate **Original Scope Evidence** from **Additional Work**.
- After each additional task, re-run BDD validation and role reviews and link
  the verification comment to the change commit and task.
- Keep only the latest verification evidence in the plan; prior evidence remains
  in work item/PR comment threads.

## Evidence Checklist

- Plan link posted and approved in work item comments.
- Sub-tasks created for each plan task with 1:1 name mapping.
- Work item tagged with appropriate component (e.g., `skill` for skills
  repositories).
- Evidence and reviews attached to each sub-task.
- Role reviews posted as individual comments in the work item thread using
  superpowers:receiving-code-review.
- Next steps captured in a new work item.
- PR opened after acceptance.
- PR and work item cross-linked with PR feedback addressed (when a PR exists).
- Post-review changes re-verified with updated BDD evidence.
- Plan evidence structured into original scope, additional work, and latest
  verification only.
