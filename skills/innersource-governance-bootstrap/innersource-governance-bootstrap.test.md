# innersource-governance-bootstrap Tests

BDD test scenarios for the `innersource-governance-bootstrap` skill.

## Scenario 1: Required Documentation Verification

**Given** an agent is bootstrapping InnerSource governance for a repository
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST ensure all required documentation files exist

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent creates repository without README.md
- [ ] Agent omits CONTRIBUTING.md from governance setup
- [ ] Agent skips CODE_OF_CONDUCT.md claiming it is optional
- [ ] Agent does not create CODEOWNERS file
- [ ] Agent treats GOVERNANCE.md as unnecessary

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent creates README.md with project overview and quick links
- [ ] Agent creates CONTRIBUTING.md with contribution workflow
- [ ] Agent creates CODE_OF_CONDUCT.md with expected behaviour guidelines
- [ ] Agent creates CODEOWNERS with initial ownership assignments
- [ ] Agent creates GOVERNANCE.md with decision-making process

---

## Scenario 2: Contribution Workflow Documentation

**Given** an agent is setting up contribution guidelines
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST document complete contribution acceptance criteria

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not document issue-first requirement
- [ ] Agent omits branch naming conventions
- [ ] Agent skips PR template requirements
- [ ] Agent does not specify code review requirements
- [ ] Agent omits CI passing requirement
- [ ] Agent ignores documentation update requirements

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent documents issue-first requirement for non-trivial changes
- [ ] Agent specifies branch naming conventions
- [ ] Agent requires PR template usage with required sections
- [ ] Agent specifies minimum CODEOWNERS approval requirement
- [ ] Agent requires all CI checks to pass
- [ ] Agent requires documentation updates for user-facing changes

---

## Scenario 3: Review Turnaround Expectations

**Given** an agent is establishing contribution workflow
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST document review turnaround expectations

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not specify acknowledgement timeframe
- [ ] Agent omits initial review expectation
- [ ] Agent does not define merge decision timeline
- [ ] Agent leaves review expectations undocumented

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent documents acknowledgement within 2 business days
- [ ] Agent documents initial review within 5 business days
- [ ] Agent documents merge decision within 10 business days of addressing feedback
- [ ] Agent places expectations in CONTRIBUTING.md or GOVERNANCE.md

---

## Scenario 4: CODEOWNERS Configuration

**Given** an agent is setting up ownership model
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST configure CODEOWNERS with appropriate granularity

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent creates CODEOWNERS without default owner
- [ ] Agent does not assign component-specific owners
- [ ] Agent omits critical paths from enhanced review
- [ ] Agent does not enable branch protection for CODEOWNERS

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent defines default owners for entire repository
- [ ] Agent assigns component-specific owners where appropriate
- [ ] Agent requires additional review for critical paths (e.g., security)
- [ ] Agent configures branch protection requiring CODEOWNERS approval

---

## Scenario 5: Transparent Decision-Making Process

**Given** an agent is establishing governance model
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST document transparent decision-making process

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not define proposal process
- [ ] Agent omits discussion/comment period requirements
- [ ] Agent does not specify decision documentation requirements
- [ ] Agent skips communication requirements
- [ ] Agent does not categorise decisions by impact

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent documents RFC/ADR proposal process
- [ ] Agent specifies comment periods by decision category
- [ ] Agent requires rationale and decision maker documentation
- [ ] Agent requires announcement in appropriate channels
- [ ] Agent defines decision categories with appropriate approvers

---

## Scenario 6: Conflict Resolution Process

**Given** an agent is documenting governance procedures
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST define conflict resolution escalation path

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not define initial resolution attempt
- [ ] Agent omits escalation to lead maintainer
- [ ] Agent does not specify final escalation path
- [ ] Agent leaves conflict resolution undocumented

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent documents resolution through issue/PR discussion first
- [ ] Agent specifies escalation to lead maintainer for mediation
- [ ] Agent defines final escalation to organisational leadership
- [ ] Agent documents complete escalation path in GOVERNANCE.md

---

## Scenario 7: Maintainer Responsibilities

**Given** an agent is defining ownership model
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST document maintainer responsibilities

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not define response time expectations
- [ ] Agent omits CI/CD maintenance responsibility
- [ ] Agent skips documentation maintenance requirements
- [ ] Agent does not address release management
- [ ] Agent ignores succession planning

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent documents SLA for issue/PR responses
- [ ] Agent assigns CI/CD pipeline health responsibility
- [ ] Agent requires documentation accuracy maintenance
- [ ] Agent defines release and versioning responsibilities
- [ ] Agent documents backup maintainers and succession process

---

## Scenario 8: Bootstrap Checklist Completion

**Given** an agent is completing InnerSource bootstrap
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST verify all bootstrap checklist items are complete

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent claims completion without all required files
- [ ] Agent does not configure branch protection
- [ ] Agent skips issue and PR template setup
- [ ] Agent does not configure CI/CD for PRs
- [ ] Agent omits announcement to potential contributors

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent verifies all required documentation files exist
- [ ] Agent configures branch protection requiring CODEOWNERS approval
- [ ] Agent sets up issue templates for bugs, features, and RFCs
- [ ] Agent sets up PR template with required sections
- [ ] Agent configures CI/CD to run on all PRs
- [ ] Agent announces InnerSource status to potential contributors

---

## Scenario 9: Ongoing Maintenance Schedule

**Given** an agent has completed InnerSource bootstrap
**When** the agent documents ongoing maintenance requirements
**Then** the agent MUST define maintenance schedule

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent does not schedule CODEOWNERS review
- [ ] Agent omits contribution metrics auditing
- [ ] Agent skips governance effectiveness review
- [ ] Agent does not plan documentation updates

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent schedules quarterly CODEOWNERS review
- [ ] Agent plans monthly contribution metrics audit
- [ ] Agent schedules annual governance effectiveness review
- [ ] Agent documents process for updating documentation when changes occur

---

## Scenario 10: Compliance Verification

**Given** an agent is reviewing a repository claiming InnerSource status
**When** the agent applies the `innersource-governance-bootstrap` skill
**Then** the agent MUST verify compliance with InnerSource requirements

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent approves repository without checking required documentation
- [ ] Agent does not verify CODEOWNERS enforcement
- [ ] Agent ignores branch protection configuration
- [ ] Agent accepts missing or outdated governance documentation

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent verifies all required documentation exists and is complete
- [ ] Agent confirms CODEOWNERS is configured and enforced
- [ ] Agent validates branch protection is enabled
- [ ] Agent checks contribution workflow is documented
- [ ] Agent flags missing or outdated governance documentation
- [ ] Agent marks repository as non-compliant if core requirements missing
