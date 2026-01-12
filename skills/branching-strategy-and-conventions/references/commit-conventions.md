# Commit Conventions

## Conventional Commits Format

```text
type(scope): subject

[optional body]

[optional footer]
```

## Commit Types

| Type       | SemVer Impact | Description               |
| ---------- | ------------- | ------------------------- |
| `feat`     | MINOR         | New feature               |
| `fix`      | PATCH         | Bug fix                   |
| `feat!`    | MAJOR         | Breaking change (feature) |
| `fix!`     | MAJOR         | Breaking change (fix)     |
| `docs`     | None          | Documentation only        |
| `chore`    | None          | Maintenance tasks         |
| `refactor` | None          | Code refactoring          |
| `test`     | None          | Test changes              |
| `ci`       | None          | CI/CD changes             |
| `perf`     | PATCH         | Performance improvement   |

## Breaking Changes

Two formats for breaking changes:

### Format 1: Type Suffix

```text
feat!: remove deprecated API endpoints
```

### Format 2: Footer

```text
feat: update authentication flow

BREAKING CHANGE: OAuth tokens now expire after 1 hour instead of 24 hours.
```

## Examples

**Feature:**

```text
feat(auth): add two-factor authentication support
```

**Bug fix:**

```text
fix(api): resolve null pointer in user lookup
```

**Breaking change:**

```text
feat(api)!: change response format from XML to JSON

BREAKING CHANGE: All API responses now return JSON instead of XML.
Clients must update parsers accordingly.
```

**Docs:**

```text
docs: update API authentication guide
```

## Tooling Setup

### commitlint

Install:

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

Configure `commitlint.config.js`:

```javascript
module.exports = {
  extends: ["@commitlint/config-conventional"],
};
```

### Husky (Pre-commit Hook)

Install:

```bash
npm install --save-dev husky
npx husky init
```

Add commit-msg hook:

```bash
echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
```

### commitizen (Interactive Commits)

Install:

```bash
npm install --save-dev commitizen cz-conventional-changelog
```

Configure `package.json`:

```json
{
  "config": {
    "commitizen": {
      "path": "cz-conventional-changelog"
    }
  }
}
```

Usage:

```bash
git cz  # Interactive commit
```

## CI Validation

**GitHub Actions:**

```yaml
- name: Validate commits
  uses: wagoid/commitlint-github-action@v5
```

**Azure DevOps:**

```yaml
- script: npx commitlint --from $(System.PullRequest.TargetBranch) --to HEAD
  displayName: Validate commit messages
```

## Brownfield Approach

For existing repositories with inconsistent history:

1. Document baseline: existing commits exempt
2. Configure validation for new commits only
3. In commitlint config, validate from merge-base:

   ```bash
   npx commitlint --from $(git merge-base HEAD main)
   ```

4. Do not rewrite existing history
