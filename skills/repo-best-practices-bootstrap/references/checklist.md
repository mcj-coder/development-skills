# Repository Best Practices Checklist

This checklist covers 6 categories of repository best practices. Each item includes
platform-specific CLI commands for GitHub (primary), Azure DevOps, and GitLab.

**Legend:**

- **Cost:** Free / Paid (indicates if feature requires paid plan)
- **Opt-out:** Category or feature ID for opt-out configuration

## 1. Repository Security

### 1.1 Branch Protection Rules

**Description:** Protect main/master branch from direct pushes and require reviews.

**Cost:** Free

**Opt-out:** `repository-security` (category) or `branch-protection` (feature)

**GitHub (Classic Branch Protection):**

```bash
# Check current protection
gh api repos/{owner}/{repo}/branches/main/protection --jq '.'

# Enable branch protection
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":[]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

**GitHub (Modern Repository Rulesets - recommended for new repos):**

```bash
# List existing rulesets
gh api repos/{owner}/{repo}/rulesets --jq '.[].name'

# Create ruleset (see templates/github/ruleset.json for full template)
gh api repos/{owner}/{repo}/rulesets --method POST --input ruleset.json
```

**Azure DevOps:**

```bash
# List branch policies
az repos policy list --repository {repo} --branch main

# Create minimum approvers policy
az repos policy approver-count create \
  --repository-id {repo-id} \
  --branch main \
  --minimum-approver-count 1 \
  --enabled true
```

**GitLab (via API - no native CLI):**

```bash
# List protected branches
glab api projects/{project-id}/protected_branches

# Protect branch
glab api projects/{project-id}/protected_branches \
  --method POST \
  -f name=main \
  -f push_access_level=0 \
  -f merge_access_level=30
```

### 1.2 Signed Commits

**Description:** Require or recommend GPG/SSH signed commits for verification.

**Cost:** Free

**Opt-out:** `repository-security` (category) or `signed-commits` (feature)

**GitHub:**

```bash
# Check if signed commits required (part of branch protection)
gh api repos/{owner}/{repo}/branches/main/protection/required_signatures

# Enable signed commits requirement
gh api repos/{owner}/{repo}/branches/main/protection/required_signatures \
  --method POST
```

**Azure DevOps:**

```bash
# Azure DevOps doesn't have native signed commits requirement
# Use policy to require commits from specific identities
az repos policy required-reviewer create \
  --repository-id {repo-id} \
  --branch main \
  --required-reviewer-ids {user-ids}
```

**GitLab (via API):**

```bash
# Enable push rules for signed commits (Premium/Ultimate)
glab api projects/{project-id}/push_rule \
  --method PUT \
  -f reject_unsigned_commits=true
```

### 1.3 Secret Scanning

**Description:** Enable secret scanning to detect accidentally committed secrets.

**Cost:** Free (public repos) / Paid (private repos on GitHub Advanced Security)

**Opt-out:** `repository-security` (category) or `secret-scanning` (feature)

**GitHub:**

```bash
# Check secret scanning status
gh api repos/{owner}/{repo} --jq '.security_and_analysis.secret_scanning.status'

# Enable secret scanning (requires GHAS for private repos)
gh api repos/{owner}/{repo} \
  --method PATCH \
  -f security_and_analysis='{"secret_scanning":{"status":"enabled"}}'

# Enable push protection
gh api repos/{owner}/{repo} \
  --method PATCH \
  -f security_and_analysis='{"secret_scanning_push_protection":{"status":"enabled"}}'
```

**Azure DevOps:**

```bash
# Azure DevOps uses Microsoft Defender for DevOps
# Configure via Azure Portal or:
az security setting update \
  --name DevOpsSecurityConnector \
  --alert-notifications enabled
```

**GitLab:**

```bash
# Secret detection is part of GitLab CI/CD
# Add to .gitlab-ci.yml:
# include:
#   - template: Security/Secret-Detection.gitlab-ci.yml
```

### 1.4 Vulnerability Alerts

**Description:** Enable Dependabot/vulnerability scanning for dependencies.

**Cost:** Free

**Opt-out:** `repository-security` (category) or `vulnerability-alerts` (feature)

**GitHub:**

```bash
# Check Dependabot alerts status
gh api repos/{owner}/{repo}/vulnerability-alerts --method GET

