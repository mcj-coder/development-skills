# Agent Behavior Rules

> Reference material for the [`whiteboard`](../SKILL.md) skill.


### Core Principles (Remember These First)

> **16 detailed rules below are organized into 3 principles.**
> **Focus on the principles; reference detailed rules as needed.**

**PRINCIPLE 1: COLLABORATE FIRST**
- Don't unilateral resolve issues - discuss with user
- Guide, don't drive - user controls content
- Present options with trade-offs; let user decide
- This prevents Issues #1, #6, #8 (unilateral resolution patterns)

**⚠️ WARNING SIGNS - You are about to violate this principle:**
- You're about to write a resolution without user input
- You're offering to "consolidate requirements" with open questions
- You're thinking "this is obvious, I'll just document it"
- You feel excited to "get through" the gaps/questions
- **User says "add a whiteboard to [X]" and you immediately execute** ← META-FAILURE
  → This means CREATE whiteboard FIRST, then discuss the approach

**STOP. Before taking action, ask yourself:**
1. "Did I discuss this with the user?"
2. "Did the user choose this approach?"
3. "Am I documenting rather than collaborating?"

If the answer is NO to any of these: **STOP and discuss first.**

**PRINCIPLE 2: DOCUMENT COMPLETELY**
- Pin insights immediately when creating valuable content
- Document decisions with full options presented, not just "User said: A"
- Decision Record format prevents information loss (Issue #7)
- Never rely on summarization at end

**PRINCIPLE 3: STAY IN SCOPE**
- **Internal:** Whiteboarding = requirements exploration, NOT implementation planning
- **External:** Guard plan from scope creep during implementation
- Validate Session Intent before exit
- This prevents Issue #3 (rushing to next phase prematurely)

### For You (Conductor)

1. **Detect existing docs** before creating whiteboard
   ```bash
   ls docs/adr docs/design docs/plans docs/phase-plans 2>/dev/null
   ```

2. **Always use whiteboard branches** - NEVER create whiteboards on main or feature branches
   - Check current branch: `git branch --show-current`
   - If not `whiteboard/*`: create `whiteboard/{date}-{topic-slug}` branch first
   - Branch format: `whiteboard/{YYYY-MM-DD}-{topic-slug}` (prevents naming collisions)
   - Commit whiteboard files to this branch
   - This applies to ALL whiteboards, not just mid-session interruptions

3. **Track sessions** in `_open-sessions.md`
   - Register new whiteboards with status: active
   - Update to parked/archived on resolution

4. **Announce clearly** when mode switching
   - Use transition messages above
   - Make state explicit

5. **Pin insights IMMEDIATELY** when creating valuable content
   - **What counts as valuable**: Tables, frameworks, structured lists, decisions, root cause analysis
   - **When to pin**: RIGHT AFTER creating the content, before continuing
   - **How to capture**: Include context, user quote, and your verbatim response
   - **Never rely on summarization at end** - details WILL be lost
   - **Do not prompt** - just pin it automatically

   **Pinned insight format in whiteboard:**
   ```markdown
   **{Insight title:}**
   > **Context:** {Brief summary of conversation leading to this insight}
   >
   > **User said:** "{exact user quote}"
   >
   > **Insight:** {your verbatim table/framework/insight}
   ```

6. **Capture context precisely** when mid-session switch
   - **User quote**: Include exact user message that triggered the branch
   - **Your response summary**: Brief summary of what you were discussing
   - **Why we branched**: Blocker, ambiguity, new idea, refactor needed, etc.
   - **Recent conversation context**: Topic we were on, recent actions, state
   - This enables accurate restoration when returning

7. **Guide, don't drive**
   - User controls whiteboard content
   - You facilitate structure and organization
   - Offer 2-3 approaches, not solutions

8. **Document decisions COMPLETELY** (prevents information loss)
   - **CRITICAL**: When presenting options A/B/C to user, you MUST document:
     - The full options presented (with descriptions and trade-offs)
     - The user's response (letter choice + any reasoning)
     - The final resolution
   - **Never** document just "User said: 'A'" without the options
   - **Decision record format:**
     ```markdown
     ### Gap/Question #N: [Title]

     **Options Presented:**
     | Option | Description | Trade-offs |
     |--------|-------------|------------|
     | A | [description] | [trade-offs] |
     | B | [description] | [trade-offs] |
     | C | [description] | [trade-offs] |

     > **User said:** "A" [or full quote with reasoning]

     **Resolution:**
     [The chosen approach with rationale]

     **Rejected Options:**
     - B: [reason rejected, if discussed]
     - C: [reason rejected, if discussed]
     ```
   - This prevents future readers from seeing "User chose A" with no context

9. **Resolution Protocol - Collaborative Decisions**
   - When gaps/questions/issues are identified, follow this sequence:
     1. **PRESENT** - Show the item to the user clearly
     2. **OPTIONS** - If multiple valid approaches, list them with trade-offs
     3. **DECIDE** - Ask user to choose OR ask "how should we handle this?"
     4. **PIN** - Record the decision with user quote AND full options
     5. **NEXT** - Only then move to next item
   - **DO NOT** resolve multiple items at once without user input on each
   - **DO NOT** mark items as DEFERRED without user confirmation
   - ALL items start as OPEN; only change to RESOLVED/DEFERRED after user discussion
   - "Defer" is a decision - user must confirm what's deferred and why

10. **Expert Review before exit** - Catch issues before finalizing
    - Before marking whiteboard complete, delegate to relevant expert personas
    - **Two types of experts needed:**
      - **Technical experts:** architect, security-reviewer, performance specialist
      - **Domain experts:** Subject-matter experts who can identify non-functional gaps
    - Examples of domain expertise:
      - "RPG Game Developer" for game mechanics, progression, simulation
      - "UX Researcher" for user experience, workflows, discoverability
      - "DevOps Engineer" for deployment, monitoring, observability
    - Expert reviews for: gaps, inconsistencies, missing requirements, overlooked edge cases
    - Add any findings to OPEN QUESTIONS; resolve with user before exit
    - This prevents "we thought we were done" issues later

11. **Stay in scope - Internal Scope Guardrail**
    - **WHITEBOARDING** = exploring requirements, options, understanding the problem
    - **PLANNING** = breaking down implementation, tasks, dependencies
    - Do NOT offer to "create implementation plan" or "delegate to architect for spec" during whiteboarding
    - Only when ALL requirements are cohesive and complete, ask user: "Ready to move to planning?"
    - If you catch yourself drifting into implementation, stop and return to requirements exploration
    - This is the most common cause of whiteboard process failure
    - **See also:** "External Scope Guardrail" section for handling scope creep during implementation

12. **Validate Session Intent before exit** - Prevent premature completion
    - Exit checklist confirms questions resolved, but must also confirm PURPOSE achieved
    - Before offering "ready to proceed" or exit, explicitly ask user:
      - "Did we accomplish what we set out to do?"
      - Review Session Intent together before closing
    - A whiteboard can pass all other checks but still fail its purpose
    - This prevents "we answered 12 questions but never explored the actual problem"

13. **Recovery Protocol: When Whiteboard Goes Off Track**
    - **What "derailed" means:** Specific scenarios that require recovery
      | Scenario | What It Looks Like | Recovery Action |
      |----------|-------------------|-----------------|
      | Scope drift | Started exploring requirements, now discussing implementation | Return to requirements exploration |
      | Unilateral resolution | Writing decisions without user input | Stop, present to user for discussion |
      | Wrong topic | Whiteboard about X, now discussing unrelated Y | Move Y to "Branches", return to X |
      | Circular discussion | Repeating same points without progress | Summarize, ask what's blocking |
      | Premature exit | User says "ready" but open questions remain | Stop, list unresolved questions |
    - **Recovery steps:**
      1. **STOP immediately** - Acknowledge the issue
      2. **ASK user:** "I think we [drifted into X]. Should I get us back to [original topic]?"
      3. **RECOVER by:**
         - Adding "Recovery Note" to whiteboard documenting what happened
         - Creating "Back on Track: [date]" section with renewed focus
         - Moving off-topic content to "Branches" or separate parked whiteboard
      4. **DO NOT** start over from scratch unless user requests it
    - If whiteboard is hopelessly derailed and user agrees:
      - Archive current whiteboard with status "derailed"
      - Start fresh whiteboard with lessons learned noted
    - Recovery Note format:
      ```markdown
      ## Recovery Note: [Date]
      > **Issue:** [specific scenario from table above]
      > **Triggered by:** [what caused the drift]
      > **Resolution:** Returning to [original intent / revised intent]
      ```

### When Delegating to Subagents

**Context to pass:**
- Current whiteboard path
- Existing docs structure detected
- Whether in worktree or main repo
- Active feature branch context (if interrupted work)

**Agent instructions:**
```
You are working in WHITEBOARD mode.

Whiteboard location: docs/whiteboards/{date}-{topic}.md
Existing docs: [list detected directories]
Worktree: [yes/no + path if yes]

Your role:
- Facilitate exploration, don't direct
- Keep bullets brief and informal
- Pin key insights as they emerge
- Track multiple branches of thought
- Follow template structure from template.md

When user signals done:
- Ask: "Archive as ADR/design/plan/park/discard?"
- Execute resolution
- Update _open-sessions.md
```
