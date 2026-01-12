# Squash Merge Guide

## SemVer Preservation Principle

When squash merging a PR with multiple commits, the squash commit message must
reflect the **greatest SemVer impact** across all commits in the branch.

## Impact Hierarchy

```text
MAJOR (feat!, fix!, BREAKING CHANGE) > MINOR (feat) > PATCH (fix, perf)
```

## Squash Message Construction

### Step 1: Analyze All Commits

List commits in the PR:

```bash
git log --oneline main..HEAD
```

### Step 2: Identify Highest Impact

| If branch contains...         | Squash message type |
| ----------------------------- | ------------------- |
| Any `feat!`, `fix!`, BREAKING | `feat!:` or `fix!:` |
| Any `feat` (no breaking)      | `feat:`             |
| Only `fix`, `perf` (no feat)  | `fix:`              |
| Only `docs`, `chore`, etc.    | Appropriate type    |

### Step 3: Construct Message

#### Example: Branch with Mixed Commits

Commits in branch:

```text
fix(api): handle null response
feat(api): add pagination support
chore: update dependencies
```

Squash message:

```text
feat(api): add pagination support with bug fixes

- Add pagination support for list endpoints
- Handle null response edge case
- Update dependencies
```

#### Example: Branch with Breaking Change

Commits in branch:

```text
feat(auth): update token format
fix(auth): resolve expiry calculation
feat(auth)!: change token expiry to 1 hour
```

Squash message:

```text
feat(auth)!: update authentication with shorter token expiry

BREAKING CHANGE: Tokens now expire after 1 hour instead of 24 hours.

- Update token format
- Fix expiry calculation
- Reduce default expiry for security
```

## Merge Strategy Rules

### When to Squash Merge

- Multiple commits in feature branch
- WIP commits, fixup commits present
- Commit history contains noise

### When to Use Fast-Forward

- Single well-formed commit
- Hotfix with atomic change
- Commit message already correct

### When to Use Merge Commit (Git Flow only)

- Release branches to main
- Hotfix branches to main/develop
- Preserve release history

## Configuration

### GitHub Repository Settings

1. Settings > General > Pull Requests
2. Disable "Allow merge commits" (optional, per team preference)
3. Enable "Allow squash merging"
4. Set "Default commit message" to "Pull request title and description"

### Branch Protection Rules

1. Settings > Branches > Branch protection rules
2. Add rule for `main`:
   - Require pull request before merging
   - Require status checks to pass
   - Require linear history (enforces squash/rebase)

## Common Mistakes

| Mistake                             | Prevention                                  |
| ----------------------------------- | ------------------------------------------- |
| Using `fix:` when branch has `feat` | Always scan all commits for highest impact  |
| Missing BREAKING CHANGE footer      | Check for `!` suffix or breaking changes    |
| Generic squash message              | Summarize actual changes, not just PR title |
| Preserving WIP commits              | Squash to single meaningful commit          |

## Automation

For automated squash message generation, consider tools like:

- `semantic-release` for release automation
- Custom PR templates with squash guidance
- CI checks validating squash message format
