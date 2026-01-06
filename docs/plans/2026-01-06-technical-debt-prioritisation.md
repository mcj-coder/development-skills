# Technical Debt Prioritisation Skill - Implementation Plan

**Issue:** #27
**Goal:** Create skill for evidence-based technical debt prioritisation using
three-dimensional scoring (impact, risk, effort), categorisation by debt type,
and roadmap planning.
**Status:** Planning

## BDD Checklist (RED -> GREEN)

### Baseline (RED - must fail initially)

- [ ] Skill exists at `skills/technical-debt-prioritisation/SKILL.md`
- [ ] BDD tests exist at `skills/technical-debt-prioritisation/technical-debt-prioritisation.test.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] "When to Use" section includes trigger conditions
- [ ] Three-dimensional scoring framework documented (impact, risk, effort)
- [ ] Debt type categorisation system documented
- [ ] Roadmap planning guidance (sprint to 6-month)
- [ ] Quick win identification criteria documented
- [ ] References superpowers:verification-before-completion
- [ ] README.md lists technical-debt-prioritisation skill
- [ ] Progressive disclosure: main SKILL.md under 300 words
- [ ] Reference files for detailed guidance

### RED Verification (Before Implementation)

Run these checks to confirm baseline failures:

```bash
# Check skill doesn't exist
ls skills/technical-debt-prioritisation/SKILL.md  # Should fail
ls skills/technical-debt-prioritisation/technical-debt-prioritisation.test.md  # Should fail

# Check README doesn't mention skill
grep "technical-debt-prioritisation" README.md  # Should return nothing
```

## Task Breakdown

### Task 1: Create Skill Directory Structure

**Directories to create:**

- `skills/technical-debt-prioritisation/`
- `skills/technical-debt-prioritisation/references/`

### Task 2: Create BDD Test File (RED Baseline)

**File:** `skills/technical-debt-prioritisation/technical-debt-prioritisation.test.md`

**Content:**

- RED scenarios: Agent addresses debt ad-hoc without prioritisation framework
- GREEN scenarios: Agent applies three-dimensional scoring, categorises debt,
  creates prioritised roadmap
- Pressure scenarios: Time pressure, political pressure, sunk cost pressure
- Quick win scenarios: Identifying high-impact, low-effort items
- Roadmap scenarios: Sprint, quarterly, 6-month planning

**Acceptance Criteria:**

- [ ] RED scenarios describe baseline failures
- [ ] GREEN scenarios describe expected behaviour
- [ ] Three-dimensional scoring demonstrated
- [ ] Debt categorisation applied
- [ ] Roadmap planning at multiple horizons
- [ ] Quick win identification shown

### Task 3: Create Main SKILL.md

**File:** `skills/technical-debt-prioritisation/SKILL.md`

**Target:** Under 300 words

**Content:**

- YAML frontmatter (name, description)
- Overview: Technical debt prioritisation concept
- Prerequisites: superpowers:verification-before-completion
- When to Use: Trigger conditions
- Core workflow (abbreviated, details in references)
- Quick reference to scoring dimensions
- Debt type categories
- Reference pointers to detailed files

**Acceptance Criteria:**

- [ ] Under 300 words
- [ ] YAML frontmatter matches specification
- [ ] Superpowers cross-references included
- [ ] Trigger conditions documented
- [ ] Scoring dimensions introduced

### Task 4: Create Reference Files

**Files:**

1. `references/impact-assessment.md`
   - Business impact scoring criteria
   - Technical impact dimensions
   - Developer experience impact
   - Impact scoring scale (1-5)

2. `references/risk-quantification.md`
   - Risk categories (failure, security, compliance, velocity)
   - Risk probability assessment
   - Risk scoring scale (1-5)
   - Risk evidence requirements

3. `references/effort-estimation.md`
   - Effort estimation techniques
   - Complexity factors
   - Effort scoring scale (1-5)
   - Dependency considerations
   - Quick win identification (low effort, high impact)

**Acceptance Criteria:**

- [ ] Impact scoring clearly documented with scale
- [ ] Risk quantification with evidence requirements
- [ ] Effort estimation with complexity factors
- [ ] Quick win formula explained

### Task 5: Update README.md

**File:** `README.md`

**Changes:**

- Add `technical-debt-prioritisation` to skills list
- Description: "P3 delivery skill for evidence-based debt prioritisation"

**Acceptance Criteria:**

- [ ] Skill listed in README.md
- [ ] Priority (P3) mentioned
- [ ] Clear one-line description

### Task 6: Update cspell.json

**Potential new words:**

- prioritisation (likely needed)
- quantification (check if present)

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

**Prioritise debt using evidence-based three-dimensional scoring. Make informed
tradeoffs visible. Plan remediation across multiple time horizons.**

### Three-Dimensional Scoring

| Dimension | Question                                     | Scale |
| --------- | -------------------------------------------- | ----- |
| Impact    | How much does this debt cost us?             | 1-5   |
| Risk      | What's the probability and severity of harm? | 1-5   |
| Effort    | How much work to address this debt?          | 1-5   |

**Priority Score:** (Impact + Risk) / Effort

Higher score = higher priority (high impact/risk, low effort = quick win)

### Debt Type Categories

| Category       | Description                                   | Examples                  |
| -------------- | --------------------------------------------- | ------------------------- |
| Code Quality   | Maintainability, readability, complexity      | Long methods, duplication |
| Architecture   | Structural issues, coupling, layering         | Circular dependencies     |
| Testing        | Coverage gaps, flaky tests, missing tests     | No integration tests      |
| Documentation  | Missing, outdated, or incorrect documentation | No API docs, stale README |
| Infrastructure | CI/CD issues, deployment complexity           | Manual deployments        |
| Dependencies   | Outdated, vulnerable, or unmaintained deps    | EOL frameworks            |
| Security       | Vulnerabilities, compliance gaps              | Hardcoded credentials     |

### Roadmap Planning Horizons

| Horizon | Focus                       | Debt Types          |
| ------- | --------------------------- | ------------------- |
| Sprint  | Quick wins, blocking issues | High priority score |
| Quarter | Systematic improvements     | Medium priority     |
| 6-month | Architectural, strategic    | Large effort items  |

### Integration with Other Skills

```text
requirements-gathering -> Issue Created ->
  -> technical-debt-prioritisation (for debt items)
  -> test-driven-development (for implementation)
  -> verification-before-completion (always)
