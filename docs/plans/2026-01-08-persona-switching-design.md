# Persona-Switching Skill Design

**Date:** 2026-01-08
**Status:** Design
**Related Issue:** #153

## Goal

Create a skill that enables repositories to adopt multi-identity Git/GitHub workflows where
agents work under role-specific personas (e.g., "Claude (Backend Engineer)") while maintaining
GPG signing integrity and appropriate permission levels.

## Problem Statement

Agents currently work under a single Git identity for all tasks, creating:

- No distinction between development work and elevated operations
- Review commits indistinguishable from implementation commits
- Single GitHub account used for everything (permission conflicts)
- Manual persona attempts break GPG signing (email mismatch)
- No guidance on which identity to use for different task types

## Requirements

1. **Bootstrap target repos** with persona configuration (playbook + shell config)
2. **Guide agents** on which persona to use for different task types
3. **Integrate with issue-driven-delivery** phase transitions
4. **Support ownership + delegation patterns** (owner invokes specialists)
5. **Preserve GPG signing validity** when switching personas
6. **Configurable security profiles** for different permission levels

## Skill Purpose & Triggers

### Primary Goals

1. Bootstrap target repos with persona configuration (playbook + shell config)
2. Guide agents on which persona to use for different task types
3. Integrate with issue-driven-delivery's phase transitions
4. Support ownership + delegation patterns (owner invokes specialists)

### Triggers (when skill activates)

| Trigger Type  | Condition                                           | Action                                    |
| ------------- | --------------------------------------------------- | ----------------------------------------- |
| Explicit      | User requests "set up personas" or "switch persona" | Full setup or quick switch                |
| Bootstrap     | `repo-best-practices-bootstrap` runs on target repo | Prompt: "Enable multi-identity workflow?" |
| Workflow      | issue-driven-delivery phase transition              | Suggest appropriate persona for phase     |
| Role mismatch | Current persona doesn't match task context          | Recommend persona switch                  |

### Detection Logic

- Check for existing `docs/playbooks/persona-switching.md` in target repo
- If exists: skill provides runtime guidance only
- If missing: skill triggers setup flow first

## Account & Security Profile Structure

### Configurable Tiers

Rather than hardcoding "developer" and "team lead", the skill supports N security profiles
that repos define based on their needs.

### Default Profiles (reference)

| Profile       | Purpose                   | Typical Permissions                    |
| ------------- | ------------------------- | -------------------------------------- |
| `contributor` | Standard development work | Push to branches, create PRs           |
| `maintainer`  | Elevated operations       | Merge PRs, manage labels, close issues |
| `admin`       | Repository administration | Branch protection, settings, releases  |

### Profile Configuration (per repo)

```yaml
# Example: target repo's persona config
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

Repos customize these mappings based on their team structure and permission model.

## Role Discovery & Persona Configuration

### Discovery Flow (during setup)

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

4. Generate customized configuration
```

### Role File Parsing Priority

1. **Frontmatter** (preferred): `name:`, `title:`, or `role:` fields
2. **Content headings**: First H1 heading as role name
3. **Filename** (fallback): `tech-lead.md` -> "Tech Lead"

### When No Roles Exist

Many repos won't have `docs/roles/` defined. The skill:

- Uses reference personas as starting suggestions
- Prompts user through brainstorming to identify needed roles
- Optionally offers to create role docs as part of setup (separate from persona config)

### Reference Personas (defaults)

| Category      | Personas                                                                                            |
| ------------- | --------------------------------------------------------------------------------------------------- |
| Development   | Backend Engineer, Frontend Engineer, Senior Engineer                                                |
| Quality       | QA Engineer                                                                                         |
| Leadership    | Tech Lead, Scrum Master                                                                             |
| Specialist    | Security Engineer, DevOps Engineer, Performance Engineer, Technical Architect, Agent Skill Engineer |
| Documentation | Documentation Specialist                                                                            |

## Ownership & Delegation Model

### Phase Ownership (issue-driven-delivery integration)

| Phase           | Default Owner          | Delegation Pattern                                           |
| --------------- | ---------------------- | ------------------------------------------------------------ |
| Refinement      | Tech Lead              | Invokes specialists for domain-specific input                |
| Implementation  | Domain expert (varies) | Invokes specialists for sub-tasks + pre-verification reviews |
| Verification    | QA Engineer            | Invokes Architecture/Security/Performance for expert reviews |
| Review/Approval | Tech Lead              | Lightweight - work already validated                         |

