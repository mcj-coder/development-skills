# Persona Switching Tests

## RED: Failure scenarios (expected without skill)

### Scenario A: New repository without persona configuration

**Context:** Agent starts work in a repository without persona playbook or security profiles configured.

**Baseline failure to record:**

- Commits made as default user identity without role distinction
- No way to distinguish commits by different logical roles (Backend Engineer, Security Reviewer, etc.)
- GPG signing fails or uses wrong key when attempting manual identity change
- Co-authored-by headers use generic identity without role context
- No visibility into which persona made which changes

**Observed baseline (RED):**

- All commits appear from single identity regardless of role being performed
- Manual attempts to change Git user.email break GPG signing
- Audit trail shows no distinction between implementation vs review commits
- Team members cannot identify which logical role produced a change

### Scenario B: Manual persona switching attempts

**Context:** Agent or user attempts to manually switch between personas without guidance.

**Baseline failure to record:**

- Git config email changed manually but GPG key not updated
- Commit signed with wrong key (email/key mismatch)
- GitHub/platform rejects commit due to GPG verification failure
- User loses track of which identity is currently active
- Commits attributed to wrong account

**Observed baseline (RED):**

- GPG signature verification fails on push
- Platform shows "unverified" badge on commits
- Identity confusion leads to compliance issues
- No consistent process for switching identities

### Scenario C: Phase transitions without persona guidance

**Context:** Agent moves between development phases (implementation, review, security audit) without persona awareness.

**Baseline failure to record:**

- Same persona used across all phases
- No prompt to switch to specialist role for reviews
- Security review performed under generic developer identity
- No separation of concerns in commit attribution
- Tech debt review lacks dedicated reviewer perspective

**Observed baseline (RED):**

- Implementation and review commits indistinguishable
- No specialist review perspectives captured
- Compliance requirements for separation of duties not met
- Audit trail lacks role-based attribution

## GREEN: Expected behaviour with skill

### Setup Flow

- [ ] Skill detects missing persona playbook on first invocation
- [ ] Skill prompts user to create initial security profile configuration
- [ ] Skill discovers available roles from `docs/roles/*.md` frontmatter
- [ ] Skill falls back to default profiles (contributor, maintainer, admin) if no roles defined
- [ ] Skill generates `.persona-profiles.yml` template with discovered roles
- [ ] Skill validates GPG key availability for each configured email
- [ ] Skill reports setup status with actionable next steps

### Security Profile Configuration

- [ ] Skill supports N security profiles with distinct identities
- [ ] Skill provides default profile set: contributor, maintainer, admin
- [ ] Each profile stores: name, email, GPG key ID, and role description
- [ ] Skill validates email format and GPG key existence
- [ ] Skill prevents duplicate profile names
- [ ] Skill supports profile inheritance (e.g., maintainer extends contributor)
- [ ] Skill stores configuration in repository-local or user-global location

### Runtime Persona Switching

- [ ] `use_persona <profile-name>` command switches Git identity correctly
- [ ] Skill updates user.name, user.email, and user.signingkey atomically
- [ ] Skill verifies GPG key is unlocked/available before switching
- [ ] Skill provides rollback if switch fails mid-operation
- [ ] `show_persona` command displays current active profile
- [ ] Skill tracks persona history for session audit
- [ ] All subsequent commits use new persona until next switch

### GPG Signing Validation

- [ ] Skill verifies GPG key matches configured email before commit
- [ ] Skill warns if GPG key is expired or will expire soon
- [ ] Skill offers to generate new GPG key if missing
- [ ] Skill validates signing works with test commit (aborted)
- [ ] Skill prevents commits if GPG verification would fail
- [ ] Skill supports both GPG and SSH signing keys

### Workflow Integration

- [ ] Skill suggests persona switch when phase changes detected
- [ ] Skill recommends Security Reviewer persona for security-related files
- [ ] Skill recommends QA Engineer persona for test file changes
- [ ] Skill recommends Tech Lead persona for architectural decisions
- [ ] Skill integrates with issue-driven-delivery phase transitions
- [ ] Skill respects user override of persona suggestions

### Delegation Mechanics

