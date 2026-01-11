# Testcontainers Integration Tests - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that testcontainers-integration-tests skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent needs to write integration tests with real infrastructure
- Repository may or may not have existing Testcontainers setup

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing Testcontainers packages in project
- [x] Detects existing test fixture patterns
- [x] Documents detection in Detection and Deference section

#### Deference Mechanism

- [x] Respects existing test fixture conventions
- [x] Uses existing container configurations if present
- [x] Only creates new fixtures if none exist

#### Drives Decision Capture

- [x] Guides creation of testing strategy document
- [x] Documents container choices and rationale
- [x] ADR template for testing approach

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] PostgreSQL test fixture template
- [x] Common database fixture template
- [x] Test project setup template

#### Idempotent Operations

- [x] Container lifecycle is idempotent
- [x] Test isolation ensures repeatability

#### Automation Opportunities Documented

- [x] CI/CD integration patterns documented
- [x] Container reuse for performance
- [x] Image pre-pull automation

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture via testing strategy, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -c "Detection and Deference" skills/testcontainers-integration-tests/SKILL.md
# Result: Section exists

# Verify templates directory exists
ls skills/testcontainers-integration-tests/templates/
# Result: Test fixture templates listed

# Verify decision capture guidance
grep -ci "testing.strategy\|adr" skills/testcontainers-integration-tests/SKILL.md
# Result: References to testing strategy documentation
```

## Notes

- Added Detection and Deference section for existing setups
- Added Decision Capture section for testing strategy ADR
- Added test fixture templates for common containers
