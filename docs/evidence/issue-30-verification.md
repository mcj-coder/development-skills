# Issue 30 Verification Evidence

Date: 2026-01-04

## Command Output

Command: `Test-Path skills/github-issue-driven-delivery/SKILL.md`
Output:

```text
True
```

Command: `rg "receiving-code-review" skills/github-issue-driven-delivery/SKILL.md`
Output:

```text
10. Require each persona to post a separate review comment in the issue thread using superpowers:receiving-code-review.
- Persona reviews must be separate issue comments using superpowers:receiving-code-review, with links captured in the summary.
- Persona reviews posted as individual comments in the issue thread using superpowers:receiving-code-review.
```

Command: `rg "approved|1:1|auth status|acceptance criteria|commits and files" skills/github-issue-driven-delivery/SKILL.md`
Output:

```text
4. Stop and wait for an explicit approval comment containing the word "approved" before continuing.
6. After approval, add issue sub-tasks for every plan task and keep a 1:1 mapping by name.
13. Create a new issue for next steps with implementation, test detail, and acceptance criteria.
- Each sub-task comment must include links to the exact commits and files that satisfy it.
- Verify `gh auth status` before creating issues, comments, or PRs.
- Plan link posted and approved in issue comments.
- Sub-tasks created for each plan task with 1:1 name mapping.
```
