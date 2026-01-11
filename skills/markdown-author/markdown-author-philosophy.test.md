# Markdown Author - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that markdown-author skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Agent is writing or editing markdown
- Repository may or may not have config files

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Checks for existing .markdownlint.json before creating
- [x] Checks for existing cspell.json before creating
- [x] Documents detection in "Configuration Verification" section

#### Deference Mechanism

- [x] Respects existing .markdownlint.json configuration
- [x] Respects existing cspell.json configuration
- [x] Only creates defaults if configs missing

#### Drives Decision Capture

- [x] Config files serve as decision records
- [x] Rule customization captured in .markdownlint.json
- [x] Project terminology captured in cspell.json

### ADR-0002: Automation-First

#### Reference Templates Provided

- [x] Default .markdownlint.json template
- [x] Strict .markdownlint.json template for documentation-heavy projects
- [x] Minimal .markdownlint.json template for simple projects
- [x] Default cspell.json template

#### Idempotent Operations

- [x] Lint checks are idempotent
- [x] Config creation is idempotent (skip if exists)
- [x] Auto-fix operations produce consistent results

#### Automation Opportunities Documented

- [x] Pre-commit hook integration documented
- [x] npm lint scripts documented
- [x] Editor integration referenced

## Then

Skill meets design philosophy requirements with detection, deference,
decision capture via config files, and reference templates.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -c "Check.*exists" skills/markdown-author/SKILL.md
# Result: Multiple checks for config existence

# Verify templates directory exists
ls skills/markdown-author/templates/
# Result: markdownlint templates listed

# Verify deference mechanism
grep -ci "respects\|existing" skills/markdown-author/SKILL.md
# Result: Multiple references to respecting existing config
```

## Notes

- Skill already had detection and deference mechanisms
- Added reference templates for common use cases
- Templates enable quick setup without decisions for common scenarios
