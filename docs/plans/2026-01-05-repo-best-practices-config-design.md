# Repository Best Practices Configuration Skill - Design Document

**Date:** 2026-01-05
**Status:** Design Complete, Awaiting Implementation
**Author:** AI Assistant with User Requirements

## Executive Summary

Design for a new skill `repo-best-practices-config` that configures repository best
practices for greenfield and brownfield repositories across multiple platforms
(GitHub, Azure DevOps, GitLab). The skill enforces security, workflow, and
collaboration standards through platform CLIs, with opinionated defaults and
interactive customization.

## Goals

1. **Platform-Agnostic:** Support GitHub, Azure DevOps, GitLab with unified workflow
2. **Setup & Configuration:** Apply best practices via platform CLIs (not just audit)
3. **Safety First:** Pre-flight checks, idempotent execution, comprehensive verification
4. **User Control:** Opinionated defaults with approval, fallback to interactive prompts
5. **Documentation:** Generate configuration decisions for ADR
6. **Integration:** Seamless integration with `issue-driven-delivery` pattern

## High-Level Architecture

### File Structure (Progressive Disclosure)

```text
skills/repo-best-practices-config/
├── SKILL.md (main workflow, <500 lines)
├── repo-best-practices-config.test.md (BDD tests)
└── references/
    ├── best-practices-defaults.md (opinionated defaults)
    ├── github-settings.md (GitHub CLI commands)
    ├── azure-devops-settings.md (Azure DevOps CLI commands)
    ├── gitlab-settings.md (GitLab CLI commands)
    └── taskboard-setup.md (project board configuration)
```

### Core Workflow

1. **Pre-flight checks** - Verify CLI installed, authenticated, admin permissions
2. **Platform detection** - Parse git remote URL, confirm platform
3. **Current state audit** - Load existing repository configuration
4. **Task board discovery** - Check README.md for taskboard link, prompt if missing
   (brownfield)
5. **Present defaults** - Show opinionated best practices, request approval
6. **Interactive prompts** - If rejected, gather preferences interactively
7. **Generate configuration decisions** - Structure data for ADR creation
8. **Apply configuration** - Idempotently configure all settings
9. **Verify & report** - Confirm each setting applied successfully
10. **Update README.md** - Add taskboard link if configured

## Opinionated Best Practices Defaults

### Branch Protection

- **Default branch:** `main` (configurable)
- **Prevent direct pushes** to default branch
- **Require pull request** before merging
- **Require status checks** to pass before merging
- **Require branches up to date** before merging (rebase enforcement)
- **Require linear history** (prevent merge commits)
- **Delete head branches** automatically after merge

### Pull Request Requirements

- **Minimum 1 reviewer approval** required
- **Dismiss stale reviews** when new commits pushed
- **Require review from code owners** (if CODEOWNERS exists)
- **Require SAST check passing** (static analysis)
- **Require secret scanning check passing**
- **Link to work item required** (enforced via PR template)
- **Require rebase before merging** (enforce linear history)

### Commit & Documentation Standards

**Versioning & Commit Format:**
- **Semantic Versioning strongly recommended** (MAJOR.MINOR.PATCH)
- **Conventional Commits strongly recommended** (feat:, fix:, docs:, etc.)
- If alternative standards used, capture in ADR with rationale
- Commit message linting enforced (via hooks or CI)

**Commit Security:**
- **Require signed commits** (GPG or SSH signatures)
- Commit message format validation
- Work item linkage enforcement
- Prevent authoring footers (unless DCO required)

**Work Item Linkage:**
- All commits must reference work item
- All PRs must link to work item
- All issues must be in project board
- No work without ticket (read-only/reviews excepted)

**Message Conciseness:**
- Commit messages: Subject line only, or subject + brief body (max 3 sentences)
- PR descriptions: Use template with Summary, Changes, Evidence sections
- Issue descriptions: Use template with Goal, Acceptance Criteria, Context
- Comments: Actionable, concise, linked to specific code/decisions

### Security Policies

**Repository Security Files:**
- **SECURITY.md required** - Vulnerability disclosure policy and contact
- LICENSE file required (prompt for license type if missing)
- CODEOWNERS file recommended (if not exists, prompt to create)

**Security Scanning:**
- Static code analysis (SAST) - Always enabled
- Secret scanning - Always enabled
- Dependency scanning - Always enabled
- **Container scanning** - If Dockerfile detected, enable container vulnerability
  scanning
- **IaC scanning** - If Terraform/CloudFormation detected, enable IaC security
  scanning

### Release Management

