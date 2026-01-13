# Worktrees Preference Documentation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Document the preferred worktree location (`.worktrees/`) in `CLAUDE.md` and
`AGENTS.md`.

**Architecture:** Update the existing workflow guidance in both files to state the
preferred worktree directory, keeping language consistent and unambiguous.

**Tech Stack:** Markdown, git, rg

---

## RED: Failing Checklist (Before Implementation)

- [ ] `CLAUDE.md` mentions `.worktrees/` as the preferred worktree directory
- [ ] `AGENTS.md` mentions `.worktrees/` as the preferred worktree directory
- [ ] Guidance is consistent across both files

**Failure Notes:**

- Worktree preference is not documented in either file.

## GREEN: Passing Checklist (After Implementation)

- [x] `CLAUDE.md` mentions `.worktrees/` as the preferred worktree directory
- [x] `AGENTS.md` mentions `.worktrees/` as the preferred worktree directory
- [x] Guidance is consistent across both files

**Applied Evidence:**

- RED checklist: <https://github.com/mcj-coder/development-skills/commit/9910c32>
- Implementation: <https://github.com/mcj-coder/development-skills/commit/3e0303a>
- GREEN checklist: <https://github.com/mcj-coder/development-skills/commit/b69233c>

---

### Task 1: Update worktree guidance in CLAUDE.md

**Files:**

- Modify: `CLAUDE.md`

#### Step 1: Add preferred worktree directory\*\*

Add a concise line stating `.worktrees/` is the preferred worktree location.

#### Step 2: Verify content\*\*

Run: `rg -n "\\.worktrees/" CLAUDE.md`
Expected: matches showing the preference text.

### Task 2: Update worktree guidance in AGENTS.md

**Files:**

- Modify: `AGENTS.md`

#### Step 1: Add preferred worktree directory\*\*

Add a concise line stating `.worktrees/` is the preferred worktree location.

#### Step 2: Verify content\*\*

Run: `rg -n "\\.worktrees/" AGENTS.md`
Expected: matches showing the preference text.

### Task 3: Update GREEN checklist and evidence

**Files:**

- Modify: `docs/plans/2026-01-13-worktrees-preference.md`

#### Step 1: Mark GREEN checklist\*\*

Check all GREEN items and add commit evidence links.
