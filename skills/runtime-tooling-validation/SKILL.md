---
name: runtime-tooling-validation
description: Use when setting up a development environment, cloning a repository, or before running builds and tests. Validates runtime dependencies, SDK versions, environment variables, and service connectivity before attempting operations that would fail without them.
---

# Runtime Tooling Validation

## Overview

**P1 Quality & Correctness** - Validate prerequisites before operations that depend on them.

**Principle:** Validate first, run second. Never discover missing dependencies through runtime failures.

## When to Use

- Cloning and setting up a new repository
- Before running builds, tests, or applications
- Debugging "works on my machine" issues
- Onboarding new team members
- After CI passes but local fails
- **Opt-out**: Validated environment confirmed within current session

## Core Workflow

1. Identify project type and requirements sources
2. Check runtime/SDK version against project specification
3. Verify required tools and extensions installed
4. Validate environment variables against template
5. Test connectivity to required services
6. Report all issues with remediation commands
7. Proceed with build/run only after validation passes

## Quick Reference

| Check Type          | .NET                         | Node.js         | Python           |
| ------------------- | ---------------------------- | --------------- | ---------------- |
| Version requirement | global.json                  | .nvmrc, engines | .python-version  |
| Version command     | dotnet --version             | node --version  | python --version |
| Package validation  | dotnet restore               | npm ls          | pip check        |
| Tool requirements   | dotnet tool list             | npx --version   | pip list         |
| Env var template    | appsettings.Development.json | .env.example    | .env.example     |

## Validation Commands

```bash
# .NET SDK validation
dotnet --list-sdks
cat global.json  # Compare required version

# Node.js validation
node --version
cat .nvmrc       # Compare required version
npm ls           # Check peer dependencies

# Python validation
python --version
cat .python-version  # Compare required version
pip check            # Verify installed packages

# Docker validation
docker version
docker compose version
docker ps        # Daemon running check
```

## Environment Variable Validation

1. Find template file (.env.example, appsettings template)
2. Compare against current environment
3. List missing variables with descriptions
4. Provide secure value guidance (secrets vs defaults)

```bash
# Compare .env.example with current .env
comm -23 <(grep -oP '^[A-Z_]+' .env.example | sort) \
         <(grep -oP '^[A-Z_]+' .env 2>/dev/null | sort)
```

## Service Connectivity Checks

Before integration tests or full application startup:

- Database: Test connection with timeout
- Message queue: Verify broker reachable
- External APIs: Validate auth configured
- Cache: Confirm service available

## Red Flags - STOP

- "Let's try it and see"
- "The error will tell us"
- "Just run npm install"
- "Works on CI"
- "Should work"

**All mean:** Run validation checks first. 30 seconds of validation saves hours of debugging.

## Remediation Pattern

When issues found, provide:

1. What is missing or wrong
2. Why it matters
3. Exact command to fix
4. Verification command after fix

```markdown
Issue: Node.js version mismatch
Required: 20.x (from .nvmrc)
Current: 18.17.0
Fix: nvm install 20 && nvm use 20
Verify: node --version
```

## Command Output Examples

### .NET Validation Example

```bash
$ dotnet --list-sdks
6.0.401 [/usr/share/dotnet/sdk]
7.0.203 [/usr/share/dotnet/sdk]
8.0.100 [/usr/share/dotnet/sdk]

$ cat global.json
{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "latestMinor"
  }
}

$ dotnet --version
8.0.100
✓ SDK version matches requirement
```

### Node.js Validation Example

```bash
$ cat .nvmrc
20

$ node --version
v20.10.0
✓ Node version matches requirement

$ npm ls --depth=0
my-project@1.0.0
├── express@4.18.2
├── typescript@5.3.2
└── UNMET PEER DEPENDENCY react@17.0.2

✗ Unmet peer dependency found - run: npm install react@18
```

### Python Validation Example

```bash
$ cat .python-version
3.11

$ python --version
Python 3.11.5
✓ Python version matches requirement

$ pip check
No broken requirements found.
✓ All dependencies satisfied
```

### Docker Validation Example

```bash
$ docker version --format '{{.Server.Version}}'
24.0.7
✓ Docker daemon running

$ docker compose version
Docker Compose version v2.23.0
✓ Compose available

$ docker ps
CONTAINER ID   IMAGE   ...
✓ Can list containers (permissions OK)
```

