# Requirements Gathering - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that requirements-gathering skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent needs to create a new work item
- No existing ticket for this work

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing tickets before creating new ones
- [x] Detects platform from git remote or README
- [x] Documents detection in Precondition Check section

#### Deference Mechanism

- [x] Redirects to other skills if ticket exists
- [x] Respects existing platform organization (ADRs)
- [x] Precondition guards prevent wrong skill usage

#### Drives Decision Capture

- [x] Creates tickets as decision records
- [x] Stores decomposition thresholds in ADRs
- [x] Structured output format ensures consistency

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] GitHub issue templates (feature, bug, epic)
- [x] Issue validation script

#### Idempotent Operations

- [x] Precondition check is idempotent
- [x] Platform detection is deterministic

#### Automation Opportunities Documented

- [x] CLI commands for each platform
- [x] Issue template installation script
- [x] Validation script for issue completeness

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture via tickets and ADRs, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -c "Precondition Check" skills/requirements-gathering/SKILL.md
# Result: Section exists

# Verify templates directory exists
ls skills/requirements-gathering/templates/
# Result: Issue templates and scripts listed

# Verify platform CLI examples exist
ls skills/requirements-gathering/references/platform-cli-examples.md
# Result: File exists with CLI commands
```

## Notes

- Skill already had strong detection and deference mechanisms
- Added GitHub issue templates for quick repository setup
- Added validation script for checking issue completeness
