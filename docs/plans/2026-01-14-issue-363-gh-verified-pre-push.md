# Issue 363: Accept GitHub-Verified Commits Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Allow the pre-push hook to treat GitHub-verified commits as acceptable
when local GPG verification fails.

**Architecture:** Extend `.husky/pre-push` to query the GitHub API via `gh` for
commits with invalid local signature status, and only block commits that remain
unverified.

**Tech Stack:** POSIX shell (`sh`), Git, GitHub CLI (`gh`), GitHub REST API.

---

## RED: Failing Checklist (Before Implementation)

- [ ] `.husky/pre-push` checks GitHub verification when local signature status is
  invalid
- [ ] `.husky/pre-push` allows commits with `verification.verified == true` to
  pass
- [ ] `.husky/pre-push` still blocks commits that are unsigned or invalid and
  not GitHub verified
- [ ] `docs/playbooks/enable-signed-commits.md` documents GitHub-verified commit
  acceptance in the pre-push hook

**Failure Notes:**

- Pre-push only checks local GPG status and rejects `E` (missing key)
- No GitHub API verification exists in the hook
- The playbook does not mention GitHub-verified commits in pre-push enforcement

---

### Task 1: Prepare helper logic for GitHub verification

**Files:**

- Modify: `.husky/pre-push`

#### Step 1: Add repo resolution helper

- Parse `git remote get-url origin` to resolve `owner/repo` for GitHub API calls.

#### Step 2: Add GitHub verification helper

- Use `gh api repos/{owner}/{repo}/commits/{sha}` and check
  `.commit.verification.verified`.
- Treat `true` as acceptable, otherwise fail.

#### Step 3: Guard for `gh` availability

- If `gh` is unavailable or repo cannot be resolved, keep existing failure
  behavior.

---

### Task 2: Integrate GitHub verification into invalid signature handling

**Files:**

- Modify: `.husky/pre-push`

#### Step 1: Filter invalid commits

- For each invalid commit, call GitHub verification.
- Keep a list of commits that remain invalid after the API check.

#### Step 2: Adjust error messaging

- Report which commits failed local verification but passed GitHub verification.
- Only block when remaining invalid commits exist.

---

### Task 3: Update documentation

**Files:**

- Modify: `docs/playbooks/enable-signed-commits.md`

#### Step 1: Document GitHub verification behavior

- Note that the pre-push hook accepts commits verified by GitHub even if local
  keys are missing.
- Provide a sample `gh api` command to verify a commit.

---

### Task 4: Verification

#### Step 1: Simulate verification with a known commit

- Run:
  `gh api repos/mcj-coder/development-skills/commits/<sha> --jq '.commit.verification'`
- Expected: `verified` is `true` for GitHub-verified commits.

#### Step 2: Validate hook behavior

- Run: `git log --show-signature -1 <sha>`
- Confirm local status can be `E` but the hook allows push when GitHub verification is `true`.

---

### Task 5: Commit

- Commit RED checklist (this plan) before implementation changes.
- Commit implementation and documentation updates after verification.
