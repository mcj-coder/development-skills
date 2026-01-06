# Git Hooks Setup

Configure pre-commit hooks to enforce standards before code reaches the repository.

## Principle: Staged-Only Checks for Speed

**Local hooks should check only staged files:**

- Fast feedback (<5 seconds typical)
- Doesn't block on unrelated issues
- Encourages frequent commits

**CI checks all files:**

- Comprehensive validation
- Catches issues missed by staged-only checks
- Authoritative gate before merge

## Husky (Node.js Projects)

### Installation

```bash
# Install Husky and lint-staged
npm install --save-dev husky lint-staged

# Initialize Husky
npx husky init
```

### Pre-Commit Hook

**.husky/pre-commit**:

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
```

### lint-staged Configuration

**lint-staged.config.js**:

```javascript
module.exports = {
  // TypeScript/JavaScript
  "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],

  // JSON, YAML, Markdown
  "*.{json,yaml,yml,md}": ["prettier --write"],

  // All text files - spell check
  "*.{ts,tsx,js,jsx,md,json}": ["cspell --no-must-find-files"],
};
```

### Alternative: package.json Configuration

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{json,yaml,yml,md}": ["prettier --write"],
    "*.{ts,tsx,js,jsx,md}": ["cspell --no-must-find-files"]
  }
}
```

### package.json Scripts

```json
{
  "scripts": {
    "prepare": "husky",
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "spell": "cspell \"**/*.{ts,tsx,js,jsx,md,json}\"",
    "validate": "npm run lint && npm run format:check && npm run spell && npm test"
  }
}
```

## Husky.Net (.NET Projects)

### Installation

```bash
# Install Husky.Net
dotnet new tool-manifest
dotnet tool install Husky

# Initialize
dotnet husky install
```

### Task Runner Configuration

**.husky/task-runner.json**:

```json
{
  "tasks": [
    {
      "name": "dotnet-format",
      "command": "dotnet",
      "args": ["format", "--verify-no-changes", "--include", "${staged}"],
      "include": ["**/*.cs"]
    },
    {
      "name": "spell-check",
      "command": "npx",
      "args": ["cspell", "--no-must-find-files", "${staged}"],
      "include": ["**/*.cs", "**/*.md"]
    },
    {
      "name": "build-check",
      "command": "dotnet",
      "args": ["build", "--no-restore", "-warnaserror"]
    }
  ]
}
```

### Pre-Commit Hook

**.husky/hooks/pre-commit**:

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

dotnet husky run
```

## pre-commit Framework (Python)

### Installation

```bash
pip install pre-commit
pre-commit install
```

### Configuration

**.pre-commit-config.yaml**:

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.4
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0
    hooks:
      - id: mypy
        additional_dependencies: [types-all]

  - repo: https://github.com/streetsidesoftware/cspell-cli
    rev: v8.8.0
    hooks:
      - id: cspell
        files: \.(py|md)$

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.8
    hooks:
      - id: bandit
        args: [-r, src]
        exclude: tests/

default_language_version:
  python: python3.11
```

### Makefile Integration

```makefile
.PHONY: install lint format test validate

install:
	pip install -r requirements.txt
	pre-commit install

lint:
	ruff check .

format:
	ruff format .

test:
	pytest

validate: lint test
	pre-commit run --all-files
```

## Cross-Platform Scripts

For projects that need to work across multiple platforms:

### validate.sh (Unix/macOS/Git Bash)

```bash
#!/usr/bin/env bash
set -e

echo "Running validation..."

# Detect project type
if [ -f "package.json" ]; then
    echo "Node.js project detected"
    npm run validate
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    echo "Python project detected"
    make validate
elif [ -f "*.sln" ] || [ -f "*.csproj" ]; then
    echo ".NET project detected"
    pwsh -File validate.ps1
else
    echo "Unknown project type"
    exit 1
fi

echo "Validation passed!"
```

### validate.ps1 (Windows PowerShell)

```powershell
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "Running validation..." -ForegroundColor Cyan

# Detect project type
if (Test-Path "package.json") {
    Write-Host "Node.js project detected" -ForegroundColor Yellow
    npm run validate
}
elseif ((Test-Path "pyproject.toml") -or (Test-Path "setup.py")) {
    Write-Host "Python project detected" -ForegroundColor Yellow
    make validate
}
elseif ((Get-ChildItem -Filter "*.sln" -ErrorAction SilentlyContinue) -or
        (Get-ChildItem -Filter "*.csproj" -ErrorAction SilentlyContinue)) {
    Write-Host ".NET project detected" -ForegroundColor Yellow
    dotnet format --verify-no-changes
    dotnet build -warnaserror
    dotnet test
}
else {
    Write-Host "Unknown project type" -ForegroundColor Red
    exit 1
}

Write-Host "Validation passed!" -ForegroundColor Green
```

## Bypassing Hooks (Emergency Only)

For genuine emergencies, hooks can be bypassed:

```bash
# Bypass pre-commit hooks (use sparingly!)
git commit --no-verify -m "Emergency fix"
```

**Document all bypasses** in the commit message and create a follow-up task to address the skipped checks.

## Troubleshooting

### "Hook takes too long"

1. Ensure lint-staged is configured (staged files only)
2. Check if tests are running in hooks (move to CI)
3. Use parallel execution where possible

### "Hook fails but CI passes"

1. Check tool versions match (package.json vs CI)
2. Verify same config files are used
3. Check for platform-specific differences

### "Team member can't commit"

1. Verify hook is installed: `ls .git/hooks/pre-commit`
2. Re-run install: `npx husky install` or `dotnet husky install`
3. Check execute permissions: `chmod +x .husky/pre-commit`

### "Too many false positives"

1. Tune tool configurations (ESLint rules, cspell dictionary)
2. Use `// eslint-disable-next-line` sparingly with justification
3. Add to `.eslintignore`, `.prettierignore` if appropriate

## Hook Maintenance

1. **Update hook tools** - Include in regular dependency updates
2. **Test hooks in CI** - Run same commands to catch drift
3. **Document exceptions** - Any disabled rules need justification
4. **Review periodically** - Remove obsolete ignores/exceptions
