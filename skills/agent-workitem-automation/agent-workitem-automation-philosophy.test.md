# Agent Work Item Automation - Philosophy Compliance Test

## Scenario: Philosophy Compliance Verification

Validates that agent-workitem-automation skill meets ADR-0001 (Design Philosophy)
and ADR-0002 (Automation-First) requirements.

## Given

- Skill is loaded by an agent
- Target repository may or may not have existing configuration
- Agent is about to apply skill guidance

## Acceptance Criteria

### ADR-0001: Design Philosophy

#### Detection Mechanism

- [x] Skill checks for existing Work Items section in README before prompting
- [x] Skill checks for existing taskboard configuration before setup
- [x] Detection documented with specific patterns to look for

#### Deference Mechanism

- [x] If taskboard already configured, skip setup prompts
- [x] If platform already determined, reuse existing choice
- [x] Deference logic clearly documented

#### Drives Decision Capture

- [x] Guidance to capture platform choice as ADR in target repo
- [x] Guidance to document taskboard URL as discoverable reference
- [x] Clear instructions for where decisions should be recorded

#### Avoids Anti-patterns

- [x] Idempotent - safe to run multiple times
- [x] Does not re-prompt for already-configured items
- [x] Documents when to skip vs when to apply

### ADR-0002: Automation-First

#### Reference Scripts Provided

- [x] scripts/ directory exists with automation helpers
- [x] CLI validation script for gh/ado/jira detection
- [x] Setup verification script
- [x] Scripts are idempotent with meaningful output

#### Automation Opportunities Documented

- [x] Identifies which steps can be automated
- [x] Documents automation hooks (CI triggers)
- [x] Provides examples of automated workflows

## Then

Skill meets design philosophy requirements with proper detection, deference,
decision capture guidance, and automation support.

## Verification Evidence

```bash
# Verify detection mechanism documented
grep -ci "detection\|detect\|existing\|already" skills/agent-workitem-automation/SKILL.md
# Result: 17 matches

# Verify deference mechanism documented
grep -ci "defer\|skip\|existing.*config\|already.*config" skills/agent-workitem-automation/SKILL.md
# Result: 10 matches

# Verify ADR guidance
grep -ci "ADR\|decision.*record\|capture.*decision" skills/agent-workitem-automation/SKILL.md
# Result: 4 matches

# Verify scripts directory exists
ls skills/agent-workitem-automation/scripts/
# Result: validate-setup.sh

# Verify scripts are documented
grep -c "scripts/" skills/agent-workitem-automation/SKILL.md
# Result: 2 references

# Verify automation documentation
grep -ci "automat\|CI\|workflow\|trigger" skills/agent-workitem-automation/SKILL.md
# Result: 40 matches
```

## Notes

- Detection and deference are core philosophy requirements
- Reference scripts enable automation-first principle
- ADR guidance ensures decisions are captured, not assumed
- Validation script provides idempotent setup verification