## Must-Pass Checklist by Stack

### .NET Checklist

- [ ] `dotnet --version` matches global.json requirement
- [ ] `dotnet restore` completes without errors
- [ ] `dotnet tool restore` installs required tools (if .config/dotnet-tools.json exists)
- [ ] Database connection string configured (if applicable)
- [ ] Environment variables from appsettings template set

```bash
#!/bin/bash
# dotnet-validate.sh
ERRORS=0

# Check SDK version
REQUIRED=$(jq -r '.sdk.version' global.json 2>/dev/null)
CURRENT=$(dotnet --version)
if [[ "$CURRENT" != "$REQUIRED"* ]]; then
  echo "✗ SDK mismatch: need $REQUIRED, have $CURRENT"
  ((ERRORS++))
else
  echo "✓ SDK version: $CURRENT"
fi

# Check restore
if dotnet restore --verbosity quiet; then
  echo "✓ Package restore successful"
else
  echo "✗ Package restore failed"
  ((ERRORS++))
fi

# Check tools
if [ -f ".config/dotnet-tools.json" ]; then
  if dotnet tool restore; then
    echo "✓ Tool restore successful"
  else
    echo "✗ Tool restore failed"
    ((ERRORS++))
  fi
fi

exit $ERRORS
```

### Node.js Checklist

- [ ] `node --version` matches .nvmrc or engines.node
- [ ] `npm ls` shows no unmet peer dependencies
- [ ] `npm ci` completes without errors
- [ ] Environment variables from .env.example set

```bash
#!/bin/bash
# node-validate.sh
ERRORS=0

# Check Node version
if [ -f ".nvmrc" ]; then
  REQUIRED=$(cat .nvmrc)
  CURRENT=$(node --version | sed 's/v//')
  if [[ "$CURRENT" != "$REQUIRED"* ]]; then
    echo "✗ Node mismatch: need $REQUIRED, have $CURRENT"
    echo "  Fix: nvm use $REQUIRED"
    ((ERRORS++))
  else
    echo "✓ Node version: $CURRENT"
  fi
fi

# Check dependencies
if npm ls --depth=0 2>&1 | grep -q "UNMET"; then
  echo "✗ Unmet peer dependencies found"
  npm ls --depth=0 2>&1 | grep "UNMET"
  ((ERRORS++))
else
  echo "✓ All dependencies satisfied"
fi

# Check env vars
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  echo "✗ .env file missing (copy from .env.example)"
  ((ERRORS++))
fi

exit $ERRORS
```

### Python Checklist

- [ ] `python --version` matches .python-version or pyproject.toml
- [ ] `pip check` shows no broken requirements
- [ ] `pip install -r requirements.txt` completes without errors
- [ ] Virtual environment activated

```bash
#!/bin/bash
# python-validate.sh
ERRORS=0

# Check Python version
if [ -f ".python-version" ]; then
  REQUIRED=$(cat .python-version)
  CURRENT=$(python --version 2>&1 | awk '{print $2}')
  if [[ "$CURRENT" != "$REQUIRED"* ]]; then
    echo "✗ Python mismatch: need $REQUIRED, have $CURRENT"
    ((ERRORS++))
  else
    echo "✓ Python version: $CURRENT"
  fi
fi

# Check virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
  echo "⚠ No virtual environment active"
  echo "  Fix: source venv/bin/activate"
fi

# Check dependencies
if pip check 2>&1 | grep -q "No broken"; then
  echo "✓ All dependencies satisfied"
else
  echo "✗ Broken dependencies found"
  pip check
  ((ERRORS++))
fi

exit $ERRORS
```

### Universal Checklist

- [ ] Git repository initialized and clean
- [ ] Required environment variables set
- [ ] Database/services reachable (if applicable)
- [ ] Docker daemon running (if using containers)

```bash
#!/bin/bash
# universal-validate.sh
ERRORS=0

# Git check
if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "✓ Git repository"
else
  echo "✗ Not a git repository"
  ((ERRORS++))
fi

# Docker check (if docker-compose.yml exists)
if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
  if docker ps > /dev/null 2>&1; then
    echo "✓ Docker daemon running"
  else
    echo "✗ Docker daemon not running"
    ((ERRORS++))
  fi
fi

exit $ERRORS
```
