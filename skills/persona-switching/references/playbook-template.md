---
name: persona-switching
description: |
  Multi-identity Git/GitHub workflow configuration for {{REPO_NAME}}.
  Enables role-based commits with GPG signing and account separation.
summary: |
  1. Source persona config: source ~/.config/{{REPO_NAME}}/persona-config.sh
  2. Switch persona: use_persona <name>
  3. Verify: show_persona
triggers:
  - session start
  - switch persona
  - change identity
  - commit as different user
  - phase transition
---

# Persona Switching for {{REPO_NAME}}

## Quick Reference

```bash
# Load configuration (add to shell profile for persistence)
source ~/.config/{{REPO_NAME}}/persona-config.sh

# Switch to a persona
use_persona backend-engineer

# Verify current identity
show_persona

# View session history
persona_history

# Validate all profiles
validate_persona_config
```

## Available Personas

{{PERSONA_TABLE}}

## Security Profiles

{{PROFILE_TABLE}}

## Setup Instructions

### 1. Generate Shell Configuration

The persona-switching skill generates this file during setup:

```bash
~/.config/{{REPO_NAME}}/persona-config.sh
```

### 2. Set File Permissions

The shell config must have restricted permissions:

```bash
chmod 600 ~/.config/{{REPO_NAME}}/persona-config.sh
```

### 3. Add to Shell Profile

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Load persona configuration for {{REPO_NAME}}
if [ -f ~/.config/{{REPO_NAME}}/persona-config.sh ]; then
    source ~/.config/{{REPO_NAME}}/persona-config.sh
fi
```

### 4. Verify GPG Keys

Ensure GPG keys exist for all configured profiles:

```bash
# List available keys
gpg --list-secret-keys --keyid-format=long

# Validate all profiles
validate_persona_config
```

### 5. Configure GitHub Accounts

Ensure `gh` CLI is authenticated for each GitHub account:

```bash
# Add additional accounts
gh auth login

# Switch between accounts
gh auth switch --user <account-name>

# Check current account
gh auth status
```

## Security Considerations

### Credential Storage

| Credential Type | Storage Location                 | Security                |
| --------------- | -------------------------------- | ----------------------- |
| GPG keys        | User's GPG keyring (`~/.gnupg/`) | Protected by passphrase |
| GitHub tokens   | gh CLI config (`~/.config/gh/`)  | Managed by gh CLI       |
| Shell config    | `~/.config/{{REPO_NAME}}/`       | chmod 600 required      |

### GPG Agent Caching

To reduce passphrase prompts, configure `gpg-agent`:

```bash
# ~/.gnupg/gpg-agent.conf
default-cache-ttl 3600    # Cache for 1 hour
max-cache-ttl 7200        # Maximum 2 hours
```

Reload agent:

```bash
gpgconf --kill gpg-agent
```

### Shell History

The `use_persona` command is safe for shell history - it only logs persona names,
not credentials. Actual secrets remain in GPG keyring and gh CLI storage.

### Email/Key Validation

The shell config validates that Git `user.email` matches the GPG signing key's email
BEFORE allowing commits. This prevents "Unverified" commits on GitHub.

If you see an email/key mismatch error:

1. Check which email the key belongs to: `gpg --list-keys <key-id>`
2. Update the profile email to match, OR
3. Add the configured email as a UID to the key: `gpg --edit-key <key-id> adduid`

## Troubleshooting

### "Unknown persona" error

```bash
# List available personas
use_persona
```

### "GPG key not found" error

```bash
# List available keys
gpg --list-secret-keys

# Generate new key
gpg --full-generate-key
```

### "Email/key mismatch" error

The signing key's email must match Git's `user.email`. See the email shown in:

```bash
gpg --list-keys <your-key-id>
```

Then update either:

- The profile's email configuration, OR
- Add the email as a UID to the GPG key

### GitHub shows "Unverified"

1. Ensure email is verified on GitHub account
2. Ensure GPG public key is uploaded to GitHub
3. Check email/key match: `show_persona`

### "Could not switch GitHub account"

```bash
# Re-authenticate the account
gh auth login

# List authenticated accounts
gh auth status
```

## Phase-Persona Recommendations

| Development Phase | Recommended Persona       | Profile     |
| ----------------- | ------------------------- | ----------- |
| Refinement        | Tech Lead                 | maintainer  |
| Implementation    | Backend/Frontend Engineer | contributor |
| Code Review       | Senior Engineer           | contributor |
| Security Review   | Security Reviewer         | contributor |
| Verification      | QA Engineer               | contributor |
| Approval/Merge    | Tech Lead                 | maintainer  |

## See Also

<!-- Future playbooks (not yet implemented):
- enable-signed-commits.md - GPG setup guide
- conducting-pr-reviews.md - Review process
-->
