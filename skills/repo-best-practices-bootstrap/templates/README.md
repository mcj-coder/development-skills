# Templates

This directory contains templates for repository configuration and documentation files.
Use these templates when bootstrapping new repositories or auditing existing ones.

## Directory Structure

```text
templates/
├── README.md              # This file
├── common/                # Platform-agnostic templates
│   ├── CLAUDE.md.template      # Agent onboarding
│   ├── AGENTS.md.template      # Agent execution rules
│   ├── CONTRIBUTING.md.template # Contribution guidelines
│   ├── SECURITY.md.template    # Security policy
│   ├── .editorconfig           # Editor settings
│   ├── .gitattributes          # Git attributes
│   └── .pre-commit-config.yaml # Pre-commit hooks
├── gitignore/             # Language-specific gitignore files
│   ├── node.gitignore          # Node.js projects
│   ├── dotnet.gitignore        # .NET projects
│   └── python.gitignore        # Python projects
└── github/                # GitHub-specific templates
    ├── branch-protection.json  # Classic branch protection
    ├── ruleset.json            # Modern repository rulesets
    ├── CODEOWNERS.template     # Code ownership
    ├── dependabot.yml          # Dependabot configuration
    └── workflows/
        ├── ci.yml              # CI workflow template
        └── oidc-deploy.yml     # OIDC deployment examples
```

## Usage

### Common Templates

These templates require customization before use. Replace placeholders:

| Placeholder         | Replace With               |
| ------------------- | -------------------------- |
| `[PROJECT-NAME]`    | Your project name          |
| `[REPO-URL]`        | Your repository URL        |
| `[INSTALL-COMMAND]` | Dependency install command |
| `[TEST-COMMAND]`    | Test execution command     |
| `[DEV-COMMAND]`     | Development server command |
| `[LINT-COMMAND]`    | Linting command            |
| `[BUILD-COMMAND]`   | Build command              |
| `[SECURITY-EMAIL]`  | Security contact email     |

### Copying Templates

```bash
# Copy a template to your repository
cp templates/common/CLAUDE.md.template CLAUDE.md

# Copy .editorconfig (no customization needed)
cp templates/common/.editorconfig .editorconfig

# Copy language-specific gitignore
cp templates/gitignore/node.gitignore .gitignore
```

### GitHub Templates

GitHub templates include JSON configurations for the GitHub API:

```bash
# Apply branch protection via API
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --input templates/github/branch-protection.json

# Apply repository ruleset
gh api repos/{owner}/{repo}/rulesets \
  --method POST \
  --input templates/github/ruleset.json
```

### Pre-commit Configuration

The pre-commit template includes common hooks. To use:

1. Copy the template: `cp templates/common/.pre-commit-config.yaml .`
2. Install pre-commit: `pip install pre-commit`
3. Install hooks: `pre-commit install`
4. Uncomment language-specific sections as needed

## Cross-References

- For agent-specific templates, also see:
  `skills/skills-first-workflow/references/AGENTS-TEMPLATE.md`
- For checklist of all features:
  `skills/repo-best-practices-bootstrap/references/checklist.md`
- For platform-specific CLI commands:
  `skills/repo-best-practices-bootstrap/references/platform-detection.md`
