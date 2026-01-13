# Agents-Onboarding Tests

## RED: Baseline Pressure Scenarios (Expected to Fail Without Skill)

### Scenario A: Time Constraint - Quick Start

**Pressure:** "Need agent working today."

**Baseline failure to record:**

- Agent does not create AGENTS.md (just starts working)
- Agent does not document standards (assumes agent will figure it out)
- Agent does not enable fresh context to apply skills (relies on conversation memory)
- Agent does not reference external skills (doesn't know about superpowers)

**Observed baseline (RED):**

- Started helping without onboarding documentation.
- Did not create AGENTS.md.
- Did not reference superpowers skills.
- Rationalizations: "Agent can learn from code", "Can document later."

### Scenario B: Authority - "Just Make It Work"

**Pressure:** "Team lead said agents should help with PRs."

**Baseline failure to record:**

- Agent does not establish review standards (assumes default behavior)
- Agent does not document required skills (ad-hoc skill usage)
- Agent does not create onboarding artifact (focuses on immediate task)

**Observed baseline (RED):**

- Started PR review without documented standards.
- No AGENTS.md created.
- Rationalizations: "Team lead just wants PR help", "Standards can evolve."

### Scenario C: Sunk Cost - Existing Usage

**Pressure:** "Agents have been helping for 3 months."

**Baseline failure to record:**

- Agent does not create comprehensive AGENTS.md (just adds testing note)
- Agent does not enable fresh context (adds note agents must be told)
- Agent does not catalog all standards (only addresses testing issue)

**Observed baseline (RED):**

- Added minimal documentation for reported issue only.
- Did not create comprehensive onboarding.
- Rationalizations: "Just need testing documented", "Full onboarding is overkill."

## GREEN: Expected Behavior With Skill

### Greenfield: Creating Complete Agent Onboarding

- [ ] Agent announces skill and why it applies.
- [ ] Agent identifies onboarding artifacts needed (AGENTS.md at repo root).
- [ ] Agent creates AGENTS.md with all required sections:
  - [ ] Repository Overview (purpose, architecture, constraints)
  - [ ] Required Skills (external and custom with triggers)
  - [ ] Development Standards (code, testing, review, deployment)
  - [ ] Repository Conventions (structure, naming, documentation)
  - [ ] Process Guidance (PR, deployment, escalation)
  - [ ] Context Optimization (must-knows, focus areas)
- [ ] Agent references external skills (`superpowers:*` format).
- [ ] Agent validates fresh context test (new agent can apply standards).
- [ ] Agent commits with evidence.

### Brownfield: Documenting Existing Standards

- [ ] Agent analyzes repository for existing standards:
  - [ ] Tooling configs (.eslintrc, .prettierrc, tsconfig.json)
  - [ ] Documentation (docs/, README.md, CONTRIBUTING.md)
  - [ ] Workflows (.github/workflows/, branch protection)
  - [ ] Code patterns (directory structure, naming)
- [ ] Agent documents discovered standards in AGENTS.md.
- [ ] Agent references external skills where applicable.
- [ ] Agent validates fresh context test passes.
- [ ] Agent commits with evidence.

### Skills Catalog Integration

- [ ] Agent catalogs all custom skills (internal).
- [ ] Agent lists all required external skills (superpowers).
- [ ] Agent documents skill triggers (when to use each).
- [ ] Agent assigns skill priorities (P0-P4).
- [ ] Agent describes skill interactions.
- [ ] Fresh agent can identify when to use which skill.

### Fresh Context Test Validation

- [ ] Agent with only AGENTS.md can implement new feature.
- [ ] Agent with only AGENTS.md knows which skills to apply.
- [ ] Agent with only AGENTS.md follows PR process correctly.
- [ ] Agent with only AGENTS.md escalates appropriately.
- [ ] If test fails, AGENTS.md is updated to address gap.

### Well-Known Location

- [ ] AGENTS.md created at repository root (not nested).
- [ ] Location is discoverable by fresh agents.
- [ ] README.md references AGENTS.md for agents.

## Evidence Requirements

### Greenfield Evidence

- [ ] AGENTS.md created at repository root.
- [ ] All required sections present and populated.
- [ ] External skills referenced (`superpowers:skill-name` format).
- [ ] Fresh context test passes.
- [ ] Commit includes AGENTS.md creation.

### Brownfield Evidence

- [ ] Repository analysis performed (documented sources).
- [ ] All existing standards identified.
- [ ] AGENTS.md created with discovered standards.
- [ ] Fresh context test passes.
- [ ] Commit includes AGENTS.md creation.

### Skills Catalog Evidence

- [ ] Custom skills listed with triggers.
- [ ] External skills listed with triggers.
- [ ] Skill priorities assigned.
- [ ] Skill interactions documented.

## Success Criteria Summary

### AGENTS.md Complete

- [ ] Repository overview section present.
- [ ] Required skills section present (with external refs).
- [ ] Development standards section present.
- [ ] Repository conventions section present.
- [ ] Process guidance section present.
- [ ] Context optimization section present.

### Fresh Context Enabled

- [ ] New agent can apply standards without conversation history.
- [ ] New agent knows when to use which skills.
- [ ] New agent follows processes correctly.
- [ ] New agent can escalate appropriately.

### Documentation Valid

- [ ] AGENTS.md at repository root.
- [ ] Lint passes (no markdown errors).
- [ ] Spell check passes.
- [ ] All sections populated (no empty placeholders).

## Rationalizations Closed

### Red Flags Identified

- [ ] "Agent can figure it out" - blocked, skill applied.
- [ ] "We'll document standards later" - blocked, skill applied.
- [ ] "Just need basic agent help" - blocked, skill applied.
- [ ] "Only one person uses agents here" - blocked, skill applied.
- [ ] "Don't want to over-document" - blocked, skill applied.

### Recovery Applied

- [ ] When onboarding was skipped, agent stops current work.
- [ ] Agent creates AGENTS.md before continuing.
- [ ] Fresh context test validates completeness.
- [ ] Work resumes with proper onboarding.
