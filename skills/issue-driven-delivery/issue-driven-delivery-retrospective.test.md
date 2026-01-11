# Issue-Driven Delivery - Retrospective Integration Tests

## RED: Failure scenarios (expected without feature)

### Scenario A: Process issue missed without retrospective prompt

**Context:** Developer closes a work item after encountering workflow friction.

**Baseline failure to record:**

- Work item closed without capturing process improvement
- Friction point forgotten by next sprint retrospective
- Same friction experienced by other team members
- No aggregation of issues for team discussion

**Observed baseline (RED):**

- Process issues lost when context is fresh
- Sprint retrospectives rely on memory recall
- Systemic issues not visible across tickets

### Scenario B: Retro items scattered across different systems

**Context:** Team captures retro items inconsistently (Slack, notes, verbal).

**Baseline failure to record:**

- No standard mechanism for flagging items
- Retro items not linked to source tickets
- Cannot aggregate items for sprint ceremony
- Lost traceability from issue to improvement

**Observed baseline (RED):**

- Inconsistent capture reduces actionable feedback
- Retrospectives miss context from original issues
- Process improvements lack evidence base

## GREEN: Expected behaviour with feature

### Retrospective Prompt at Close

- [ ] Skill prompts for retro items when closing work item (step 20)
- [ ] Prompt is optional - user can skip without justification
- [ ] Prompt text: "Any process issues to flag for retrospective?"
- [ ] User can answer Yes/No/Skip

### Capture Mechanisms

- [ ] Option 1: Add `retro` label to current work item
- [ ] Option 2: Post retro comment on current work item
- [ ] Option 3: Create linked `work-type:retro-item` issue
- [ ] All mechanisms include timestamp for aggregation

### Label-Based Capture

- [ ] `retro` label can be added to any work item
- [ ] Label flags item for retrospective discussion
- [ ] Label preserved after work item closed
- [ ] Query: `gh issue list --label "retro" --state all`

### Comment-Based Capture

- [ ] Retro comment uses standard format
- [ ] Format: `## Retrospective Item\n[description]\n\nCategory: [process|tooling|workflow]`
- [ ] Comments searchable in aggregation query

### Linked Issue Capture

- [ ] New issue created with `work-type:retro-item` label
- [ ] Issue body references source work item
- [ ] Issue assigned appropriate priority for triage
- [ ] Issue tracked separately from source work

### Aggregation Queries

- [ ] CLI query for all retro-flagged items
- [ ] Filter by date range (sprint boundary)
- [ ] Filter by category if comment-based
- [ ] Output suitable for retrospective facilitation

### Ceremony Integration (Scrum Mode)

- [ ] Sprint Retrospective: Query retro items from sprint period
- [ ] Items displayed with source context
- [ ] After retrospective: Items marked as discussed
- [ ] Improvement issues created from discussion

### Guidance on When to Capture

- [ ] Skill provides examples of retro-worthy items
- [ ] Categories: process friction, tooling issues, workflow gaps
- [ ] Guidance: "Capture if you'd want to discuss with team"
- [ ] Not for: bugs, features, technical debt (use appropriate labels)

## Error Handling Scenarios

### Scenario: User declines retro prompt

**Expected behaviour:**

- [ ] Skill accepts decline without requiring justification
- [ ] Work item closes normally
- [ ] No retro item created
- [ ] Continue to branch cleanup

### Scenario: Retro label already exists on issue

**Expected behaviour:**

- [ ] Skip retro prompt (already flagged)
- [ ] Note: "Retro item already flagged"
- [ ] Proceed to close work item

### Scenario: Linked retro issue creation fails

**Expected behaviour:**

- [ ] Fall back to comment-based capture
- [ ] Notify user of fallback
- [ ] Do not block work item closure

## Verification Checklist

### Workflow Integration

- [ ] Step 20 includes retrospective prompt
- [ ] Prompt occurs after DoD validation, before close
- [ ] Skip mechanism documented
- [ ] All three capture mechanisms documented

### Process Models Reference

- [ ] Kanban: Retro items aggregated periodically
- [ ] Scrum: Integration with Sprint Retrospective ceremony
- [ ] Aggregation query examples provided

### CLI Commands

- [ ] Label addition command documented
- [ ] Comment format template provided
- [ ] Linked issue creation command documented
- [ ] Aggregation query examples provided
