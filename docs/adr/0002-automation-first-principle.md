---
name: automation-first-principle
description: |
  Apply when designing skills that involve repetitive processes,
  when identifying opportunities to reduce manual agent work,
  or when deciding whether to create automation scripts for a workflow.
decision: Automate repetitive processes via reference scripts; skills drive script creation.
status: accepted
---

# 2. Automation-First Principle

Date: 2026-01-07
Deciders: development-skills maintainers
Tags: process, automation, skills

## Context and Problem Statement

Skills in this repository often involve repetitive processes such as:

- Removing blocked flags when blocking issues are closed
- Calculating priority order based on dependencies
- Notifying dependent issues when state changes

Manual agent execution of these processes is expensive (consumes context), error-prone
(inconsistent execution), and wasteful (same work repeated across projects).

**Key question:** When should a process be automated via scripts versus executed manually
by agents?

## Decision Drivers

- **Reduce repetitive manual agent work** - Preserve agent context for discretionary tasks
- **Improve consistency and reliability** - Scripts execute the same way every time
- **Create reusable reference implementations** - Scripts become templates for target repos
- **Enable skill composability** - Automated scripts can be composed across skills
- **Support cross-platform execution** - Scripts work in CI/CD and local environments

## Considered Options

### Option 1: Manual Agent Execution for All Processes

Agents execute all processes manually, including repetitive mechanical tasks.

**Pros:**

- No script development or maintenance required
- Agents can handle edge cases with discretion

**Cons:**

- Expensive (consumes agent context repeatedly)
- Inconsistent execution
- Error-prone for mechanical tasks
- Duplicates effort across projects

### Option 2: Full Automation with No Manual Fallback

All processes are automated; agents never execute processes manually.

**Pros:**

- Maximum consistency
- Minimal agent context consumption

**Cons:**

- Over-engineering for rare or simple tasks
- Cannot handle cases requiring discretion
- High upfront development cost
- Brittle when edge cases arise

### Option 3: Hybrid - Automate Common Cases, Manual for Edge Cases

Common repetitive processes are automated via scripts. Manual execution is reserved for
complex cases requiring discretion or rare one-time operations.

**Pros:**

- Balances efficiency with flexibility
- Scripts handle the common case reliably
- Agents focus on tasks requiring discretion
- Practical to implement incrementally

**Cons:**

- Requires criteria to decide when to automate
- Some script development and maintenance overhead

## Decision Outcome

Chosen option: **"Hybrid - Automate Common Cases, Manual for Edge Cases"**, because it
provides the best balance between efficiency (automating repetitive work) and flexibility
(manual handling of edge cases requiring discretion).

### Automation Criteria

**When to automate a process:**

| Criterion       | Threshold                                   | Example                                |
| --------------- | ------------------------------------------- | -------------------------------------- |
| **Frequency**   | Process occurs 3+ times per week            | Unblocking issues after blockers close |
| **Complexity**  | Mechanical with clear rules (no discretion) | Priority calculation from labels       |
| **Error-prone** | Manual execution risks human error          | Multi-step flag updates                |
| **Teachable**   | Can be documented as algorithm              | Dependent issue notification           |

A process should be automated if it meets **2 or more** of these criteria.

**When NOT to automate:**

| Criterion                      | Threshold                                   | Example                        |
| ------------------------------ | ------------------------------------------- | ------------------------------ |
| **Requires discretion**        | >2 decision points needing human input      | Triaging ambiguous bug reports |
| **Rare occurrence**            | <10 times over project lifetime             | Initial repository setup       |
| **Low effort + low frequency** | <5 minutes AND <10 times total              | One-time configuration         |
| **Cost exceeds benefit**       | Automation time > manual time over lifetime | Complex edge case handling     |

### Agent Decision Algorithm

When an agent encounters a potentially repetitive process:

```text
1. CHECK: Does script exist in skills/<skill-name>/scripts/?
   - Also check target repo conventions: scripts/, tools/, automation/

2. IF script exists:
   → Invoke script with appropriate flags
   → Use dry-run by default, --apply for changes
   → Document invocation in issue comment

3. IF script does NOT exist AND process meets automation criteria:
   → Create issue for script creation (tag: automation-opportunity)
   → Execute manually this time
   → Document what the script should do

4. IF script does NOT exist AND process does NOT meet criteria:
   → Execute manually
   → Document in issue comment (for future reference)
```

### Reference Script Pattern

Scripts in this repository follow these conventions:

| Aspect         | Convention                                   |
| -------------- | -------------------------------------------- |
| **Location**   | `skills/<skill-name>/scripts/`               |
| **Naming**     | `<verb>-<noun>.sh` or `<verb>-<noun>.ps1`    |
| **Header**     | Comments with purpose, usage, prerequisites  |
| **Dry-run**    | Default behavior shows what would change     |
| **Apply flag** | `--apply` or `-a` to make actual changes     |
| **Idempotent** | Safe to run multiple times with same result  |
| **Exit codes** | 0 = success, non-zero = failure with message |

