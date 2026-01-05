# Component Tagging

Every work item must be tagged with the component or component type it impacts.

## Tagging Strategy

**Skills repository**: Use `skill` label/tag

**Application repository**: Use component labels like `api`, `ui`, `database`, `auth`

**Multi-project repository**: Use project labels like `project-a`, `project-b`

## Platform-Specific Implementation

**GitHub**: Use labels

- Example: `skill`, `component:api`, `type:documentation`

**Azure DevOps**: Use tags or area path

- Example tags: `skill`, `api`, `ui`
- Example area path: `ProjectName\API\Authentication`

**Jira**: Use components or labels

- Example components: Skills, API, UI
- Example labels: skill, api-component, documentation

## Enforcement

- Verify component tag exists before closing work item
- Stop with error if work item has no component tag
- Suggest appropriate component based on file changes

## Automatic Tagging

When creating a new work item, analyze the repository structure and suggest
appropriate component tags:

- If `skills/` directory exists → suggest `skill` tag
- If `src/api/` exists → suggest `api` tag
- If `docs/` changes → suggest `documentation` tag

## Priority Tagging

Every work item should have a priority tag indicating urgency and importance.

### Priority Levels

| Level | Name         | Description                                     | Examples                                  |
| ----- | ------------ | ----------------------------------------------- | ----------------------------------------- |
| P0    | Critical     | System down, data loss, security breach         | Production outage, security vulnerability |
| P1    | High         | Major functionality broken, blocking other work | Core feature broken, build failing        |
| P2    | Medium       | Important but not urgent, has workarounds       | Enhancement, non-critical bug             |
| P3    | Low          | Nice to have, minimal impact                    | Minor UI improvement, typo fix            |
| P4    | Nice-to-have | Future consideration, low priority              | Feature idea, optimisation                |

### When to Apply

- **P0-P1**: Requires immediate attention, should be worked on now
- **P2**: Normal priority, part of regular backlog
- **P3-P4**: Low priority, work on when time permits

### Platform-Specific Implementation

**GitHub:**

- Labels: `priority:p0`, `priority:p1`, `priority:p2`, `priority:p3`, `priority:p4`

**Azure DevOps:**

- Tags: `P0`, `P1`, `P2`, `P3`, `P4`
- OR use Priority field: Critical, High, Medium, Low

**Jira:**

- Priority field: Highest, High, Medium, Low, Lowest
- OR labels: `priority-p0`, `priority-p1`, etc.