# Enable Dependabot alerts
gh api repos/{owner}/{repo}/vulnerability-alerts --method PUT

# Enable Dependabot security updates
gh api repos/{owner}/{repo} \
  --method PATCH \
  -f security_and_analysis='{"dependabot_security_updates":{"status":"enabled"}}'
```

**Azure DevOps:**

```bash
# Use Azure DevOps dependency scanning extension or Defender
# Configure via project settings or:
az devops extension install \
  --extension-id dependencycheck \
  --publisher-id dependency-check
```

**GitLab:**

```bash
# Dependency scanning is part of GitLab CI/CD
# Add to .gitlab-ci.yml:
# include:
#   - template: Security/Dependency-Scanning.gitlab-ci.yml
```

### 1.5 Security Policy

**Description:** Create SECURITY.md with vulnerability reporting instructions.

**Cost:** Free

**Opt-out:** `repository-security` (category) or `security-policy` (feature)

**All Platforms:**

```bash
# Check if SECURITY.md exists
test -f SECURITY.md && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/SECURITY.md.template SECURITY.md
git add SECURITY.md
git commit -m "docs: add security policy"
```

See [SECURITY.md template](../templates/common/SECURITY.md.template) for standard format.

## 2. CI/CD Security

### 2.1 Actions Permissions

**Description:** Configure least-privilege permissions for CI/CD workflows.

**Cost:** Free

**Opt-out:** `ci-cd-security` (category) or `actions-permissions` (feature)

**GitHub:**

```bash
# Check repository workflow permissions
gh api repos/{owner}/{repo}/actions/permissions --jq '.'

# Set default token permissions to read-only
gh api repos/{owner}/{repo}/actions/permissions \
  --method PUT \
  -f default_workflow_permissions=read

# Require approval for fork PRs
gh api repos/{owner}/{repo}/actions/permissions/access \
  --method PUT \
  -f access_level=none
```

**Workflow permissions block:**

```yaml
# Add to every workflow file
permissions:
  contents: read
  # Add only permissions needed
```

See [CI workflow template](../templates/github/workflows/ci.yml) for example.

**Azure DevOps:**

```bash
# Set pipeline permissions
az pipelines update \
  --id {pipeline-id} \
  --project {project} \
  --authorized false
```

**GitLab:**

```bash
# Configure CI/CD job token permissions
# In .gitlab-ci.yml or project settings:
# CI_JOB_TOKEN scope can be restricted via Project > Settings > CI/CD
```

### 2.2 OIDC for Deployments

**Description:** Use OIDC tokens instead of long-lived secrets for cloud deployments.

**Cost:** Free (cloud provider may have costs)

**Opt-out:** `ci-cd-security` (category) or `oidc-deployments` (feature)

**GitHub:**

```bash
# OIDC is configured per cloud provider
# AWS: Create OIDC identity provider
# Azure: Configure federated credentials
# GCP: Create workload identity pool
```

See [OIDC deploy template](../templates/github/workflows/oidc-deploy.yml) for AWS/Azure/GCP examples.

**Azure DevOps:**

```bash
# Use workload identity federation
az devops service-endpoint create \
  --service-endpoint-configuration oidc-config.json
```

**GitLab:**

```bash
# GitLab supports OIDC via CI_JOB_JWT
# Configure ID token in .gitlab-ci.yml:
# id_tokens:
#   GITLAB_OIDC_TOKEN:
#     aud: https://gitlab.com
```

### 2.3 Artifact Signing

**Description:** Sign build artifacts using Sigstore/cosign for supply chain security.

**Cost:** Free (Sigstore is free and open source)

**Opt-out:** `ci-cd-security` (category) or `artifact-signing` (feature)

**GitHub:**

```yaml
# Add to workflow
- name: Sign artifact
  uses: sigstore/cosign-installer@v3
- run: cosign sign-blob --yes artifact.tar.gz
```

**All Platforms:**

```bash
# Install cosign
# https://docs.sigstore.dev/cosign/installation/

# Sign a container image (keyless with OIDC)
cosign sign --yes ghcr.io/{owner}/{repo}:latest

