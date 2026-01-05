# Requirements Gathering Skill - Implementation Plan

**Issue:** #51
**Goal:** Create skill for gathering requirements and creating tickets without committing design documents
**Status:** Planning (Refinement)

## BDD Checklist (RED → GREEN)

### Baseline (RED - must fail initially) → GREEN (Implementation Complete)

- [x] Skill exists at `skills/requirements-gathering/SKILL.md`
  - Evidence: File created with 407 lines (skills/requirements-gathering/SKILL.md)
- [x] BDD tests exist at `skills/requirements-gathering/requirements-gathering.test.md`
  - Evidence: File created with comprehensive RED/GREEN/Pressure/Integration scenarios (skills/requirements-gathering/requirements-gathering.test.md)
- [x] SKILL.md has YAML frontmatter with name and description
  - Evidence: Lines 1-4 of SKILL.md contain YAML frontmatter with name and description fields
- [x] "When to Use" section distinguishes from brainstorming and planning
  - Evidence: Lines 14-28 "When to Use This Skill" section + Lines 30-42 comparison table showing distinct workflows
- [x] Interactive Q&A process documented in workflow
  - Evidence: Lines 56-110 "Core Workflow" section documents question-driven approach
- [x] Output format specified (GitHub issue body structure)
  - Evidence: Lines 111-166 structure requirements and Lines 305-334 provide template format
- [x] Explicitly states "No design documents created"
  - Evidence: Lines 177-189 "Stop - Do Not Proceed to Planning", Lines 240-254 Common Mistake #1, Lines 293-302 Red Flags
- [x] Integration with issue-driven-delivery documented
  - Evidence: Lines 271-300 "Integration with Issue-Driven-Delivery" section with workflow diagram and state transitions
- [x] README.md lists requirements-gathering skill
  - Evidence: Line 111 of README.md lists "requirements-gathering - For creating work items with requirements
    (no design docs)"
- [x] Progressive disclosure: main SKILL.md under 500 lines
  - Evidence: 407 lines total with references/examples.md (319 lines) and references/platform-cli-examples.md
    (165 lines) for detailed content

### RED Verification (Before Implementation)

Run these checks to confirm baseline failures:

```bash
# Check skill doesn't exist
ls skills/requirements-gathering/SKILL.md  # Should fail
ls skills/requirements-gathering/requirements-gathering.test.md  # Should fail

# Check README doesn't mention skill
grep "requirements-gathering" README.md  # Should return nothing
```

## Task Breakdown

### Task 1: Create BDD Test File (RED Baseline)

**File:** `skills/requirements-gathering/requirements-gathering.test.md`

**Content:**

- RED scenarios: Agents creating designs without tickets
- GREEN scenarios: Agents gathering requirements, creating tickets, no design commits
- Pressure scenarios: Time pressure, complexity pressure, authority pressure

**Acceptance Criteria:**

- [ ] RED scenarios describe baseline failures
- [ ] GREEN scenarios describe expected behaviour (unchecked boxes)
- [ ] Scenarios validate no design documents created
- [ ] Scenarios validate ticket creation workflow

### Task 2: Create Main SKILL.md

**File:** `skills/requirements-gathering/SKILL.md`

**Content:**

- YAML frontmatter (name, description)
- Overview: Purpose and scope
- Prerequisites: None or minimal (gh/ado/glab CLI for ticket creation)
- When to Use: Clear distinction from brainstorming and planning
- Core Workflow: Interactive Q&A process
- Output Format: Issue body structure (Goal, Requirements, Acceptance Criteria, Context)
- Integration: How it hands off to issue-driven-delivery
- Common Mistakes: Using this for implementation planning
- Red Flags: Creating design documents during requirement gathering

**Acceptance Criteria:**

- [ ] Under 500 lines (progressive disclosure)
- [ ] YAML frontmatter compliant
- [ ] Clear "When to Use" section
- [ ] Workflow documented
- [ ] Output format specified
- [ ] No design document creation stated explicitly

### Task 3: Create References (if needed)

**Approach:** Keep skill simple, only create references if SKILL.md exceeds 400 lines

