---
name: process-skill-router
description: Route agents to the correct process skill based on context and preconditions. Use when uncertain which process skill applies or when starting new work.
---

# Process Skill Router

## Overview

Guide agents to the correct process skill based on current context and preconditions. This
skill addresses the skill selection loophole where agents may load `brainstorming` when
`requirements-gathering` should apply.

**Core principle**: Evaluate context, recommend appropriate skill, provide rationale.

## When to Use This Skill

Use process-skill-router when:

- **Starting new work** - Uncertain which process skill applies
- **Context is ambiguous** - Multiple skills might be relevant
- **Workflow decision needed** - Need guidance on next process step
- **Skills-first check** - Validating correct skill selection

Do NOT use process-skill-router when:

- **User explicitly requests a skill** - Defer to their choice
- **Already in a skill workflow** - Continue with current skill
- **Simple task** - No process skill needed

## Routing Rules

Evaluate rules in priority order. First matching precondition determines the recommended skill.

| Priority | Precondition                           | Recommended Skill              |
| -------- | -------------------------------------- | ------------------------------ |
| P1       | PR review feedback received            | receiving-code-review          |
| P2       | Bug/unexpected behavior                | systematic-debugging           |
| P3       | No ticket exists for new work          | requirements-gathering         |
| P4       | Ticket exists, requirements unclear    | brainstorming                  |
| P5       | Ticket exists, ready to plan           | writing-plans                  |
| P6       | Implementation plan exists, code ready | test-driven-development        |
| P7       | Work complete, claiming done           | verification-before-completion |

## Conflict Resolution

- Rules are evaluated in priority order (P1 highest)
- First matching precondition determines the skill
- When uncertain, prefer earlier (higher priority) rules
- Fallback: If no rule matches, prompt user for clarification

## Core Workflow

### 1. Evaluate Current Context

Assess the current state:

- Does PR feedback exist that needs addressing?
- Is there a bug or unexpected behavior to investigate?
- Does a ticket exist for this work?
- Are requirements clear and complete?
- Does an implementation plan exist?
- Is the work ready for coding?
- Is the work complete and ready for verification?

### 2. Apply Priority Rules

Check each rule in P1-P7 order:

```text
P1: PR feedback received? → receiving-code-review
P2: Bug/unexpected behavior? → systematic-debugging
P3: No ticket exists? → requirements-gathering
P4: Requirements unclear? → brainstorming
P5: Ready to plan? → writing-plans
P6: Plan exists, code ready? → test-driven-development
P7: Claiming done? → verification-before-completion
```

### 3. Provide Recommendation

Output the recommended skill with rationale:

```text
Recommended skill: [skill-name]
Rationale: [why this skill applies based on context]
```

### 4. Handle Edge Cases

**Multiple conditions match:**

- Use priority order (P1 wins over P2, etc.)
- Example: Bug reported + no ticket = P2 wins (systematic-debugging)

**User explicitly requests skill:**

- Defer to user's choice
- Provide recommendation but do not override

**No conditions match:**

- Prompt user for clarification
- Do not make arbitrary recommendations

## Skill Comparison

| Context                      | Recommended Skill              | Rationale                          |
| ---------------------------- | ------------------------------ | ---------------------------------- |
| PR has reviewer comments     | receiving-code-review          | Address feedback before continuing |
| Test failure, unexpected log | systematic-debugging           | Investigate root cause first       |
| User describes new feature   | requirements-gathering         | Create ticket before designing     |
| Ticket exists, reqs fuzzy    | brainstorming                  | Clarify before planning            |
| Ticket ready, no plan yet    | writing-plans                  | Create implementation plan         |
| Plan approved, code needed   | test-driven-development        | Write tests, then implement        |
| Implementation done          | verification-before-completion | Verify before claiming complete    |

## Extensibility Pattern

New routing rules can be added by:

1. Adding a row to the routing rules table with appropriate priority
2. Adding corresponding BDD test scenarios in `process-skill-router.test.md`
3. Updating the Mermaid decision tree in `docs/playbooks/skill-selection.md`

Example - Adding a P8 rule:

```markdown
| P8 | Documentation update needed | documentation-skill |
```

## Output Format

When providing a recommendation:

```text
## Skill Recommendation

**Recommended:** [skill-name]
**Rationale:** [explanation of why this skill applies]
**Context:** [summary of evaluated conditions]

To use this skill, invoke: [skill-name]
```

## Common Mistakes

### Mistake 1: Skipping Priority Order

**Anti-pattern:**

```text
Context: Bug exists + no ticket
Agent: "No ticket exists, use requirements-gathering"
```

**Why wrong:** Bug (P2) takes priority over no ticket (P3).

**Correct approach:** Recommend systematic-debugging (P2).

### Mistake 2: Overriding User's Explicit Choice

**Anti-pattern:**

```text
User: "Use brainstorming skill"
Agent: "Actually, no ticket exists, must use requirements-gathering"
```

**Why wrong:** User's explicit skill request should be respected.

**Correct approach:** Defer to user's choice, provide recommendation as advisory.

### Mistake 3: Guessing When Context Is Unclear

**Anti-pattern:**

```text
Context: Ambiguous, no clear precondition match
Agent: "I'll recommend writing-plans since that seems reasonable"
```

**Why wrong:** Arbitrary recommendations can lead to wrong workflow.

**Correct approach:** Prompt user for clarification.

## Success Indicators

Router is working correctly when:

- [ ] Recommendations match priority order (P1-P7)
- [ ] User explicit requests are respected
- [ ] Ambiguous contexts prompt for clarification
- [ ] Rationale is provided with each recommendation
- [ ] All process skills are reachable via routing rules

## See Also

- `docs/playbooks/skill-selection.md` - Visual decision tree
- `skills/requirements-gathering/SKILL.md` - Creating tickets
- `skills/issue-driven-delivery/SKILL.md` - Work item lifecycle
