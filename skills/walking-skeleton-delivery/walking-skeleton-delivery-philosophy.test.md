# Walking Skeleton Delivery - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that walking-skeleton-delivery skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent needs to create minimal end-to-end slice
- Repository may or may not have existing project structure

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing project/solution structure
- [x] Detects existing deployment pipeline
- [x] Documents detection in Detection and Deference section

#### Deference Mechanism

- [x] Respects existing project conventions
- [x] Uses existing deployment patterns if present
- [x] Only creates new structure if none exists

#### Drives Decision Capture

- [x] Guides creation of architecture ADR
- [x] Documents skeleton scope decisions
- [x] Captures learnings from validation

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] ASP.NET Web API skeleton template
- [x] Architecture decision template
- [x] Skeleton scope checklist

#### Idempotent Operations

- [x] Detection checks are idempotent
- [x] Skeleton creation is additive

#### Automation Opportunities Documented

- [x] Project scaffolding commands
- [x] Deployment pipeline examples
- [x] BDD test structure

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture via architecture ADR, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -c "Detection and Deference" skills/walking-skeleton-delivery/SKILL.md
# Result: Section exists

# Verify templates directory exists
ls skills/walking-skeleton-delivery/templates/
# Result: Skeleton templates listed

# Verify decision capture guidance
grep -ci "adr\|decision" skills/walking-skeleton-delivery/SKILL.md
# Result: References to architecture decisions
```

## Notes

- Added Detection and Deference section for existing projects
- Added Decision Capture section for architecture ADR
- Added skeleton templates for common architectures
