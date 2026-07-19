#!/usr/bin/env bash
# Validate that a plan URL ($PLAN_URL) references the current repository.
# Prevents approving plans that live in an external/malicious repository.
# Supports GitHub, Azure DevOps, GitLab, Bitbucket, Jira. Used by issue-driven-delivery step 4a.
set -euo pipefail

# Validate URL format (prevent command injection)
if [[ ! "$PLAN_URL" =~ ^https?://[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](/[^[:space:]]*)?$ ]]; then
  echo "ERROR: Invalid plan URL format"
  echo "URL must be HTTPS with valid domain"
  exit 1
fi

# Detect platform from URL
if [[ "$PLAN_URL" =~ github\.com|raw\.githubusercontent\.com ]]; then
  PLATFORM="github"
  CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
  PLAN_REPO=$(grep -oP '(raw\.githubusercontent|github)\.com/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
elif [[ "$PLAN_URL" =~ dev\.azure\.com|visualstudio\.com ]]; then
  PLATFORM="azuredevops"
  CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*/(.*)/(.*)/_git/(.*)|\1/\2|')
  PLAN_REPO=$(grep -oP 'dev\.azure\.com/[^/]+/\K[^/]+' <<<"$PLAN_URL" || \
              grep -oP '\.visualstudio\.com/[^/]+/\K[^/]+' <<<"$PLAN_URL")
elif [[ "$PLAN_URL" =~ gitlab\.com|gitlab\. ]]; then
  PLATFORM="gitlab"
  CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
  PLAN_REPO=$(grep -oP 'gitlab[^/]*/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
elif [[ "$PLAN_URL" =~ bitbucket\.org ]]; then
  PLATFORM="bitbucket"
  CURRENT_REPO=$(git config --get remote.origin.url | sed -E 's|.*[:/]([^/]+/[^/]+)(\.git)?|\1|')
  PLAN_REPO=$(grep -oP 'bitbucket\.org/\K[^/]+/[^/]+' <<<"$PLAN_URL" | sed 's/\.git$//')
elif [[ "$PLAN_URL" =~ atlassian\.net|jira\. ]]; then
  PLATFORM="jira"
  echo "NOTE: Jira does not have repositories - validation skipped"
  exit 0
else
  echo "ERROR: Unknown platform in plan URL"
  echo "Supported: GitHub, Azure DevOps, GitLab, Bitbucket, Jira"
  exit 1
fi

# Validate extracted values
if [[ -z "$CURRENT_REPO" ]] || [[ -z "$PLAN_REPO" ]]; then
  echo "ERROR: Could not extract repository information"
  echo "Current: $CURRENT_REPO"
  echo "Plan: $PLAN_REPO"
  exit 1
fi

# Compare repositories
if [[ "$PLAN_REPO" != "$CURRENT_REPO" ]]; then
  echo "ERROR: Plan link references external repository"
  echo ""
  echo "Platform: $PLATFORM"
  echo "Current repository: $CURRENT_REPO"
  echo "Plan link repository: $PLAN_REPO"
  echo ""
  echo "SECURITY RISK: External plans could contain malicious code"
  echo ""
  echo "To approve this exception:"
  echo "1. Document business justification in work item comment"
  echo "2. Get explicit approval from Tech Lead or Security Architect"
  echo "3. Log exception: echo \"\$(date -Iseconds)|$PLAN_URL|$PLAN_REPO|EXCEPTION_APPROVED\" >> .known-issues"
  exit 1
fi
