# Persona Switching - BDD Tests

## Overview

This test suite validates that agents use persona-switching skill to maintain GPG signing
integrity and role-based commit attribution when working across different phases and contexts.

## RED Scenarios (Expected Failures - Baseline)

These scenarios describe the current undesired behaviour that should fail without the skill:

### RED-1: New Repository Without Persona Configuration

**Given**: Agent starts work in a repository without persona playbook
**When**: Agent performs tasks across different phases (implementation, review, security audit)
**Then**: All commits appear from single identity regardless of role
**And**: Audit trail shows no distinction between implementation vs review commits
**But**: Different logical roles should be distinguishable in commit history
**Result**: :x: FAIL - No role distinction in commits

**Evidence**: Commits show same author for all work types; no way to identify which logical role produced a change

### RED-2: Manual Persona Switching Breaks GPG Signing

**Given**: Agent or user attempts to manually change Git identity
**When**: User runs `git config user.email different@email.com`
**Then**: Git config email changes
**But**: GPG signing key is not updated to match
**And**: Next commit fails GPG verification or shows "Unverified" on GitHub
**Result**: :x: FAIL - GPG signature verification fails

**Evidence**: Platform shows "Unverified" badge on commits; email/key mismatch causes compliance issues

### RED-3: Phase Transitions Without Persona Guidance

**Given**: Agent moves from implementation to security review phase
**When**: Agent continues working without persona switch prompt
**Then**: Security review commits use same developer persona
**And**: No specialist review perspective captured
**But**: Security reviews should be attributed to Security Reviewer persona
**Result**: :x: FAIL - No separation of concerns in commit attribution

**Evidence**: Implementation and review commits indistinguishable; compliance requirements
for separation of duties not met

### RED-4: GitHub Account Not Switched

**Given**: Agent has multiple GitHub accounts configured
**When**: Agent manually changes Git user.email
**Then**: Git identity changes
**But**: `gh` CLI remains on original account
**And**: PR operations use wrong account permissions
**Result**: :x: FAIL - GitHub account mismatch with Git identity

**Evidence**: `gh auth status` shows different account than `git config user.email`

## GREEN Scenarios (Expected Behaviour - Post-Implementation)

These scenarios describe the desired behaviour after skill implementation:

### GREEN-1: Skill Detects Missing Playbook and Triggers Setup

**Given**: Agent enters repository without `docs/playbooks/persona-switching.md`
**When**: Agent invokes persona-switching skill
**Then**: [ ] Skill detects missing persona playbook
**And**: [ ] Skill prompts user to create initial security profile configuration
**And**: [ ] Skill discovers available roles from `docs/roles/*.md` frontmatter
**And**: [ ] Skill falls back to default profiles if no roles defined
**And**: [ ] Skill generates shell config with `chmod 600` permissions
**Result**: :white_check_mark: PASS - Setup flow completes with secure configuration

**Verification**:

- [ ] `docs/playbooks/persona-switching.md` created in target repo
- [ ] `~/.config/<repo-name>/persona-config.sh` created with mode 600
- [ ] Shell config contains `use_persona` and `show_persona` functions
- [ ] GPG key availability validated for each configured email

### GREEN-2: Runtime Persona Switching Works Atomically

**Given**: Agent has persona configuration set up
**When**: Agent runs `use_persona backend-engineer`
**Then**: [ ] `gh` CLI switches to correct GitHub account
**And**: [ ] Git config updates `user.name`, `user.email`, `user.signingkey` atomically
**And**: [ ] GPG key availability verified before switch completes
**And**: [ ] `show_persona` displays new active profile
**Result**: :white_check_mark: PASS - Atomic persona switch with verification

**Verification**:

- [ ] `git config user.email` returns expected email
- [ ] `git config user.signingkey` returns matching GPG key ID
- [ ] `gh auth status` shows expected GitHub account
- [ ] Test commit (aborted) verifies GPG signature valid

### GREEN-3: Rollback on Partial Failure

**Given**: Agent attempts persona switch
**When**: Switch fails mid-operation (e.g., GPG key not found after email updated)
**Then**: [ ] Skill detects partial failure
**And**: [ ] Skill rolls back to previous Git config state
**And**: [ ] Skill reports actionable error message
**And**: [ ] No partial state remains in Git config
**Result**: :white_check_mark: PASS - Clean rollback on failure

**Verification**:

- [ ] Original `user.email` restored after rollback
- [ ] Original `user.signingkey` restored after rollback
- [ ] `show_persona` shows original profile
- [ ] Error message indicates what failed and how to fix

### GREEN-4: Workflow Phase Suggestions

**Given**: Agent is working on issue with `state:implementation` label
**When**: Issue transitions to `state:verification` label
**Then**: [ ] Skill detects phase change
**And**: [ ] Skill suggests switching to QA Engineer persona
**And**: [ ] Skill allows user override of suggestion
**And**: [ ] Suggestion logged for audit trail
**Result**: :white_check_mark: PASS - Phase-appropriate persona suggested

