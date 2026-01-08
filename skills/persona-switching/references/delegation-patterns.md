# Delegation Patterns Reference

## Overview

When working across different roles, there are two primary mechanisms for
invoking specialist perspectives:

1. **Persona Switch** - Change your current identity
2. **Sub-agent Delegation** - Spawn a specialist agent for focused work

## Decision Matrix

| Situation                                        | Duration | Recommended          | Rationale                        |
| ------------------------------------------------ | -------- | -------------------- | -------------------------------- |
| Quick code review                                | < 10 min | Persona switch       | Low overhead, stays in flow      |
| Security audit of single file                    | < 15 min | Persona switch       | Brief focused review             |
| Substantial feature implementation               | > 30 min | Sub-agent delegation | Parallel work, clear scope       |
| Multi-domain work (frontend + backend)           | Variable | Multiple sub-agents  | Concurrent execution             |
| Expert consultation ("Is this approach secure?") | < 5 min  | Persona switch       | Quick input, owner keeps context |
| Full verification phase                          | > 1 hour | Sub-agent delegation | Dedicated focus                  |

## Rule of Thumb

**Switch** when you'll make **> 3 commits** in the specialist role.
**Delegate** for **single focused tasks** that can run independently.

## Persona Switch Examples

### Example 1: Quick Security Review

Owner (Backend Engineer) needs security feedback on an API endpoint:

```bash
# Owner pauses implementation work
use_persona security-reviewer

# Review the endpoint (makes 0-2 review commits/comments)
# ... review work ...

# Return to implementation
use_persona backend-engineer
```

### Example 2: Tech Lead Approval

Implementation complete, need Tech Lead sign-off:

```bash
# Developer switches to elevated role
use_persona tech-lead

# Review and approve PR
gh pr review --approve

# Return to developer role
use_persona backend-engineer
```

### Example 3: QA Perspective Check

Before marking implementation complete:

```bash
use_persona qa-engineer

# Run tests, check edge cases
# Document any issues found

use_persona backend-engineer  # Return to fix issues
```

## Sub-agent Delegation Examples

### Example 1: Parallel Frontend/Backend Work

```text
Owner (Senior Engineer) has two independent tasks:
- Backend API changes
- Frontend UI updates

Action:
1. Delegate backend work to Backend Engineer sub-agent
2. Delegate frontend work to Frontend Engineer sub-agent
3. Both run in parallel
4. Owner reviews and integrates results
```

### Example 2: Comprehensive Security Audit

```text
Owner (Tech Lead) needs full security review:

Action:
1. Delegate to Security Reviewer sub-agent with scope:
   - "Review all authentication code"
   - "Check for OWASP Top 10 vulnerabilities"
   - "Document findings in issue comment"
2. Sub-agent works independently
3. Owner reviews findings when complete
```

### Example 3: Test Suite Development

```text
Owner (Backend Engineer) needs comprehensive tests:

Action:
1. Delegate to QA Engineer sub-agent:
   - "Write integration tests for new endpoints"
   - "Cover edge cases in error handling"
   - "Ensure 80% coverage target met"
2. Sub-agent creates test files
3. Owner reviews and integrates
```

## "Dev Complete" Gate Pattern

Before transitioning from Implementation to Verification:

```text
1. Owner (Domain Expert) completes implementation
2. Owner invokes specialist personas for review:
   - use_persona security-reviewer → security check
   - use_persona qa-engineer → test coverage check
   - use_persona tech-lead → architecture check
3. Each specialist validates their domain
4. Only after all sign-offs does work move to formal Verification
```

This front-loads validation so final Review/Approval is lightweight.

## Context Preservation

### Persona Switch (Context Preserved)

- Owner retains full conversation context
- Switch is just identity change, not context change
- Good for: opinions, quick reviews, approvals

### Sub-agent Delegation (Fresh Context)

- Sub-agent starts with provided task description only
- Must include all necessary context in delegation prompt
- Good for: independent work, parallel execution

## Delegation Prompt Template

When delegating to a sub-agent, include:

```markdown
## Task

[Clear description of what needs to be done]

## Context

[Relevant background the sub-agent needs]

## Persona

Working as [Persona Name] ([profile] profile)

## Scope

- [Specific files/areas to focus on]
- [What's in scope]
- [What's out of scope]

## Expected Output

- [What deliverables are expected]
- [Where to document findings]
```

## Anti-Patterns

### Don't: Switch for Single Question

```bash
# BAD: Overhead not worth it for quick question
use_persona security-reviewer
# "Is this SQL parameterized correctly?"
use_persona backend-engineer
```

Instead: Ask the question without switching, or phrase as "From a security perspective..."

### Don't: Delegate Trivial Work

```bash
# BAD: Delegation overhead exceeds task
# Delegating: "Add a console.log for debugging"
```

Instead: Just do it yourself.

### Don't: Stay in Wrong Persona

```bash
# BAD: Implementation work as Tech Lead
use_persona tech-lead
# ... writes 50 lines of implementation code ...
```

Instead: Switch to contributor profile for implementation work.

## Tracking Decisions

The shell config tracks persona switches via `persona_history`:

```bash
$ persona_history
[2024-01-15 10:30:45] SWITCH: backend-engineer
[2024-01-15 11:15:22] SWITCH: security-reviewer
[2024-01-15 11:28:03] SWITCH: backend-engineer
```

For sub-agent delegations, document in issue comments for audit trail.
