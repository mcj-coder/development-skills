# TDD/BDD Verification Requirements Implementation Plan

## Issue Reference

Issue #42: Baseline practice: TDD/BDD verification requirements

## Summary

Establish clear TDD/BDD verification requirements distinguishing between concrete changes (requiring applied evidence) and process-only skills (allowing analytical verification). This baseline practice will unblock many other issues requiring clear verification standards.

## Background

Current state:
- AGENTS.md line 12-15 contains applied-skill evidence requirement but lacks clarity on concrete vs process-only distinction
- README.md lines 24-34 mandates TDD for all changes including documentation
- Skills reference superpowers:test-driven-development but don't have clear BDD checklist guidance
- Existing plan at docs/plans/2026-01-04-skill-application-verification.md has basic BDD checklist but needs expansion

## Objectives

1. Define BDD expectations for concrete changes (code, config, documentation)
2. Document analytical BDD allowance for process-only skills
3. Update AGENTS.md with clear verification requirements
4. Update relevant skills with TDD/BDD guidance
5. Create BDD checklist templates distinguishing concrete vs process-only verification
6. Cross-check with Superpowers skills for consistency

## Analysis

### Concrete Changes (Require Applied Evidence)
Concrete changes modify the repository state and must show evidence that skills were applied:
- Code implementation
- Configuration files
- Documentation files
- Build scripts
- CI/CD workflows
- Schema changes
- Test files

**BDD Requirement:** Must demonstrate skill was applied in THIS repository. Example: "TDD skill applied: failing test committed at [SHA], implementation at [SHA], passing test at [SHA]"

### Process-Only Changes (Allow Analytical BDD)
Process-only skills guide workflow without modifying repository state:
- Planning workflows
- Review processes
- Requirements gathering
- Brainstorming approaches
- Verification procedures
- Code review methodologies

**BDD Requirement:** Analytical verification acceptable. Example: "Brainstorming skill applied: requirements clarified in issue comment [link], alternatives considered [link], decision documented [link]"

### Skills Analysis

**Concrete-change skills in this repo:**
- issue-driven-delivery (modifies workflow files, documentation)
- markdown-author (modifies linting configs, documentation)
- skills-first-workflow (modifies AGENTS.md)

