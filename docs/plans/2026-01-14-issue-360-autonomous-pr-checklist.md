# Autonomous Agent PR Checklist Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Define a standard PR checklist comment template for autonomous agents
and document the auto-merge requirement when checks and approvals pass.

**Architecture:** Add a dedicated "Autonomous PR Checklist" section to
`AGENTS.md` with a copy-ready comment template and explicit auto-merge guidance.
Use a BDD checklist to enforce the documentation changes.

**Tech Stack:** Markdown documentation.

---

## RED: Failing Checklist (Before Implementation)

- [ ] `AGENTS.md` contains an "Autonomous PR Checklist" section with a
      copy-ready comment template
- [ ] `AGENTS.md` documents that PRs must enable auto-merge once approvals and
      checks pass
- [ ] The checklist template includes evidence-link expectations for test plan items

**Failure Notes:**

- No autonomous PR checklist template currently exists in `AGENTS.md`
- Auto-merge guidance is not explicitly stated for agents

---

### Task 1: Write failing BDD checklist

**Files:**

- Create: `docs/plans/2026-01-14-issue-360-pr-checklist.bdd.md`

#### Step 1: Create RED checklist

- Capture missing sections and requirements in the checklist.

#### Step 2: Verify checklist fails

- Note missing `AGENTS.md` sections in the failure notes.

#### Step 3: Commit RED checklist

```bash
git add docs/plans/2026-01-14-issue-360-pr-checklist.bdd.md
git commit -m "test: add PR checklist BDD" -m "Refs: #360"
```

---

### Task 2: Update agent-facing documentation

**Files:**

- Modify: `AGENTS.md`

#### Step 1: Add Autonomous PR Checklist section

Add a new section in `AGENTS.md` with a copy-ready comment template covering:

- Summary
- Issues (Refs/Closes)
- Test plan with evidence link expectation
- Verification evidence placeholder
- Auto-merge requirement

#### Step 2: Add auto-merge requirement

- State that autonomous PRs must enable auto-merge once required approvals and checks pass.

---

### Task 3: Mark checklist green

#### Step 1: Update checklist to GREEN

- Mark checklist items as passed with evidence links to `AGENTS.md` and commit.

#### Step 2: Commit GREEN checklist

```bash
git add AGENTS.md docs/plans/2026-01-14-issue-360-pr-checklist.bdd.md
git commit -m "docs: add autonomous PR checklist" -m "Refs: #360"
```

---

### Task 4: Verification

#### Step 1: Validate checklist targets

```bash
rg -n "Autonomous PR Checklist|auto-merge" AGENTS.md
```

**Expected:** Section and auto-merge guidance are present.

---

### Task 5: PR and issue updates

- Post evidence links in issue #360
- Open PR with the checklist and auto-merge guidance
