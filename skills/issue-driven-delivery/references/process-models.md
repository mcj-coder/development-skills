# Process Models

## Overview

Issue-driven delivery supports two process models: **Kanban** (default) and **Scrum** (optional).
Teams should document their process model choice in their ways-of-working or an ADR.

## Kanban (Default/Recommended)

Kanban continuous flow is the preferred model for most teams. Work items flow through states
without time-boxed iterations.

**Characteristics:**

- Pull-based work assignment (self-assign when capacity available)
- WIP limits prevent bottlenecks
- Continuous delivery - no waiting for sprint boundaries
- Prioritization by P0-P4 labels, not sprint commitment
- State transitions drive workflow, not calendar events

**When to use Kanban:**

- Team handles varied work types (features, bugs, support)
- Delivery cadence is continuous or unpredictable
- Work items vary significantly in size
- Team wants minimal ceremony overhead
- Stakeholders need fastest possible time-to-delivery

## Scrum Mode (Optional)

Scrum mode adds time-boxed iterations (sprints) with associated ceremonies. Enable this when
your team uses Scrum and needs ceremony integration points.

**Characteristics:**

- Time-boxed sprints (typically 1-4 weeks)
- Sprint commitment at planning
- Ceremonies at fixed cadence
- Sprint backlog vs product backlog distinction
- Velocity tracking and sprint goals

**When to use Scrum mode:**

- Organization requires Scrum methodology
- Team benefits from fixed delivery cadence
- Sprint ceremonies add value for coordination
- Stakeholders expect sprint-based reporting

## Enabling Scrum Mode

Document your process model choice in one of these locations.

### Configuration Options

#### Option 1: Ways of Working (Recommended)

```markdown
# docs/ways-of-working/team-agreements.md

## Process Model

Our team uses **Scrum** with 2-week sprints.

- Sprint planning: Mondays
- Daily standup: 9:30 AM
- Sprint review: Friday PM (end of sprint)
- Sprint retrospective: Following Monday AM
```

#### Option 2: ADR

```markdown
# docs/adr/NNNN-process-model.md

---

name: process-model
decision: Scrum with 2-week sprints
status: accepted

---

## Context

Team coordination benefits from fixed cadence...

## Decision

Use Scrum mode with 2-week sprints...
```

## Sprint Boundary Handling

### Sprint Backlog vs Product Backlog

| Backlog         | Contains                          | Labels                                |
| --------------- | --------------------------------- | ------------------------------------- |
| Product Backlog | All unstarted work items          | `state:new-feature`, `state:grooming` |
| Sprint Backlog  | Work committed for current sprint | `sprint:current` or `sprint:YYYY-WNN` |

**Sprint label convention:**

```bash
# Add to current sprint
gh issue edit N --add-label "sprint:current"

# Add to specific sprint (ISO week format)
gh issue edit N --add-label "sprint:2026-W03"

# Remove from sprint (carryover)
gh issue edit N --remove-label "sprint:current"
```

### Work Spanning Sprint Boundaries (Carryover)

When work items are not completed within a sprint:

#### 1. End-of-Sprint Assessment

Before sprint review, assess incomplete work:

```bash
# List incomplete sprint items
gh issue list --label "sprint:current" --state open --json number,title,labels
```

#### 2. Carryover Decision

For each incomplete item, decide:

- **Continue**: Keep in next sprint (update sprint label)
- **Split**: Break into smaller items (close original, create children)
- **Defer**: Return to product backlog (remove sprint label)

#### 3. Document Carryover

Post comment on carried-over items explaining status:

```bash
gh issue comment N --body "Carryover from Sprint 2026-W02 to 2026-W03.
Status: Implementation 80% complete. Blocked by code review availability.
Expected completion: First 2 days of new sprint."
```

#### 4. Update Sprint Labels

```bash
# Transition to new sprint
gh issue edit N --remove-label "sprint:2026-W02" --add-label "sprint:2026-W03"
```

### Mid-Sprint Scope Changes

Scope changes during a sprint require explicit handling:

**Adding work mid-sprint:**

1. Emergency P0/P1 work may be added (document justification)
2. Lower priority additions require removing equivalent work
3. Post comment: "Added mid-sprint: [justification]"

**Removing work mid-sprint:**

1. Return item to product backlog (remove sprint label)
2. Post comment: "Removed from sprint: [reason]"
3. Do not count toward velocity

