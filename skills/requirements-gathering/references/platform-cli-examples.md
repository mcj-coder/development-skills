# Platform CLI Examples

## Platform Detection

### Check repository README for taskboard URL

```bash
grep -E "(github.com|dev.azure.com|atlassian.net)" README.md
```

### Check git remote URL

```bash
git remote get-url origin
```

### Platform Mapping Table

| Platform     | Domain patterns                     | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

## Creating Tickets

### GitHub

```bash
gh issue create --title "Goal statement" --body "$(cat <<'EOF'
## Goal
[One sentence goal]

## Requirements
1. [Requirement 1]
2. [Requirement 2]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Context
[Background and constraints]
EOF
)"
```

### Azure DevOps

```bash
ado workitems create \
  --type "User Story" \
  --title "Goal statement" \
  --description "$(cat <<'EOF'
## Goal
[One sentence goal]

## Requirements
1. [Requirement 1]
2. [Requirement 2]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Context
[Background and constraints]
EOF
)"
```

### Jira

```bash
jira issue create \
  --type Story \
  --summary "Goal statement" \
  --description "$(cat <<'EOF'
## Goal
[One sentence goal]

## Requirements
1. [Requirement 1]
2. [Requirement 2]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Context
[Background and constraints]
EOF
)"
```

## Component Tagging

### GitHub - Add component label

```bash
gh issue edit <number> --add-label "skill"
gh issue edit <number> --add-label "component:api"
gh issue edit <number> --add-label "type:documentation"
```

### Azure DevOps - Add tags

```bash
ado workitems update --id <id> --tags "skill"
ado workitems update --id <id> --tags "api,documentation"
```

### Jira - Add component or label

```bash
jira issue edit <key> --component "Skills"
jira issue edit <key> --labels "skill,api-component,documentation"
```

## Component Tag Suggestions

Based on repository structure:

- If `skills/` directory exists → `skill` tag
- If `src/api/` exists → `api` tag
- If `src/ui/` exists → `ui` tag
- If `docs/` changes → `documentation` tag
- If tests modified → `testing` tag

## Creating Epics

### GitHub - Create Epic with Mermaid Graph

```bash
gh issue create --title "Epic: [Title]" --body "$(cat <<'EOF'
## Goal

[Epic goal statement]

## Child Tickets

- [ ] #TBD - [Child 1 title]
- [ ] #TBD - [Child 2 title]
- [ ] #TBD - [Child 3 title]

## Dependency Graph

\`\`\`mermaid
flowchart TD
    A[#1 Child 1] --> B[#2 Child 2]
    B --> C[#3 Child 3]
\`\`\`

## Feature Flags

| Flag | Introduced In | Purpose | Status |
| ---- | ------------- | ------- | ------ |
| —    | —             | —       | —      |

Cleanup ticket: TBD
EOF
)" --label "epic"
```

### Azure DevOps - Create Epic Work Item

```bash
az boards work-item create \
  --type "Epic" \
  --title "[Epic Title]" \
  --description "$(cat <<'EOF'
## Goal

[Epic goal statement]

## Acceptance Criteria

- [ ] All child work items completed
- [ ] All feature flags removed
EOF
)"
```

### Jira - Create Epic Issue

```bash
jira issue create \
  --type Epic \
  --summary "[Epic Title]" \
  --description "$(cat <<'EOF'
## Goal

[Epic goal statement]

## Child Issues

Will be linked after creation.
EOF
)"
```

## Linking Dependencies

### GitHub - Add Blocker Reference in Body

GitHub doesn't have native dependency tracking. Use body text:

```bash
# When creating child issue, include blocker in body
gh issue create --title "[Title]" --body "$(cat <<'EOF'
**Blocked by:** #[BLOCKER_NUMBER]

## Goal

[Goal statement]

## Requirements

1. [Requirement]

## Acceptance Criteria

- [ ] [Criterion]
EOF
)"
```

### Azure DevOps - Add Predecessor Link

```bash
# Add predecessor (blocker) relationship
az boards work-item relation add \
  --id [WORK_ITEM_ID] \
  --relation-type "System.LinkTypes.Dependency-Reverse" \
  --target-id [BLOCKER_ID]
```

### Jira - Add Blocks Link

```bash
# Add "is blocked by" link
jira issue link [ISSUE_KEY] [BLOCKER_KEY] "is blocked by"
```

## Updating Epic After Child Creation

### GitHub - Update Epic Body with Child Numbers

```bash
# After creating children, update epic body with actual issue numbers
gh issue edit [EPIC_NUMBER] --body "$(cat <<'EOF'
## Goal

[Epic goal statement]

## Child Tickets

- [ ] #101 - Database Schema
- [ ] #102 - API Endpoints
- [ ] #103 - UI Components
- [ ] #104 - Feature Flag Cleanup

## Dependency Graph

\`\`\`mermaid
flowchart TD
    A[#101 Schema] --> B[#102 API]
    B --> C[#103 UI]
    C --> D[#104 Cleanup]
\`\`\`

## Feature Flags

| Flag              | Introduced In | Purpose          | Status |
| ----------------- | ------------- | ---------------- | ------ |
| `FEATURE_ENABLED` | #103          | Hide until ready | Active |

Cleanup ticket: #104
EOF
)"
```

## CLI Verification

### GitHub

```bash
gh auth status
```

Expected output:

```text
✓ Logged in to github.com as username
✓ Token: *******************
```

### Azure DevOps

```bash
ado login --check
```

Expected output:

```text
You are logged in to organization 'orgname'
```

### Jira

```bash
jira me
```

Expected output:

```text
username
user@example.com
```
