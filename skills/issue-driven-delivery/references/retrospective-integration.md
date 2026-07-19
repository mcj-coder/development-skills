# Retrospective Integration

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


When closing work items, capture process improvement opportunities while context is fresh.
This enables continuous improvement by surfacing issues before they're forgotten.

### Retrospective Prompt

Before closing a work item (step 20, after DoD validation), prompt:

```text
Any process issues to flag for retrospective? (Y/n/skip)
```

- **Default:** No (retrospective flagging is optional)
- **If Yes:** Choose capture mechanism (see below)
- **If No/Skip:** Continue to close work item

### When to Capture Retro Items

Flag items that would benefit from team discussion:

| Category         | Examples                                              |
| ---------------- | ----------------------------------------------------- |
| Process friction | Approval delays, unclear handoff points, missing docs |
| Tooling issues   | CLI quirks, integration failures, slow builds         |
| Workflow gaps    | Missing labels, unclear states, automation needs      |
| Communication    | Stakeholder misalignment, requirement ambiguity       |

**Do NOT use for:** Bugs (use `work-type:bug`), features (use `work-type:new-feature`),
technical debt (use `work-type:tech-debt`). Retro items are process improvements, not work items.

### Capture Mechanisms

Choose the appropriate mechanism based on context:

#### Option 1: Label-Based (Quick Flag)

Add `retro` label to the current work item:

```bash
gh issue edit N --add-label "retro"
```

Use when: Quick flag for discussion, context clear from issue itself.

#### Option 2: Comment-Based (With Details)

Post a structured comment on the current work item:

```bash
gh issue comment N --body "## Retrospective Item

[Description of process issue]

**Category:** [process|tooling|workflow|communication]
**Impact:** [low|medium|high]
**Suggestion:** [optional improvement idea]

---
_Flagged for retrospective: $(date '+%Y-%m-%d')_"
```

Use when: Need to capture specific details beyond issue context.

#### Option 3: Linked Issue (Substantial Improvement)

Create a separate issue for tracking:

```bash
gh issue create \
  --title "retro: [Brief description of process issue]" \
  --body "## Source

Identified during: #N

## Issue

[Description of process issue]

## Proposed Improvement

[Suggested change]

## Category

[process|tooling|workflow|communication]" \
  --label "work-type:retro-item"
```

Use when: Issue warrants dedicated tracking and prioritization.

### Aggregation Queries

Gather retro items for team discussion:

```bash
# All items flagged for retrospective
gh issue list --label "retro" --state all --json number,title,closedAt

# Retro items from specific date range (sprint boundary)
gh issue list --label "retro" --state all --search "closed:2026-01-06..2026-01-17"

# Linked retro-item issues
gh issue list --label "work-type:retro-item" --state open

# Search comments for retro items
gh api search/issues --method GET \
  -f q="repo:{owner}/{repo} \"Retrospective Item\" in:comments"
```

### Ceremony Integration

**Kanban teams:** Run aggregation query periodically (weekly or bi-weekly) and
review items in team meetings.

**Scrum teams:** Run aggregation at sprint boundary. Include retro items in Sprint
Retrospective using the Sprint Retrospective integration in process-models.md.

### After Retrospective Discussion

Mark items as addressed:

```bash
# Remove retro label after discussion
gh issue edit N --remove-label "retro"

# Close linked retro-item issues
gh issue close N --comment "Addressed in retrospective [date]"

# Or create improvement issue if action agreed
gh issue create --title "improvement: [action from retro]" --label "work-type:enhancement"
```