**Target repositories may adapt:**

- Location may be `scripts/` at repo root or other convention
- Scripts become templates that teams customize to local needs
- Naming conventions may differ per project standards

### Cross-Platform Guidance

| Requirement                                 | Guidance                                                                                                                                  |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **SHOULD provide both bash and PowerShell** | When script performs cross-platform operations (file manipulation, git commands) or target repos include Windows environments without WSL |
| **MAY provide bash-only**                   | When targeting CI/CD environments (GitHub Actions, Linux containers) or Windows users have WSL/Git Bash available                         |

**Current state:** Existing scripts in this repository are bash-only. PowerShell variants
are future work and will be added as needed.

### Skill-to-Script Integration

Skills and scripts work together in this workflow:

1. **Skills identify automation opportunities** during design phase
2. **Skills reference scripts** for repetitive operations in their documentation
3. **Scripts become reusable templates** that target repos can adopt
4. **Target repos may adapt scripts** to local conventions and needs
5. **ADR-0001 capture pattern applies** - document script adoption in target repo

## Consequences

### Good

- **Reduced manual work** for both agents and humans on repetitive tasks
- **Consistent execution** of mechanical processes across all projects
- **Reusable implementations** - scripts are templates for target repos
- **Preserved agent context** for tasks requiring discretion and creativity
- **Documented automation opportunities** - issues capture what should be automated

### Neutral

- **Initial script development effort** required for each automation
- **Learning curve** for script conventions and invocation patterns

### Bad

- **Maintenance overhead** - scripts require updates as platforms evolve
- **Platform fragmentation risk** if cross-platform guidance not followed

## Examples

### Blocked Flag Removal (Existing Script)

**Context:** When a blocking issue is closed, dependent issues should have their
`blocked` label removed automatically.

| Aspect  | Value                                                        |
| ------- | ------------------------------------------------------------ |
| Trigger | Blocking issue closed                                        |
| Script  | `skills/issue-driven-delivery/scripts/unblock-dependents.sh` |
| Dry-run | `./unblock-dependents.sh mcj-coder/repo 45`                  |
| Apply   | `./unblock-dependents.sh mcj-coder/repo 45 --apply`          |
| Output  | Lists issues that would be/were unblocked                    |

**Automation criteria met:** Frequency (happens per-issue), Mechanical (clear rules),
Error-prone (easy to forget dependents).

### Priority Calculation (Existing Script)

**Context:** Determining issue priority order based on labels and dependencies.

| Aspect     | Value                                                        |
| ---------- | ------------------------------------------------------------ |
| Trigger    | Need to prioritize backlog                                   |
| Script     | `skills/issue-driven-delivery/scripts/get-priority-order.sh` |
| Invocation | `./get-priority-order.sh mcj-coder/repo`                     |
| Output     | Ordered list of issues by priority                           |

**Automation criteria met:** Mechanical (algorithm-based), Teachable (clear rules),
Error-prone (complex dependency graph).

### Dependent Notification (Future Example)

**Context:** When an issue changes state, dependent issues should be notified via comment.

| Aspect  | Value                                                              |
| ------- | ------------------------------------------------------------------ |
| Trigger | Issue state changes (closed, blocked, etc.)                        |
| Script  | `skills/<skill-name>/scripts/notify-dependents.sh` (to be created) |
| Action  | Comment on dependent issues about state change                     |

**Automation criteria met:** Frequency (happens per-issue), Mechanical (templated comment),
Error-prone (easy to miss dependents).

## Anti-Patterns

These behaviors indicate the automation-first principle is not being followed:

1. **Agent manually performing scriptable operations repeatedly**
   - Indicates: Automation criteria not being applied, or script not discoverable
   - Fix: Check if script exists; if not, create issue for script creation

2. **Over-automation of decisions requiring discretion**
   - Indicates: "When NOT to automate" criteria being ignored
   - Fix: Keep discretionary decisions manual; automate only mechanical parts

3. **Platform-specific scripts without documentation**
   - Indicates: Documentation standard not being followed
   - Fix: Add header comments; consider cross-platform variant

4. **Non-idempotent scripts that fail on re-run**
   - Indicates: Script pattern conventions not followed
   - Fix: Make scripts check state before acting; use dry-run by default

## Links

- [ADR-0001: Skill Design Philosophy](0001-skill-design-philosophy.md) - Bootstrap pattern
  and capture guidance
- [Issue-driven-delivery scripts](../../skills/issue-driven-delivery/scripts/) - Reference
  implementations
- [Scripts README](../../skills/issue-driven-delivery/scripts/README.md) - Installation
  and customization guide