# Sign a blob
cosign sign-blob --yes artifact.tar.gz > artifact.tar.gz.sig
```

### 2.4 Supply Chain Security (SLSA)

**Description:** Generate SLSA provenance for builds to verify artifact origins.

**Cost:** Free

**Opt-out:** `ci-cd-security` (category) or `slsa-provenance` (feature)

**GitHub:**

```yaml
# Use SLSA GitHub Generator
- uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v1
  with:
    base64-subjects: "${{ needs.build.outputs.digests }}"
```

See [SLSA Framework](https://slsa.dev/) for SLSA levels and requirements.

### 2.5 Workflow Approval for Forks

**Description:** Require approval before running workflows from fork PRs.

**Cost:** Free

**Opt-out:** `ci-cd-security` (category) or `fork-workflow-approval` (feature)

**GitHub:**

```bash
# Check current setting
gh api repos/{owner}/{repo}/actions/permissions --jq '.allowed_actions'

# Require approval for first-time contributors
gh api repos/{owner}/{repo} \
  --method PATCH \
  -f fork_pull_request_workflows_run_approval_policy=require_first_time_contributor_approval
```

## 3. Code Quality Gates

### 3.1 Required Reviews

**Description:** Require minimum number of reviewers before merge.

**Cost:** Free

**Opt-out:** `code-quality` (category) or `required-reviews` (feature)

**GitHub:**

```bash
# Set via branch protection (see 1.1)
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews='{"required_approving_review_count":1}'
```

**Azure DevOps:**

```bash
az repos policy approver-count create \
  --repository-id {repo-id} \
  --branch main \
  --minimum-approver-count 1 \
  --enabled true
```

**GitLab:**

```bash
# Set merge request approvals (Premium/Ultimate for multiple approvers)
glab api projects/{project-id}/approval_rules \
  --method POST \
  -f name="Default" \
  -f approvals_required=1
```

### 3.2 Required Status Checks

**Description:** Require CI checks to pass before merge.

**Cost:** Free

**Opt-out:** `code-quality` (category) or `required-checks` (feature)

**GitHub:**

```bash
# Set via branch protection
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["build","test","lint"]}'
```

**Azure DevOps:**

```bash
az repos policy build create \
  --repository-id {repo-id} \
  --branch main \
  --build-definition-id {pipeline-id} \
  --enabled true \
  --blocking true
```

**GitLab:**

```bash
# Configure via project settings or API
glab api projects/{project-id} \
  --method PUT \
  -f only_allow_merge_if_pipeline_succeeds=true
```

### 3.3 Linting Enforcement

**Description:** Enforce code style via pre-commit hooks.

**Cost:** Free

**Opt-out:** `code-quality` (category) or `linting` (feature)

**All Platforms:**

```bash
# Check if pre-commit config exists
test -f .pre-commit-config.yaml && echo "EXISTS" || echo "MISSING"

# Install pre-commit
pip install pre-commit
pre-commit install
```

See [pre-commit template](../templates/common/.pre-commit-config.yaml) for configuration.

### 3.4 No Direct Commits to Main

**Description:** Prevent direct pushes to main branch.

**Cost:** Free

**Opt-out:** `code-quality` (category) or `no-direct-commits` (feature)

This is enforced via branch protection (see 1.1 Branch Protection Rules).

### 3.5 Conventional Commits (Optional)

**Description:** Enforce conventional commit message format.

**Cost:** Free

**Opt-out:** `code-quality` (category) or `conventional-commits` (feature)

**All Platforms:**

```bash
# Add commitlint to pre-commit or CI
# In .pre-commit-config.yaml:
# - repo: https://github.com/compilerla/conventional-pre-commit
#   hooks:
#     - id: conventional-pre-commit
```

## 4. Documentation Baseline

### 4.1 README.md

**Description:** Comprehensive README with standard sections.

**Cost:** Free

**Opt-out:** `documentation` (category) or `readme` (feature)

**Required sections:**

- Project name and description
- Installation instructions
- Usage examples
- Contributing link
- License

```bash
# Check if README exists
test -f README.md && echo "EXISTS" || echo "MISSING"
```

### 4.2 CONTRIBUTING.md

**Description:** Contribution guidelines for the project.

**Cost:** Free

**Opt-out:** `documentation` (category) or `contributing` (feature)

```bash
# Check if CONTRIBUTING exists
test -f CONTRIBUTING.md && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/CONTRIBUTING.md.template CONTRIBUTING.md
```

See [CONTRIBUTING template](../templates/common/CONTRIBUTING.md.template).

### 4.3 LICENSE

**Description:** Appropriate license file for the project.

**Cost:** Free

**Opt-out:** `documentation` (category) or `license` (feature)

```bash
# Check if LICENSE exists
test -f LICENSE && echo "EXISTS" || echo "MISSING"

