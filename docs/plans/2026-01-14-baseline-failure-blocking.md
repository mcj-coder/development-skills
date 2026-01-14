# Baseline Failure Blocking Rule Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Document the rule that baseline test failures must trigger a blocking issue
and halt current work until the baseline passes.

**Architecture:** Add concise, consistent guidance in agent-facing docs and record
BDD checklist evidence for the documentation change.

**Tech Stack:** Markdown, git, rg

---

## RED: Failing Checklist (Before Implementation)

- [ ] AGENTS.md documents that baseline failures must be addressed immediately
- [ ] AGENTS.md documents that work is blocked until baseline passes
- [ ] CLAUDE.md mirrors the same baseline failure rule
- [ ] Guidance requires creating a blocking issue if none exists

**Failure Notes:**

- Baseline failure handling is not explicitly documented.

## GREEN: Passing Checklist (After Implementation)

- [ ] AGENTS.md documents that baseline failures must be addressed immediately
- [ ] AGENTS.md documents that work is blocked until baseline passes
- [ ] CLAUDE.md mirrors the same baseline failure rule
- [ ] Guidance requires creating a blocking issue if none exists

---

### Task 1: Create RED BDD checklist

**Files:**

- Create: `docs/plans/2026-01-14-baseline-failure-blocking.bdd.md`

#### Step 1: Write failing checklist

Define checklist items for baseline failure handling in AGENTS.md and CLAUDE.md.

#### Step 2: Verify RED failure

Run: `rg -n "baseline.*failure|block.*baseline" AGENTS.md CLAUDE.md`
Expected: no matches.

#### Step 3: Commit RED checklist

Commit the failing checklist with `Refs: #361`.

### Task 2: Update AGENTS.md and CLAUDE.md

**Files:**

- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

#### Step 1: Document baseline failure handling

Add a concise rule: if baseline verification fails, create or reference a
blocking issue and pause the current task until baseline passes.

#### Step 2: Verify content

Run: `rg -n "baseline.*failure|block.*baseline" AGENTS.md CLAUDE.md`
Expected: matches in both files.

#### Step 3: Commit documentation update

Commit the doc changes with `Refs: #361`.

### Task 3: Update GREEN checklist and evidence

**Files:**

- Modify: `docs/plans/2026-01-14-baseline-failure-blocking.bdd.md`

#### Step 1: Mark GREEN checklist

Check all GREEN items and add commit evidence links.
