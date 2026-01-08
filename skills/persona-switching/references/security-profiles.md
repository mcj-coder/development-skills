# Security Profiles Reference

## Overview

Security profiles define distinct identity configurations for different permission levels.
Each profile combines a GitHub account, email address, and GPG signing key.

## Default Profile Set

Most repositories use three profiles aligned with GitHub permission levels:

| Profile       | Purpose                   | Typical Permissions                    |
| ------------- | ------------------------- | -------------------------------------- |
| `contributor` | Standard development work | Push to branches, create PRs           |
| `maintainer`  | Elevated operations       | Merge PRs, manage labels, close issues |
| `admin`       | Repository administration | Branch protection, settings, releases  |

## Configuration Format

Profiles are defined in the shell configuration using associative arrays:

```bash
declare -A SECURITY_PROFILES

# Contributor profile (standard development)
SECURITY_PROFILES[contributor_account]="dev-bot-account"
SECURITY_PROFILES[contributor_email]="dev@company.com"
SECURITY_PROFILES[contributor_gpg_key]="ABC123DEF456"
SECURITY_PROFILES[contributor_name]="Claude (Developer)"

# Maintainer profile (elevated operations)
SECURITY_PROFILES[maintainer_account]="lead-bot-account"
SECURITY_PROFILES[maintainer_email]="lead@company.com"
SECURITY_PROFILES[maintainer_gpg_key]="DEF456GHI789"
SECURITY_PROFILES[maintainer_name]="Claude (Tech Lead)"

# Admin profile (repository administration)
SECURITY_PROFILES[admin_account]="admin-bot-account"
SECURITY_PROFILES[admin_email]="admin@company.com"
SECURITY_PROFILES[admin_gpg_key]="GHI789JKL012"
SECURITY_PROFILES[admin_name]="Claude (Admin)"
```

## Field Descriptions

| Field       | Required    | Description                                              |
| ----------- | ----------- | -------------------------------------------------------- |
| `*_account` | Optional    | GitHub account name for `gh auth switch`                 |
| `*_email`   | Required    | Email for Git commits (must match GPG key)               |
| `*_gpg_key` | Recommended | GPG key ID for commit signing                            |
| `*_name`    | Optional    | Display name for commits (default: "Claude (<persona>)") |

## Email/Key Requirements

**Critical**: The `*_email` value MUST match one of the UIDs on the GPG key.
Mismatches cause "Unverified" badges on GitHub commits.

To check a key's emails:

```bash
gpg --list-keys <key-id>
```

To add an email to an existing key:

```bash
gpg --edit-key <key-id>
gpg> adduid
gpg> save
```

## Token Scoping Recommendations

For security, each GitHub account should have minimal required permissions:

### Contributor Account

```yaml
permissions:
  contents: write # Push to branches
  pull-requests: write # Create/update PRs
  issues: read # Read issues for context
```

### Maintainer Account

```yaml
permissions:
  contents: write # Push to branches
  pull-requests: write # Merge PRs
  issues: write # Close issues, manage labels
  discussions: write # Manage discussions
```

### Admin Account

```yaml
permissions:
  administration: write # Repository settings
  contents: write # All content operations
  pull-requests: write # All PR operations
  issues: write # All issue operations
```

## Customization Guidelines

### Single-Account Repositories

If using a single GitHub account for all operations, configure all profiles
with the same account but different GPG keys for audit trail:

```bash
SECURITY_PROFILES[contributor_account]="my-account"
SECURITY_PROFILES[contributor_email]="dev@me.com"
SECURITY_PROFILES[contributor_gpg_key]="KEY_FOR_DEV"

SECURITY_PROFILES[maintainer_account]="my-account"
SECURITY_PROFILES[maintainer_email]="lead@me.com"
SECURITY_PROFILES[maintainer_gpg_key]="KEY_FOR_LEAD"
```

### Team Repositories

For team repositories with real separation of duties:

```bash
# Different accounts with different access levels
SECURITY_PROFILES[contributor_account]="team-dev-bot"
SECURITY_PROFILES[maintainer_account]="team-lead-bot"
SECURITY_PROFILES[admin_account]="team-admin-bot"
```

### Personal Repositories

For personal projects, you might use a single profile:

```bash
# Minimal setup - just contributor
SECURITY_PROFILES[contributor_account]="my-username"
SECURITY_PROFILES[contributor_email]="me@example.com"
SECURITY_PROFILES[contributor_gpg_key]="MY_KEY"
```

## Validation

Run `validate_persona_config` after setup to verify:

1. All configured emails have matching GPG keys
2. GPG keys are not expired
3. GPG keys exist in the local keyring

```bash
$ validate_persona_config

=== Validating Persona Configuration ===

Profile: contributor
  Email: dev@company.com
  GPG Key: ABC123DEF456
  Status: OK

Profile: maintainer
  Email: lead@company.com
  GPG Key: DEF456GHI789
  Status: OK

All configured profiles are valid
```
