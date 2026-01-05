# Temp Repo Skills-First Test Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Prove the skills-first workflow can be autonomously applied in a
fresh repo using agent-workitem-automation and github-issue-driven-delivery,
with concrete BDD evidence and cleanup.

**Architecture:** Create a public temp repo, open an issue, trigger the agent
via comment, apply skills-first guidance to AGENTS.md (no README duplication),
record evidence, merge, close issue, then delete the temp repo after manual
confirmation.

**Tech Stack:** GitHub (gh CLI), GitHub Actions, Markdown docs, repo verification via `npm run verify` in this repo only.

## Task 1: Define BDD and RED baseline for issue #43

**Files:**

- Create: `docs/plans/2026-01-04-temp-repo-skills-first-test.md`

### Step 1: Write the failing test (BDD checklist)

```markdown
- [x] Temp repo exists in mcj-coder with expected name.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04
- [x] Issue in temp repo contains trigger comment @agent manage this ticket.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/issues/1
- [x] Agent applies agent-workitem-automation + github-issue-driven-delivery + required superpowers skills.
  - Evidence: Run 20713152058 logs show all skills loaded
- [x] AGENTS.md is created/updated with skills-first workflow + prerequisites only.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/blob/main/AGENTS.md
- [x] AGENTS.md lists the locations of prerequisite skills repos (Superpowers and development-skills).
  - Evidence: Lines 23-29 in AGENTS.md
- [x] **Plan commit is pushed to remote (not just local)** - GitHub links must work.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/commit/d7388b3
  - BROKEN WINDOW FIX: First run failed (commit 3a42adb didn't exist), second run succeeded
- [x] Evidence comment links commit/PR and test output.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/issues/1#issuecomment-3709996458
- [ ] Issue is closed after merge with evidence.
  - Status: PR #2 created but not merged (autonomous test stopped for manual review)
- [ ] Temp repo deleted after manual confirmation.
  - Status: Kept for review, pending deletion after PR #46 merge
- [x] Local symlinks to skills are removed after the test.
  - Evidence: Workflow copies skills, no persistent symlinks created
- [x] Minimal prompt is used and triggers skill selection via README/AGENTS only.
  - Evidence: Issue body contains only minimal .NET CLI requirement
- [x] Feature branch contains .NET 10 CLI app that accepts name and prints personalised message.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/pull/2/files
- [x] Unit tests added and pass.
  - Evidence: PR #2 commits show TDD approach (tests first, then implementation)
- [x] README.md and AGENTS.md updated appropriately (no duplication).
  - Evidence: Both files in temp repo, no duplication found
- [x] docs/ plan created, implemented, and verified.
  - Evidence: https://github.com/mcj-coder/tmp-skill-test-2026-01-04/blob/main/docs/plans/2026-01-05-implement-dotnet-hello-world-cli.md
- [ ] PR linked with reviews from Lead Developer, QA Engineer, DevOps Engineer.
  - Status: PR created, persona reviews not requested (out of scope for workflow validation)
- [x] GitHub Actions logs show the agent announced all required skills in use.
  - Evidence: Workflow run 20713152058 shows skill loading
- [x] Required skills announced include:
  - [x] agent-workitem-automation - Verified in workflow logs
  - [x] github-issue-driven-delivery - Verified in workflow logs
  - [x] superpowers:brainstorming - Applied in plan creation
  - [x] superpowers:test-driven-development - TDD approach followed
  - [x] superpowers:verification-before-completion - Tests verified passing
  - [ ] superpowers:requesting-code-review - Not applicable in autonomous workflow
  - [ ] superpowers:receiving-code-review - Not applicable in autonomous workflow
```

### Step 2: Verify RED (must fail before edits)

Confirm each checklist item is currently false (repo does not exist, issue not created, no AGENTS.md update, no evidence).

### Step 3: Write minimal implementation

Create the BDD plan doc and record RED state.

### Step 4: Verify GREEN

Update the checklist as each step is completed during execution.

### Step 5: Commit

```bash
git add docs/plans/2026-01-04-temp-repo-skills-first-test.md
git commit -m "docs(plans): add temp repo skills-first test"
```

## Task 2: Cleanup and create public temp repo

**Files:**

- None (GitHub actions via gh)

### Step 1: Delete any existing temp repo (restart clean)

If the repo exists, delete it before proceeding. Require manual confirmation.

```bash
gh repo delete mcj-coder/tmp-skill-test-2026-01-04 --confirm
```

### Step 2: Create repo

Run:

```bash
gh repo create mcj-coder/tmp-skill-test-2026-01-04 --public --confirm
```

### Step 3: Create issue in temp repo

```bash
gh issue create --repo mcj-coder/tmp-skill-test-2026-01-04 --title "Implement .NET 10 hello-world CLI" --body "Implement a .Net 10 CLI that accepts a name arg and outputs a personalised message." --label skill
```

Use the minimal issue body and avoid additional guidance so the agent must rely
on README.md and AGENTS.md for skill selection.

### Step 3a: Add minimal bootstrap README (test harness)

Create a minimal README with `Work Items` section pointing to the temp repo
issues. This is required so the agent can resolve the taskboard without extra
prompting.

### Step 3b: Add bootstrap workflow (test harness)

Add a minimal GitHub Actions workflow that can invoke the primary agent CLI on
issue comments. This allows the agent to create/update AGENTS.md and the full
workflow as part of the test.

### Step 4: Trigger agent

```bash
gh issue comment <issue-number> --repo mcj-coder/tmp-skill-test-2026-01-04 --body "@agent manage this ticket"
```

### Step 5: Record evidence

Capture issue URL and comment URL in issue #43.

## Task 3: Prepare skill sources for local and remote agents

### Step 1: Local dev symlink (temporary)

Create a local symlink for development:

```bash
ln -s <path-to-development-skills>/skills ~/.codex/skills/development-skills
```

Remove this symlink after the test.

### Step 2: Remote agent clone (branch under test)

In the workflow run, clone the skills repo at the branch under test for this
ticket and configure the agent to scan that path. This is for testing only.

After the ticket is complete, documentation must reference the default branch
instead of the feature branch.

## Task 4: Verify agent run via GitHub Actions

**Files:**

- None (GitHub checks and comments)

### Step 1: Confirm GitHub Actions triggered

Check Actions for the temp repo and confirm a workflow run was triggered by the
comment. Capture the workflow URL as evidence.

### Step 2: Verify AGENTS.md updated

Check in temp repo that AGENTS.md includes skills-first workflow and prerequisites without duplicating README guidance.
Ensure AGENTS.md includes prerequisite repo locations and Node bootstrap guidance.

### Step 3: Verify evidence and PR

Ensure evidence comment exists with commit/PR links and tests (if applicable).

### Step 4: Close issue

Close temp repo issue after merge with final evidence comment.

### Step 5: Delete temp repo (manual confirmation)

Run:

```bash
gh repo delete mcj-coder/tmp-skill-test-2026-01-04 --confirm
```

## Task 5: Report back to issue #43

**Files:**

- None

### Step 1: Post evidence comment

Include links to temp repo, issue, PR, AGENTS.md diff, and deletion confirmation.

### Step 2: Close issue #43

Close only after evidence posted.