**Potential references:**

- `references/issue-templates.md` - Example issue body formats
- `references/question-patterns.md` - Common question flows

**Decision:** Create only if needed during implementation

### Task 4: Update README.md

**File:** `README.md`

**Changes:**

- Add `requirements-gathering` to skills list
- Description: "For creating work items with requirements (no design docs)"

**Acceptance Criteria:**

- [ ] Skill listed in README.md
- [ ] Clear one-line description

### Task 5: Run Linting and Validation

**Commands:**

```bash
npm run lint
```

**Acceptance Criteria:**

- [ ] All linting checks pass
- [ ] No markdownlint errors
- [ ] No spelling errors (cspell)

### Task 6: Verify BDD Checklist GREEN

**Process:**

- Go through each BDD checklist item
- Mark as complete with evidence
- Link to specific files, lines, commits

**Acceptance Criteria:**

- [ ] All BDD items marked complete
- [ ] Evidence provided for each item
- [ ] GREEN scenarios remain unchecked (for test execution)

## Skill Design Notes

### Core Principle

**Gather requirements, create ticket, stop. No design, no plan, no commits.**

### Workflow Comparison

| Activity                   | requirements-gathering | brainstorming | writing-plans              |
| -------------------------- | ---------------------- | ------------- | -------------------------- |
| Gather requirements        | ✅ Yes                 | ✅ Yes        | ❌ No (assumes reqs exist) |
| Create design              | ❌ No                  | ✅ Yes        | ❌ No                      |
| Create implementation plan | ❌ No                  | ✅ Yes        | ✅ Yes                     |
| Create ticket              | ✅ Yes                 | ❌ No         | ❌ No                      |
| Commit documents           | ❌ No                  | ✅ Yes        | ✅ Yes                     |

### Key Differentiators

**Use requirements-gathering when:**

- Creating a new work item/ticket
- Need to drive out requirements through questions
- Don't want design documents committed yet
- Requirements will inform future planning

**Don't use requirements-gathering when:**

- Ticket already exists (use brainstorming or planning instead)
- Ready to create implementation plan
- Doing actual implementation work

### Output Format

```markdown
## Goal

[One sentence goal]

## Requirements

1. [Requirement 1]
2. [Requirement 2]
   ...

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
      ...

## Context

[Why this work is needed, background, constraints]
```

### Integration with issue-driven-delivery

```text
requirements-gathering → Create Issue →
  (Later when picked up)
  → Load Issue → brainstorming/planning → Implementation
```

## Verification Steps

### Post-Implementation Verification

1. **Skill exists and is complete:**

   ```bash
   ls skills/requirements-gathering/SKILL.md
   ls skills/requirements-gathering/requirements-gathering.test.md
   ```

2. **README updated:**

   ```bash
   grep "requirements-gathering" README.md
   ```

3. **Linting passes:**

   ```bash
   npm run lint
   ```

4. **BDD checklist complete:**
   - All items marked [x]
   - Evidence links provided

5. **Progressive disclosure compliance:**

   ```bash
   wc -l skills/requirements-gathering/SKILL.md  # Should be < 500
   ```

## Commit Strategy

Following Conventional Commits:

1. `feat(skill): add requirements-gathering BDD tests`
2. `feat(skill): create requirements-gathering skill`
3. `docs(readme): add requirements-gathering to skills list`
4. `docs(plan): update BDD checklist with evidence`

## Risk Mitigation

**Risk:** Skill is too similar to brainstorming, causing confusion
**Mitigation:** Clear "When to Use" section, explicit comparison table

**Risk:** Users might still create design documents manually
**Mitigation:** RED scenarios test for this, skill explicitly warns against it

**Risk:** Integration with issue-driven-delivery unclear
**Mitigation:** Document hand-off clearly, provide workflow diagram

## Success Criteria

When complete:

- [ ] Agents use requirements-gathering when creating tickets
- [ ] Requirements captured in issues, not design documents
- [ ] No design documents created during requirement gathering phase
- [ ] Clear workflow from requirements → ticket → (later) planning → implementation
- [ ] Loophole closed: Can't create designs without tickets