# Create via GitHub CLI
gh repo edit --license mit
```

### 4.4 SECURITY.md

**Description:** Security policy with vulnerability reporting process.

**Cost:** Free

**Opt-out:** `documentation` (category) or `security-policy` (feature)

See 1.5 Security Policy for details.

### 4.5 CODEOWNERS (Optional)

**Description:** Define code ownership for automatic review assignment.

**Cost:** Free

**Opt-out:** `documentation` (category) or `codeowners` (feature)

```bash
# Check if CODEOWNERS exists
test -f CODEOWNERS -o -f .github/CODEOWNERS && echo "EXISTS" || echo "MISSING"

# Create from template
mkdir -p .github
cp templates/github/CODEOWNERS.template .github/CODEOWNERS
```

See [CODEOWNERS template](../templates/github/CODEOWNERS.template).

## 5. Agent Enablement

### 5.1 CLAUDE.md

**Description:** Agent onboarding document for Claude Code and similar tools.

**Cost:** Free

**Opt-out:** `agent-enablement` (category) or `claude-md` (feature)

```bash
# Check if CLAUDE.md exists
test -f CLAUDE.md && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/CLAUDE.md.template CLAUDE.md
```

See [CLAUDE.md template](../templates/common/CLAUDE.md.template).

Cross-reference: `skills/skills-first-workflow/references/AGENTS-TEMPLATE.md`

### 5.2 AGENTS.md

**Description:** Agent execution rules and behavioral constraints.

**Cost:** Free

**Opt-out:** `agent-enablement` (category) or `agents-md` (feature)

```bash
# Check if AGENTS.md exists
test -f AGENTS.md && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/AGENTS.md.template AGENTS.md
```

See [AGENTS.md template](../templates/common/AGENTS.md.template).

Cross-reference: `skills/skills-first-workflow/references/AGENTS-TEMPLATE.md`

### 5.3 Skills Bootstrap

**Description:** Configure skill library integration.

**Cost:** Free

**Opt-out:** `agent-enablement` (category) or `skills-bootstrap` (feature)

```bash
# Check for .claude/settings.json or skills references in CLAUDE.md
grep -q "skills" CLAUDE.md && echo "CONFIGURED" || echo "NOT CONFIGURED"
```

### 5.4 Pre-commit Hooks for Agents

**Description:** Linting and validation hooks that run before commits.

**Cost:** Free

**Opt-out:** `agent-enablement` (category) or `agent-hooks` (feature)

```bash
# Check if hooks are installed
test -f .git/hooks/pre-commit && echo "INSTALLED" || echo "NOT INSTALLED"
```

## 6. Development Standards

### 6.1 .editorconfig

**Description:** Consistent editor settings across team.

**Cost:** Free

**Opt-out:** `development-standards` (category) or `editorconfig` (feature)

```bash
# Check if .editorconfig exists
test -f .editorconfig && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/.editorconfig .
```

See [.editorconfig template](../templates/common/.editorconfig).

### 6.2 .gitignore

**Description:** Language-appropriate gitignore configuration.

**Cost:** Free

**Opt-out:** `development-standards` (category) or `gitignore` (feature)

```bash
# Check if .gitignore exists
test -f .gitignore && echo "EXISTS" || echo "MISSING"

# Create from language-specific template
# Options: node.gitignore, dotnet.gitignore, python.gitignore
cp templates/gitignore/{language}.gitignore .gitignore
```

See templates in `templates/gitignore/`.

### 6.3 .gitattributes

**Description:** Git attributes for line endings and diff handling.

**Cost:** Free

**Opt-out:** `development-standards` (category) or `gitattributes` (feature)

```bash
# Check if .gitattributes exists
test -f .gitattributes && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/.gitattributes .
```

See [.gitattributes template](../templates/common/.gitattributes).

### 6.4 Pre-commit Configuration

**Description:** Pre-commit hooks for automated quality checks.

**Cost:** Free

**Opt-out:** `development-standards` (category) or `pre-commit` (feature)

```bash
# Check if pre-commit config exists
test -f .pre-commit-config.yaml && echo "EXISTS" || echo "MISSING"

