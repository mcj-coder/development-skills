---
name: session-aware
description: Manages session types, state tracking, and transition enforcement for all development work. Wraps other skills with session awareness.
---

# Session-Aware Workflow

## Overview

The session-aware skill adds session type recognition, state management, and transition enforcement to all interactions. It ensures work flows through appropriate phases (Vision → Guardrails → Plan → Implement) with clear boundaries and handoffs.

**Core principle:** Every interaction happens in a session context. Transitions between sessions are explicit and validated.

## Session Types

| Type | Purpose | Duration | Output | Checkpoint |
|------|---------|----------|--------|------------|
| **vision** | Project kickoff | 1 session | Vision docs, tech stack, backlog | "Scope locked, ready for guardrails" |
| **guardrails** | Tooling/standards | 1 session | Repo setup, ways of working | "Ready for feature planning" |
| **plan** | Breakdown/estimation | Variable | Tasks, acceptance criteria | Per feature approved |
| **brainstorm** | Open discussion | Variable | Ideas, options explored | Ready to plan |
| **whiteboard** | Exploration | As needed | Insights, parked branches | Refined into formal doc |
| **implement** | Coding/execution | Variable | Working code | Ready for test/review |

## Valid Transitions

```
vision → guardrails, whiteboard, brainstorm
guardrails → plan, whiteboard, brainstorm, vision
plan → implement, whiteboard, brainstorm, vision, guardrails
brainstorm → vision, guardrails, plan, implement, whiteboard (universal)
whiteboard → vision, guardrails, plan, implement, brainstorm (universal)
implement → whiteboard, brainstorm, plan (blockers only)
None → vision, guardrails, plan, brainstorm, whiteboard
```

**Key rules:**
- `brainstorm` and `whiteboard` are universal - can go anywhere
- `implement` can only go to whiteboard/brainstorm/plan (for blockers)
- Can loop back to earlier stages if needed

## Intent Detection Patterns

**When user sends a message, detect intent from keywords:**

```python
INTENT_PATTERNS = {
    "vision": [
        "build me a", "i want a new", "start a project", "create a new",
        "from scratch", "new project", "starting fresh",
        "what should i build", "help me design", "project vision",
        "product vision", "app idea", "game concept",
        "what tech stack", "which framework", "choose between",
    ],
    "guardrails": [
        "setup repo", "configure", "tooling", "standards",
        "project setup", "initial setup", "way of working",
        "coding standards", "git workflow", "ci/cd", "linting",
        "testing approach", "code review process",
    ],
    "plan": [
        "plan this", "plan the", "create a plan for", "planning session",
        "break down", "break this into", "estimate", "task breakdown",
        "implementation plan", "how to implement", "steps to",
        "design the", "feature breakdown", "user stories for",
    ],
    "brainstorm": [
        "brainstorm", "brainstorming", "ideation", "design thinking",
        "let's discuss", "what are the options", "pros and cons",
        "compare", "alternatives for", "different approaches to",
        "explore ideas", "conceptual", "theoretical",
    ],
    "whiteboard": [
        "whiteboard", "wb:", "whiteboard this", "spawn a whiteboard",
        "explore", "not sure", "what do you think", "rough this out",
        "sketch this out", "let me think about", "i need to think through",
        "park this", "side note", "another thought", "while we're at it",
    ],
    "implement": [
        "implement", "code this", "write the code", "build this",
        "start coding", "get to work", "execute this",
        "write the function", "create the class", "add this feature",
        "fix this bug", "implement the", "code the",
    ],
}

# Priority order for ambiguous matches
PRIORITY_ORDER = ["vision", "guardrails", "plan", "brainstorm", "whiteboard", "implement"]
```

## Agent Behavior

**When processing user input:**

1. **Load session state** - Read `.session-state/session.json`
2. **Detect intent** - Match keywords against patterns
3. **Validate transition** - Check if transition is valid from current state
4. **Handle result** - Continue session, handoff, or reject

### Loading Session State

```python
def load_session_state():
    try:
        with open(".session-state/session.json", "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return {"current_session": None, "history": []}
```

### Detecting Intent

```python
def detect_intent(user_message, session_state):
    msg_lower = user_message.lower()

    for intent in PRIORITY_ORDER:
        patterns = INTENT_PATTERNS.get(intent, [])
        if any(p in msg_lower for p in patterns):
            # Disambiguate with context if needed
            if intent == "discuss" and session_state.get("type") == "plan":
                return "plan"
            return intent

    return None
```

### Validating Transitions

```python
VALID_TRANSITIONS = {
    "vision": ["guardrails", "whiteboard", "brainstorm"],
    "guardrails": ["plan", "whiteboard", "brainstorm", "vision"],
    "plan": ["implement", "whiteboard", "brainstorm", "vision", "guardrails"],
    "brainstorm": ["vision", "guardrails", "plan", "implement", "whiteboard"],
    "whiteboard": ["vision", "guardrails", "plan", "implement", "brainstorm"],
    "implement": ["whiteboard", "brainstorm", "plan"],
    None: ["vision", "guardrails", "plan", "brainstorm", "whiteboard"],
}

def validate_transition(intent, current_type):
    if current_type is None:
        return True
    return intent in VALID_TRANSITIONS.get(current_type, [])
```

### Session State Schema

