# Open Sessions Tracking

> Reference material for the [`whiteboard`](../SKILL.md) skill.


**Location:** `docs/whiteboards/_open-sessions.md`

**Format:**
```markdown
# Open Whiteboard Sessions

| Date       | Topic              | File                          | Status | Created During          |
| ---------- | ------------------ | ----------------------------- | ------ | ----------------------- |
| 2025-01-28 | Combat refactoring | 2025-01-28-combat-refactor.md | active | feature/combat-overhaul |
| 2025-01-27 | NPC needs system   | 2025-01-27-npc-needs.md       | parked | main                    |
```

**Status values:**
- `active` - Currently being worked on
- `parked` - Saved for later, not abandoned
- `archived` - Refined into formal doc (link in "Refined Into" section)

**Update rules:**
- Create entry when whiteboard created
- Update status on state change
- Add "Refined Into" link when archived
- Remove entry only when discarded

### Resuming Parked Whiteboards

When user wants to continue a previously parked whiteboard:

1. **READ** the full parked whiteboard to understand context
2. **SUMMARIZE** key points for user:
   - Original Session Intent
   - What was discussed
   - What was left unresolved
3. **ASK user:**
   ```
   "This whiteboard was parked on [date] about [topic].

   Key points: [brief summary of 2-3 items]

   Unresolved: [list open questions]

   Ready to continue?"
   ```
4. **IF yes:**
   - Add "Resumed: [date]" section to whiteboard
   - Update _open-sessions.md: `parked` → `active`
   - Continue discussion
5. **IF no:**
   - Ask if they want to archive or discard

**Mode transition announcement:**
```
"Resuming WHITEBOARD from parked state: [topic]

Last worked on: [date]
Context: [brief context]
```

### Example 1: Mid-Session Exploration

```
User: "I'm implementing the combat system but just realized
      I need to think through how morale affects target selection."

You: [Detects implicit trigger during active work]

     "Switching to WHITEBOARD mode for exploration...

      Creating temporary planning space at docs/whiteboards/2025-01-28-morale-target-selection.md
      Detected existing docs: adr/, design/, plans/
      Context Snapshot: feature/combat-system branch, implementing CombatResolver

      Let's explore this..."

[Create whiteboard with enhanced Context Snapshot:]

## Context Snapshot

**What Just Happened (Trigger):**
- User quote: "I'm implementing the combat system but just realized I need to think through how morale affects target selection."
- Your response summary: We were discussing the CombatResolver implementation and you identified an ambiguity in how morale influences target selection decisions
- Why we branched: Unclear requirements - need to explore mechanics before continuing

**Conversation Context (Recent Summary):**
- Topic we were on: Implementing CombatResolver.CalculateTargets()
- Recent actions: Defined base target selection algorithm, about to add morale modifier
- State of conversation: Mid-implementation, hit ambiguity in design

**Interrupted Work:**
- Branch: feature/combat-system
- Task: Implementing CombatResolver class
- Tracking file: docs/plans/2025-01-25-combat-implementation.md
- Worktree: C:/Projects/cozy-fantasy-rpg/

**State to Restore:**
- Files modified: src/Combat/CombatResolver.cs (partially complete)
- Next step: Continue morale modifier implementation after resolution
- Uncommitted changes: yes
```

### Example 2: Explicit Whiteboard Request

```
User: "whiteboard: I'm not sure whether to use event sourcing or
      direct state updates for the inventory system"

You: [Detects explicit trigger]

     "Switching to WHITEBOARD mode for exploration...

      Creating whiteboard at docs/whiteboards/2025-01-28-inventory-persistence.md
      Existing docs structure found:
      - docs/adr/ (Architecture Decision Records)
      - docs/design/ (Design docs)

      I see 2-3 approaches here. Let's sketch them out..."

[Create whiteboard, list approaches, let user drive]
```

### Example 3: Parking a Branch

