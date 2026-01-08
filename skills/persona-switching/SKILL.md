---
name: persona-switching
description: Use when setting up multi-identity Git/GitHub workflows or when phase transitions require role-specific personas for commits and operations.
compatibility: Requires bash/zsh shell, GPG, and gh CLI
requires:
  - superpowers:verification-before-completion
metadata:
  type: Setup + Runtime
  priority: P2 (Consistency & Governance)
---

# Persona-Switching

## Overview

Enable repositories to adopt multi-identity Git/GitHub workflows where agents work
under role-specific personas (e.g., "Claude (Backend Engineer)") while maintaining
GPG signing integrity and appropriate permission levels.

**Skill announcement:** "Using persona-switching to [set up multi-identity workflow |
switch to appropriate role | suggest persona for this phase]."

## Prerequisites

- **Shell**: Bash or Zsh (Windows PowerShell not supported - see Limitations)
- **GPG**: Installed with keys configured for each identity email
- **gh CLI**: Installed and authenticated for each GitHub account
- **Permissions**: Write access to `~/.config/<repo-name>/` for shell config

## When to Use

| Trigger Type  | Condition                                           | Action                                    |
| ------------- | --------------------------------------------------- | ----------------------------------------- |
| Explicit      | User requests "set up personas" or "switch persona" | Full setup or quick switch                |
| Bootstrap     | `repo-best-practices-bootstrap` runs on target repo | Prompt: "Enable multi-identity workflow?" |
| Workflow      | issue-driven-delivery phase transition              | Suggest appropriate persona for phase     |
| Role mismatch | Current persona doesn't match task context          | Recommend persona switch                  |

## Detection Logic

1. Check for existing `docs/playbooks/persona-switching.md` in target repo
2. If exists: Skill provides runtime guidance only
3. If missing: Skill triggers setup flow first

## Setup Flow

### Step 1: Role Discovery

```text
1. Check target repo for docs/roles/*.md
   |-- Found: Parse frontmatter for role metadata
   |          Fallback to file content if no frontmatter
   |          Last resort: derive from filename
   +-- Not found: Use reference personas as defaults

2. Present discovered/default personas to user
   +-- User can add, remove, or rename

3. For each persona, prompt for security profile mapping
   +-- Suggest based on role type (dev work vs elevated ops)
```

**Role file parsing priority:**

1. Frontmatter: `name:`, `title:`, or `role:` fields
2. Content: First H1 heading as role name
3. Filename fallback: `tech-lead.md` -> "Tech Lead"

### Step 2: Security Profile Configuration

Configure N security profiles based on repository needs.

**Default profiles (reference):**

| Profile       | Purpose                   | Typical Permissions                    |
| ------------- | ------------------------- | -------------------------------------- |
| `contributor` | Standard development work | Push to branches, create PRs           |
| `maintainer`  | Elevated operations       | Merge PRs, manage labels, close issues |
| `admin`       | Repository administration | Branch protection, settings, releases  |

**Configuration format:**

```yaml
security_profiles:
  contributor:
    github_account: "dev-bot-account"
    email: "dev@company.com"
    gpg_key: "ABC123..."
  maintainer:
    github_account: "lead-bot-account"
    email: "lead@company.com"
    gpg_key: "DEF456..."
```

### Step 3: Generate Artifacts

1. Generate playbook: `docs/playbooks/persona-switching.md`
2. Generate shell config: `~/.config/<repo-name>/persona-config.sh`
3. Set file permissions: `chmod 600` on shell config (contains account mappings)
4. Provide sourcing instructions for user's shell profile

## Runtime Usage

### Switching Personas

```bash
# Source the config (add to shell profile for persistence)
source ~/.config/<repo-name>/persona-config.sh

# Switch to a persona
use_persona backend-engineer

# Verify current persona
show_persona
```

### What `use_persona` Does

1. Switches `gh` CLI to correct GitHub account
2. Updates Git config: `user.name`, `user.email`, `user.signingkey`
3. Verifies GPG key is available
4. Reports success or failure with actionable message

### Persona-to-Profile Mapping

Each persona maps to exactly one security profile:

| Persona           | Default Profile | Rationale                                  |
| ----------------- | --------------- | ------------------------------------------ |
| Backend Engineer  | contributor     | Implementation work                        |
| Frontend Engineer | contributor     | Implementation work                        |
| QA Engineer       | contributor     | Test development                           |
| Tech Lead         | maintainer      | Approvals, label management                |
| Scrum Master      | maintainer      | Issue triage, workflow management          |
| Security Engineer | contributor     | Reviews (escalate to maintainer if needed) |

## Ownership Model

### Phase Ownership (issue-driven-delivery integration)

| Phase           | Default Owner          | Delegation Pattern                                           |
| --------------- | ---------------------- | ------------------------------------------------------------ |
| Refinement      | Tech Lead              | Invokes specialists for domain-specific input                |
| Implementation  | Domain expert (varies) | Invokes specialists for sub-tasks + pre-verification reviews |
| Verification    | QA Engineer            | Invokes Architecture/Security/Performance for expert reviews |
| Review/Approval | Tech Lead              | Lightweight - work already validated                         |

