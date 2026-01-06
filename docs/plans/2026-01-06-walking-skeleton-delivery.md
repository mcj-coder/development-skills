# Walking Skeleton Delivery Skill - Implementation Plan

**Issue:** #29
**Goal:** Create skill for building minimal E2E slices before full build-out,
validating architecture and establishing deployment pipeline
**Status:** Planning

## BDD Checklist (RED -> GREEN)

### Baseline (RED - must fail initially)

- [ ] Skill exists at `skills/walking-skeleton-delivery/SKILL.md`
- [ ] BDD tests exist at `skills/walking-skeleton-delivery/walking-skeleton-delivery.test.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] "When to Use" section includes trigger conditions
- [ ] Minimal E2E flow documented with BDD format
- [ ] Explicit scope definition (in/out of scope)
- [ ] Technology validation variant documented
- [ ] Distributed system variant documented
- [ ] References superpowers:test-driven-development
- [ ] References superpowers:verification-before-completion
- [ ] README.md lists walking-skeleton-delivery skill
- [ ] Progressive disclosure: main SKILL.md under 300 words

### RED Verification (Before Implementation)

Run these checks to confirm baseline failures:

```bash
# Check skill doesn't exist
ls skills/walking-skeleton-delivery/SKILL.md  # Should fail
ls skills/walking-skeleton-delivery/walking-skeleton-delivery.test.md  # Should fail

# Check README doesn't mention skill
grep "walking-skeleton-delivery" README.md  # Should return nothing
```

## Task Breakdown

### Task 1: Create Skill Directory Structure

**Directories to create:**

- `skills/walking-skeleton-delivery/`
- `skills/walking-skeleton-delivery/references/`

### Task 2: Create BDD Test File (RED Baseline)

**File:** `skills/walking-skeleton-delivery/walking-skeleton-delivery.test.md`

**Content:**

- RED scenarios: Agent builds features without E2E validation, discovers issues late
- GREEN scenarios: Agent proposes skeleton first, validates architecture, establishes pipeline
- Pressure scenarios: Time pressure, authority pressure, sunk cost pressure
- Technology spike scenario: Validating unfamiliar technologies
- Distributed system scenario: Multi-service E2E validation

**Acceptance Criteria:**

- [ ] RED scenarios describe baseline failures from issue spec
- [ ] GREEN scenarios describe expected behaviour
- [ ] Pressure scenarios from issue included
- [ ] Technology validation scenario included
- [ ] Distributed system scenario included

### Task 3: Create Main SKILL.md

**File:** `skills/walking-skeleton-delivery/SKILL.md`

**Target:** Under 300 words (as specified in issue)

**Content:**

- YAML frontmatter (name, description as specified)
- Overview: Walking skeleton concept
- Prerequisites: superpowers:test-driven-development, superpowers:verification-before-completion
- When to Use: Trigger conditions from issue
- Core workflow (abbreviated, details in references)
- Quick scope reference (in/out)
- Red Flags section
- Reference pointers to detailed files

**Acceptance Criteria:**

- [ ] Under 300 words
- [ ] YAML frontmatter matches issue specification
- [ ] Superpowers cross-references included
- [ ] Trigger conditions documented
- [ ] Scope definition (in/out) included

### Task 4: Create Reference Files

**Files:**

1. `references/examples-by-pattern.md`
   - New microservice example (from issue GREEN scenario 1)
   - Technology validation example (from issue GREEN scenario 2)
   - Distributed system example (from issue GREEN scenario 3)

2. `references/pitfalls-and-scope-creep.md`
   - Rationalizations table from issue
   - Red Flags from issue
   - Common scope creep patterns

3. `references/technology-spike-distinction.md`
   - Walking skeleton vs technology spike
   - When to use which approach
   - Decision criteria

**Acceptance Criteria:**

- [ ] Examples clearly formatted in BDD/Gherkin
- [ ] Rationalizations table complete
- [ ] Red flags documented
- [ ] Technology spike guidance clear

### Task 5: Update README.md

**File:** `README.md`

**Changes:**

- Add `walking-skeleton-delivery` to skills list
- Description: "P3 delivery skill for minimal E2E architecture validation"

**Acceptance Criteria:**

- [ ] Skill listed in README.md
- [ ] Priority (P3) mentioned
- [ ] Clear one-line description

### Task 6: Update cspell.json

**Potential new words:**

- skeleton (likely already present)
- roundtrip
- greenfield (if not present)
- brownfield (if not present)

**Process:**

- Run lint to identify spelling errors
- Add legitimate new terms to cspell.json

### Task 7: Run Linting and Validation

**Commands:**

```bash
npm run lint
```

**Acceptance Criteria:**

- [ ] All linting checks pass
- [ ] No markdownlint errors
- [ ] No spelling errors (cspell)

### Task 8: Verify BDD Checklist GREEN

**Process:**

- Go through each BDD checklist item
- Mark as complete with evidence
- Link to specific files, lines, commits

## Skill Design Notes

### Core Principle

**Build minimal E2E first. Validate architecture. Establish pipeline. Then features.**

### Key Differentiators

Walking skeleton is NOT:

- A prototype (skeletons are production-quality)
- A spike (spikes are throwaway, skeletons are foundation)
- MVP (MVP includes features, skeleton is infrastructure)

Walking skeleton IS:

- Minimal E2E flow proving architecture works
- Deployment pipeline establishment
- Foundation for all future features
- BDD-defined acceptance criteria

### Variants

| Variant            | Focus                                     | Timeline |
| ------------------ | ----------------------------------------- | -------- |
| New Service        | HTTP API -> Service -> Database roundtrip | 2 days   |
| Technology Spike   | Validate unfamiliar tech integration      | 3 days   |
| Distributed System | Multi-service communication validation    | 4 days   |

### Integration with Other Skills

```text
requirements-gathering -> Issue Created ->
  -> walking-skeleton-delivery (first)
  -> test-driven-development (for features)
  -> verification-before-completion (always)