**Verification**:

- [ ] Persona suggestion matches phase (Tech Lead for refinement, QA for verification)
- [ ] Suggestion does not force switch (user can decline)
- [ ] Session history records suggestion and decision

### GREEN-5: "Dev Complete" Gate Enforces Reviews

**Given**: Agent is about to mark implementation complete
**When**: Agent invokes verification-before-completion
**Then**: [ ] Skill checks if security review was performed (Security Reviewer persona)
**And**: [ ] Skill checks if QA review was performed (QA Engineer persona)
**And**: [ ] Skill generates review checklist based on files changed
**And**: [ ] Skill blocks completion claim until required reviews documented
**And**: [ ] Skill allows bypass with explicit justification recorded
**Result**: :white_check_mark: PASS - Dev complete gate front-loads validation

**Verification**:

- [ ] Review personas appear in session history before completion claim
- [ ] Bypass requires explicit justification text
- [ ] Justification logged for audit purposes

### GREEN-6: Co-Author Attribution Includes Role

**Given**: Agent commits code as Backend Engineer persona
**When**: Commit message is generated
**Then**: [ ] Co-Authored-By header includes role context
**And**: [ ] Format: `Co-Authored-By: Claude (Backend Engineer) <backend@example.com>`
**And**: [ ] Role information preserved in commit message
**Result**: :white_check_mark: PASS - Role-aware attribution

**Verification**:

- [ ] `git log` shows role in Co-Authored-By
- [ ] Multiple co-authors with different roles supported

## GREEN: Error Handling Scenarios

These scenarios describe expected skill behaviour when errors occur:

### GREEN-E1: Missing GPG Key

**Given**: Configured persona references GPG key that doesn't exist
**When**: Agent attempts `use_persona` with that profile
**Then**: [ ] Skill detects missing GPG key on switch attempt
**And**: [ ] Skill reports which key ID is missing
**And**: [ ] Skill offers to generate new key or update configuration
**And**: [ ] Skill does not allow commits with invalid signing configuration
**Result**: :white_check_mark: PASS - Graceful handling of missing GPG key

**Verification**:

- [ ] Clear error message with key ID
- [ ] `gpg --gen-key` command suggested if appropriate
- [ ] Git config not modified on error

### GREEN-E2: Locked GPG Agent

**Given**: GPG agent requires passphrase but is locked/unavailable
**When**: Agent attempts persona switch
**Then**: [ ] Skill detects GPG agent connection failure
**And**: [ ] Skill prompts user to unlock GPG agent
**And**: [ ] Skill offers to proceed without signing (with warning)
**And**: [ ] Signing bypass logged for audit purposes
**Result**: :white_check_mark: PASS - Clear guidance for locked agent

**Verification**:

- [ ] Error message suggests `gpg-connect-agent` or passphrase entry
- [ ] Bypass option available with explicit warning
- [ ] Audit log records signing bypass

### GREEN-E3: Profile Not Found

**Given**: User requests switch to non-existent profile
**When**: Agent runs `use_persona nonexistent-profile`
**Then**: [ ] Skill reports profile not found
**And**: [ ] Skill lists available profiles
**And**: [ ] Skill suggests similar profile names if typo detected (edit distance <= 2)
**And**: [ ] Skill does not modify Git config on error
**Result**: :white_check_mark: PASS - Helpful error for unknown profile

**Verification**:

- [ ] Available profiles listed in error output
<!-- cspell:ignore baceknd -->
- [ ] Similar names suggested (e.g., "backend" suggested for "baceknd")
- [ ] Git config unchanged after error

### GREEN-E4: Configuration Corruption

**Given**: `.persona-profiles.yml` has invalid YAML or missing required fields
**When**: Agent attempts any persona operation
**Then**: [ ] Skill detects configuration parse error
**And**: [ ] Skill reports specific validation errors
**And**: [ ] Skill offers to regenerate from template
**And**: [ ] Skill backs up corrupted file before regeneration
**Result**: :white_check_mark: PASS - Recovery from corrupted config

**Verification**:

- [ ] Specific YAML error reported (line number if available)
- [ ] Backup created at `<filename>.backup`
- [ ] Regenerated config is valid

### GREEN-E5: Email/Key Mismatch Detection

**Given**: Git config has `user.email` that doesn't match the GPG signing key's email
**When**: Agent attempts `use_persona` or validates current configuration
**Then**: [ ] Skill detects email/key mismatch before any commits
**And**: [ ] Skill reports which email is configured vs which email the key belongs to
**And**: [ ] Skill blocks commits that would show "Unverified" on GitHub
**And**: [ ] Skill offers to fix by updating user.email to match signing key
**Result**: :white_check_mark: PASS - Prevents "Unverified" commits proactively