```json
{
  "current_session": {
    "type": "plan",
    "feature": "inventory-system",
    "started_at": "2025-01-28T10:30:00Z",
    "tracking_file": "docs/plans/inventory-implementation.md"
  },
  "history": [
    {
      "type": "vision",
      "started_at": "2025-01-27T09:00:00Z",
      "ended_at": "2025-01-27T11:30:00Z",
      "output": "docs/design/vision.md",
      "handed_off_to": "guardrails"
    }
  ],
  "branch": "feature/inventory",
  "worktree": "C:/Projects/cozy-fantasy-rpg/"
}
```

## Announcement Patterns

### Entering a Session

```
"→ ENTERING {SESSION_TYPE} mode

Context: {brief context}
Tracking file: {path}
Type 'done', 'pause', or 'switch to {OTHER}' when ready"
```

### Invalid Transition

```
"⚠️ INVALID TRANSITION

You're in: {CURRENT_SESSION}
Requested: {REQUESTED_SESSION}

Valid next steps from {CURRENT}:
- {OPTION_1}
- {OPTION_2}
- {OPTION_3}

Options:
1. Continue {CURRENT}
2. Handoff to {VALID_OPTION}
3. Whiteboard to explore first"
```

### Session Drift Detected

```
"⚠️ SESSION DRIFT DETECTED

You're questioning: {TOPIC}
Current session: {CURRENT}
This should have been resolved in: {EARLIER_SESSION}

Session history shows:
- Vision (completed)
- Guardrails (completed)
- Plan (completed) → architecture decided
- Implementation (current)

Recommendation: Whiteboard the concern, then either:
- Return to Implementation (affirm decision)
- Reopen Planning (revisit decision)"
```

### Handoff Between Sessions

```
"→ HANDOFF: {CURRENT} → {NEW_SESSION}

Completing: {CURRENT}
- Output: {tracking_file}
- Duration: {duration}

Entering: {NEW_SESSION}
- Context: {why this transition}
- Next steps: {what to expect}"
```

## Special Behaviors

### During Implementation

If user questions settled decisions:
```
"⚠️ DECISION RECONSIDERATION

You're questioning: {DECISION}
This was settled in: {EARLIER_SESSION}

Options:
1. Accept previous decision (continue)
2. Whiteboard to explore concern
3. Reopen {EARLIER_SESSION} to revisit"
```

### During Planning

If scope expansion detected:
```
"⚠️ SCOPE CHANGE DETECTED

This request would alter the scope of the approved plan:
- Current plan: {plan_file}
- Agreed scope: {scope_summary}
- Requested change: {what user wants}
- Impact: {how this changes things}

Recommendation: Whiteboard this change before proceeding"
```

### When Switching Modes

Always announce:
```
"Switching from {CURRENT} to {NEW} mode...
Reason: {why the switch}
State saved: {tracking_file}"
```

## Concurrency Model

**Each worktree has independent session state:**

| Worktree | Branch | Session State |
|----------|--------|---------------|
| Main | `main` | `.session-state/session.json` (local) |
| Worktree 1 | `feature/inventory` | `.session-state/session.json` (local) |
| Worktree 2 | `whiteboard/combat` | `.session-state/session.json` (local) |

**Rules:**
- Each worktree has its own `.session-state/session.json`
- Session state is never committed to git
- No merge conflicts - state is transient
- Handoffs only occur within a worktree

## Error Handling

### Corrupted or Missing Session State

```python
def load_session_state():
    try:
        with open(".session-state/session.json", "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"current_session": None, "history": []}
```

### Unable to Determine Intent

```
"I'm not sure what type of session you want.

Are you trying to:
1. Start a new project (vision)
2. Plan some work (plan)
3. Explore ideas (whiteboard/brainstorm)
4. Write code (implement)

Please clarify and I'll proceed."
```

## Session Lifecycle

```
1. START SESSION
   - Create .session-state/session.json
   - Set type, started_at, tracking_file

2. WORK IN SESSION
   - Update session.json as needed
   - Track progress

3. COMPLETE SESSION
   - Move current_session to history
   - Set ended_at, output, handed_off_to
   - Delete session.json or leave for next session
```

## Integration with Other Skills

**Session-aware wraps existing skills:**

```
User: "plan the inventory system"
    ↓
[Session-aware detects: intent=plan]
    ↓
[Session-aware creates session state, announces entry]
    ↓
[Delegates to 'plan' skill]
    ↓
[Plan skill executes with session context]
    ↓
[Session-aware maintains state throughout]
```

**Skills remain unchanged** - session-aware is a wrapper that:
- Pre-processes: Detects intent, validates state
- Post-processes: Updates state, announces transitions
- Delegates: Invokes the appropriate skill

## Checklist for Agents

**When processing user input:**

- [ ] Load `.session-state/session.json`
- [ ] Detect intent from keywords
- [ ] Validate transition against VALID_TRANSITIONS
- [ ] Announce mode changes explicitly
- [ ] Update session state after transitions
- [ ] Detect and warn on scope changes during planning
- [ ] Detect and warn on decision reconsideration during implementation
- [ ] Clean up session state when complete

## Related Skills

- `whiteboard` - Lightweight exploration spaces
- `brainstorming` - Structured exploration with interview workflow
- `plan` - Formal planning sessions
- `note` - Quick memory capture
