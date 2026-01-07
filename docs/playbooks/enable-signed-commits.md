# Playbook: Enable Signed Commits

## Overview

This playbook guides you through setting up GPG-signed commits for your repository.
Signed commits provide cryptographic verification that commits were made by the
claimed author.

## Prerequisites

- Git installed (2.0+)
- GPG installed (`gpg --version` to check)
- GitHub/GitLab/Azure DevOps account with write access

## Step 1: Check Existing GPG Keys

```bash
gpg --list-secret-keys --keyid-format=long
```

If you see output like `sec rsa4096/XXXXXXXXXXXXXXXX`, you already have a key.
Skip to Step 3.

## Step 2: Generate a New GPG Key

```bash
gpg --full-generate-key
```

When prompted:

1. **Key type:** Select `RSA and RSA` (default)
2. **Key size:** Enter `4096` for maximum security
3. **Expiration:** Choose based on your security policy (0 = never expires)
4. **Real name:** Enter your full name (must match your Git config)
5. **Email:** Enter your email (must match your GitHub verified email)
6. **Passphrase:** Create a strong passphrase

## Step 3: Get Your GPG Key ID

```bash
gpg --list-secret-keys --keyid-format=long
```

Output example:

```text
sec   rsa4096/3AA5C34371567BD2 2024-01-01 [SC]
      ABCDEF1234567890ABCDEF1234567890ABCDEF12
uid                 [ultimate] Your Name <your.email@example.com>
ssb   rsa4096/42B317FD4BA89E7A 2024-01-01 [E]
```

Your key ID is `3AA5C34371567BD2` (the part after `rsa4096/`).

## Step 4: Export Your Public Key

```bash
gpg --armor --export YOUR_KEY_ID
```

Copy the entire output including:

```text
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

## Step 5: Add Key to Your Platform

### GitHub

1. Go to **Settings** > **SSH and GPG keys** > **New GPG key**
2. Paste your public key
3. Click **Add GPG key**

### GitLab

1. Go to **Preferences** > **GPG Keys**
2. Paste your public key
3. Click **Add key**

### Azure DevOps

Azure DevOps does not natively support GPG signature verification.
Signed commits will show as unverified but are still cryptographically signed.

## Step 6: Configure Git

```bash
# Set your signing key
git config --global user.signingkey YOUR_KEY_ID

# Enable signing for all commits
git config --global commit.gpgsign true

# Enable signing for all tags
git config --global tag.gpgsign true
```

## Step 7: Configure GPG Agent (Recommended)

To avoid entering your passphrase for every commit:

### macOS/Linux

Add to `~/.gnupg/gpg-agent.conf`:

```text
default-cache-ttl 3600
max-cache-ttl 86400
```

Then reload:

```bash
gpgconf --kill gpg-agent
```

### Windows

GPG4Win includes a GUI agent. Ensure it's running in the system tray.

## Step 8: Test Your Setup

```bash
# Create a test commit
echo "test" >> test-signing.txt
git add test-signing.txt
git commit -m "test: verify GPG signing works"

# Verify the signature
git log --show-signature -1
```

You should see `Good signature from "Your Name <your.email@example.com>"`.

## Step 9: Verify on Platform

Push your test commit and check the commit on GitHub/GitLab.
You should see a "Verified" badge next to the commit.

## Step 10: Enable Branch Protection

**Only after verifying Steps 8-9 succeed:**

### GitHub

```bash
gh api repos/OWNER/REPO/branches/main/protection/required_signatures -X POST
```

### GitLab

```bash
glab api projects/PROJECT_ID/protected_branches/main -X PATCH \
  -f code_owner_approval_required=true
```

## Troubleshooting

### "gpg failed to sign the data"

```bash
# Ensure GPG_TTY is set
export GPG_TTY=$(tty)

# Add to your shell profile (~/.bashrc, ~/.zshrc)
echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
```

### "secret key not available"

Your Git email doesn't match your GPG key email:

```bash
git config --global user.email "your.gpg.email@example.com"
```

### Commits show "Unverified" on GitHub

1. Ensure your email is verified on GitHub
2. Ensure the GPG key email matches your GitHub verified email
3. Re-upload your public key if recently regenerated

## Pre-commit Hook Verification

Add this to `.husky/pre-commit` to warn if signing isn't configured:

```bash
# Check if GPG signing is enabled
if [ "$(git config --get commit.gpgsign)" != "true" ]; then
  echo "⚠️  WARNING: GPG commit signing is not enabled"
  echo "   Run: git config --global commit.gpgsign true"
  echo "   See: docs/playbooks/enable-signed-commits.md"
fi
```

## See Also

- [GitHub: Signing commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [GitLab: Signing commits with GPG](https://docs.gitlab.com/ee/user/project/repository/signed_commits/gpg.html)
- [GPG documentation](https://gnupg.org/documentation/)
