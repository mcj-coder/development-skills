# Skills Review Report Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Produce `skills-review.md` in the repo root with per-skill purpose
summaries, effectiveness reviews, and actionable next steps, while respecting
the "do not commit report" constraint.

**Architecture:** Inventory all skills under `skills/`, review each skill folder
(SKILL.md, references, tests), record structured notes per skill, then author a
consolidated markdown report. Maintain a BDD checklist for the report and
resolve the commit-constraint conflict up front via an issue comment.

**Tech Stack:** Markdown, PowerShell, rg, git, gh

---

## RED: Failing Checklist (Before Implementation)

- [ ] File `skills-review.md` exists in repo root
- [ ] Report summarizes purpose for every `skills/*` folder
- [ ] Report provides a qualitative effectiveness review per skill
      (agent/platform agnostic, opinionated, conversation-driving)
- [ ] Report evaluates whether `*.test.md` validates skill intent and notes gaps
- [ ] Report includes actionable, prioritized next steps and cross-cutting themes
- [ ] Report states constraints and intent (draft skills, greenfield/brownfield focus, agent/platform agnostic)

**Failure Notes:**

- Report does not exist yet.

## GREEN: Passing Checklist (After Implementation)

- [x] File `skills-review.md` exists in repo root
- [x] Report summarizes purpose for every `skills/*` folder
- [x] Report provides a qualitative effectiveness review per skill
      (agent/platform agnostic, opinionated, conversation-driving)
- [x] Report evaluates whether `*.test.md` validates skill intent and notes gaps
- [x] Report includes actionable, prioritized next steps and cross-cutting themes
- [x] Report states constraints and intent (draft skills, greenfield/brownfield focus, agent/platform agnostic)

**Applied Evidence:**

- Report created/updated: <https://github.com/mcj-coder/development-skills/commit/9c59dbc>
- BDD checklist updated: pending

---

### Task 1: Resolve the "do not commit report" constraint

**Files:**

- Modify: `docs/plans/2026-01-13-skills-review-report.md` (status update only, if needed)

#### Step 1: Post decision in issue #296

Use `gh issue comment` to document how the report will be delivered without
commits, or get approval to commit on branch without merge.

Expected: issue comment links to agreed approach and notes any evidence exceptions.

### Task 2: Inventory skills and gather source materials

**Files:**

- Read: `skills/*/SKILL.md`
- Read: `skills/*/references/**`
- Read: `skills/*/*.test.md`

#### Step 1: List all skills

Run: `rg --files -g "SKILL.md" skills`
Expected: list of all skill folders to review.

#### Step 2: Capture a per-skill review worksheet

Create a structured note for each skill with:

- Purpose summary (1-2 sentences)
- Effectiveness review (strengths, gaps, loopholes)
- Test alignment review (intent vs tests)
- Actionable next steps (short list)

### Task 3: Draft the report structure

**Files:**

- Create: `skills-review.md`

#### Step 1: Create report outline

Include:

- Executive summary and overall themes
- Per-skill sections (purpose, effectiveness, test alignment, next steps)
- Cross-cutting improvement themes and prioritized recommendations

### Task 4: Write per-skill reviews

**Files:**

- Modify: `skills-review.md`

#### Step 1: Fill in each skill section

For each skill folder:

- Summarize purpose in human terms
- Rate qualitative effectiveness (clear/partial/weak) with short rationale
- Call out test intent gaps and loopholes
- Provide concrete next steps

### Task 5: Final consistency pass

**Files:**

- Modify: `skills-review.md`
- Modify: `docs/plans/2026-01-13-skills-review-report.md` (GREEN checklist updates)

#### Step 1: Verify coverage

Confirm every `skills/*` folder is included with the required fields.

#### Step 2: Update GREEN checklist

Mark GREEN checklist items as passing with evidence or approved exception notes.

### Task 6: Deliver report without commit (per constraint)

**Files:**

- None (if report remains uncommitted)

#### Step 1: Provide handoff instructions

Explain how to keep the report uncommitted and how to share it (local file only),
with the issue comment noting the exception.
