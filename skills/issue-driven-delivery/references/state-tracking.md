# Work Item State Tracking

Update work item state throughout the delivery lifecycle to maintain visibility:

## Lifecycle States

1. **New Feature**: Initial state when work item created
2. **Refinement**: During planning, brainstorming, requirements gathering
3. **Implementation**: During active development and execution
4. **Verification**: During testing, review, and validation
5. **Complete**: Final state when work item closed

## State Transitions

- **New → Refinement**: When plan creation begins
- **Refinement → Implementation**: When plan is approved
- **Implementation → Verification**: When all sub-tasks complete and testing begins
- **Verification → Complete**: When all acceptance criteria met and work item closed

## Platform-Specific Implementation

**GitHub**: Use state labels

- `state:new-feature`, `state:refinement`, `state:implementation`, `state:verification`

**Azure DevOps**: Use work item state field

- New → Active (Refinement) → Resolved (Implementation/Verification) → Closed

**Jira**: Use issue status

- To Do → In Planning → In Progress → In Review → Done

## When to Update State

- Set `state:refinement` when creating the plan
- Set `state:implementation` immediately after plan approval
- Set `state:verification` when implementation complete and testing begins
- Set `state:complete` / close work item only after all acceptance criteria met