### Ownership Selection Logic

- **Skill authoring tasks**: Agent Skill Engineer owns, delegates to Backend/QA for validation
- **E2E feature tasks**: Senior Engineer owns, delegates to Backend/Frontend for implementation
- **Bug fixes**: Domain expert owns based on affected area
- **Infrastructure tasks**: DevOps Engineer owns

### Delegation Mechanics (context-dependent)

| Situation               | Mechanism            | Rationale                          |
| ----------------------- | -------------------- | ---------------------------------- |
| Quick review (< 10 min) | Persona switch       | Low overhead, stays in flow        |
| Substantial sub-task    | Sub-agent delegation | Parallel work, cleaner separation  |
| Multi-domain work       | Multiple sub-agents  | Backend + Frontend simultaneously  |
| Expert consultation     | Persona switch       | Brief input, owner retains context |

### "Dev Complete" Gate

Before transitioning from Implementation to Verification:

1. Owner invokes relevant specialist personas for review
2. Each specialist validates their domain concerns
3. Only after specialist sign-off does work move to QA

This front-loads validation so final Review/Approval is a formality.

## Generated Artifacts

### 1. Playbook (`docs/playbooks/persona-switching.md`)

Frontmatter with triggers for auto-loading:

```yaml
---
name: persona-switching
description: |
  Multi-identity Git/GitHub workflow configuration for this repository.
  Enables role-based commits with GPG signing and account separation.
summary: |
  1. Source persona config: source ~/.config/repo-name/persona-config.sh
  2. Switch persona: use_persona <name>
  3. Verify: show_persona
triggers:
  - session start
  - switch persona
  - change identity
  - commit as different user
---
```

Body contains:

- Available personas for this repo (customized list)
- Security profile mappings
- Quick reference commands
- Troubleshooting section

### 2. Shell Config Template (copied to user's machine)

Location: `~/.config/<repo-name>/persona-config.sh`

Contains:

- Security profile definitions (accounts, emails, GPG keys)
- Persona-to-profile mappings
- `use_persona` function
- `show_persona` function
- Shell aliases for quick switching

### 3. Setup Instructions (in playbook)

- GPG key generation per account
- GitHub CLI multi-account auth (`gh auth login`)
- Shell profile sourcing instructions
- Verification steps

## Skill Structure (in development-skills repo)

### Directory Layout

```text
skills/persona-switching/
|-- SKILL.md                    # Main skill specification
|-- persona-switching.test.md   # BDD test scenarios
+-- references/
    |-- persona-config-template.sh      # Shell script template
    |-- playbook-template.md            # Playbook template for target repos
    |-- security-profiles.md            # Profile configuration guidance
    |-- delegation-patterns.md          # When to switch vs sub-agent
    +-- workflow-integration.md         # issue-driven-delivery integration
```

### SKILL.md Sections

1. **Overview** - Purpose and when to use
2. **Prerequisites** - GPG, gh CLI, shell access
3. **Triggers** - When skill activates (explicit, bootstrap, workflow)
4. **Setup Flow** - Steps to configure a new repo
5. **Runtime Usage** - How to switch personas during work
6. **Ownership Model** - Phase ownership and delegation patterns
7. **Integration** - Links to issue-driven-delivery, pre-commit hooks
8. **Common Mistakes / Red Flags** - Following repo conventions

### Template Variables (in persona-config-template.sh)

```bash
# Placeholders replaced during setup
{{REPO_NAME}}
{{SECURITY_PROFILES}}      # Generated profile definitions
{{PERSONAS}}               # Generated persona mappings
{{PROFILE_PERSONAS}}       # Which personas use which profile
```

### Playbook Template Variables

```markdown
{{REPO_NAME}}
{{PERSONA_TABLE}} # Markdown table of available personas
{{PROFILE_TABLE}} # Security profile descriptions
{{SETUP_INSTRUCTIONS}} # Customized per platform (GitHub/ADO/GitLab)
```

## Integration Points

### Issue-Driven-Delivery Integration

| Workflow Step                    | Persona Suggestion          | Trigger                            |
| -------------------------------- | --------------------------- | ---------------------------------- |
| Step 3b (refinement start)       | Tech Lead                   | `state:refinement` label added     |
| Step 7a (implementation handoff) | Domain expert based on task | `state:implementation` label added |
| Step 8c (verification start)     | QA Engineer                 | `state:verification` label added   |
| Step 11 (role reviews)           | Relevant specialists        | Review request in workflow         |