# Create from template
cp templates/common/.pre-commit-config.yaml .
```

See [pre-commit template](../templates/common/.pre-commit-config.yaml).

### 6.5 CI/CD Pipeline

**Description:** Continuous integration pipeline configuration.

**Cost:** Free (platform provides free tier)

**Opt-out:** `development-standards` (category) or `ci-pipeline` (feature)

**GitHub:**

```bash
# Check if workflow exists
test -d .github/workflows && echo "EXISTS" || echo "MISSING"

# Create from template
mkdir -p .github/workflows
cp templates/github/workflows/ci.yml .github/workflows/
```

See [CI workflow template](../templates/github/workflows/ci.yml).

**Azure DevOps:**

```bash
# Check if pipeline exists
test -f azure-pipelines.yml && echo "EXISTS" || echo "MISSING"
```

**GitLab:**

```bash
# Check if pipeline exists
test -f .gitlab-ci.yml && echo "EXISTS" || echo "MISSING"
```

## 7. Project Management

### 7.1 Project Board Linking

**Description:** Link repository to a project board (kanban/sprint) for work tracking.

**Cost:** Free

**Opt-out:** `project-management` (category) or `project-board` (feature)

**GitHub:**

```bash
# List linked projects
gh api graphql -f query='
{
  repository(owner: "{owner}", name: "{repo}") {
    projectsV2(first: 10) {
      nodes { title url }
    }
  }
}'

# List user/org projects available for linking
gh project list --owner {owner}

# Create project if none exists
gh project create --owner {owner} --title "{repo} Kanban"

# IMPORTANT: Link project to repository (required for repo Projects tab)
gh project link {project-number} --owner {owner} --repo {owner}/{repo}
```

**Note:** Creating a project does NOT automatically link it to the repository.
You must run `gh project link` for the project to appear in the repo's Projects tab.

**Azure DevOps:**

```bash
# Azure repos are always linked to their project's boards
# List work items linked to repository
az boards query --wiql "SELECT [System.Id] FROM WorkItems WHERE [System.TeamProject] = '{project}'"

# Verify board exists
az boards show --board "Kanban Board" --team {team} --project {project}
```

**GitLab:**

```bash
# GitLab uses issue boards per project
# List boards
glab api projects/{project-id}/boards

# Create kanban board if none exists
glab api projects/{project-id}/boards --method POST -f name="Kanban"
```

### 7.2 Kanban/Sprint Board Configuration

**Description:** Configure board columns and workflows for consistent team process.

**Cost:** Free

**Opt-out:** `project-management` (category) or `board-config` (feature)

**GitHub Projects:**

```bash
# List project fields (columns, status)
gh project field-list {project-number} --owner {owner}

# Add standard status field options
# Note: Column configuration done via UI or GraphQL mutations
```

**Recommended columns:**

- Backlog / To Do
- In Progress
- In Review
- Done

**Azure DevOps:**

```bash
# Configure board columns
az boards column update \
  --board "Kanban Board" \
  --column "Doing" \
  --name "In Progress" \
  --team {team} \
  --project {project}
```

**GitLab:**

```bash
# Add board lists (columns)
glab api projects/{project-id}/boards/{board-id}/lists \
  --method POST \
  -f label_id={label-id}
```

### 7.3 Issue Labels

**Description:** Create standard labels for issue categorisation and board filtering.

**Cost:** Free

**Opt-out:** `project-management` (category) or `issue-labels` (feature)

**GitHub:**

```bash
# List existing labels
gh label list

# Create standard labels
gh label create "type: bug" --color d73a4a --description "Something isn't working"
gh label create "type: feature" --color 0075ca --description "New feature request"
gh label create "type: docs" --color 0052cc --description "Documentation improvements"
gh label create "priority: high" --color b60205 --description "High priority"
gh label create "priority: medium" --color ffc000 --description "Medium priority"
gh label create "priority: low" --color c5def5 --description "Low priority"
gh label create "status: blocked" --color d93f0b --description "Blocked by dependency"
gh label create "status: ready" --color 0e8a16 --description "Ready for work"
```

**Azure DevOps:**

```bash
# Azure uses work item types and area paths instead of labels
# Configure via Project Settings > Boards > Team configuration
```

**GitLab:**

```bash
# Create labels
glab label create "type::bug" --color "#d73a4a" --description "Something isn't working"
glab label create "type::feature" --color "#0075ca" --description "New feature request"
glab label create "priority::high" --color "#b60205" --description "High priority"
```

### 7.4 Link Repository Issues to Project

**Description:** Add existing repository issues to the project board for tracking.

**Cost:** Free

**Opt-out:** `project-management` (category) or `issue-linking` (feature)

**GitHub:**

```bash
# Add all open issues to project
for issue in $(gh issue list --state open --json number --jq '.[].number'); do
  gh project item-add {project-number} --owner {owner} \
    --url "https://github.com/{owner}/{repo}/issues/$issue"