- **Tag protection enabled** (immutable releases)
- **Release branches protected** (e.g., `release/*`)
- Semantic versioning recommended in configuration decisions

### Automation

- **Enable auto-merge** when approved and checks pass
- **Enable automatic dependency updates** (Dependabot/Renovate/Mend)
- **Configure vulnerability alerts**

### Enforcement Mechanisms (Dual Enforcement)

**Client-side hooks** (commitlint, pre-commit):
- Fast feedback during development
- Can be bypassed with `--no-verify`

**CI/CD validation** (unskippable):
- Replicates ALL client-side checks
- Blocks merge if validation fails
- Required status checks prevent bypass

**Validation Coverage:**
- Commit message format (Conventional Commits)
- Work item linkage (commit must reference ticket)
- Secret scanning (detect leaked credentials)
- SAST/linting (code quality checks)
- Branch up-to-date requirement (rebase enforcement)

### Task Board Integration

**Board Configuration:**
- Create or link project board (Kanban layout preferred)
- Add README.md "Work Items" section with board link
- Configure board columns: Backlog, Ready, In Progress, Review, Done
- Link board to repository issues/work items

**Automation Rules:**
- Issue created → Backlog column
- PR opened → Review column
- PR merged → Done column
- Stale issues (60 days) → Auto-close with warning

**README.md Integration:**

```markdown
## Work Items

Taskboard: <project-board-url>

All work must be linked to a work item in the taskboard.
```

**Brownfield Detection:**
- Search README.md for "Work Items" or "Taskboard" section
- If not found, prompt: "Project board exists? [Y/n]"
- If Yes: "Enter board URL: ___"
- If No: "Create new board? [Y/n]"
- Update README.md with board link

### Optional Prompts (Interactive Mode)

If user rejects defaults, prompt for:
- Environment protection rules (production deployment approvals)
- Deployment gates (required checks per environment)
- Observability requirements (logging/monitoring/alerting standards)
- Custom security policies (additional scanning tools, compliance frameworks)
- Branch name preference
- Number of required reviewers
- Additional protected branches
- Custom CI/CD checks
- Board layout preference

### Overridable Settings

Via interactive prompts if defaults rejected:
- Branch name preference
- Number of required reviewers
- Additional protected branches
- Custom CI/CD checks
- Board layout preference
- Commit standards (if not using Semantic Versioning/Conventional Commits)

## Platform-Specific Implementation

### Platform Detection

```bash
# Parse git remote URL
REMOTE_URL=$(git remote get-url origin)

# Map to platform
github.com          → GitHub (CLI: gh)
dev.azure.com       → Azure DevOps (CLI: ado)
*.visualstudio.com  → Azure DevOps (CLI: ado)
gitlab.com          → GitLab (CLI: glab)
```

If remote URL doesn't match known patterns, prompt user for platform selection.

### GitHub-Specific Configuration

**CLI:** `gh`

**Branch Protection:**
```bash
gh api repos/:owner/:repo/branches/main/protection -X PUT --input protection.json
```

**Required Status Checks:**
```bash
gh api repos/:owner/:repo/branches/main/protection/required_status_checks \
  -X PATCH -f strict=true -f contexts[]=SAST -f contexts[]=SecretScan
```

**Project Board:**
```bash
gh project create --owner :owner --title "Repository Board" --template "Basic kanban"
gh project item-add <project-id> --url <repo-url>
```

**Signed Commits:**
```bash
gh api repos/:owner/:repo -X PATCH -f allow_unsigned_commits=false
```

**Pull Request Settings:**
```bash
gh api repos/:owner/:repo -X PATCH \
  -f allow_merge_commit=false \
  -f allow_squash_merge=true \
  -f allow_rebase_merge=true \
  -f delete_branch_on_merge=true
```

See `references/github-settings.md` for complete command reference.

### Azure DevOps-Specific Configuration

**CLI:** `ado`

**Branch Policies:**
```bash
ado repos policy create --policy-type RequirePullRequest --branch main
ado repos policy create --policy-type RequireReviewers --min-reviewers 1 \
  --branch main
ado repos policy create --policy-type StatusCheck --status-name "Build" \
  --branch main --required
ado repos policy create --policy-type StatusCheck --status-name "SAST" \
  --branch main --required
```

**Work Item Board:**
```bash
ado boards create --name "Repository Board" --type Kanban
```

**Required Build Validation:**
```bash
ado pipelines policy create --repository <repo> --branch main --required
```

**Commit Validation:**
```bash
ado repos policy create --policy-type CommitAuthorEmail --branch main
```

