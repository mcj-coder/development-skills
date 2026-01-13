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
