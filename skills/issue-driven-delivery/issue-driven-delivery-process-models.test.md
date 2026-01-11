# Issue-Driven Delivery - Process Models Test

## Scenario: Sprint/Iteration Boundary Support

Validates that the skill supports both Kanban (default) and Scrum (optional) process models.

## Given

- A team using issue-driven-delivery skill
- Team may use Kanban continuous flow OR Scrum time-boxed iterations

## Acceptance Criteria

### Process Model Documentation

- [x] Skill documents Kanban as the default/preferred model
- [x] Skill provides optional sprint boundary configuration
- [x] Process model choice documented in ways-of-working or ADR reference

### Sprint Boundary Handling

- [x] Guidance exists for work spanning sprint boundaries (carryover)
- [x] Sprint backlog vs product backlog distinction documented
- [x] Mid-sprint scope change handling documented
- [x] Sprint commitment rules documented (optional for Scrum mode)

### Ceremony Integration Points

- [x] Daily standup touchpoint documented
- [x] Sprint planning touchpoint documented
- [x] Sprint review touchpoint documented
- [x] Sprint retrospective touchpoint documented
- [x] Ceremonies are optional (only apply when Scrum mode enabled)

### Configuration

- [x] Clear toggle/configuration for enabling Scrum mode
- [x] Reference document for process model details exists
- [x] Ways-of-working template includes process model choice

## Then

Sprint/iteration boundary support enables teams using time-boxed iterations to use issue-driven-delivery
while maintaining Kanban as the recommended default for continuous flow teams.

## Verification Evidence

```bash
# Verify process-models reference document exists
ls skills/issue-driven-delivery/references/process-models.md
# Result: File exists

# Verify SKILL.md references process models
grep -ci "kanban\|scrum\|sprint\|ceremony" skills/issue-driven-delivery/SKILL.md
# Result: 10+ matches

# Verify Kanban documented as default
grep -c "Kanban.*default\|default.*Kanban\|Kanban (Default)" skills/issue-driven-delivery/references/process-models.md
# Result: 2 matches

# Verify ceremony sections exist
grep -c "Daily Standup\|Sprint Planning\|Sprint Review\|Sprint Retrospective" skills/issue-driven-delivery/references/process-models.md
# Result: 8 matches (title + table)

# Verify sprint boundary handling
grep -c "Carryover\|Sprint Backlog\|Mid-Sprint" skills/issue-driven-delivery/references/process-models.md
# Result: 7+ matches
```

## Notes

- Kanban continuous flow is preferred - emphasize pull-based work and WIP limits
- Scrum ceremonies integrate at transition points (state changes, approvals)
- Sprint boundaries are advisory - work items can carry over with proper handling
