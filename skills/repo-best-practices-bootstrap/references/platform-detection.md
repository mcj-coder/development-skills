# Platform Detection

This document describes how to detect the hosting platform for a repository and
determine CLI tool availability.

## Supported Platforms

| Platform     | CLI Tool   | Support Level | Notes                             |
| ------------ | ---------- | ------------- | --------------------------------- |
| GitHub       | `gh`       | Full          | Primary platform for MVP          |
| Azure DevOps | `az repos` | Partial       | CLI available, templates deferred |
| GitLab       | `glab`     | Partial       | Some features require API calls   |
| Bitbucket    | (manual)   | Detection     | No CLI support in MVP             |

## Detection Script

Detect platform from git remote URL:

```bash
#!/bin/bash
# Platform detection based on git remote origin

detect_platform() {
  local REMOTE_URL
  REMOTE_URL=$(git config --get remote.origin.url)

  if [[ -z "$REMOTE_URL" ]]; then
    echo "ERROR: No git remote origin configured"
    return 1
  fi

  if [[ "$REMOTE_URL" =~ github\.com ]]; then
    PLATFORM="github"
    CLI_TOOL="gh"
  elif [[ "$REMOTE_URL" =~ dev\.azure\.com|visualstudio\.com ]]; then
    PLATFORM="azuredevops"
    CLI_TOOL="az repos"
  elif [[ "$REMOTE_URL" =~ gitlab\.com|gitlab\. ]]; then
    PLATFORM="gitlab"
    CLI_TOOL="glab"
  elif [[ "$REMOTE_URL" =~ bitbucket\.org ]]; then
    PLATFORM="bitbucket"
    CLI_TOOL="manual"
  else
    PLATFORM="unknown"
    CLI_TOOL="manual"
  fi

  echo "Platform: $PLATFORM"
  echo "CLI Tool: $CLI_TOOL"
}

# Run detection
detect_platform
```

## Remote URL Patterns

### GitHub

```text
https://github.com/{owner}/{repo}.git
git@github.com:{owner}/{repo}.git
ssh://git@github.com/{owner}/{repo}.git
```

**Regex:** `github\.com`

### Azure DevOps

```text
https://dev.azure.com/{org}/{project}/_git/{repo}
https://{org}.visualstudio.com/{project}/_git/{repo}
git@ssh.dev.azure.com:v3/{org}/{project}/{repo}
```

**Regex:** `dev\.azure\.com|visualstudio\.com`

### GitLab

```text
https://gitlab.com/{group}/{repo}.git
git@gitlab.com:{group}/{repo}.git
https://gitlab.{company}.com/{group}/{repo}.git  # Self-hosted
```

**Regex:** `gitlab\.com|gitlab\.`

### Bitbucket

```text
https://bitbucket.org/{workspace}/{repo}.git
git@bitbucket.org:{workspace}/{repo}.git
```

**Regex:** `bitbucket\.org`

## CLI Tool Requirements

### GitHub CLI (gh)

```bash
# Installation check
gh --version

# Authentication check
gh auth status

# Required scopes for this skill
# - repo (full control of private repositories)
# - read:org (for organization settings)
# - admin:repo_hook (for branch protection)
```

**Installation:** <https://cli.github.com/>

### Azure CLI with DevOps Extension

```bash
# Installation check
az version
az repos --help

# Authentication check
az account show

# Install DevOps extension if needed
az extension add --name azure-devops
```

**Installation:** <https://docs.microsoft.com/en-us/cli/azure/>

### GitLab CLI (glab)

```bash
# Installation check
glab version

# Authentication check
glab auth status

# Note: Some features require API calls via 'glab api'
# Protected branches, push rules, etc. don't have direct CLI commands
```

**Installation:** <https://gitlab.com/gitlab-org/cli>

### Bitbucket

No official CLI. Manual configuration required via web UI or API.

## Fallback Behavior

When CLI tool is not available or platform is unsupported:

1. **Warn user:** "Platform detected as {platform}, but CLI tool is not available"
2. **Offer alternatives:**
   - Manual configuration via web UI
   - API-based commands (if auth available)
   - Skip platform-dependent features
3. **Continue with documentation-only items:** SECURITY.md, CONTRIBUTING.md, etc.

## CLI Authentication Verification

Before running checklist, verify CLI authentication:

```bash
verify_cli_auth() {
  case "$PLATFORM" in
    github)
      gh auth status 2>/dev/null || {
        echo "GitHub CLI not authenticated. Run: gh auth login"
        return 1
      }
      ;;
    azuredevops)
      az account show 2>/dev/null || {
        echo "Azure CLI not authenticated. Run: az login"
        return 1
      }
      ;;
    gitlab)
      glab auth status 2>/dev/null || {
        echo "GitLab CLI not authenticated. Run: glab auth login"
        return 1
      }
      ;;
    *)
      echo "No CLI authentication required for $PLATFORM"
      ;;
  esac
}
```

## Platform-Specific Limitations

### GitLab API Requirements

The following features require `glab api` calls instead of direct CLI commands:

- Protected branch configuration
- Push rules (signed commits)
- Merge request approval rules
- Project-level settings

Example API call:

```bash
# Protect branch via API
glab api projects/{project-id}/protected_branches \
  --method POST \
  -f name=main \
  -f push_access_level=0 \
  -f merge_access_level=30
```

### Azure DevOps Limitations

- Some policies require project-level permissions
- Build policies require existing pipeline definitions
- Branch policies use different ID schemes than GitHub

### Bitbucket Limitations

- No official CLI tool
- API-only configuration
- May require Bitbucket Pipelines for CI/CD features