- [ ] Skill recommends persona switch for long-duration role changes
- [ ] Skill recommends sub-agent delegation for short focused tasks
- [ ] Skill provides guidance: "switch" for >3 commits, "delegate" for single task
- [ ] Skill tracks delegation vs switch decisions for session history
- [ ] Skill ensures sub-agent uses appropriate persona if delegated

### "Dev Complete" Gate

- [ ] Skill prompts for specialist reviews before marking work complete
- [ ] Skill checks if security review was performed (Security Reviewer persona)
- [ ] Skill checks if QA review was performed (QA Engineer persona)
- [ ] Skill generates review checklist based on files changed
- [ ] Skill blocks completion claim until required reviews documented
- [ ] Skill allows bypass with explicit justification recorded

### Co-Author Attribution

- [ ] Skill includes role context in Co-Authored-By headers
- [ ] Format: `Co-Authored-By: Claude (Backend Engineer) <backend@example.com>`
- [ ] Skill preserves role information in commit messages
- [ ] Skill supports multiple co-authors with different roles
- [ ] Skill generates attribution summary for PR descriptions

## RED: Error Handling Scenarios

### Scenario: Missing GPG Key

**Context:** Configured persona references GPG key that doesn't exist.

**Expected behaviour:**

- [ ] Skill detects missing GPG key on switch attempt
- [ ] Skill reports which key ID is missing
- [ ] Skill offers to generate new key or update configuration
- [ ] Skill does not allow commits with invalid signing configuration
- [ ] Skill provides gpg key generation command if needed

### Scenario: Locked GPG Agent

**Context:** GPG agent requires passphrase but is locked/unavailable.

**Expected behaviour:**

- [ ] Skill detects GPG agent connection failure
- [ ] Skill prompts user to unlock GPG agent
- [ ] Skill waits for agent availability with timeout
- [ ] Skill offers to proceed without signing (with warning)
- [ ] Skill logs signing bypass for audit purposes

### Scenario: Profile Not Found

**Context:** User requests switch to non-existent profile.

**Expected behaviour:**

- [ ] Skill reports profile not found
- [ ] Skill lists available profiles
- [ ] Skill suggests similar profile names if typo detected
- [ ] Skill offers to create new profile
- [ ] Skill does not modify Git config on error

### Scenario: Configuration Corruption

**Context:** `.persona-profiles.yml` has invalid YAML or missing required fields.

**Expected behaviour:**

- [ ] Skill detects configuration parse error
- [ ] Skill reports specific validation errors
- [ ] Skill offers to regenerate configuration from template
- [ ] Skill backs up corrupted file before regeneration
- [ ] Skill does not crash on malformed configuration

### Scenario: Platform Email Verification

**Context:** Platform requires verified email but persona email is not verified.

**Expected behaviour:**

- [ ] Skill warns about unverified email before switching
- [ ] Skill checks GitHub/platform email verification status if CLI available
- [ ] Skill recommends adding email to platform account
- [ ] Skill allows proceed with warning for local-only work
- [ ] Skill blocks push if email verification required by platform

## Verification Checklist

### Skill Structure

- [ ] `SKILL.md` exists with valid frontmatter
- [ ] `SKILL.md` includes REQUIRED dependency on verification-before-completion
- [ ] `persona-switching.test.md` exists with RED/GREEN scenarios
- [ ] `references/` directory exists for supporting documentation

### Reference Files

- [ ] `references/security-profiles.md` documents profile configuration format
- [ ] `references/gpg-setup.md` provides GPG key setup guidance
- [ ] `references/workflow-integration.md` documents phase transition triggers
- [ ] `references/delegation-guidance.md` explains switch vs delegate decision

### Template Variables

- [ ] Skill supports `{{REPO_NAME}}` placeholder in profile templates
- [ ] Skill supports `{{USER_NAME}}` placeholder for identity defaults
- [ ] Skill supports `{{USER_EMAIL}}` placeholder for email defaults
- [ ] Skill supports `{{GPG_KEY_ID}}` placeholder for signing key

### Integration Points

- [ ] Skill integrates with issue-driven-delivery for phase awareness
- [ ] Skill integrates with verification-before-completion for review gates
- [ ] Skill integrates with pre-commit hooks for GPG validation
- [ ] Skill respects repository AGENTS.md persona delegation rules