done

# Add specific issue to project
gh project item-add {project-number} --owner {owner} \
  --url "https://github.com/{owner}/{repo}/issues/{issue-number}"
```

**Azure DevOps:**

```bash
# Azure DevOps issues (work items) are automatically part of the project
# No linking needed - configure board to show correct work item types
```

**GitLab:**

```bash
# GitLab issues are automatically shown on project boards based on labels
# Ensure issues have appropriate labels for board visibility
```

### 7.5 Status Sync with issue-driven-delivery

**Description:** Align project board statuses with issue-driven-delivery workflow states.

**Cost:** Free

**Opt-out:** `project-management` (category) or `status-sync` (feature)

**Recommended Status Mapping:**

| issue-driven-delivery State | Project Board Column |
| --------------------------- | -------------------- |
| Unassigned                  | Backlog              |
| Assigned (In Progress)      | In Progress          |
| PR Created                  | In Review            |
| Merged/Closed               | Done                 |
| Blocked                     | Blocked              |

**GitHub Projects Automation:**

```bash
# Check current workflow status
gh api graphql -f query='
{
  user(login: "{owner}") {
    projectV2(number: {project-number}) {
      workflows(first: 10) {
        nodes { id name enabled }
      }
    }
  }
}'

# Enable/disable workflow via GraphQL
gh api graphql -f query='
mutation {
  updateProjectV2Workflow(input: {
    workflowId: "{workflow-id}"
    enabled: true
  }) { projectV2Workflow { id enabled } }
}'
```

**Required Workflows for issue-driven-delivery:**

| Workflow              | Action          | Status Set To    |
| --------------------- | --------------- | ---------------- |
| Item added to project | New issues      | Backlog          |
| Item reopened         | Reopened issues | Todo             |
| Pull request linked   | PR opened       | In Review        |
| Pull request merged   | PR merged       | Done             |
| Item closed           | Issue closed    | Done             |
| Auto-add sub-issues   | Child issues    | (inherit parent) |

**Status Field Configuration (via GitHub UI):**

1. Go to Project Settings > Status field
2. Add these statuses with colors:
   - Backlog (Gray) - Unassigned issues
   - Ready (Green) - Ready for work
   - In Progress (Yellow) - Actively being worked
   - In Review (Purple) - PR created, awaiting review
   - Blocked (Red) - Blocked by dependency
   - Done (Green) - Completed

**Sync Checklist:**

- [ ] Status field has all required options (Backlog, Ready, In Progress, In Review, Blocked, Done)
- [ ] "Item added to project" workflow sets status to Backlog
- [ ] "Pull request linked" workflow sets status to In Review
- [ ] "Pull request merged" workflow sets status to Done
- [ ] "Item closed" workflow sets status to Done
- [ ] Auto-add enabled for new issues
- [ ] Auto-move on PR merge configured
- [ ] Blocked column/label synchronised

## 8. Standard Tooling

### 8.1 Git Hooks Manager (husky)

**Description:** Install husky for managing Git hooks in Node.js projects.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `husky` (feature)

**Node.js Projects:**

```bash
# Check if husky is configured
test -d .husky && echo "EXISTS" || echo "MISSING"

# Install husky
npm install --save-dev husky
npx husky init

# Verify installation
cat .husky/pre-commit
```

**Alternative for non-Node projects:**

```bash
# Use pre-commit framework (Python-based, language-agnostic)
pip install pre-commit
pre-commit install
```

### 8.2 Code Formatter (prettier)

**Description:** Install Prettier for consistent code formatting.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `prettier` (feature)

**Node.js Projects:**

```bash
# Check if prettier is configured
test -f .prettierrc -o -f .prettierrc.json -o -f prettier.config.js && echo "EXISTS" || echo "MISSING"

