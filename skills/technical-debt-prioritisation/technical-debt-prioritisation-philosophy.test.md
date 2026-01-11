# Technical Debt Prioritisation - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that technical-debt-prioritisation skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent needs to prioritise technical debt backlog
- Repository may or may not have existing debt tracking

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing debt register before creating
- [x] Detects existing debt tracking in docs/
- [x] Documents detection in Detection and Deference section

#### Deference Mechanism

- [x] Respects existing debt register format
- [x] Uses existing scoring system if present
- [x] Only creates defaults if tracking missing

#### Drives Decision Capture

- [x] Documents scoring rationale with evidence
- [x] Creates debt register as decision record
- [x] Tradeoffs made visible

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] Debt register template
- [x] Impact score calculation script

#### Idempotent Operations

- [x] Scoring is deterministic with same inputs
- [x] Register updates are additive

#### Automation Opportunities Documented

- [x] Score calculation script provided
- [x] CI integration for debt tracking documented
- [x] Quick setup commands provided

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture via debt register, and automation scripts.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -c "Detection and Deference" skills/technical-debt-prioritisation/SKILL.md
# Result: Section exists

# Verify templates directory exists
ls skills/technical-debt-prioritisation/templates/
# Result: Templates and scripts listed

# Verify scoring formula documented
grep -c "Priority Score" skills/technical-debt-prioritisation/SKILL.md
# Result: Formula exists
```

## Notes

- Added Detection and Deference section for existing tracking
- Added debt register template for consistent tracking
- Added score calculation script for automation
