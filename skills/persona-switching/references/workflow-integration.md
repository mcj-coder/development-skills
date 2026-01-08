# Workflow Integration Reference

## Overview

Persona-switching integrates with `issue-driven-delivery` to suggest appropriate
personas at each phase of the development workflow.

## Phase-Persona Mapping

| Workflow Phase  | State Label            | Suggested Persona | Profile     | Rationale                              |
| --------------- | ---------------------- | ----------------- | ----------- | -------------------------------------- |
| Refinement      | `state:refinement`     | Tech Lead         | maintainer  | Planning requires elevated perspective |
| Implementation  | `state:implementation` | Domain Expert\*   | contributor | Implementation work                    |
| Verification    | `state:verification`   | QA Engineer       | contributor | Quality validation                     |
| Review/Approval | `state:review`         | Tech Lead         | maintainer  | Final approval authority               |

\*Domain Expert varies by task type (Backend Engineer, Frontend Engineer, etc.)

## Trigger Points

### Issue State Transitions

The skill detects phase changes via label transitions:

```text
Issue #123 transitions from:
  state:refinement → state:implementation

Skill suggests:
  "Phase changed to Implementation. Switch to Backend Engineer persona?"
```

### File-Based Context

The skill recommends specialists based on files being modified:

| File Pattern                 | Suggested Persona        | Reason                  |
| ---------------------------- | ------------------------ | ----------------------- |
| `*.test.*`, `tests/**`       | QA Engineer              | Test development        |
| `**/security/**`, auth files | Security Reviewer        | Security-sensitive code |
| `docs/**`, `*.md`            | Documentation Specialist | Documentation work      |
| Architecture files           | Technical Architect      | Architectural decisions |
| `SKILL.md`, skills/\*\*      | Agent Skill Engineer     | Skill development       |

### Review Requests

When reviews are requested via issue comments or PR reviews:

```text
PR #456 requests review from: security

Skill suggests:
  "Security review requested. Switch to Security Reviewer persona?"
```

## Integration with issue-driven-delivery

### Step 3b: Refinement Start

```text
Trigger: Issue enters refinement state
Action: Suggest Tech Lead persona for planning work
Reason: Planning and scoping requires maintainer-level perspective
```

### Step 7a: Implementation Handoff

```text
Trigger: Issue transitions to implementation
Action: Suggest domain expert based on issue labels/content
Reason: Implementation should use contributor profile
```

### Step 8c: Verification Start

```text
Trigger: Issue transitions to verification
Action: Suggest QA Engineer persona
Reason: Quality assurance requires testing perspective
```

### Step 11: Role Reviews

```text
Trigger: Review request in workflow
Action: Suggest specialist persona for review type
Reason: Reviews should use appropriate specialist perspective
```

## Ownership by Task Type

Different task types have different natural owners:

| Task Type       | Primary Owner          | Supporting Personas    |
| --------------- | ---------------------- | ---------------------- |
| Skill authoring | Agent Skill Engineer   | QA, Security           |
| API development | Backend Engineer       | Security, QA           |
| UI development  | Frontend Engineer      | UX, QA                 |
| Infrastructure  | DevOps Engineer        | Security, Architecture |
| Bug fixes       | Domain Expert (varies) | QA                     |
| Security fixes  | Security Engineer      | QA, Architecture       |

## Label Integration

### Recommended Labels for Automation

```yaml
# Phase labels (one at a time)
state:refinement
state:implementation
state:verification
state:review

# Domain labels (for persona suggestions)
domain:backend
domain:frontend
domain:infrastructure
domain:security
domain:documentation

# Review type labels
needs:security-review
needs:architecture-review
needs:qa-review
```

### Label-to-Persona Mapping

```bash
# Example automation (pseudo-code)
if issue has label "domain:backend":
    suggest_persona("backend-engineer")
elif issue has label "domain:frontend":
    suggest_persona("frontend-engineer")
elif issue has label "domain:security":
    suggest_persona("security-reviewer")
```

## Pre-Commit Hook Compatibility

Persona-switching is designed to work with GPG signing verification hooks:

```text
Pre-commit hook checks:
1. commit.gpgsign = true ✓
2. Signature present ✓

Persona-switching ensures:
- GPG key matches configured email
- Signature will be valid
- Commit won't show "Unverified"
```

The existing `enable-signed-commits` playbook hooks remain unchanged.
Persona-switching adds email/key validation BEFORE commits are attempted.

## Automatic Suggestions vs Manual Control

### Default Behavior

Suggestions are **non-blocking** recommendations:

```text
[Skill suggestion]
Phase changed to Verification. Consider switching to QA Engineer persona.

Current persona: backend-engineer
Suggested: qa-engineer

Switch now? [y/N]
```

### User Override

Users can always decline suggestions:

```bash
# Decline suggestion and continue with current persona
use_persona --keep

# Or explicitly switch to different persona
use_persona security-reviewer
```

### Audit Trail

All suggestions and decisions are logged:

```bash
$ persona_history
[2024-01-15 10:30:00] SUGGESTION: qa-engineer (phase: verification)
[2024-01-15 10:30:05] DECLINED: staying as backend-engineer
[2024-01-15 10:45:00] SWITCH: qa-engineer
```

## Integration Checklist

For repositories using persona-switching with issue-driven-delivery:

- [ ] State labels configured (`state:refinement`, etc.)
- [ ] Domain labels configured (`domain:backend`, etc.)
- [ ] Personas mapped to profiles in shell config
- [ ] GPG keys configured for all profiles
- [ ] Pre-commit hooks allow signed commits
- [ ] Team understands phase-persona recommendations

## Graceful Degradation

If issue-driven-delivery is not present:

- Persona-switching still works for manual switches
- File-based suggestions still active
- Phase-based suggestions disabled
- No error, just reduced automation
