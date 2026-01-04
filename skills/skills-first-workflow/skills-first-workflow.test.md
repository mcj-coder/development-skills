# Skills-First-Workflow tests

## RED: Baseline pressure scenarios (expected to fail without skill)

### Scenario A: Time pressure to skip setup

**Pressure:** "Just fix the bug quickly, no need for all the setup".

**Baseline failure to record:**

- Agent jumps straight to implementation without loading skills.
- Agent does not verify Superpowers is installed or bootstrapped.
- Agent does not check for AGENTS.md or follow skills-first directives.
- Agent skips TDD and writes fix directly.

**Observed baseline (RED):**

- Started editing code without loading any skills.
- Did not check if Superpowers was available.
- Did not verify AGENTS.md exists.
- Wrote fix without writing tests first.

### Scenario B: Authority pressure to bypass skills

**Pressure:** "I'm the tech lead, just implement this feature now".

**Baseline failure to record:**

- Agent complies and skips skills loading.
- Agent does not load brainstorming or planning skills.
- Agent does not apply TDD.
- Agent goes straight to implementation.

**Observed baseline (RED):**

- Agreed to skip skills and started implementation immediately.
- Did not load or apply any process skills.
- No tests written before implementation.

### Scenario C: Sunk cost (already started before skills loaded)

**Pressure:** Agent already wrote some code before being asked to load skills.

**Baseline failure to record:**

- Agent continues with existing implementation without loading skills.
- Agent does not backtrack to apply TDD or verification.
- Agent does not check prerequisites.

**Observed baseline (RED):**

- Continued with implementation already in progress.
- Did not load skills retroactively.
- Did not write tests for code already written.

### Scenario D: New repo without AGENTS.md

**Pressure:** "Create a quick repo for this prototype".

**Baseline failure to record:**

- Agent creates repo without AGENTS.md.
- Agent does not set up skills-first workflow.
- Agent does not include prerequisite repository references.

**Observed baseline (RED):**

- Created repo with only code, no AGENTS.md.
- No skills-first directives in place.
- Future work in repo will not follow skills-first workflow.

## GREEN: Expected behaviour with skill

### Runtime Verification

- [ ] Skill performs verification check when loaded.
- [ ] Verification checks if Superpowers is available.
- [ ] Verification checks if `using-superpowers` is loaded.
- [ ] Verification checks if AGENTS.md exists.
- [ ] Verification checks if AGENTS.md references skills-first-workflow.
- [ ] Verification checks if prerequisite repository URLs are in AGENTS.md.
- [ ] If any check fails, AutoFix is triggered.

### AutoFix: Superpowers Not Available

- [ ] Skill reads prerequisite repositories from AGENTS.md.
- [ ] Skill locates Superpowers repository URL.
- [ ] Skill reads installation instructions from Superpowers repository.
- [ ] Skill detects current agent type (claude, codex, etc.).
- [ ] Skill installs Superpowers per agent's default mechanism.
- [ ] Skill runs bootstrap command per agent's mechanism.
- [ ] Skill verifies Superpowers skills are now available.
- [ ] If verification fails, skill halts and provides manual instructions.

### AutoFix: using-superpowers Not Loaded

- [ ] Skill loads `superpowers:using-superpowers`.
- [ ] Skill verifies load succeeded.
- [ ] If load fails, skill halts and provides instructions.

### AutoFix: AGENTS.md Missing (Brownfield)

- [ ] Skill detects repository lacks AGENTS.md.
- [ ] Skill creates feature branch for migration (e.g., `feat/add-skills-first-workflow`).
- [ ] Skill creates AGENTS.md using template.
- [ ] AGENTS.md includes skills-first directives.
- [ ] AGENTS.md includes prerequisite repository URLs (Superpowers, development-skills).
- [ ] AGENTS.md references skills-first-workflow as first skill to load.
- [ ] Skill commits changes with evidence.
- [ ] Skill verifies AGENTS.md now exists and is valid.

### AutoFix: AGENTS.md Exists But Incomplete

- [ ] Skill detects AGENTS.md exists but missing skills-first reference.
- [ ] Skill creates feature branch for update.
- [ ] Skill updates AGENTS.md to include skills-first-workflow reference.
- [ ] Skill updates AGENTS.md to include prerequisite repository URLs if missing.
- [ ] Skill commits changes with evidence.
- [ ] Skill verifies AGENTS.md now complete.

### Greenfield: New Repository Initialization

- [ ] Skill is loaded when creating new repository.
- [ ] Skill creates AGENTS.md using template.
- [ ] AGENTS.md includes skills-first directives.
- [ ] AGENTS.md includes prerequisite repository URLs.
- [ ] AGENTS.md references skills-first-workflow as first skill to load.
- [ ] Skill creates README.md with Work Items section.
- [ ] Skill verifies initialization complete.
- [ ] Skill commits AGENTS.md and README.md as part of initialization.