### Pre-Commit Hook Compatibility

The existing GPG signing verification hook (`enable-signed-commits` playbook) validates:

- `commit.gpgsign = true` configured
- Signature present on commits

Persona switching preserves validity because:

- GPG validates against email, not author name
- Each security profile has consistent email + GPG key pairing
- Author name changes ("Claude (Backend Engineer)") don't break signatures

### Repo-Best-Practices-Bootstrap Integration

When bootstrap skill runs:

```text
1. Check: "Enable multi-identity workflow?" (Y/n)
2. If yes: Chain to persona-switching skill
3. Persona-switching runs setup flow
4. Bootstrap continues with remaining items
```

### Sub-Agent Spawning (for pair-programming skill #154)

When delegating substantial work:

```bash
# Owner spawns sub-agent with specific persona
Task tool with prompt: "Working as {{PERSONA}}. Task: {{DESCRIPTION}}"
Sub-agent sources persona config before starting
```

## BDD Test Scenarios

### RED Scenarios (expected failures without skill)

#### Scenario A: New repo without persona config

- Agent commits as default Git user for all tasks
- No distinction between dev work and elevated operations
- Review commits indistinguishable from implementation commits
- Single GitHub account used for everything (permission conflicts)

#### Scenario B: Manual persona attempts

- User tries to change author name manually
- GPG signing breaks (email mismatch)
- GitHub account doesn't switch (gh CLI still on wrong account)
- Commits show "Unverified" badge

#### Scenario C: Phase transitions without guidance

- Agent continues as same persona across all phases
- Tech Lead persona does implementation (wrong permissions scope)
- No specialist reviews before "Dev Complete"
- Final review catches issues that should have been found earlier

### GREEN Scenarios (expected with skill)

#### Setup Flow

- [ ] Skill detects missing playbook in target repo
- [ ] Skill discovers roles from `docs/roles/*.md` frontmatter (when present)
- [ ] Skill falls back to reference personas when no roles exist
- [ ] User can customize persona list and profile mappings
- [ ] Generated playbook has valid frontmatter with triggers
- [ ] Generated shell config has all security profiles
- [ ] GPG signing remains valid after persona switch

#### Runtime Usage

- [ ] `use_persona backend` switches to contributor profile
- [ ] `use_persona teamlead` switches to maintainer profile
- [ ] `show_persona` displays current identity correctly
- [ ] `gh auth status` shows correct GitHub account after switch

#### Workflow Integration

- [ ] Skill suggests Tech Lead for refinement phase
- [ ] Skill suggests domain expert for implementation phase
- [ ] Skill suggests QA Engineer for verification phase
- [ ] Owner can invoke specialist via persona switch (quick review)
- [ ] Owner can delegate to sub-agent (substantial work)

## Summary

| Aspect               | Decision                                                                    |
| -------------------- | --------------------------------------------------------------------------- |
| Skill scope          | Setup-focused, generates playbook in target repos                           |
| Triggers             | Explicit, bootstrap integration, workflow-context                           |
| Account model        | Configurable security profiles (contributor/maintainer/admin)               |
| Role discovery       | Frontmatter -> content -> filename; reference defaults when none            |
| Workflow integration | Suggest personas per phase, don't enforce                                   |
| Delegation           | Context-dependent: persona switch (quick) vs sub-agent (substantial)        |
| Ownership            | Phase owners invoke specialists; "Dev Complete" gate front-loads validation |

## Artifacts Created

1. `skills/persona-switching/SKILL.md` - Main skill spec
2. `skills/persona-switching/references/*` - Templates and guidance
3. `skills/persona-switching/persona-switching.test.md` - BDD tests
4. Target repo: `docs/playbooks/persona-switching.md` - Generated playbook
5. User machine: `~/.config/<repo>/persona-config.sh` - Shell config

## Dependencies

- `superpowers:brainstorming` - For role discovery in new repos
- `issue-driven-delivery` - Workflow phase integration
- `repo-best-practices-bootstrap` - Chained setup trigger
- `enable-signed-commits` playbook - GPG compatibility

## Open Questions

None - all key decisions made during brainstorming.

## Next Steps

1. Get design approval
2. Create implementation plan with sub-tasks using `superpowers:writing-plans`
3. Implement skill structure
4. Create BDD tests
5. Create reference templates
6. Update README.md skill list
