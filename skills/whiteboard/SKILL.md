---
name: whiteboard
description: Lightweight planning space for rough ideas and exploration. Detects existing docs structure (ADR, design, plans) and creates temporary whiteboard docs in docs/whiteboards/ that can be refined into formal docs later.  Use during Planning, Brainstorming or discussing changes/modifications mid-plan.
---

# Whiteboard Skill

## Overview

The whiteboard skill creates a lightweight, temporary planning space for exploring ideas mid-session. Unlike formal planning sessions that create detailed implementation plans, whiteboards are quick, informal spaces for:
- Roughing out approaches when you're unsure
- Parking branches of thought during exploration
- Capturing insights before committing to direction
- Temporary context switches during active work

**Key difference from planning**: Whiteboards are **ephemeral** and **iterative**. They're not formal plans - they're thinking tools you can refine into proper docs later.

**Scope boundary**: Whiteboards explore **future requirements and options** to feed into planning. Do NOT derailing into implementation planning during whiteboarding. Requirements must be cohesive and complete BEFORE moving to planning.

## When to Use

### Trigger Conditions

The whiteboard activates when you detect these user signals:

**Explicit Triggers:**
- "whiteboard", "wb:", "whiteboard this"
- "add a whiteboard to [X]" → **LITERAL TRIGGER: create whiteboard first, then execute**
- "rough this out", "sketch this out"
- "let me think about this", "explore this approach"
- "park this thought", "branch this idea"
- "not sure yet, let's brainstorm"

**Implicit Triggers:**
- User switches topics mid-session without "discuss"/"brainstorm" keywords
- User asks "what do you think" during active work
- You detect 2+ divergent approaches being considered
- User seems uncertain or exploring options
- Context switching needed during feature implementation
- **Scope/plan deviation detected** (see Scope Guardrail below)

**When NOT to use:**
- Clear request for implementation plan → Use `plan` skill
- Specific, well-defined requirements → Delegate directly
- Quick lookup/clarification → Answer directly
- User says "stop brainstorming" → Return to previous work

### Decision Tree: Which Skill Should I Use?

```
START: User wants to discuss something
│
├─ Is the topic CLEARLY DEFINED with known requirements?
│  └─ YES → Can you implement directly? → Delegate to executor
│           └─ NO → Use `plan` skill for implementation planning
│
├─ Is the topic UNCERTAIN, exploring options, or "not sure"?
│  └─ YES → Is there a specific decision needed? → Use `whiteboard`
│           └─ NO (general exploration) → Use `brainstorming` skill
│
└─ TRIGGER WORDS:
   - "whiteboard this", "sketch this out", "rough this out" → whiteboard
   - "plan this", "create a plan for", "break down tasks" → plan
   - "evaluate", "assess", "what do you think about" → brainstorming
```

**Quick Reference Table:**

| Situation | Use Skill | Output |
|-----------|-----------|--------|
| Rough out approaches when unsure | whiteboard | Informal notes → refine to doc later |
| Explore multiple options with discussion | brainstorming | Structured exploration with interview |
| Create detailed implementation plan | plan | Task breakdown with dependencies |
| Quick note/memory capture | note | Single fact or insight |

**Key Differentiator:**
- **Whiteboard**: Quick, informal, thinking tool → can refine later
- **Brainstorming**: Structured exploration with interview workflow
- **Plan**: Detailed implementation tasks with dependencies

### Skill Switching: When to Switch TO Whiteboard

Whiteboarding can be entered from other skills when they go off-track:

```
ALREADY IN ANOTHER SKILL → Should you switch to whiteboard?
│
├─ In PLANNING session → scope deviation detected?
│  └─ YES → Switch to whiteboard to explore the deviation
│           - "This alters the agreed plan. Let's whiteboard this change."
│
├─ In BRAINSTORMING → requirements becoming unclear?
│  └─ YES → Switch to whiteboard to capture what's known
│           - "We're discovering requirements. Let me whiteboard this."
│
└─ During IMPLEMENTATION → blocker or ambiguity found?
   └─ YES → Switch to whiteboard to resolve
            - "I need to think through this ambiguity. Whiteboarding..."
```

**When to SWITCH BACK:**
- Whiteboard complete → return to original skill with new clarity
- Or refine whiteboard into appropriate formal doc → resume work

### External Scope Guardrail: Push Back on Plan Deviations

**Purpose:** When IMPLEMENTING, push back on user requests that deviate from agreed plan.

**Distinction from Rule #11:**
- **External Scope Guardrail** (this section): Protect the PLAN from scope creep during implementation
- **Rule #11 (Internal Scope Guardrail)**: Protect the WHITEBOARD from drifting into planning

When you detect a request that would **alter the agreed plan's scope** or **deviate from the approved approach**:

**Detection signals:**
- Request adds features not in the original plan
- Request changes architecture/data model already agreed upon
- Request expands acceptance criteria beyond what was documented
- Request conflicts with an existing ADR or design doc
- "While we're at it, let's also add..." during implementation

**Your response pattern:**
```
"⚠️ **SCOPE CHANGE DETECTED**

This request would alter the scope of the approved plan:
- Current plan: {cite the plan file and relevant section}
- Agreed scope: {what was approved}
- Requested change: {what user is asking for}
- Impact: {how this changes scope/effort/architecture}

**I recommend whiteboarding this change** rather than implementing immediately.
This allows us to:
- Understand the full impact on existing work
- Update the plan with revised scope/acceptance criteria
- Consider dependencies on other planned work
- Potentially create an ADR if architectural

Shall we whiteboard this?"
```

**If user insists on implementing without whiteboard:**
- Reiterate the impact with specific evidence
- Ask them to confirm they want to proceed anyway
- Document the decision in the relevant plan file with a "Scope Change" note
- Update acceptance criteria if applicable