**Verification**:

- [ ] Error message shows both emails (configured vs key)
- [ ] `gpg --list-keys <key-id>` email compared against `git config user.email`
- [ ] No commits allowed until mismatch resolved
- [ ] Suggested fix updates user.email to match key

**Real-world scenario**: Local repo has `user.signingkey=KEY_A` (belongs to email_A) but
`user.email=email_B`. Commits will be signed correctly (GPG validates) but GitHub shows
"Unverified" because the key's email doesn't match a verified email on the account.

## Pressure Test Scenarios

These scenarios test that the skill holds up under common pressures:

### PRESSURE-1: Time Pressure - Quick Commit Needed

**Given**: User says "Just commit this quickly, don't worry about switching personas"
**When**: Agent has persona-switching skill loaded
**Then**: [ ] Skill reminds about audit trail requirements
**And**: [ ] Skill offers quick switch option (not skip)
**And**: [ ] Agent does NOT skip persona switch
**Result**: :white_check_mark: PASS - Time pressure does not bypass persona switching

**Rationalization to resist**: "It's just a small change, switching takes too long"

### PRESSURE-2: Sunk Cost - Already Made Commits as Wrong Persona

**Given**: Agent realizes 3 commits were made as wrong persona
**When**: Agent considers continuing as wrong persona to avoid disruption
**Then**: [ ] Skill recommends switching now for remaining work
**And**: [ ] Skill suggests amending commits if appropriate
**And**: [ ] Agent switches persona for future commits
**Result**: :white_check_mark: PASS - Sunk cost does not perpetuate error

**Rationalization to resist**: "Already made commits as this persona, might as well continue"

### PRESSURE-3: Authority - User Says GPG Is Optional

**Given**: User says "GPG signing is annoying, just disable it"
**When**: Agent has persona-switching skill loaded
**Then**: [ ] Skill explains GPG requirement for audit compliance
**And**: [ ] Skill offers gpg-agent caching to reduce friction
**And**: [ ] Agent does NOT disable GPG signing
**Result**: :white_check_mark: PASS - Authority pressure does not compromise signing

**Rationalization to resist**: "User said it's optional, they know their requirements"

### PRESSURE-4: Convenience - Admin Profile for Everything

**Given**: User says "Just use admin profile, it has all permissions"
**When**: Agent needs to perform implementation work
**Then**: [ ] Skill recommends contributor profile for implementation
**And**: [ ] Skill explains least-privilege principle
**And**: [ ] Agent uses appropriate profile, not admin
**Result**: :white_check_mark: PASS - Convenience does not override least-privilege

**Rationalization to resist**: "Admin works for everything, simpler to just use that"

## Rationalization Table

Common excuses the skill must resist:

| Rationalization                           | Why It's Wrong                        | Correct Response              |
| ----------------------------------------- | ------------------------------------- | ----------------------------- |
| "Too simple to switch personas"           | Every commit becomes audit evidence   | Switch even for small changes |
| "GPG is optional anyway"                  | Platform may require verified commits | Maintain signing integrity    |
| "I'll switch persona after this commit"   | Creates inconsistent audit trail      | Switch before committing      |
| "Admin access is fine for implementation" | Violates least-privilege              | Use contributor for dev work  |
| "Manual email change is faster"           | Breaks GPG signing                    | Always use `use_persona`      |
| "Just one commit won't matter"            | Audit trail gaps compound             | No exceptions                 |

## Verification Checklist

### Skill Structure

- [ ] `SKILL.md` exists with valid frontmatter
- [ ] `SKILL.md` includes `requires: [superpowers:verification-before-completion]`
- [ ] `persona-switching.test.md` exists with RED/GREEN/PRESSURE scenarios
- [ ] `references/` directory exists for supporting documentation

### Reference Files

- [ ] `references/persona-config-template.sh` - Shell script template
- [ ] `references/playbook-template.md` - Playbook template for target repos
- [ ] `references/security-profiles.md` - Profile configuration guidance
- [ ] `references/delegation-patterns.md` - When to switch vs delegate
- [ ] `references/workflow-integration.md` - issue-driven-delivery integration

### Template Variables

- [ ] `{{REPO_NAME}}` placeholder supported in templates
- [ ] `{{SECURITY_PROFILES}}` placeholder for profile definitions
- [ ] `{{PERSONAS}}` placeholder for persona mappings
- [ ] `{{GPG_KEY_ID}}` placeholder for signing key

### Integration Points

- [ ] Integrates with issue-driven-delivery for phase awareness
- [ ] Integrates with verification-before-completion for review gates
- [ ] Compatible with pre-commit GPG validation hooks
- [ ] Respects repository AGENTS.md persona delegation rules