### Sprint Commitment Rules

Sprint commitment is advisory, not binding. The goal is predictability, not rigidity.

**Recommended guidelines:**

- Commit to 80% of capacity (buffer for unknowns)
- Track velocity for future planning
- Incomplete work is a learning signal, not failure
- Never sacrifice quality to meet sprint commitment

## Ceremony Integration Points

Scrum ceremonies integrate with issue-driven delivery at specific workflow points.

### Daily Standup

**Purpose:** Surface blockers, coordinate handoffs

**Integration points:**

- Review tickets in `state:implementation` and `state:verification`
- Check for tickets approaching WIP limits
- Identify blocked work items needing escalation
- Note any tickets ready for handoff (unassigned in-progress states)

**Suggested format:**

```text
1. What tickets are you working on? (show issue numbers)
2. Any blockers? (reference blocking issues)
3. Any handoffs needed? (tickets ready for next state)
```

### Sprint Planning

**Purpose:** Select and commit to sprint backlog

**Integration points:**

1. **Before planning:** Run grooming on candidate issues
2. **During planning:**
   - Select from groomed `state:grooming` issues by priority (P0-P4)
   - Apply `sprint:current` label to selected items
   - Verify total estimated effort fits capacity
3. **After planning:**
   - Transition selected items to `state:refinement`
   - Tech Lead self-assigns for plan creation

**Automation support:**

```bash
# View groomed items ready for sprint
gh issue list --label "state:grooming" --json number,title,labels --jq 'sort_by(.labels | map(select(.name | startswith("priority:"))) | .[0].name)'

# Add sprint label to selected issues
gh issue edit N --add-label "sprint:current"
```

### Sprint Review

**Purpose:** Demonstrate completed work, gather feedback

**Integration points:**

1. **Before review:**
   - List completed items: `gh issue list --label "sprint:current" --state closed`
   - Gather evidence from closed issues (plan links, PR links)
2. **During review:**
   - Demo features using merged PRs
   - Reference issue comments for decisions made
3. **After review:**
   - Create follow-up issues for feedback received
   - Link follow-ups to original issues

### Sprint Retrospective

**Purpose:** Improve team process

**Integration points:**

1. **Before retrospective:**
   - Review velocity (closed vs committed)
   - Identify carryover patterns
   - Note any blocked work duration
2. **During retrospective:**
   - Discuss workflow bottlenecks
   - Review WIP limit effectiveness
   - Identify grooming/refinement improvements
3. **After retrospective:**
   - Create improvement issues with `work-type:enhancement`
   - Update ways-of-working if process changes agreed
   - Document in `docs/retrospectives/YYYY-MM-DD-sprint-N.md`

## Ceremony Timing Reference

| Ceremony             | Frequency    | Duration    | Participants         |
| -------------------- | ------------ | ----------- | -------------------- |
| Daily Standup        | Daily        | 15 min      | Development team     |
| Sprint Planning      | Sprint start | 2-4 hours   | Team + Product Owner |
| Sprint Review        | Sprint end   | 1-2 hours   | Team + Stakeholders  |
| Sprint Retrospective | After review | 1-1.5 hours | Development team     |

## Process Model Comparison

| Aspect        | Kanban (Default)      | Scrum Mode            |
| ------------- | --------------------- | --------------------- |
| Time-boxing   | None                  | Sprints               |
| Commitment    | Continuous            | Per sprint            |
| Planning      | On-demand             | Sprint start          |
| Ceremonies    | None required         | 4 ceremonies          |
| Metrics       | Lead time, cycle time | Velocity              |
| Delivery      | Continuous            | End of sprint         |
| Scope changes | Anytime (by priority) | Mid-sprint restricted |

## Migration Between Models

### Kanban to Scrum

1. Document decision in ADR
2. Define sprint length and ceremony schedule
3. Add sprint labels to in-progress work
4. Schedule first sprint planning
5. Begin tracking velocity

### Scrum to Kanban

1. Document decision in ADR
2. Remove sprint labels from all issues
3. Cancel recurring ceremony meetings
4. Implement WIP limits if not present
5. Begin tracking cycle time instead of velocity

## See Also

- [Assignment Workflow](assignment-workflow.md) - Pull-based work assignment
- [State Tracking](state-tracking.md) - Work item lifecycle states
- [Prioritization Rules](prioritization-rules.md) - P0-P4 priority system
