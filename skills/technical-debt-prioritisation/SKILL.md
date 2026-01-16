---
name: technical-debt-prioritisation
description: Use when facing technical debt backlog requiring systematic prioritisation. Applies three-dimensional scoring (impact, risk, effort), categorises by debt type, identifies quick wins, and creates multi-horizon roadmaps for evidence-based remediation planning.
---

# Technical Debt Prioritisation

## Overview

Prioritise technical debt using **evidence-based three-dimensional scoring**,
not gut feel. Make tradeoffs visible. Plan remediation across sprint, quarterly,
and 6-month horizons.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Large debt backlog requiring systematic triage
- Sprint planning with competing debt items
- Stakeholder asks "what should we fix first?"
- Quarterly planning for debt remediation
- Justifying debt work to management

## Detection and Deference

Before creating new debt tracking, check for existing systems:

```bash
# Check for existing debt register
ls docs/debt-register.md docs/technical-debt.md docs/tech-debt/ 2>/dev/null

# Check for debt tracking in issues
gh issue list --label "tech-debt" --state open --json number,title --jq 'length'
```

**If existing tracking found:**

- Use the existing format and location
- Don't create duplicate tracking systems
- Add to existing register rather than creating new

**If no tracking found:**

- Create `docs/debt-register.md` from template
- Establish scoring convention with team

## Core Workflow

1. **Inventory debt items** (collect from backlog, code analysis, team input)
2. **Categorise by type** (code quality, architecture, testing, etc.)
3. **Score each item** on three dimensions with evidence
4. **Calculate priority** using formula
5. **Identify quick wins** (high impact, low effort)
6. **Create roadmap** at appropriate horizon
7. **Document decisions** with evidence and tradeoffs

See `references/impact-assessment.md`, `references/risk-quantification.md`,
and `references/effort-estimation.md` for scoring details.

## Three-Dimensional Scoring

| Dimension | Question                            | Scale |
| --------- | ----------------------------------- | ----- |
| Impact    | What's the business/developer cost? | 1-5   |
| Risk      | What's the probability of harm?     | 1-5   |
| Effort    | How much work to address?           | 1-5   |

**Priority Score:** (Impact + Risk) / Effort

Higher score = higher priority. Quick wins: score > 4.0, effort <= 2.

## Debt Categories

Code Quality, Architecture, Testing, Documentation, Infrastructure,
Dependencies, Security.

## Red Flags - STOP

- "This feels urgent" / "Let's just pick something"
- "Team lead knows best" / "No time for analysis"
- "There's too much to prioritise"

**All mean: Apply scoring framework before deciding.**

## Reference Templates

Templates and scripts for debt tracking automation:

| Template                                                      | Purpose                              |
| ------------------------------------------------------------- | ------------------------------------ |
| [debt-register.md](templates/debt-register.md.template)       | Debt register with scoring tables    |
| [calculate-score.sh](templates/calculate-score.sh.template)   | Calculate priority score for item    |
| [analyze-register.sh](templates/analyze-register.sh.template) | Analyze register and find quick wins |

### Quick Setup

```bash
# Create debt register from template
cp templates/debt-register.md.template docs/debt-register.md

# Calculate score for a debt item (impact=4, risk=3, effort=2)
./calculate-score.sh 4 3 2
# Output: Score: 3.50, Quick Win: No

# Analyze existing register
./analyze-register.sh docs/debt-register.md
```

### CI Integration

Add to your CI pipeline to track debt over time:

```yaml
# .github/workflows/debt-check.yml
- name: Check debt register
  run: |
    ./scripts/analyze-register.sh docs/debt-register.md
    # Fail if quick wins exceed threshold
    QUICK_WINS=$(grep -c "Quick Win" docs/debt-register.md || echo 0)
    if [ "$QUICK_WINS" -gt 5 ]; then
      echo "::warning::$QUICK_WINS quick wins pending - consider addressing"
    fi
```

## Worked Scoring Example

### Debt Item: "Replace hand-rolled JSON serialization with System.Text.Json"

#### Step 1: Score each dimension (1-5)

| Dimension | Score | Justification                                                |
| --------- | ----- | ------------------------------------------------------------ |
| Impact    | 4     | Performance issues in logs, 3 production bugs last quarter   |
| Risk      | 3     | Moderate: affects multiple services, well-defined interfaces |
| Effort    | 2     | Low: library swap, ~2 days work, good test coverage          |

#### Step 2: Calculate weighted score

```text
Score = (Impact × 0.4) + (Risk × 0.3) + ((6 - Effort) × 0.3)
Score = (4 × 0.4) + (3 × 0.3) + ((6 - 2) × 0.3)
Score = 1.6 + 0.9 + 1.2
Score = 3.7
```

#### Step 3: Classify

- Score 3.7 = **High priority**
- Effort 2 + Impact 4 = **Quick Win candidate**

#### Step 4: Horizon assignment

- Quick Win + High Priority → **Sprint horizon** (do next sprint)

## Sample Debt Register

```markdown
# Technical Debt Register

Last updated: 2026-01-15
Review cadence: Monthly

## Quick Wins (High Impact, Low Effort)

| ID     | Item                           | Impact | Risk | Effort | Score | Horizon |
| ------ | ------------------------------ | ------ | ---- | ------ | ----- | ------- |
| TD-001 | Replace JSON serialization     | 4      | 3    | 2      | 3.7   | Sprint  |
| TD-003 | Add missing null checks in API | 3      | 4    | 1      | 3.5   | Sprint  |

## Planned Remediation

| ID     | Item                       | Impact | Risk | Effort | Score | Horizon |
| ------ | -------------------------- | ------ | ---- | ------ | ----- | ------- |
| TD-002 | Extract payment module     | 5      | 4    | 4      | 3.3   | Quarter |
| TD-004 | Migrate to async handlers  | 4      | 3    | 4      | 2.9   | Quarter |
| TD-005 | Consolidate duplicate DTOs | 3      | 2    | 3      | 2.6   | 6-month |

## Parking Lot (Low Priority)

| ID     | Item                     | Impact | Risk | Effort | Score | Reason       |
| ------ | ------------------------ | ------ | ---- | ------ | ----- | ------------ |
| TD-006 | Rename legacy namespace  | 2      | 1    | 3      | 1.9   | Cosmetic     |
| TD-007 | Remove deprecated API v1 | 2      | 2    | 4      | 1.8   | No consumers |

## Summary

- **Total items**: 7
- **Quick wins pending**: 2
- **Sprint capacity allocated**: 20% for debt
- **Next review**: 2026-02-15
```