See `references/azure-devops-settings.md` for complete command reference.

### GitLab-Specific Configuration

**CLI:** `glab`

**Protected Branches:**
```bash
glab api projects/:id/protected_branches -X POST -f name=main \
  -f push_access_level=0 \
  -f merge_access_level=30 \
  -f allow_force_push=false
```

**Merge Request Approval Rules:**
```bash
glab api projects/:id/approval_rules -X POST \
  -f name="Code Review" \
  -f approvals_required=1
```

**Issue Board:**
```bash
glab api projects/:id/boards -X POST -f name="Repository Board"
```

**Push Rules:**
```bash
glab api projects/:id/push_rule -X POST \
  -f commit_message_regex="^(feat|fix|docs|style|refactor|test|chore):" \
  -f reject_unsigned_commits=true
```

See `references/gitlab-settings.md` for complete command reference.

## ADR Integration

### File Location

`docs/adr/NNNN-repository-configuration.md` (numbered, e.g.,
`0003-repository-configuration.md`)

### ADR Handling

- Skill generates configuration decisions as structured data
- Delegates to ADR management skill (not yet implemented) for file creation
- If ADR skill unavailable: Output decisions to console for manual ADR creation
- ADR number determined by existing ADR sequence in `docs/adr/` directory

### Configuration Decisions Output

```yaml
# Repository configuration decisions (for ADR)
platform: github
branch_protection:
  default_branch: main
  require_pr: true
  required_reviewers: 1
  require_rebase: true
  linear_history: true
commit_standards:
  semantic_versioning: true
  conventional_commits: true
  signed_commits: true
security:
  sast_enabled: true
  secret_scanning: true
  security_md_created: true
  container_scanning: true # if applicable
  iac_scanning: true # if applicable
taskboard:
  type: kanban
  url: https://github.com/users/username/projects/1
  readme_updated: true
optional_settings:
  environment_protection: false
  deployment_gates: false
  observability_requirements: false
```

### Integration Point

- Call ADR skill (when available) with decisions data
- ADR skill handles numbering, formatting, git commit
- This skill focuses only on repository configuration

## Error Handling & Verification

### Pre-Flight Check Failures

```
❌ Pre-flight check failed: gh CLI not found
   → Install: https://cli.github.com/
   → Run: gh auth login
   → Re-run skill

❌ Pre-flight check failed: Insufficient permissions
   → Required: Repository admin access
   → Current: Write access
   → Contact repository owner
```

**Pre-flight Checks:**
1. Platform CLI installed (gh/ado/glab)
2. CLI authenticated (valid credentials)
3. Repository exists and accessible
4. User has admin/owner permissions
5. Git repository has remote configured

### Idempotent Configuration with State Tracking

```text
Configuring repository best practices...

✓ Branch protection: Already configured (skipped)
⚙ Pull request settings: Configuring...
✓ Pull request settings: Configured successfully
⚙ Required status checks: Configuring...
❌ Required status checks: Failed - CI workflow not found
   → Action: Create CI workflow first, then re-run
✓ Task board: Already exists, linking to README.md
✓ README.md: Updated with taskboard link
```

**State Tracking Approach:**
- Query current state for each setting before applying
- Skip if already configured correctly
- Only apply changes needed
- Safe to run multiple times

### Error Recovery Strategy

**Graceful Degradation:**
- Continue configuring remaining settings after non-critical failure
- Collect all errors, report at end
- Categorize: **Blocking** (must fix) vs **Warning** (can defer)

**Example Error Report:**

```text
Configuration Summary:
✓ 8/10 settings applied successfully

❌ Blocking Issues (must fix):
  - Required status check "SAST" failed: Workflow .github/workflows/sast.yml
    not found

⚠ Warnings (can defer):
  - Container scanning skipped: No Dockerfile detected

Next Steps:
1. Create SAST workflow: .github/workflows/sast.yml
2. Re-run: repo-best-practices-config (safe to re-run, idempotent)
```

**Error Categories:**

**Blocking:**
- CLI not installed
- Authentication failed
- Insufficient permissions
- Repository not found
- Platform API error

**Non-Blocking (Warnings):**
- Optional feature not available (e.g., container scanning without Dockerfile)
- Recommended file missing (e.g., CODEOWNERS)
- Advisory settings (e.g., observability not configured)

### Verification Strategy

**Post-Configuration Verification:**

