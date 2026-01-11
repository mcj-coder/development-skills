# Automated Standards Enforcement - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that automated-standards-enforcement skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Target repository may have existing linting setup
- Agent is about to apply standards enforcement

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing configuration files (.editorconfig, eslint, etc.)
- [x] Detects existing linting setup
- [x] Documents detection patterns explicitly

#### Deference Mechanism

- [x] Respects existing configuration
- [x] Enhances rather than replaces existing setup
- [x] Documents brownfield approach

#### Drives Decision Capture

- [x] Guides configuration file creation
- [x] Documents tools in README.md
- [x] Exceptions documented in docs/known-issues.md

### ADR-0002: Automation-First

#### Reference CI Templates Provided

- [x] templates/ directory exists
- [x] GitHub Actions lint workflow template
- [x] GitHub Actions security workflow template
- [x] Azure DevOps lint pipeline template

#### Automation Opportunities Documented

- [x] Pre-commit hooks documented
- [x] CI enforcement documented
- [x] Single-command local validation

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture, and CI workflow templates.

## Verification Evidence

```bash
# Verify CI templates directory exists
ls skills/automated-standards-enforcement/templates/
# Result: github-lint-workflow.yml.template github-security-workflow.yml.template azure-pipelines-lint.yml.template

# Verify templates are documented in skill
grep -c "templates/" skills/automated-standards-enforcement/SKILL.md
# Result: 4 references
```

## Notes

- Skill was already largely compliant
- Added CI workflow templates to complete automation-first coverage
- Templates cover GitHub Actions and Azure DevOps