### Delegation Mechanics

| Situation               | Mechanism            | Rationale                          |
| ----------------------- | -------------------- | ---------------------------------- |
| Quick review (< 10 min) | Persona switch       | Low overhead, stays in flow        |
| Substantial sub-task    | Sub-agent delegation | Parallel work, cleaner separation  |
| Multi-domain work       | Multiple sub-agents  | Backend + Frontend simultaneously  |
| Expert consultation     | Persona switch       | Brief input, owner retains context |

**Rule of thumb:** Switch for >3 commits in a role; delegate for single focused tasks.

### "Dev Complete" Gate

Before transitioning from Implementation to Verification:

1. Owner invokes relevant specialist personas for review
2. Each specialist validates their domain concerns
3. Only after specialist sign-off does work move to QA

This front-loads validation so final Review/Approval is a formality.

## Workflow Integration

### Automatic Suggestions

| Workflow Step                    | Persona Suggestion          | Trigger                            |
| -------------------------------- | --------------------------- | ---------------------------------- |
| Step 3b (refinement start)       | Tech Lead                   | `state:refinement` label added     |
| Step 7a (implementation handoff) | Domain expert based on task | `state:implementation` label added |
| Step 8c (verification start)     | QA Engineer                 | `state:verification` label added   |
| Step 11 (role reviews)           | Relevant specialists        | Review request in workflow         |

### GPG Signing Compatibility

Persona switching preserves GPG validity because:

- GPG validates against email, not author name
- Each security profile has consistent email + GPG key pairing
- Author name changes ("Claude (Backend Engineer)") don't break signatures

## Security Considerations

### Credential Storage

- **GPG keys**: Stored in user's GPG keyring (managed by `gpg-agent`)
- **GitHub tokens**: Managed by `gh` CLI (stored in `~/.config/gh/hosts.yml`)
- **Shell config**: Contains account mappings but NO secrets

### GPG Agent Caching

Configure `gpg-agent` for passphrase caching to avoid repeated prompts:

```bash
# ~/.gnupg/gpg-agent.conf
default-cache-ttl 3600
max-cache-ttl 7200
```

### Shell History

The `use_persona` command does NOT expose secrets in shell history.
Profile names are safe to log; actual credentials remain in secure storage.

### File Permissions

Generated shell config MUST have restricted permissions:

```bash
chmod 600 ~/.config/<repo-name>/persona-config.sh
```

This prevents other users from reading account mappings.

## Limitations

### Platform Compatibility

| Platform             | Status           | Notes                                    |
| -------------------- | ---------------- | ---------------------------------------- |
| Linux                | ✅ Supported     | Native bash environment                  |
| macOS                | ✅ Supported     | Requires bash 4.0+ (`brew install bash`) |
| Windows (WSL2)       | ✅ Supported     | Use WSL2 with GPG4Win bridge             |
| Windows (Git Bash)   | ⚠️ Partial       | Works but GPG integration complex        |
| Windows (PowerShell) | ❌ Not Supported | Bash/Zsh shell required                  |

**Windows Users:** This skill requires a bash-compatible shell. Options:

1. **WSL2 (Recommended)**: Install WSL2 with Ubuntu, configure GPG passthrough
2. **Git Bash**: Install Git for Windows, use bundled bash with GPG4Win

### Other Limitations

- **SSH signing**: GPG-based signing only; SSH signing keys planned for future
- **Platform scope**: GitHub-focused; Azure DevOps/GitLab integration planned
- **Bash version**: Requires bash 4.0+ for associative arrays

## Common Mistakes

**Red flags - STOP:**

- "I'll just change user.email manually" (breaks GPG signing)
- "Skip persona switch, it's a small change" (loses audit trail)
- "Use admin profile for everything" (violates least-privilege)
- "Commit as maintainer during implementation" (wrong permission level)

**Correct approach:**

- Always use `use_persona` to switch (handles all config atomically)
- Switch to appropriate role even for small changes
- Use contributor profile for implementation work
- Elevate to maintainer only for approvals/merges

## Evidence Requirements

### Setup Evidence

- [ ] Playbook generated at `docs/playbooks/persona-switching.md`
- [ ] Shell config generated with `chmod 600` permissions
- [ ] GPG keys validated for all configured emails
- [ ] `use_persona` and `show_persona` commands tested

### Runtime Evidence

- [ ] Persona switch logged in session
- [ ] `show_persona` confirms correct identity
- [ ] `gh auth status` shows expected account
- [ ] Test commit verifies GPG signature valid

## References

- `references/persona-config-template.sh` - Shell script template
- `references/playbook-template.md` - Playbook template for target repos
- `references/security-profiles.md` - Profile configuration guidance
- `references/delegation-patterns.md` - When to switch vs delegate
- `references/workflow-integration.md` - issue-driven-delivery integration