**When NOT to use:**
- Clear request for implementation plan → Use `plan` skill
- Specific, well-defined requirements → Delegate directly
- Quick lookup/clarification → Answer directly
- User says "stop brainstorming" → Return to previous work

## How It Works

### Workflow

```
1. DETECT trigger (explicit or implicit)
   ↓
2. CHECK for existing docs structure
   - docs/adr/ (Architecture Decision Records)
   - docs/design/ (Design docs)
   - docs/plans/ (Implementation plans)
   - docs/phase-plans/ (Phase-based planning)
   ↓
3. CREATE temporary whiteboard
   - docs/whiteboards/{YYYY-MM-DD}-{topic-slug}.md
   - From template.md (section structure below)
   ↓
4. ANNOUNCE mode transition
   "Switching to WHITEBOARD mode for exploration..."
   ↓
5. TRACK session
   - Register in docs/whiteboards/_open-sessions.md
   - Update status on state changes
   ↓
6. CONDUCT exploration
   - Quick bullets, not formal structure
   - Multiple branches/alternatives
   - Pin key insights
   - User drives, you facilitate
   ↓
7. RESOLVE on completion
   - Archive: Move to appropriate formal doc type
   - Park: Keep for later (status: parked)
   - Discard: Delete if obsolete
   - Resume: Return to interrupted work
```

### Worktree Protocol (Isolation)

**ALL whiteboards must be created on `whiteboard/{topic}` branches.** Never create whiteboards on main or feature branches.

```
1. CHECK current branch
   - If already on whiteboard/* → Use existing branch
   - If on main or feature/* → Create new whiteboard branch
   ↓
2. CREATE whiteboard branch (if needed)
   - git checkout -b whiteboard/{YYYY-MM-DD}-{topic-slug}
   - OR: git worktree add ../{repo}-wb-{topic} -b whiteboard/{YYYY-MM-DD}-{topic-slug}
   ↓
3. CREATE whiteboard file
   - docs/whiteboards/{YYYY-MM-DD}-{topic-slug}.md
   - From template.md
   ↓
4. IF interrupting active work
   - Populate Context Snapshot with interrupted state
   - Note original branch for return
   ↓
5. COMMIT whiteboard
   - git add docs/whiteboards/
   - git commit with descriptive message
   ↓
6. ON completion
   - Refine into formal docs OR park as-is
   - PR whiteboard branch → main
   - Return to original branch if interrupted
```

**Why always whiteboard branches?**
- Keeps exploration isolated from production code
- Clean git history (no exploratory commits mixed with real work)
- Easy to discard whiteboard without affecting main
- Consistent pattern regardless of context

### Mode Transitions

**Entering Whiteboard Mode:**
```
"Switching to WHITEBOARD mode for exploration..."

- Creating temporary planning space at docs/whiteboards/{date}-{topic}.md
- Detected existing docs structure: [list found]
- This will NOT create a formal plan yet, just a space to think
- Type 'done', 'archive this', or 'back to work' when ready
```

**Exiting Whiteboard Mode:**
```
"Exiting WHITEBOARD mode..."

Whiteboard refined into:
- [Formal doc type] at [path]
- Resuming work on [feature branch/task]

OR

Whiteboard parked at docs/whiteboards/{topic}.md (status: parked)
Resuming work on [feature branch/task]
```

## Agent Behavior Rules

Rules governing agent behaviour while using the whiteboard.

See [Agent Behavior Rules](references/agent-behavior-rules.md).

## Integration with Existing Docs

### Detecting Doc Types

On whiteboard creation, probe for existing structure:

```bash
# Check for ADR structure
if [[ -f "docs/adr/0000-use-adrs.md" ]]; then
  HAS_ADR=true
  ADR_NEXT=$(ls docs/adr/*.md | tail -1 | grep -oP '\d+' | awk '{print $1+1}')
fi

# Check for design docs
if [[ -d "docs/design" ]]; then
  HAS_DESIGN=true
fi

# Check for plans
if [[ -d "docs/plans" ]] || [[ -d "docs/phase-plans" ]]; then
  HAS_PLANS=true
fi
```

### Refinement Paths

When whiteboard is complete, offer appropriate options based on detected structure:

| Whiteboard Content | Refine Into       | Template/Process                  |
| ------------------ | ----------------- | --------------------------------- |
| Technical decision | ADR               | docs/adr/{next-number}-{topic}.md |
| Game mechanic      | Design doc        | docs/design/gdd-{topic}.md        |
| Implementation     | Plan              | docs/plans/{topic}.md             |
| Multi-phase work   | Phase plan        | docs/phase-plans/phase-{N}.md     |
| Not ready yet      | Parked whiteboard | docs/whiteboards/{topic}.md       |
| Obsolete           | Discarded         | (delete file)                     |

## Open Sessions Tracking

How open whiteboard sessions are tracked, listed, and resumed.

See [Open Sessions Tracking](references/session-tracking.md).

## Template Structure

See `template.md` for the whiteboard template with all sections:

- **Header** - Topic, date, status, triggered by
- **Context Snapshot** - Interrupted work state (if mid-session)
- **Session Intent** - What we're exploring
- **Pinned Insights** - Key findings as we go
- **Branches** - Alternative ideas to revisit
- **Active Thread** - Current exploration thread
- **Next Steps** - What to do when done (if resolved)
- **Refined Into** - Link to formal doc (if archived)

## Related Skills

- `brainstorming` - More structured exploration with interview workflow
- `plan` - Formal planning session with implementation tasks
- `note` - Quick memory capture (single facts, not exploration)

**Whiteboard is lighter than all of these** - it's for roughing out ideas quickly, not creating formal outputs.