```bash
# Verify each setting via platform API
✓ Branch protection enabled
✓ Required reviewers: 1 (expected: 1)
✓ Signed commits: Required
✓ Auto-merge: Enabled
✓ Taskboard linked in README.md
✓ SECURITY.md exists

Verification: 6/6 checks passed ✓
```

**Verification Process:**
1. Query current state via platform API
2. Compare against expected configuration
3. Report discrepancies
4. Suggest corrective actions if mismatch

**Continuous Verification:**
- Skill can be re-run anytime (audit mode)
- Shows: "Currently configured ✓" vs "Needs configuration ⚙"
- Safe to run multiple times (idempotent)

## Testing Strategy

### BDD Test File

`repo-best-practices-config.test.md`

### RED Scenarios (Expected Failures Without Skill)

#### Scenario A: Time pressure to skip configuration

**Pressure:** "Just start coding, we'll secure the repo later"

**Baseline failure:**
- Agent proceeds without configuring branch protection
- No PR requirements set
- Direct pushes allowed to main branch
- No task board setup
- No security scanning

#### Scenario B: Partial configuration (good enough)

**Pressure:** "We only need branch protection, skip the rest"

**Baseline failure:**
- Agent configures only requested items
- Skips security scanning, signed commits, taskboard
- No comprehensive security posture
- Inconsistent with best practices

#### Scenario C: Manual configuration without verification

**Pressure:** "I already configured this manually"

**Baseline failure:**
- Agent trusts user claim without verification
- Settings not actually applied or incomplete
- No ADR documenting decisions
- No verification of current state

### GREEN Scenarios (Expected Behavior With Skill)

**Core Functionality:**
- [ ] Platform detected from git remote URL
- [ ] Pre-flight checks run (CLI installed, authenticated, admin permissions)
- [ ] Current repository state audited
- [ ] Opinionated defaults presented for approval
- [ ] Interactive prompts used if defaults rejected

**Required Settings Configured:**
- [ ] Branch protection (main, no direct push, require PR)
- [ ] Required reviewers (minimum 1)
- [ ] Signed commits required
- [ ] SAST and secret scanning enabled
- [ ] Linear history enforced (rebase required)
- [ ] Auto-merge on approval enabled
- [ ] Branch deletion after merge enabled
- [ ] Work item linkage enforced (commits and PRs)
- [ ] SECURITY.md created
- [ ] Container/IaC scanning enabled (if applicable)

**Task Board Integration:**
- [ ] Task board created/linked (Kanban layout)
- [ ] README.md updated with taskboard link
- [ ] Board columns configured (Backlog, Ready, In Progress, Review, Done)
- [ ] Automation rules configured

**Process Requirements:**
- [ ] Configuration decisions captured for ADR
- [ ] All settings verified post-configuration
- [ ] Idempotent: Safe to re-run, skips already-configured items
- [ ] CI/CD enforcement replicates all client-side hooks

**Platform-Specific Tests:**
- [ ] GitHub: All settings applied via `gh` CLI
- [ ] Azure DevOps: All policies applied via `ado` CLI
- [ ] GitLab: All protections applied via `glab` CLI

### Test Repositories

**Greenfield Testing:**
- Create fresh test repos on each platform
- Verify all defaults applied correctly
- Test interactive mode by rejecting defaults