```

## Verification Steps

### Post-Implementation Verification

1. **Skill exists and is complete:**

   ```bash
   ls skills/walking-skeleton-delivery/SKILL.md
   ls skills/walking-skeleton-delivery/walking-skeleton-delivery.test.md
   ls skills/walking-skeleton-delivery/references/examples-by-pattern.md
   ls skills/walking-skeleton-delivery/references/pitfalls-and-scope-creep.md
   ls skills/walking-skeleton-delivery/references/technology-spike-distinction.md
   ```

2. **README updated:**

   ```bash
   grep "walking-skeleton-delivery" README.md
   ```

3. **Word count within limit:**

   ```bash
   wc -w skills/walking-skeleton-delivery/SKILL.md  # Should be < 300
   ```

4. **Linting passes:**

   ```bash
   npm run lint
   ```

5. **BDD checklist complete:**
   - All items marked [x]
   - Evidence links provided

## Commit Strategy

Following Conventional Commits:

1. `feat(skill): add walking-skeleton-delivery BDD tests`
2. `feat(skill): create walking-skeleton-delivery skill and references`
3. `docs(readme): add walking-skeleton-delivery to skills list`
4. `docs(plan): update BDD checklist with evidence`

Or single commit:

- `feat(skill): add walking-skeleton-delivery skill (#29)`

## Risk Mitigation

**Risk:** Skill confused with technology spike
**Mitigation:** Dedicated reference file distinguishing the two

**Risk:** Scope creep during skeleton implementation
**Mitigation:** Explicit in/out scope lists, rationalizations table

**Risk:** Users skip skeleton for "time savings"
**Mitigation:** RED scenarios showing late-discovery costs, rationalizations closing

**Risk:** Skeleton too complex (becomes mini-MVP)
**Mitigation:** Clear examples showing minimal viable skeleton

## Success Criteria

When complete:

- [ ] Agents propose walking skeleton before full build-out
- [ ] E2E flow defined in BDD format
- [ ] Skeleton scope explicit (in/out)
- [ ] Deployment pipeline established as part of skeleton
- [ ] Technology validation variant available
- [ ] Distributed system variant available
- [ ] Rationalizations closed (can't skip skeleton)
