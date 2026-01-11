# Aspire Integration Testing - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that aspire-integration-testing skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Target repository may have existing Aspire tests
- Agent is about to apply Aspire testing patterns

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing \*.AppHost.Tests projects
- [x] Detects existing Aspire.Hosting.Testing references
- [x] Documents detection patterns explicitly

#### Deference Mechanism

- [x] Respects existing Aspire test projects
- [x] Enhances rather than replaces existing tests
- [x] Documents when to skip vs when to apply

#### Drives Decision Capture

- [x] Guides testing strategy documentation
- [x] Documents where decisions should be recorded
- [x] Provides testing strategy template

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] templates/ directory exists with test templates
- [x] Aspire integration tests template
- [x] Test project csproj template
- [x] Templates are customizable

#### Automation Opportunities Documented

- [x] Template usage documented in skill
- [x] Test categories documented
- [x] Incremental adoption path documented

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -ci "detect\|existing\|AppHost" skills/aspire-integration-testing/SKILL.md
# Result: 12 matches

# Verify testing strategy guidance
grep -ci "testing.*strategy\|decision" skills/aspire-integration-testing/SKILL.md
# Result: 6 matches

# Verify templates directory exists
ls skills/aspire-integration-testing/templates/
# Result: aspire-integration-tests.cs.template aspire-test-project.csproj.template
```

## Notes

- Detection prevents duplicate Aspire test projects
- Templates accelerate adoption of Aspire testing
- Strategy guidance ensures testing approach is documented
