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

## Work Type Tagging

Every work item must be tagged with its work type. This enables filtering by type of work and helps with metrics tracking.

### Work Type Taxonomy

| Type           | Description                                   | Example Issues                             |
| -------------- | --------------------------------------------- | ------------------------------------------ |
| new-feature    | New functionality that didn't exist before    | Add dark mode, implement OAuth             |
| enhancement    | Improvement to existing functionality         | Improve search performance, add filtering  |
| bug            | Defect that needs fixing                      | Fix login error, resolve crash             |
| tech-debt      | Technical debt remediation                    | Refactor legacy code, upgrade dependencies |
| documentation  | Documentation changes only                    | Update README, add API docs                |
| refactoring    | Code restructuring without behaviour change   | Extract methods, rename variables          |
| infrastructure | Build, deploy, CI/CD, tooling changes         | Add GitHub Actions, configure linting      |
| chore          | Maintenance tasks not affecting functionality | Update dependencies, fix typos             |

### Work Type Guidelines

**new-feature vs enhancement:**

- new-feature: Adds capability that didn't exist (e.g., "Add user authentication")
- enhancement: Improves existing capability (e.g., "Add password strength indicator to existing login")

**bug vs tech-debt:**

- bug: Visible defect affecting users now
- tech-debt: Code quality issue that could cause problems later

**refactoring vs chore:**

- refactoring: Restructures code logic/architecture
- chore: Updates dependencies, configs, build scripts

### Platform-Specific Implementation

**GitHub:**

- Labels: `work-type:new-feature`, `work-type:bug`, `work-type:tech-debt`, etc.
- Can also use: `new-feature`, `bug`, `tech-debt` (simpler, already in use)

**Azure DevOps:**

- Work Item Type: Bug, User Story, Task, Technical Debt
- OR tags: `new-feature`, `enhancement`, `bug`, etc.

**Jira:**

- Issue Type: Story, Bug, Task, Technical Debt
- OR labels: `work-type-feature`, `work-type-bug`, etc.
