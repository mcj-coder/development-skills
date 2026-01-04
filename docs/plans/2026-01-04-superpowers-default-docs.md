# Superpowers-First Documentation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make Superpowers skills usage the default workflow in AGENTS.md and
README.md to prevent jumping straight into implementation.

**Architecture:** Update repo guidance to mandate Superpowers-first workflow,
include explicit default steps, and clarify that implementation begins only
after skills and plans are loaded. Align AGENTS.md and README.md so they
reinforce the same behaviour.

**Tech Stack:** Markdown documentation, repo linting via `npm run lint:check`.

## Task 1: Strengthen Superpowers-first rules in AGENTS.md

**Files:**

- Modify: `AGENTS.md`

### Step 1: Write the failing test (BDD checklist)

```markdown
- [ ] AGENTS.md explicitly states Superpowers-first workflow is mandatory before implementation.
- [ ] AGENTS.md adds a default workflow checklist (bootstrap -> use-skill -> plan/verify -> implement).
- [ ] AGENTS.md clarifies that fallback to human-driven steps must still follow skills.
```

### Step 2: Verify RED (must fail before edits)

Confirm each checklist item is currently false in `AGENTS.md`, and note the
missing sections or wording. If any item already passes, tighten the checklist
until it fails for the right reason.

### Step 3: Write minimal implementation

Edit `AGENTS.md` to:

- Add a "Superpowers-First Default Workflow" section with ordered steps.
- Add a "No-Implementation-First" rule that forbids skipping skills.
- Emphasize fallback must still follow skills.

### Step 4: Verify GREEN

Re-check the checklist; all items must now be true. Then run:
`npm run lint:check`
Expected: PASS.

### Step 5: Commit

```bash
git add AGENTS.md
git commit -m "docs(agents): enforce superpowers-first workflow"
```

## Task 2: Align README.md to Superpowers-first default workflow

**Files:**

- Modify: `README.md`

### Step 1: Write the failing test (BDD checklist)

```markdown
- [ ] README.md states that skills workflow is the default for any work.
- [ ] README.md links to AGENTS.md for workflow details.
- [ ] README.md mentions implementation happens only after skills are loaded.
```

### Step 2: Verify RED (must fail before edits)

Confirm each checklist item is currently false in `README.md`, and note the
missing sections or wording. If any item already passes, tighten the checklist
until it fails for the right reason.

### Step 3: Write minimal implementation

Edit `README.md` to:

- Add a Superpowers-first section.
- Link to AGENTS.md.
- State that direct implementation is not the default path.

### Step 4: Verify GREEN

Re-check the checklist; all items must now be true. Then run:
`npm run lint:check`
Expected: PASS.

### Step 5: Commit

```bash
git add README.md
git commit -m "docs(readme): emphasize superpowers-first default"
```
