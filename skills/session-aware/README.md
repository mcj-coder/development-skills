# Session-Aware Skill

## What It Does

The session-aware skill adds **session type recognition** and **transition enforcement** to all development work. It ensures that work flows through appropriate phases with clear boundaries and handoffs.

## Session Types

| Type | When to Use | Output |
|------|-------------|--------|
| **vision** | Starting a new project | Vision docs, tech stack |
| **guardrails** | Setting up tooling/standards | Repo configuration |
| **plan** | Breaking down work | Tasks, acceptance criteria |
| **brainstorm** | Exploring options | Ideas, alternatives |
| **whiteboard** | Quick exploration | Insights, parked branches |
| **implement** | Writing code | Working features |

## How It Works

1. **Detects intent** from your message keywords
2. **Validates transitions** - prevents jumping from vision → implementation
3. **Tracks state** in `.session-state/session.json`
4. **Announces changes** - explicit mode switches
5. **Enforces boundaries** - scope guardrails, drift detection

## Example Interactions

### Valid transition
```
You: "plan the inventory system"

→ ENTERING PLAN mode

Context: Breaking down inventory system
Tracking file: docs/plans/inventory-plan.md
```

### Invalid transition - caught
```
You: "let's implement this"

⚠️ INVALID TRANSITION

You're in: vision
Requested: implement

Valid next steps from vision:
- guardrails (setup tooling/standards)
- whiteboard (explore ideas)
- brainstorm (discuss options)
```

### Session drift detected
```
[During implementation]
You: "I'm not sure about this architecture"

⚠️ SESSION DRIFT DETECTED

You're questioning: architecture decision
Current session: implement
This should have been resolved in: plan

Recommendation: Whiteboard the concern
```

## State File

**Location:** `.session-state/session.json` (gitignored, local to each worktree)

**Format:**
```json
{
  "current_session": {
    "type": "plan",
    "feature": "inventory-system",
    "started_at": "2025-01-28T10:30:00Z",
    "tracking_file": "docs/plans/inventory.md"
  },
  "history": [...],
  "branch": "feature/inventory",
  "worktree": "C:/Projects/cozy-fantasy-rpg/"
}
```

## Concurrency

Each worktree has its own session state:
- No merge conflicts
- Independent tracking
- Session state never committed to git

## Valid Transitions

```
vision → guardrails, whiteboard, brainstorm
guardrails → plan, whiteboard, brainstorm, vision
plan → implement, whiteboard, brainstorm, vision, guardrails
brainstorm → anywhere (universal)
whiteboard → anywhere (universal escape hatch)
implement → whiteboard, brainstorm, plan (blockers only)
```

## Trigger Words

| Session | Keywords |
|--------|----------|
| vision | "build me", "I want a new", "start a project" |
| guardrails | "setup", "tooling", "standards" |
| plan | "plan this", "break down", "estimate" |
| brainstorm | "brainstorm", "discuss", "pros and cons" |
| whiteboard | "whiteboard", "explore", "not sure" |
| implement | "implement", "code this", "write the code" |

## Key Benefits

- **Context rot mitigation** - Clear session boundaries prevent meandering
- **Transition validation** - Can't skip important phases
- **Drift detection** - Warns when questioning settled decisions
- **Scope guardrails** - Pushes back on plan deviations
- **Concurrent agents** - Each worktree has independent state
- **No merge conflicts** - Session state is transient
