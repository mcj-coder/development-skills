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

## Enforcement Rules

### Mandatory Tags (Before Closing)

**Always required:**

- **Component tag**: Which component/area this affects
- **Work type tag**: Type of work (new-feature, bug, etc.)
- **Priority tag**: Priority level (P0-P4)

**Required when applicable:**

- **Blocked tag**: If work is currently blocked (with comment)

### Enforcement Actions

**Before closing work item:**

1. Verify all mandatory tags exist
2. If blocked tag exists, verify blocking comment exists
3. Stop with error if any mandatory tag missing
4. Suggest appropriate tags based on:
   - File changes (for component)
   - Issue title/body (for work type)
   - Severity/urgency keywords (for priority)

**For blocked work items:**

1. Verify work item is assigned
2. Prevent unassignment (can reassign, cannot unassign)
3. Verify blocking comment exists
4. Error if blocked tag without comment

### Error Messages

**Missing component tag:**

```text
ERROR: Cannot close work item without component tag.
Suggestion: Based on file changes, consider: 'component:api', 'skill'
```

**Missing work type tag:**

```text
ERROR: Cannot close work item without work type tag.
Suggestion: Based on issue title, consider: 'work-type:bug', 'work-type:enhancement'
```

**Missing priority tag:**

```text
ERROR: Cannot close work item without priority tag.
Suggestion: Based on issue severity, consider: 'priority:p2' (Medium)
```

**Blocked without comment:**

```text
ERROR: Work item tagged as 'blocked' but no blocking comment found.
Required: Post comment explaining what is blocking this work.
```

**Blocked work item unassigned:**

```text
ERROR: Cannot unassign blocked work item.
Blocked work must remain assigned for accountability.
To proceed: Either (1) remove blocked tag if no longer blocked, or (2) reassign to another person.
```

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

## Blocked Status Tagging

Work items that are blocked (cannot proceed) must be tagged and require a comment explaining what's blocking them.

### When to Apply Blocked Tag

Apply `blocked` tag when:

- Waiting for external dependency (API, service, library)
- Blocked by another work item that must complete first
- Blocked by decision needed from stakeholder
- Blocked by missing information or access

### Requirements for Blocked Tag

1. **Add blocked tag/label**
2. **Post comment explaining blocker** with:
   - What is blocking this work
   - Blocker ID (if another work item: link to it)
   - What's needed to unblock
   - Who can help unblock

3. **Keep work item assigned**
   - Blocked work must remain assigned (accountability)
   - Can reassign to someone else if appropriate
   - Cannot unassign (prevents abandonment)

### Clearing Blocked Status

When blocker is resolved:

1. Post comment confirming blocker resolved
2. Remove blocked tag/label
3. Update work item state to resume work

### Platform-Specific Implementation

**GitHub:**

- Label: `blocked`
- Comment with blocker details
- Use "blocked by #123" syntax for work item blockers

**Azure DevOps:**

- Tag: `blocked`
- Comment with blocker details
- Can use "Related Work" links for blockers

**Jira:**

- Label: `blocked`
- OR custom status: "Blocked"
- Comment with blocker details
- Use "blocks"/"is blocked by" link types
