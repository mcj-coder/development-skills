# Broken Window - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that broken-window skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent encounters warnings/errors during operations
- Agent needs to fix or track broken windows

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Detects warnings/errors during operations
- [x] Checks for existing quality gates
- [x] Documents detection triggers explicitly

#### Deference Mechanism

- [x] Respects existing linting/CI setup
- [x] Uses existing enforcement patterns
- [x] Documents when to skip vs when to apply (2x rule)

#### Drives Decision Capture

- [x] Creates tech-debt issues when deferring
- [x] Documents fix vs defer decision
- [x] Clear labeling (tech-debt)

### ADR-0002: Automation-First

#### Quick-Fix Scripts

- [x] Common fix commands documented
- [x] Quick-fix script template provided
- [x] Automation for common scenarios

#### Automation Opportunities Documented

- [x] CI enforcement documented
- [x] Pre-commit integration documented
- [x] Idempotent lint checks

## Then

Skill meets design philosophy requirements with clear detection,
decision capture, and quick-fix automation support.

## Verification Evidence

```bash
# Verify quick-fix documentation
grep -ci "fix\|script\|automat" skills/broken-window/SKILL.md
# Result: Multiple matches for automation

# Verify 2x rule documented
grep -c "2x" skills/broken-window/SKILL.md
# Result: Multiple references to decision threshold
```

## Notes

- Skill was already largely compliant
- Added quick-fix scripts section for common scenarios
- Script template enables faster broken window resolution
