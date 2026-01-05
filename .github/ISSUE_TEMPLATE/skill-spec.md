---
name: Skill Specification
about: Define a new skill following writing-skills methodology with RED-GREEN-REFACTOR
title: "Skill: [skill-name]"
labels: ["skill", "new-feature"]
assignees: ""
---

## Skill: {skill-name}

## Summary

{One sentence: what agents should do when this skill triggers}

## Skill Priority

- Priority: P{0-4} ({Safety & Integrity | Quality & Correctness | Consistency & Governance |
  Delivery & Flow | Optimisation & Convenience})
- Rationale: {Why this priority level}
- Conflicts with: {Other skills or "None expected"}

## Frontmatter Specification

```yaml
---
name: { skill-name } # letters, numbers, hyphens only
description: Use when {triggering conditions ONLY - NO workflow summary, third person, <500 chars}
---
```

## Trigger Conditions

- {Concrete symptom/situation}
- {Concrete user request pattern}
- {Repo state that signals applicability}

## Opt-Out Rule

{When/how users can decline this skill, or "No opt-out - required for compliance"}

## Required Superpowers References

**REQUIRED SUB-SKILL:** superpowers:{skill-name}
**REQUIRED SUB-SKILL:** superpowers:{skill-name}

Cross-references:

- {other-skill-in-this-repo} for {specific case}

## Progressive Loading Strategy

Main SKILL.md (target <300 words):

- {Core pattern/workflow}
- {Quick reference table}
- {Common mistakes}

references/ folder (on-demand):

- {Heavy API docs or comprehensive examples}
- {Supporting tools/scripts}

## Brainstorming Integration

When brainstorming {context}:

1. Present options: {option A, option B, option C}
2. Ask about: {key decision factor}
3. If user chooses {X}, apply this skill with {config}
4. Surface trade-offs: {trade-off table}

## RED Phase - Baseline Testing (BEFORE Writing Skill)

### Pressure Scenario 1: {Name}

```gherkin
Given agent WITHOUT {skill-name}
And pressure: {time/sunk cost/exhaustion/authority}
When user says: "{exact concrete input}"
Then record:
  - What does agent do naturally?
  - What rationalizations does it use?
  - What gets skipped or done incorrectly?
```

### Pressure Scenario 2: {Name}

```gherkin
Given agent WITHOUT {skill-name}
And pressure: {different combination of pressures}
When user says: "{exact concrete input}"
Then record:
  - What does agent do naturally?
  - What rationalizations does it use?
  - What gets skipped or done incorrectly?
```

### Pressure Scenario 3: {Name}

```gherkin
Given agent WITHOUT {skill-name}
And pressure: {combined pressures - time + sunk cost + exhaustion}
When user says: "{exact concrete input}"
Then record:
  - What does agent do naturally?
  - What rationalizations does it use?
  - What gets skipped or done incorrectly?
```

### Expected Baseline Failures

- {Specific behaviour that should fail without skill}
- {Rationalization pattern to identify}
- {Common mistake from baseline testing}

## GREEN Phase - Concrete BDD Scenarios (WITH Skill)

### Scenario 1: {Primary use case}

```gherkin
Given agent WITH {skill-name}
When user says: "{exact concrete input}"
Then agent responds with:
  "{Exact expected announcement}"
And agent performs:
  - {Specific action 1 with evidence requirement}
  - {Specific action 2 with evidence requirement}
And creates/updates:
  - {File path} containing {specific content}
Evidence checklist:
  - [ ] {Verifiable artifact 1}
  - [ ] {Verifiable artifact 2}
```

### Scenario 2: {Opt-out case or edge case}

```gherkin
Given agent WITH {skill-name}
When user says: "{exact concrete input for opt-out case}"
Then agent responds with:
  "{Expected opt-out offering}"
And agent does NOT apply skill unless user opts in
Evidence checklist:
  - [ ] {Verification that skill was not force-applied}
```

### Scenario 3: {Greenfield vs Brownfield}

```gherkin
Given {existing codebase with legacy structure | new empty project}
When user says: "{exact concrete input}"
Then agent responds with:
  "{Expected announcement}"
And agent adapts approach for {greenfield | brownfield} context
Evidence checklist:
  - [ ] {Context-appropriate behaviour}
```

## REFACTOR Phase - Rationalization Closing

After initial GREEN tests, identify new rationalizations and add:

### Rationalizations Table

| Excuse                                    | Reality                                |
| ----------------------------------------- | -------------------------------------- |
| "{Specific rationalization from testing}" | {Counter-argument with why it's wrong} |
| "{Another excuse agents use}"             | {Reality check}                        |

### Red Flags - STOP

- "{Pattern that signals violation}"
- "{Another red flag from testing}"
- "{Common rationalization to watch for}"

All of these mean: {corrective action}

## Required Agent Steps

1. {Step with clear success criteria}
2. {Step with clear success criteria}
3. {Step with clear success criteria}
4. Provide evidence checklist for completion

## Assertable Success Checks

- [ ] Response includes {specific element} (minimum {N})
- [ ] Response demonstrates {specific behaviour}
- [ ] Files created: {specific list}
- [ ] Evidence provided: {type and format}
- [ ] {Specific verification that can be checked}

## Conventions Tracking Requirements

When this skill is applied, update README.md under "Applied Conventions":

```markdown
### Applied Conventions

{skill-name}:

- {Convention key}: {value chosen}
- {Another convention}: {value}
- Applied on: {date}
- User opted out: {none | reason + date}
```

Before prompting user about {specific decision}, check README.md for existing opt-out to prevent repeated prompting.

## Token Efficiency Target

- Main SKILL.md: <{200-500} words (choose based on load frequency)
- Total with references: <{500-1000} words
- Load frequency: {Always loaded | Triggered only | On-demand}

## Greenfield & Brownfield Applicability

**Greenfield:**

- {How skill applies to new projects}
- {What gets established from scratch}
- {Baseline structure created}

**Brownfield:**

- {How skill applies to existing codebases}
- {What gets verified/retrofitted}
- {Safe incremental adoption path}
- {Backward compatibility considerations}

## Test Design Guidance

- {Specific testing approach}
- {Concurrency/isolation requirements}
- {What to avoid in tests}
- {Data setup/teardown strategy}

## Review Roles

- {Role 1 - who should review from this perspective} (see [Team Roles](../../docs/roles/README.md))
- {Role 2 - who should review from this perspective}
- {Role 3 - who should review from this perspective}

## Deliverable

Create an agentskills.io-compatible skill spec for `{skill-name}` following the **writing-skills RED-GREEN-REFACTOR methodology**:

1. **RED phase**: Run all baseline scenarios WITHOUT skill present, document failures and rationalizations verbatim
2. **GREEN phase**: Write minimal skill addressing those specific failures, verify concrete scenarios pass with skill present
3. **REFACTOR phase**: Close loopholes systematically, add rationalizations table, re-verify under pressure

The resulting SKILL.md must include:

- Proper YAML frontmatter (name, description per CSO rules)
- Progressive loading strategy (main content + references/ for heavy detail)
- DRY superpowers cross-references (no duplication)
- Brainstorming integration hooks
- Conventions tracking mechanism
- Rationalizations table and red flags list
- Concrete examples with evidence requirements