# Install prettier
npm install --save-dev prettier

# Create config file
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
EOF

# Create ignore file
cat > .prettierignore << 'EOF'
node_modules/
dist/
build/
coverage/
*.min.js
EOF
```

### 8.3 Markdown Linter (markdownlint)

**Description:** Install markdownlint for consistent markdown formatting.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `markdownlint` (feature)

**Node.js Projects:**

```bash
# Check if markdownlint is configured
test -f .markdownlint.json -o -f .markdownlint.yaml && echo "EXISTS" || echo "MISSING"

# Install markdownlint
npm install --save-dev markdownlint-cli2

# Create config file
cat > .markdownlint.json << 'EOF'
{
  "default": true,
  "MD013": false,
  "MD033": false
}
EOF
```

**Python/Other Projects:**

```bash
# Install via pip
pip install markdownlint-cli2
# Or use pre-commit hook (see 8.6)
```

### 8.4 Staged File Linter (lint-staged)

**Description:** Run linters only on staged files for faster commits.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `lint-staged` (feature)

**Node.js Projects:**

```bash
# Check if lint-staged is configured
grep -q "lint-staged" package.json && echo "EXISTS" || echo "MISSING"

# Install lint-staged
npm install --save-dev lint-staged

# Add configuration to package.json
# Or create .lintstagedrc.json:
cat > .lintstagedrc.json << 'EOF'
{
  "*.{js,ts,jsx,tsx}": ["eslint --fix", "prettier --write"],
  "*.{md,json,yaml,yml}": ["prettier --write"],
  "*.md": ["markdownlint-cli2 --fix"]
}
EOF

# Configure husky pre-commit hook
echo "npx lint-staged" > .husky/pre-commit
```

### 8.5 Local Secret Scanning

**Description:** Scan for secrets in commits before they reach the remote.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `local-secret-scanning` (feature)

**Using secretlint (Recommended for Node.js projects):**

```bash
# Check if secretlint is configured
test -f .secretlintrc.json && echo "EXISTS" || echo "MISSING"

# Install secretlint
npm install --save-dev secretlint @secretlint/secretlint-rule-preset-recommend

# Create config file
cat > .secretlintrc.json << 'EOF'
{
  "rules": [
    {
      "id": "@secretlint/secretlint-rule-preset-recommend"
    }
  ]
}
EOF

# Scan repository
npx secretlint "**/*"

# Add to package.json scripts
# "secretlint": "secretlint \"**/*\""

# Add to lint-staged
# "*.{js,ts,json,yaml,yml,env}": ["secretlint"]
```

**Using git-secrets (AWS-focused):**

```bash
# Install git-secrets
# macOS: brew install git-secrets
# Linux: https://github.com/awslabs/git-secrets

# Check if configured
git secrets --list 2>/dev/null && echo "CONFIGURED" || echo "NOT CONFIGURED"

# Install hooks
git secrets --install
git secrets --register-aws
```

**Using detect-secrets (Python projects):**

```bash
# Install detect-secrets
pip install detect-secrets

# Check if baseline exists
test -f .secrets.baseline && echo "EXISTS" || echo "MISSING"

# Create baseline
detect-secrets scan > .secrets.baseline

# Add to pre-commit
# - repo: https://github.com/Yelp/detect-secrets
#   rev: v1.4.0
#   hooks:
#     - id: detect-secrets
#       args: ['--baseline', '.secrets.baseline']
```

### 8.6 Pre-commit Integration

**Description:** Integrate all tools via pre-commit hooks for consistent enforcement.

**Cost:** Free

**Opt-out:** `standard-tooling` (category) or `precommit-integration` (feature)

**Node.js Projects (husky + lint-staged):**

```bash
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
```

**All Projects (pre-commit framework):**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json

  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.38.0
    hooks:
      - id: markdownlint-fix

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.1.0
    hooks:
      - id: prettier
        types_or: [javascript, typescript, json, yaml, markdown]

  - repo: local
    hooks:
      - id: secretlint
        name: secretlint
        entry: npx secretlint
        language: system
        files: .*
```

```bash
# Install pre-commit hooks
pre-commit install

# Run on all files
pre-commit run --all-files
```
