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
