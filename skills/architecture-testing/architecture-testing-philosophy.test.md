# Architecture Testing - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that architecture-testing skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Target repository may have existing architecture tests
- Agent is about to apply architectural patterns

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing \*.ArchitectureTests projects
- [x] Detects existing architecture testing patterns
- [x] Documents detection patterns explicitly

#### Deference Mechanism

- [x] Respects existing architecture test projects
- [x] Enhances rather than replaces existing tests
- [x] Documents when to skip vs when to apply

#### Drives Decision Capture

- [x] Guides creation of architecture ADRs
- [x] Documents where decisions should be recorded
- [x] Links to architecture-overview.md updates

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] templates/ directory exists with test templates
- [x] Clean Architecture test template
- [x] Layered Architecture test template
- [x] Templates are customizable

#### Automation Opportunities Documented

- [x] Template usage documented in skill
- [x] CI integration patterns documented
- [x] Incremental adoption path documented

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -ci "detect\|existing\|ArchitectureTests" skills/architecture-testing/SKILL.md
# Result: 14 matches

# Verify ADR guidance
grep -ci "ADR\|decision" skills/architecture-testing/SKILL.md
# Result: 6 matches

# Verify templates directory exists
ls skills/architecture-testing/templates/
# Result: clean-architecture-tests.cs.template layered-architecture-tests.cs.template
```

## Notes

- Detection prevents duplicate architecture test projects
- Templates accelerate adoption of architecture testing
- ADR guidance ensures decisions are captured