```

## Verification Steps

### Post-Implementation Verification

1. **Skill exists and is complete:**

   ```bash
   ls skills/technical-debt-prioritisation/SKILL.md
   ls skills/technical-debt-prioritisation/technical-debt-prioritisation.test.md
   ls skills/technical-debt-prioritisation/references/impact-assessment.md
   ls skills/technical-debt-prioritisation/references/risk-quantification.md
   ls skills/technical-debt-prioritisation/references/effort-estimation.md
   ```

2. **README updated:**

   ```bash
   grep "technical-debt-prioritisation" README.md
   ```

3. **Word count within limit:**

   ```bash
   wc -w skills/technical-debt-prioritisation/SKILL.md  # Should be < 300
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

Single commit:

- `feat(skill): add technical-debt-prioritisation skill (#27)`

## Risk Mitigation

**Risk:** Scoring becomes bureaucratic overhead
**Mitigation:** Emphasise quick assessment, not lengthy analysis

**Risk:** Teams skip prioritisation under pressure
**Mitigation:** RED scenarios showing cost of ad-hoc debt work

**Risk:** Scores become political rather than evidence-based
**Mitigation:** Evidence requirements for each score dimension

**Risk:** Roadmap plans ignored after creation
**Mitigation:** Integration with sprint planning, regular review cadence

## Success Criteria

When complete:

- [ ] Agents use three-dimensional scoring for debt prioritisation
- [ ] Debt categorised by type
- [ ] Impact, risk, and effort scored with evidence
- [ ] Priority calculated using formula
- [ ] Quick wins identified (high impact, low effort)
- [ ] Roadmap planned at appropriate horizon
- [ ] Evidence-based decisions, not gut feel
