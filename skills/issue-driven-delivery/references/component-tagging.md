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
