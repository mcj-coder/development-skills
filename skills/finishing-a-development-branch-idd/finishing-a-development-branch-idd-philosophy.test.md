# Finishing a Development Branch - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that finishing-a-development-branch skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Implementation is complete on a feature branch
- Agent needs to integrate changes to main

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Detects file change types (skills, docs, tests)
- [x] Checks for verification requirements
- [x] Documents automatic detection patterns

#### Deference Mechanism

- [x] Respects documented branch preferences
- [x] Checks for existing workflow patterns
- [x] Documents when to use each option

#### Drives Decision Capture

- [x] Guides integration path decision
- [x] Documents merge strategy choice
- [x] Clear evidence requirements

### ADR-0002: Automation-First

#### Dry-Run Mode

- [x] PR preview (dry-run) documented
- [x] Shows commits and files before PR creation
- [x] Non-destructive preview available

#### Automation Opportunities Documented

- [x] Git commands for each path
- [x] gh CLI integration
- [x] Branch cleanup automation

## Then

Skill meets design philosophy requirements with detection, decision capture,
and dry-run preview for PR creation.

## Verification Evidence

```bash
# Verify dry-run mode documented
grep -ci "dry-run\|preview" skills/finishing-a-development-branch/SKILL.md
# Result: Multiple matches for preview mode

# Verify integration paths documented
grep -c "Option" skills/finishing-a-development-branch/SKILL.md
# Result: 3 options documented
```

## Notes

- Skill was already compliant
- Added PR preview (dry-run) section for safer PR creation
- Preview shows commits and files before actual PR creation