```
User: "Wait, I just thought of something - what if we made
      crafting quality affect enchantment capacity too?"

You: [Detects branch during whiteboard]

     "That's a different branch. Let me park it in the whiteboard
     so we don't lose it..."

[Add to "Branches" section in whiteboard]
```

### Example 4: Refining to Formal Doc

```
User: "Okay, this makes sense. Let's turn this into an ADR."

You: [Detects refinement signal]

     "Exiting WHITEBOARD mode...

      Whiteboard refined into:
      - ADR at docs/adr/0042-inventory-event-sourcing.md

      Resuming work on feature/inventory-persistence..."

[Copy key content to ADR, archive whiteboard, update _open-sessions.md]
```

### Example 5: Scope Guardrail - Pushing Back on Plan Deviation

```
User: "While we're implementing the inventory system, can we also add
      item durability that degrades with use?"

You: [Detects scope expansion - not in agreed plan]

     "⚠️ **SCOPE CHANGE DETECTED**

      This request would alter the scope of the approved plan:
      - Current plan: docs/plans/2025-01-20-inventory-implementation.md
      - Agreed scope: Basic inventory CRUD, stacking, and persistence
      - Requested change: Add item durability system with degradation
      - Impact: New feature not in scope, requires data model changes,
                adds significant effort, affects related systems (crafting, combat)

      **I recommend whiteboarding this change** rather than implementing immediately.
      This allows us to:
      - Understand the full impact on existing work
      - Update the plan with revised scope/acceptance criteria
      - Consider dependencies on other planned work
      - Potentially create an ADR for the durability mechanics

      Shall we whiteboard this?"

User: "Yeah, you're right. Let's whiteboard it."

You: "Switching to WHITEBOARD mode for scope exploration..."
```

### Example 6: Immediate Insight Pinning

```
[During discussion about session management]

User: "How long the session run depends on the task. For example, starting a fresh
      project I want to brainstorm the vision for the project, tech stack, features, etc.
      I generally want to complete this overview in a session and then have a list of
      key topics to review in detail as we drill down."

You: [Creates session hierarchy table, then immediately pins it]

     "That's a really clear hierarchical structure. Let me reflect what I'm hearing:

      Your Ideal Session Hierarchy:
      | Level | Scope | Duration | Output | Checkpoint |
      |-------|-------|----------|--------|------------|
      | 1. Vision | Project kickoff | 1 session | Vision docs... | Scope locked |
      | 2. Guardrails | Tooling/standards | 1 session | Repo setup... | Ready for planning |
      [...]

      [Pinning this to whiteboard ✓]

      The core principle: Each session has clear inputs, clear outputs, and a checkpoint..."
```

### Example 7: Gap Resolution with Decision Records

```
[After expert review identified 4 critical gaps]

You: "Let me add these to OPEN QUESTIONS and work through each one..."

[Added to whiteboard:]

## OPEN QUESTIONS

| # | Gap | Status | Answer |
|---|-----|--------|--------|
| 1 | Performance at high speed | OPEN | |
| 2 | Event buffer overflow | OPEN | |
| 3 | No search/filter | OPEN | |
| 4 | No error display | OPEN | |

[For each gap, presented options and asked user to choose:]

### Gap #1: Performance - Display Updates at High Speed

**Options Presented:**
| Option | Description | Trade-offs |
|--------|-------------|------------|
| A | Frame rate cap at 60 FPS | Simpler; may miss fast events |
| B | Batch updates every N ticks | More complex; good balance |
| C | Dynamic based on speed | Most flexible; hardest to implement |

> **User said:** "A. Although if we implement conditional breakpoints,
> the simulation should run at MAX and only update when breakpoint hit."

**Resolution:**
- Display capped at 60 FPS in normal mode
- Breakpoint mode: sim runs at MAX, display updates only on hit
- Breakpoint dialog popup appears when hit

**Rejected Options:**
- B: Batch updates adds complexity; user wants simple cap
- C: Dynamic approach not needed for MVP

[All 4 gaps resolved with complete Decision Records]

You: "All gaps resolved. Ready to move to Phase 2?"
```