**Process-only skills referenced:**
- superpowers:brainstorming
- superpowers:test-driven-development
- superpowers:verification-before-completion
- superpowers:receiving-code-review
- requirements-gathering
- agent-workitem-automation (creates issues, but doesn't modify repo files directly)

## Implementation Plan

### Task 1: Create BDD Checklist Templates

**Objective:** Provide clear templates for both verification types

**Actions:**
1. Create `docs/references/bdd-checklist-templates.md` with:
   - Concrete changes checklist template
   - Process-only changes checklist template
   - Examples for each type
   - When to use which template

**BDD Verification (Concrete Change):**
- [ ] File `docs/references/bdd-checklist-templates.md` exists
- [ ] Contains concrete changes checklist template with applied evidence requirements
- [ ] Contains process-only checklist template with analytical verification guidance
- [ ] Includes 2+ examples for concrete changes
- [ ] Includes 2+ examples for process-only skills
- [ ] Clearly distinguishes when to use each template

**Deliverables:**
- `docs/references/bdd-checklist-templates.md`

### Task 2: Update AGENTS.md with TDD/BDD Requirements

**Objective:** Clarify verification requirements in agent execution rules

**Actions:**
1. Expand AGENTS.md line 12-15 applied-skill evidence section to distinguish concrete vs process-only
2. Add explicit TDD/BDD requirements section
3. Reference BDD checklist templates
4. Add examples of both verification types

**BDD Verification (Concrete Change):**
- [ ] AGENTS.md contains expanded applied-skill evidence section
- [ ] Distinguishes concrete changes (require applied evidence) from process-only (analytical verification)
- [ ] References `docs/references/bdd-checklist-templates.md`
- [ ] Includes example of concrete verification with commit SHAs
- [ ] Includes example of process-only analytical verification
- [ ] States "TDD enforcement" section (line 20-21) applies to all changes including documentation

**Deliverables:**
- Updated `AGENTS.md`

### Task 3: Update issue-driven-delivery Skill

**Objective:** Clarify BDD requirements in workflow skill

**Actions:**
1. Update step 16 (line 285-287) to reference BDD checklist templates
2. Add guidance on determining if change is concrete or process-only
3. Clarify what "evidence that required skills were applied" means for each type

**BDD Verification (Concrete Change):**
- [ ] issue-driven-delivery step 16 references BDD checklist templates
- [ ] Explains how to determine if change is concrete vs process-only
- [ ] Clarifies applied evidence requirement for concrete changes
- [ ] Clarifies analytical verification allowance for process-only
- [ ] Provides examples of each verification type

**Deliverables:**
- Updated `skills/issue-driven-delivery/SKILL.md`

### Task 4: Update agent-workitem-automation Skill

**Objective:** Align automation skill with BDD requirements

**Actions:**
1. Update "Delivery Completion" section (lines 130-148) to reference BDD templates
2. Clarify verification requirements for autonomous workflows
3. Add guidance on when to use concrete vs process-only verification

**BDD Verification (Concrete Change):**
- [ ] agent-workitem-automation references BDD checklist templates
- [ ] Clarifies verification requirements before opening PR
- [ ] Distinguishes concrete vs process-only verification
- [ ] Aligns with issue-driven-delivery requirements

**Deliverables:**
- Updated `skills/agent-workitem-automation/SKILL.md`

### Task 5: Create/Update BDD Test Files

**Objective:** Ensure all skills have proper BDD tests demonstrating verification

**Actions:**
1. Review existing `.test.md` files for BDD coverage
2. Add BDD tests demonstrating concrete vs process-only verification
3. Ensure tests show RED (failing) and GREEN (passing) states

**BDD Verification (Concrete Change):**
- [ ] issue-driven-delivery.test.md includes BDD verification test cases
- [ ] agent-workitem-automation has .test.md with BDD verification scenarios
- [ ] markdown-author.test.md demonstrates concrete change verification
- [ ] skills-first-workflow.test.md demonstrates process-only verification
- [ ] Each test file shows RED (failing) state before skill applied
- [ ] Each test file shows GREEN (passing) state after skill applied

**Deliverables:**
- Updated/created test files in skills directories

### Task 6: Cross-Check with Superpowers Skills

**Objective:** Ensure consistency with Superpowers TDD/verification skills

**Actions:**
1. Document how superpowers:test-driven-development integrates
2. Document how superpowers:verification-before-completion integrates
3. Ensure no conflicts or overlaps in requirements
4. Reference Superpowers skills appropriately in documentation

**BDD Verification (Analytical - Process Only):**
- [ ] Documented integration with superpowers:test-driven-development in AGENTS.md
- [ ] Documented integration with superpowers:verification-before-completion in AGENTS.md
- [ ] No conflicting requirements identified
- [ ] Appropriate references to Superpowers skills in all documentation
- [ ] Clear distinction between this repo's concrete requirements and Superpowers process guidance

**Deliverables:**
- Updated AGENTS.md with Superpowers integration notes
- Documentation of how Superpowers skills complement local requirements

### Task 7: Update README.md TDD Section

**Objective:** Align README with new BDD requirements

**Actions:**
1. Review README.md TDD Behaviour section (lines 24-34)
2. Add reference to BDD checklist templates
3. Clarify concrete vs process-only verification
4. Ensure consistency with AGENTS.md

**BDD Verification (Concrete Change):**
- [ ] README.md TDD section references BDD checklist templates
- [ ] Clarifies verification requirements for documentation changes
- [ ] Distinguishes concrete documentation changes from process-only
- [ ] Consistent with AGENTS.md requirements
- [ ] References `docs/references/bdd-checklist-templates.md`

**Deliverables:**
- Updated `README.md`

## Acceptance Criteria

1. AGENTS.md clearly distinguishes concrete vs process-only verification requirements
2. BDD checklist templates exist with examples for both types
3. issue-driven-delivery and agent-workitem-automation skills reference BDD templates
4. All skills have .test.md files with RED/GREEN BDD scenarios
5. Superpowers skills integration documented without conflicts
6. README.md TDD section aligned with new requirements
7. Documentation uses human-centric terminology, not skill names

## Dependencies

None - this is a baseline practice that will unblock other issues

## Risks

1. **Risk:** Confusion between concrete and process-only verification
   **Mitigation:** Provide clear examples and templates for both types

2. **Risk:** Over-complication of verification process
   **Mitigation:** Keep templates simple and actionable, focus on practical examples

3. **Risk:** Inconsistency with Superpowers skills
   **Mitigation:** Explicit cross-check task and documentation of integration

## Out of Scope

- Creating new testing frameworks or tools
- Modifying Superpowers skills (external dependency)
- Automating BDD verification checks (future enhancement)
- Skill-specific BDD templates beyond general guidance

## Timeline

Single iteration - all tasks can be completed in one implementation phase.

## Evidence Requirements

Each task must include:
- Commit SHA links to changes
- Before/after snippets showing failing then passing BDD checks
- Links to modified files in repository
- Verification that changes follow TDD (BDD checklist committed before edits)

## Notes

- This is a baseline practice that many issues are blocked on
- Clear documentation will prevent future confusion
- Templates should be reusable for all future work
- Maintain consistency with existing Superpowers integration
