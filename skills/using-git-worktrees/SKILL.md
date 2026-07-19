---
name: using-git-worktrees
description: Use this skill when starting feature work that needs isolation or when an approved plan should be executed in a clean, separate workspace.
---

# Using Git Worktrees

## Intent

Create isolated workspaces for reliable execution, clear baselines, and safe
parallel development.

---

## When to Use

- Before executing a multi-step plan.
- When multiple branches are active at once.
- When the current workspace is not clean.

---

## Precondition Failure Signal

- Work starts in a dirty workspace without a clean baseline.
- Worktrees are created in non-ignored directories.
- Baseline tests are skipped.

---

## Postcondition Success Signal

- Worktree created in an approved directory.
- Directory is ignored by git (if project-local).
- Baseline tests run and recorded before changes.

---

## Process

1. **Locate Worktree Directory**:
   - Prefer `.worktrees/` or `worktrees/` if present.
   - If neither exists, ask the user where to create it.
2. **Verify Ignore**:
   - For project-local worktrees, ensure the directory is in `.gitignore`.
3. **Create Worktree**:
   - `git worktree add <path> -b <branch-name>`
4. **Bootstrap**:
   - Install dependencies based on repo tooling.
5. **Baseline Verification**:
   - Run the appropriate test suite and record results.

---

## Example Test / Validation

- Baseline tests run in the new worktree and exit 0 before changes begin.

---

## Common Red Flags / Guardrail Violations

- Creating a worktree without checking `.gitignore`.
- Proceeding after baseline tests fail.
- Hardcoding a worktree directory without user agreement.

---

## Recommended Review Personas

- **Platform Engineer** - validates tooling and baseline verification.
- **Tech Lead** - validates branch isolation discipline.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If baseline tests fail, stop and resolve before proceeding.
- Do not bypass ignore verification for convenience.

---

## Conceptual Dependencies

- quality-gate-enforcement
- verification-and-handover

---

## Classification

Governance  
Operational

---

## Notes

Isolation prevents hidden state and makes failures reproducible.
