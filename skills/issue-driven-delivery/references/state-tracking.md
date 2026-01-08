# Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility:

## Lifecycle States

1. **New Feature**: Initial state when work item created
2. **Grooming**: During backlog triage and preparation
3. **Refinement**: During planning, brainstorming, requirements gathering
4. **Implementation**: During active development and execution
5. **Verification**: During testing, review, and validation
6. **Complete**: Final state when work item closed

## State Transitions

- **New → Grooming**: When issue enters active backlog review
- **Grooming → Refinement**: When all grooming activities complete
- **Refinement → Implementation**: When plan is approved
- **Implementation → Verification**: When all sub-tasks complete and testing begins
- **Verification → Complete**: When all acceptance criteria met and work item closed

## Platform-Specific Implementation

**GitHub**: Use state labels

- `state:new-feature`, `state:grooming`, `state:refinement`, `state:implementation`,
  `state:verification`

**Azure DevOps**: Use work item state field

- New → Active (Refinement) → Resolved (Implementation/Verification) → Closed

**Jira**: Use issue status

- To Do → In Planning → In Progress → In Review → Done

## When to Update State

- Set `state:grooming` when issue enters active backlog review
- Set `state:refinement` when all grooming activities complete and plan creation begins
- Set `state:implementation` immediately after plan approval
- Set `state:verification` when implementation complete and testing begins
- Set `state:complete` / close work item only after all acceptance criteria met