**Brownfield Testing:**
- Clone production-like repos with existing configuration
- Verify idempotency (doesn't break existing settings)
- Test README.md taskboard detection and prompts
- Verify upgrade scenarios (partial → full configuration)

**Automated Testing:**
- Use dedicated test organizations/projects
- Automated cleanup after tests
- Run in CI/CD to catch regressions

### Manual Testing Checklist

1. **Setup:**
   - Create test repo on target platform
   - Remove any existing protections

2. **Run skill with default approval:**
   - Verify all settings configured
   - Check platform UI confirms settings

3. **Verification tests:**
   - Attempt direct push to main (should fail)
   - Create PR without work item link (should fail CI)
   - Create PR without approval (should block merge)
   - Push unsigned commit (should fail)

4. **Idempotency test:**
   - Run skill again
   - Should show "already configured" for all items
   - No errors, no duplicate settings

5. **Interactive mode test:**
   - Create new test repo
   - Reject defaults
   - Answer interactive prompts
   - Verify custom configuration applied

## Integration with Existing Skills

### `issue-driven-delivery` Integration

**Task Board URL as Platform Source:**
- README.md "Work Items" section provides taskboard URL
- This URL used for platform detection in both skills
- Consistent work item tracking across repository lifecycle

**Work Item State Labels:**
- Match board columns (Backlog, Ready, In Progress, Review, Done)
- Auto-update board on state transitions
- Consistent state tracking

**Work Item Linkage Enforcement:**
- Both skills enforce work item linkage
- `repo-best-practices-config` sets up enforcement
- `issue-driven-delivery` provides workflow for compliance

### Future Skill Integration

**ADR Management Skill (Not Yet Implemented):**
- `repo-best-practices-config` generates configuration decisions data
- ADR skill handles file creation, numbering, formatting, commit
- Clean separation of concerns

**CI/CD Configuration Skill (Future):**
- Create required workflows (.github/workflows/, .gitlab-ci.yml, azure-pipelines.yml)
- Configure status checks referenced by `repo-best-practices-config`
- Complementary functionality

## Implementation Phases

### Phase 1: Core Functionality (GitHub Only)

**Deliverables:**
- SKILL.md with core workflow
- GitHub-specific implementation (`references/github-settings.md`)
- Pre-flight checks
- Idempotent configuration
- Verification strategy
- BDD tests

**Validation:**
- Manual testing on GitHub test repository
- Verify all settings applied correctly
- Confirm idempotency

### Phase 2: Multi-Platform Support

**Deliverables:**
- Azure DevOps implementation (`references/azure-devops-settings.md`)
- GitLab implementation (`references/gitlab-settings.md`)
- Platform detection logic
- Platform-specific BDD tests

**Validation:**
- Test on all three platforms
- Verify platform detection
- Cross-platform consistency

### Phase 3: Interactive Mode & ADR

**Deliverables:**
- Interactive prompt system
- Configuration decisions output (YAML)
- ADR integration point
- Enhanced error reporting

**Validation:**
- Test rejection of defaults
- Verify interactive prompts work
- Validate ADR data structure

### Phase 4: Task Board Integration

**Deliverables:**
- Task board creation/linking
- README.md integration
- Brownfield detection
- Board automation rules

**Validation:**
- Test on greenfield repos
- Test on brownfield repos
- Verify README.md updates
- Confirm board automation

## Success Criteria

**Functional:**
- All required settings configurable on GitHub, Azure DevOps, GitLab
- Idempotent execution (safe to re-run)
- Pre-flight checks prevent invalid configurations
- Post-configuration verification confirms success
- Task board integration functional

**Quality:**
- BDD tests passing (RED scenarios fail without skill, GREEN scenarios pass with
  skill)
- Progressive disclosure compliant (<500 lines main SKILL.md)
- Platform-specific details in references/
- Clear error messages with actionable guidance

**User Experience:**
- Opinionated defaults work for 80% of use cases
- Interactive mode handles edge cases
- Configuration decisions captured for ADR
- Seamless integration with `issue-driven-delivery`

## Security Considerations

**Credential Handling:**
- Use platform CLIs for authentication (no credential storage)
- Verify authentication before applying changes
- Clear error messages if authentication fails

**Permission Validation:**
- Verify admin/owner permissions before configuration
- Prevent partial application due to permission issues
- Fail fast with clear permission requirements

**Audit Trail:**
- All configuration changes logged
- ADR documents decisions
- Git commits provide change history

**Rollback Safety:**
- Idempotent execution allows safe re-configuration
- Settings can be manually reverted via platform UI
- No destructive operations (only additive configuration)

## Future Enhancements

1. **Compliance Profiles:**
   - SOC 2, ISO 27001, HIPAA, PCI-DSS preset configurations
   - Industry-specific best practices

2. **Drift Detection:**
   - Periodic checks for configuration drift
   - Alerts when settings manually changed
   - Auto-remediation option

3. **Team Templates:**
   - Organization-wide configuration templates
   - Inherit base settings, customize per repo
   - Centralized policy enforcement

4. **Reporting & Metrics:**
   - Compliance dashboard across multiple repos
   - Configuration coverage metrics
   - Security posture scoring

5. **Additional Platforms:**
   - Bitbucket, Gitea, Codeberg support
   - Self-hosted GitLab/GitHub Enterprise specific features

## Conclusion

This design provides a comprehensive, platform-agnostic skill for configuring
repository best practices. The opinionated defaults ensure security and workflow
consistency while interactive prompts provide flexibility for edge cases.
Integration with `issue-driven-delivery` creates a cohesive workflow for
repository management.

The progressive disclosure architecture (main SKILL.md + references/) ensures
maintainability and follows established patterns in this repository. BDD tests
validate behavior under pressure scenarios, ensuring the skill enforces best
practices even when users might skip them.

Implementation can proceed in phases, starting with GitHub support and expanding
to other platforms, with clear success criteria at each phase.
