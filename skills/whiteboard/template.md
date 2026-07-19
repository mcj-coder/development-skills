# Whiteboard: {TOPIC}

**Date:** {YYYY-MM-DD}
**Status:** active | parked | archived
**Triggered By:** explicit | implicit | mid-session-switch
**During:** [feature branch / task / context - if mid-session]

---

## Context Snapshot

> Only populate this section if switching to whiteboard mid-session

**What Just Happened (Trigger):**
- User quote: `"{exact user message that caused the branch}"`
- Your response summary: `{brief summary of what you were discussing/doing}`
- Why we branched: `{what triggered the whiteboard - blocker, ambiguity, new idea, etc.}`

**Conversation Context (Recent Summary):**
- Topic we were on: `{what we were discussing before the branch}`
- Recent actions: `{what we just did - files edited, decisions made, etc.}`
- State of conversation: `{where we were in the flow}`

**Interrupted Work:**
- Branch: `{feature-branch-name}`
- Task: `{what you were working on}`
- Tracking file: `{path to plan or whiteboard being followed}`
- Worktree: `{path if using worktrees}`

**State to Restore:**
- Files modified: `{list}`
- Next step: `{what to return to}`
- Uncommitted changes: `{yes/no + details}`

---

## Session Intent

> **SCOPE BOUNDARY:** This whiteboard is for exploring requirements and options ONLY.
> Implementation planning happens AFTER requirements are complete.

**What are we exploring?**

- {Brief question or problem statement}
- {What outcome we're looking for}

**Constraints:**

- {Any boundaries or non-negotiables}
- {What's NOT in scope}

---

## Pinned Insights

> Key findings that emerge during exploration. Update IMMEDIATELY when creating valuable content.

**{Insight 1:}**
> **Context:** {Brief summary of conversation leading to this insight}
>
> **User said:** "{exact user quote that triggered this insight}"
>
> **Insight:** {your verbatim table/framework/insight - preserve structure}

---

## Decision Records

> **CRITICAL:** When resolving questions, gaps, or decisions through options (A/B/C), ALWAYS document the full options presented. Never document just "User chose A" without context.

### Decision #N: {Title}

**Options Presented:**
| Option | Description | Trade-offs |
|--------|-------------|------------|
| A | {description} | {trade-offs} |
| B | {description} | {trade-offs} |
| C | {description} | {trade-offs} |

> **User said:** "{Full user quote - not just 'A' or 'B'}"

**Resolution:**
- {The chosen approach}
- {Rationale if provided}

**Rejected Options:**
- B: {reason rejected, if discussed}
- C: {reason rejected, if discussed}

---

## Branches

> Alternative ideas or side threads that aren't the main focus right now.
> Park these here so we don't lose them but can stay on track.

**{Branch 1:}**
- {Idea or alternative approach}
- {Why it's interesting}
- {Status: explore-later | discard | merged}

**{Branch 2:}**
- {Idea or alternative approach}
- {Why it's interesting}
- {Status: explore-later | discard | merged}

---

## Active Thread

> Current exploration thread. What we're working through right now.

**{Current focus or question:}**

**Option 1: {Name}**
- {Brief description}
- Pros: {benefits}
- Cons: {drawbacks}
- Open questions: {what we don't know}

**Option 2: {Name}**
- {Brief description}
- Pros: {benefits}
- Cons: {drawbacks}
- Open questions: {what we don't know}

**Option 3: {Name}**
- {Brief description}
- Pros: {benefits}
- Cons: {drawbacks}
- Open questions: {what we don't know}

**Working Notes:**
- {Bullet points as we explore}
- {Rough thoughts, not polished}
- {Update iteratively}

---

## Open Questions (Must Resolve Before Exit)

> Track all unresolved questions, gaps, and decisions. Update in real-time.

| # | Question | Raised By | Status |
|---|----------|-----------|--------|
| 1 | [question] | [user/ai] | [OPEN/DISCUSSING/RESOLVED/DEFERRED/BLOCKER] |

**EXIT CHECKLIST:**
Before offering "ready to proceed" or exiting whiteboard:
- [ ] All questions marked RESOLVED or DEFERRED
- [ ] Session Intent achieved - **ask user explicitly: "Did we accomplish what we set out to do?"**
- [ ] User confirms ready to proceed
- [ ] No unilateral resolutions
- [ ] All decisions have complete documentation (options + user choice)
- [ ] **Technical expert review** - architect/security/performance review; no technical gaps
- [ ] **Domain expert review** - Subject-matter expert review; no functional gaps

---

## Next Steps

> What to do when we exit the whiteboard. Only populate when resolved.

**Decision:** {Which option we chose (if applicable)}

**Actions:**
- [ ] {Action item 1}
- [ ] {Action item 2}
- [ ] {Action item 3}

**Refine Into:**
- [ ] ADR (technical decision)
- [ ] Design doc (game mechanic / system)
- [ ] Implementation plan
- [ ] Phase plan
- [ ] Park this whiteboard for later
- [ ] Discard (idea obsolete)

---

## Refined Into

> Only populate when this whiteboard is archived into a formal doc.

**Formal Doc:** {doc type}
**Path:** {path to formal document}
**Date Archived:** {YYYY-MM-DD}
**Archived By:** {user / system}