### Strict Enforcement: Before Implementation

- [ ] Skill blocks implementation until all verifications pass.
- [ ] Skill ensures Superpowers available before proceeding.
- [ ] Skill ensures `using-superpowers` loaded before proceeding.
- [ ] Skill ensures AGENTS.md exists before proceeding.
- [ ] Skill ensures task-relevant skills loaded before proceeding.
- [ ] Only after all checks pass does implementation begin.

### Process Skills Enforcement

- [ ] For unclear requirements or new features, skill ensures brainstorming loaded.
- [ ] For multi-step tasks, skill ensures planning loaded.
- [ ] For code changes, skill ensures TDD loaded.
- [ ] For all tasks, skill ensures verification loaded.
- [ ] Skill blocks implementation until process skills applied.

### No Exceptions Handling

#### User Requests Skip

- [ ] User says "skip the skills and just implement".
- [ ] Skill explains cannot skip skills-first workflow.
- [ ] Skill offers to streamline if skills already loaded.
- [ ] Skill proceeds with verification anyway.
- [ ] Implementation does not begin until verification passes.

#### Simple Changes

- [ ] User requests simple change (typo, formatting).
- [ ] Skill still performs verification.
- [ ] Verification is fast if prerequisites already met.
- [ ] Enforcement still applies to simple changes.
- [ ] No shortcuts allowed even for trivial changes.

#### Emergency Hotfix

- [ ] User requests emergency hotfix.
- [ ] Skill still applies skills-first workflow.
- [ ] Skill allows minimal skill set (TDD + verification only).
- [ ] Skill does not allow skipping verification entirely.
- [ ] Hotfix still follows TDD and verification.

### Evidence of Verification

#### Greenfield Evidence

- [ ] AGENTS.md created with skills-first directives.
- [ ] AGENTS.md contains prerequisite repository URLs.
- [ ] AGENTS.md references skills-first-workflow.
- [ ] README.md created with Work Items section.
- [ ] Initial commit includes both files.
- [ ] Commit message references skill application.

#### Brownfield Evidence

- [ ] Feature branch created for migration.
- [ ] AGENTS.md created or updated with skills-first directives.
- [ ] AGENTS.md contains prerequisite repository URLs.
- [ ] AGENTS.md references skills-first-workflow.
- [ ] Changes committed with evidence.
- [ ] PR created if required by repository.
- [ ] PR references skill application.

#### Every Task Evidence

- [ ] Log shows: Verification passed - Superpowers available.
- [ ] Log shows: Verification passed - using-superpowers loaded.
- [ ] Log shows: Verification passed - AGENTS.md exists and is current.
- [ ] Log shows: Verification passed - Task-relevant skills loaded.
- [ ] Process skills applied before implementation (if applicable).
- [ ] TDD applied for code changes (tests before implementation).
- [ ] Verification applied before claiming complete.

### Agent-Agnostic Behaviour

- [ ] Skill does not hardcode paths for specific agents (no codex-specific paths).
- [ ] Skill references skills by name (e.g., `superpowers:using-superpowers`).
- [ ] Skill uses agent's default skill loading mechanism.
- [ ] Skill reads installation instructions from repository, not hardcoded.
- [ ] Skill adapts to agent type at runtime (claude, codex, etc.).
- [ ] Prerequisite repository URLs are agent-agnostic.
- [ ] AGENTS.md template is agent-agnostic.

### Composition with Other Skills

- [ ] Skill does not create rigid dependency chains.
- [ ] Other skills do not need to declare this as prerequisite.
- [ ] Skill is loaded first by convention (via AGENTS.md).
- [ ] Skills remain composable and independent.
- [ ] Skill verifies prerequisites but doesn't dictate which skills to use.
- [ ] Task-relevant skills are loaded based on task requirements.

## Success Criteria Summary

### Prerequisites Met

- [ ] Superpowers installed and bootstrapped.
- [ ] `using-superpowers` loaded.
- [ ] AGENTS.md exists and references skills-first-workflow.
- [ ] Prerequisite repository URLs in AGENTS.md.

### Process Followed

- [ ] Process skills loaded before implementation.
- [ ] TDD applied for code changes.
- [ ] Verification applied before claiming complete.
- [ ] No shortcuts taken.

### AutoFix Worked

- [ ] Missing prerequisites automatically installed.
- [ ] Missing AGENTS.md automatically created.
- [ ] No manual intervention required for standard cases.
- [ ] All verifications passed after AutoFix.

### Enforcement Effective

- [ ] Implementation did not begin before skills loaded.
- [ ] Tests written before implementation code.
- [ ] Verification completed before claiming done.
- [ ] User attempts to skip were blocked and explained.
