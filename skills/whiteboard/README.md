# Whiteboard Skill - User Guide

## What Is Whiteboard?

Whiteboard is a **lightweight planning space** for exploring ideas when you're unsure or need to think through something mid-session. Unlike formal planning that creates detailed implementation plans, whiteboards are:

- **Quick** - Set up in seconds, not minutes
- **Informal** - Bullets and rough thoughts, not structured requirements
- **Temporary** - Archive into proper docs when ready, or discard
- **Isolated** - Uses worktrees so they don't mess up your active work

## When to Use It

### Perfect For:

- "I'm not sure how to approach this..."
- "Let me think about this for a minute"
- "Wait, what if we tried..."
- Mid-session exploration when you realize you need to brainstorm
- Parking interesting ideas that aren't the current focus
- Roughing out 2-3 approaches before committing

### Not For:

- Well-defined implementation tasks → Just do them
- Formal planning with tasks → Use "plan this"
- Quick lookups → Just ask directly
- Decisions you've already made → Just implement

## How to Use

### Trigger the Skill

**Explicitly:**
```
whiteboard: I need to think through how to handle inventory stacking
wb: should crafting quality affect enchantment capacity?
let me whiteboard this approach
```

**Implicitly (auto-detects):**
```
"I'm not sure whether to use events or direct state updates..."
"What do you think about this idea I just had?"
"Let me explore a couple options here..."
```

**Mid-session:**
```
"Wait, I just realized I need to think about morale affects targeting"
[while working on a feature branch]
```

### What Happens

1. **Mode transition announced**
   ```
   Switching to WHITEBOARD mode for exploration...
   Creating temporary planning space at docs/whiteboards/2025-01-28-topic.md
   ```

2. **Whiteboard created** from template with sections:
   - Session Intent (what we're exploring)
   - Pinned Insights (key findings)
   - Branches (alternative ideas)
   - Active Thread (current exploration)
   - Next Steps (when ready to proceed)

3. **You drive** the exploration
   - Claude facilitates, doesn't direct
   - Rough bullets, not formal structure
   - Multiple approaches considered
   - Can park branches for later

4. **Resolution** when you say "done":
   - Archive into formal doc (ADR, design, plan)
   - Park for later (status: parked)
   - Discard if obsolete
   - Resume interrupted work (if mid-session)

## Whiteboard Sections

### Session Intent
What we're exploring and what outcome we want.

### Pinned Insights
Key findings that emerge. Claude adds these as we go.
- "Oh, that's important - let me pin that insight..."

### Branches
Alternative ideas that aren't the main focus right now.
- "That's interesting but let's not go down that rabbit hole yet - parking it as a branch"

### Active Thread
Current exploration. Claude structures this as options with pros/cons.

### Next Steps
What to do when done. Only populated when you reach a decision.

### Refined Into
Link to formal doc when this whiteboard is archived.

## Worktree Protocol

When you whiteboard **mid-session** (interrupting active work):

1. Claude snapshots your current state
   - Active feature branch
   - What you were working on
   - Why you switched to whiteboard

2. Whiteboard created in isolated worktree
   - Keeps whiteboard docs separate from feature branch
   - Prevents merge conflicts
   - Clean git history

3. When done, Context Snapshot restores your state
   - Return to feature branch
   - Resume where you left off

## Integration with Your Docs

The skill **auto-detects** existing doc structure:

```
docs/
├── adr/              # Architecture Decision Records
├── design/           # Design docs (game mechanics, systems)
├── plans/            # Implementation plans
├── phase-plans/      # Phase-based planning
└── whiteboards/      # Whiteboards (created here)
```

When you say "done", Claude offers refinement options based on what exists:

| Whiteboard Content | Refine Into |
| ------------------ | ----------- |
| Technical decision | ADR (e.g., `docs/adr/0042-inventory-events.md`) |
| Game mechanic      | Design doc (e.g., `docs/design/gdd-inventory.md`) |
| Implementation     | Plan (e.g., `docs/plans/inventory-overhaul.md`) |
| Not ready          | Park as whiteboard (status: parked) |
| Obsolete           | Discard (delete file) |

## Session Tracking

All whiteboards are tracked in `docs/whiteboards/_open-sessions.md`:

```markdown
| Date | Topic | File | Status | Created During |
| ---- | ----- | ---- | ------ | -------------- |
| 2025-01-28 | Combat morale | 2025-01-28-combat-morale.md | active | feature/combat-system |
| 2025-01-27 | NPC needs | 2025-01-27-npc-needs.md | parked | main |
```

**Status values:**
- `active` - Currently being explored
- `parked` - Saved for later, not abandoned
- `archived` - Refined into formal doc (link included)

## Example Session

```
You: "I'm implementing the inventory system but just realized
     I need to think through how to handle item stacking."

Claude: Switching to WHITEBOARD mode for exploration...
        Creating temporary planning space at docs/whiteboards/2025-01-28-item-stacking.md
        Context Snapshot: feature/inventory branch, implementing InventoryManager
        Detected existing docs: adr/, design/, plans/

        Let me understand the stacking problem...

[Exploration happens - Claude structures options, you drive]

You: "Option 2 makes sense - stack by item type, don't stack unique items."

Claude: [Pins insight to Pinned Insights section]
        [Updates Next Steps with decision]

        Exiting WHITEBOARD mode...
        Whiteboard refined into:
        - ADR at docs/adr/0043-item-stacking-rules.md

        Resuming work on feature/inventory...
        Context Snapshot restored: implementing InventoryManager
```

## Best Practices

1. **Be informal** - Whiteboards are for rough thoughts, not polished docs
2. **Park branches** - Don't lose interesting ideas, but stay focused
3. **Let Claude facilitate** - You drive the content, Claude handles structure
4. **Archive when ready** - Don't leave whiteboards active indefinitely
5. **Discard obsolete** - If an idea doesn't pan out, delete the whiteboard

## Commands

| You Say | What Happens |
| ------- | ------------ |
| `whiteboard: {topic}` | Create new whiteboard |
| `done` / `archive this` | Refine to formal doc or park |
| `back to work` / `resume` | Exit whiteboard, restore context |
| `park this` | Save whiteboard for later (status: parked) |
| `discard this` | Delete whiteboard (idea obsolete) |

## Related Skills

- **Brainstorming** (`/oh-my-claudecode:brainstorming`) - More structured exploration with interview workflow
- **Plan** (`/oh-my-claudecode:plan`) - Formal planning session with implementation tasks
- **Note** (`/oh-my-claudecode:note`) - Quick memory capture for single facts

**Whiteboard is lighter** - use it for rough exploration, formal skills for structured outputs.
