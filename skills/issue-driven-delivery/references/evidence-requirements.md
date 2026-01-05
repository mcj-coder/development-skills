# Evidence Requirements

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
