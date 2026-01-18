---
name: local-dev-experience
description: Use when setting up or optimizing local development environments for fast feedback loops. Applies to any project where iteration speed matters. Covers hot reload, incremental builds, test filtering, IDE optimization, and multi-service local development patterns.
metadata:
  type: Platform
  priority: P4
---

# Local Dev Experience

## Overview

**P3 Delivery & Flow** - Developer productivity through fast feedback loops.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Setting up new project for local development
- Build or test times exceed 5 seconds
- IDE performance issues
- Multi-service local development needs
- **Opt-out**: Explicit trade-off decision documented

## Core Workflow

1. Identify current iteration cycle time
2. Configure watch modes for automatic rebuilds
3. Enable incremental compilation/builds
4. Set up targeted test execution
5. Optimize IDE for project type
6. Configure minimal service dependencies
7. Document development startup patterns
8. Verify sub-second feedback achievable

## Quick Reference

| Pattern           | .NET                  | Node.js/TypeScript   | Python           |
| ----------------- | --------------------- | -------------------- | ---------------- |
| Hot Reload        | dotnet watch          | nodemon, tsx         | uvicorn --reload |
| Incremental Build | Directory.Build.props | tsconfig incremental | N/A              |
| Test Watch        | dotnet watch test     | jest --watch         | pytest-watch     |
| Test Filter       | --filter              | --testNamePattern    | -k               |
| Lint Cache        | N/A                   | eslint --cache       | ruff --cache     |

## Watch Mode Patterns

**Principle:** Never manually restart. Watch modes detect changes automatically.

```bash
# .NET
dotnet watch run
dotnet watch test --filter "Category=Unit"

# Node.js
npm run dev          # with nodemon or tsx
npm test -- --watch  # jest watch mode

# Python
uvicorn main:app --reload
ptw -- -x           # pytest-watch, stop on first failure
```

## Incremental Build Setup

**.NET (Directory.Build.props):**

```xml
<PropertyGroup>
  <IncrementalBuild>true</IncrementalBuild>
  <BuildInParallel>true</BuildInParallel>
</PropertyGroup>
```

**TypeScript (tsconfig.json):**

```json
{
  "compilerOptions": {
    "incremental": true,
    "tsBuildInfoFile": ".tsbuildinfo"
  }
}
```

## Multi-Service Local Dev

**Principle:** Run only what you're changing. Mock dependencies.

1. Docker Compose profiles for selective startup
2. Mock services (WireMock, MSW) for dependencies
3. Environment-based service URLs
4. Single-service development mode

```yaml
# docker-compose.override.yml
services:
  api:
    profiles: [dev, full]
  mocks:
    profiles: [dev]
  database:
    profiles: [dev, full]
```

## IDE Optimization

- Exclude generated folders (node_modules, bin, obj, .git)
- Configure file watchers for project type
- Limit search scope to source directories
- Enable format-on-save with cached formatters

## Red Flags - STOP

- "Just restart the application"
- "Run the full test suite every time"
- "Start all services for local dev"
- "Wait for the build to complete"
- "Default configuration is good enough"

**All mean:** Apply fast feedback patterns or document trade-off decision.

## Feedback Loop Targets

| Operation              | Target | Acceptable |
| ---------------------- | ------ | ---------- |
| Code change to running | < 1s   | < 3s       |
| Single test execution  | < 2s   | < 5s       |
| Lint/format check      | < 1s   | < 3s       |
| Service startup        | < 10s  | < 30s      |

If exceeding targets, investigate and optimize.

## Baseline vs Target Worksheet

Use this worksheet to measure current state and track improvements:

````markdown
# Local Dev Experience Assessment

**Project**: [Project Name]
**Date**: YYYY-MM-DD
**Assessor**: [Name]

## Current Baseline Measurements

| Operation              | Baseline | Target | Gap     | Priority |
| ---------------------- | -------- | ------ | ------- | -------- |
| Code change to running | [X]s     | < 1s   | [X-1]s  | [H/M/L]  |
| Single test execution  | [X]s     | < 2s   | [X-2]s  | [H/M/L]  |
| Full test suite        | [X]s     | < 60s  | [X-60]s | [H/M/L]  |
| Lint/format check      | [X]s     | < 1s   | [X-1]s  | [H/M/L]  |
| Service startup        | [X]s     | < 10s  | [X-10]s | [H/M/L]  |
| Full rebuild           | [X]s     | < 30s  | [X-30]s | [H/M/L]  |

## Measurement Commands

Record the commands used to measure each baseline:

| Operation       | Command                                         | Notes |
| --------------- | ----------------------------------------------- | ----- |
| Hot reload      | `time (edit file && wait for reload)`           |       |
| Single test     | `time npm test -- --testNamePattern="specific"` |       |
| Full suite      | `time npm test`                                 |       |
| Lint check      | `time npm run lint`                             |       |
| Service startup | `time npm run dev` (until ready)                |       |
| Full rebuild    | `time npm run build`                            |       |

## Improvement Actions

| Action                    | Expected Gain    | Actual Gain | Status    |
| ------------------------- | ---------------- | ----------- | --------- |
| Enable incremental builds | -50% build time  |             | ☐ Pending |
| Configure test filtering  | -80% test time   |             | ☐ Pending |
| Add lint caching          | -70% lint time   |             | ☐ Pending |
| Enable hot reload         | -90% reload time |             | ☐ Pending |

## Evidence Capture

### Before Optimization

```bash
# Record baseline measurements
$ time npm run build
real    0m45.123s

$ time npm test
real    1m23.456s
```

### After Optimization

```bash
# Record improved measurements
$ time npm run build
real    0m12.345s  # 73% improvement

$ time npm test -- --watch --changedSince=main
real    0m5.678s   # 96% improvement (changed files only)
```

## Summary

- **Total time saved per iteration**: [X] seconds
- **Iterations per day (estimated)**: [N]
- **Daily productivity gain**: [X × N] seconds = [Y] minutes
````

## Quick Measurement Script

```bash
#!/bin/bash
# measure-dev-experience.sh

echo "=== Local Dev Experience Baseline ==="
echo ""

# Full build time
echo "Measuring full build..."
BUILD_TIME=$( { time npm run build 2>&1; } 2>&1 | grep real | awk '{print $2}' )
echo "Full build: $BUILD_TIME"

# Single test time
echo "Measuring single test..."
TEST_TIME=$( { time npm test -- --testNamePattern="should" --bail 2>&1; } 2>&1 | grep real | awk '{print $2}' )
echo "Single test: $TEST_TIME"

# Lint time
echo "Measuring lint..."
LINT_TIME=$( { time npm run lint 2>&1; } 2>&1 | grep real | awk '{print $2}' )
echo "Lint check: $LINT_TIME"

echo ""
echo "=== Results ==="
echo "Build: $BUILD_TIME"
echo "Test:  $TEST_TIME"
echo "Lint:  $LINT_TIME"
```
