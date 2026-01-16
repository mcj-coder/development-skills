---
name: monorepo-orchestration-setup
description: Use when setting up or orchestrating monorepos with build tools like Nx, Turborepo, or Lerna. Covers workspace configuration, task pipelines, dependency graph management, caching strategies, and CI/CD integration patterns.
---

# Monorepo Orchestration Setup

## Overview

Configure and orchestrate monorepos for scalable multi-project development. This skill covers
workspace setup, task pipeline configuration, incremental builds, and CI/CD integration using
modern monorepo tooling (Nx, Turborepo, Lerna).

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- Setting up a new monorepo from scratch
- Migrating from polyrepo to monorepo architecture
- Adding monorepo tooling (Nx, Turborepo, Lerna) to existing repository
- Configuring task pipelines and build orchestration
- Optimising build performance with caching strategies
- Setting up CI/CD for monorepo workflows
- User asks about "workspace configuration" or "multi-package repository"

## Detection and Deference

Before creating new monorepo configuration, check for existing setup:

```bash
# Check for existing monorepo tools
ls nx.json turbo.json lerna.json pnpm-workspace.yaml 2>/dev/null

# Check for existing workspace configuration
ls package.json && grep -l "workspaces" package.json 2>/dev/null

# Check for existing project structure
ls packages/ apps/ libs/ projects/ 2>/dev/null
```

**If existing configuration found:**

- Build upon existing monorepo setup
- Use existing tool conventions
- Reference existing workspace structure

**If no configuration found:**

- Help select appropriate monorepo tool
- Create minimal initial configuration
- Document tool selection in ADR

## Tool Selection Guide

Select monorepo tooling based on ecosystem and requirements:

| Tool      | Best For                      | Key Features                        |
| --------- | ----------------------------- | ----------------------------------- |
| Nx        | Large enterprise, full-stack  | Plugins, generators, affected graph |
| Turborepo | JavaScript/TypeScript focused | Simple config, fast caching         |
| Lerna     | npm package publishing        | Version management, publishing      |

### Selection Criteria

**Choose Nx when:**

- Building full-stack applications (frontend + backend)
- Need code generators and scaffolding
- Require advanced dependency graph analysis
- Team benefits from opinionated structure

**Choose Turborepo when:**

- Primary focus is JavaScript/TypeScript
- Want minimal configuration overhead
- Need fast remote caching
- Prefer flexibility over structure

**Choose Lerna when:**

- Managing multiple npm packages for publishing
- Need version synchronisation across packages
- Publishing to npm registry is primary goal
- Already using Lerna (migration cost consideration)

## Core Workflow

1. **Assess requirements** (team size, project types, CI/CD needs)
2. **Select monorepo tool** based on ecosystem and requirements
3. **Configure workspace** with appropriate project structure
4. **Define task pipelines** (build, test, lint dependencies)
5. **Enable caching** (local and remote)
6. **Configure CI/CD** with affected-only execution
7. **Document conventions** and onboarding guide

## Configuration Patterns

### Workspace Structure

Standard monorepo directory layout:

```text
monorepo/
  apps/           # Deployable applications
    web/
    api/
  packages/       # Shared libraries
    ui/
    utils/
  tools/          # Build tooling and scripts
  nx.json         # or turbo.json
  package.json    # Root package with workspaces
```

### Task Pipeline Configuration

Define task dependencies to enable incremental builds:

**Nx (nx.json):**

```json
{
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"],
      "cache": true
    },
    "test": {
      "dependsOn": ["build"],
      "cache": true
    },
    "lint": {
      "cache": true
    }
  }
}
```

**Turborepo (turbo.json):**

```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": []
    },
    "lint": {
      "outputs": []
    }
  }
}
```

### Caching Strategies

Enable caching for reproducible, fast builds:

**Local caching:**

- Enabled by default in Nx and Turborepo
- Cache stored in `.nx/cache` or `node_modules/.cache/turbo`
- Clear with `nx reset` or `turbo run build --force`

**Remote caching:**

- Nx Cloud: `npx nx connect`
- Vercel Remote Cache: `turbo login` and `turbo link`
- Self-hosted: Configure cache storage endpoint

### CI/CD Integration

Run only affected projects in CI:

**GitHub Actions (Nx):**

```yaml
- name: Build affected
  run: npx nx affected -t build --base=origin/main

- name: Test affected
  run: npx nx affected -t test --base=origin/main
```

**GitHub Actions (Turborepo):**

```yaml
- name: Build
  run: npx turbo run build --filter=...[origin/main]

- name: Test
  run: npx turbo run test --filter=...[origin/main]
```

## Common Pitfalls

### Pitfall 1: Over-coupling packages

**Problem:** Too many dependencies between packages slow builds.

**Solution:** Design packages with clear boundaries. Use dependency graph visualisation
to identify problematic coupling (`nx graph` or `turbo run build --graph`).

### Pitfall 2: Missing task dependencies

**Problem:** Tasks run in wrong order causing failures.

**Solution:** Explicitly define `dependsOn` for all tasks that require outputs from
other tasks. Test with clean cache.

### Pitfall 3: Cache invalidation issues

**Problem:** Stale cache causes incorrect builds.

**Solution:** Define all outputs and inputs correctly. Use hashing configuration
to include all relevant files. When in doubt, clear cache and rebuild.

### Pitfall 4: Slow CI without affected filtering

**Problem:** CI rebuilds everything on every commit.

**Solution:** Use affected commands with base branch comparison. Configure proper
base branch for PRs and main branch builds.

## Verification Checklist

Before declaring setup complete, verify:

- [ ] Workspace configuration is valid (`nx show projects` or `turbo run build --dry-run`)
- [ ] Task pipelines execute in correct order
- [ ] Caching works correctly (second run is fast)
- [ ] Affected detection works (only changed projects run)
- [ ] CI/CD pipeline executes affected tasks only
- [ ] Team onboarding documentation exists
- [ ] Architecture decision documented (tool selection rationale)

## Quick Reference Commands

### Nx

```bash
# Create workspace
npx create-nx-workspace@latest myworkspace

# Generate application
npx nx g @nx/web:app myapp

# Generate library
npx nx g @nx/js:lib mylib

# Run affected
npx nx affected -t build test lint

# Visualise dependency graph
npx nx graph
```

### Turborepo

```bash
# Create workspace
npx create-turbo@latest

# Run all builds
npx turbo run build

# Run affected builds
npx turbo run build --filter=...[origin/main]

# Visualise dependency graph
npx turbo run build --graph
```

### Lerna

```bash
# Initialise Lerna
npx lerna init

# Bootstrap packages
npx lerna bootstrap

# Run script in all packages
npx lerna run build

# Run only in changed packages
npx lerna run build --since main

# Version and publish
npx lerna version
npx lerna publish
```

## Red Flags - STOP

These statements indicate monorepo anti-patterns:

| Thought                             | Reality                                                                   |
| ----------------------------------- | ------------------------------------------------------------------------- |
| "Everything in one repo is simpler" | Without proper tooling, monorepos become unmanageable; use orchestration  |
| "We don't need affected detection"  | Full builds on every commit waste CI time exponentially; enable filtering |
| "Caching isn't worth the setup"     | Remote caching can reduce build times by 70%+; invest in setup            |
| "Packages can depend on anything"   | Unconstrained coupling kills build performance; define boundaries         |
| "We'll optimise builds later"       | Build performance debt compounds quickly; configure pipelines early       |
| "Task ordering doesn't matter"      | Missing dependencies cause flaky builds; explicitly define dependsOn      |

## Integration with Other Skills

- **walking-skeleton-delivery**: Use monorepo structure for E2E skeleton across services
- **ci-cd-conformance**: Configure CI/CD pipelines with affected-only execution
- **automated-standards-enforcement**: Apply linting and formatting across all packages

## Evidence Examples

### Nx Graph Output

```bash
npx nx graph --file=output.json
```

**Sample output.json (dependency graph):**

```json
{
  "graph": {
    "nodes": {
      "web": {
        "name": "web",
        "type": "app",
        "data": { "root": "apps/web" }
      },
      "api": {
        "name": "api",
        "type": "app",
        "data": { "root": "apps/api" }
      },
      "ui": {
        "name": "ui",
        "type": "lib",
        "data": { "root": "packages/ui" }
      },
      "utils": {
        "name": "utils",
        "type": "lib",
        "data": { "root": "packages/utils" }
      }
    },
    "dependencies": {
      "web": [
        { "source": "web", "target": "ui", "type": "static" },
        { "source": "web", "target": "utils", "type": "static" }
      ],
      "api": [{ "source": "api", "target": "utils", "type": "static" }],
      "ui": [{ "source": "ui", "target": "utils", "type": "static" }],
      "utils": []
    }
  }
}
```

### Turborepo Graph Output

```bash
$ npx turbo run build --graph=graph.html
# Or JSON format:
$ npx turbo run build --graph=graph.json
```

**Sample turbo output (task execution):**

```text
• Packages in scope: @myorg/api, @myorg/ui, @myorg/utils, @myorg/web
• Running build in 4 packages
• Remote caching disabled

@myorg/utils:build: cache hit, replaying output
@myorg/ui:build: cache miss, executing
@myorg/api:build: cache hit, replaying output
@myorg/web:build: cache miss, executing

 Tasks:    4 successful, 4 total
Cached:    2 cached, 4 total
  Time:    3.245s
```

### Affected Detection Evidence

```bash
# Nx affected output
$ npx nx affected:apps --base=main --head=HEAD
>  NX   Affected apps:
- web

$ npx nx affected:libs --base=main --head=HEAD
>  NX   Affected libs:
- ui
- utils

# Turborepo affected output
$ npx turbo run build --filter='...[origin/main]' --dry-run
• Packages in scope: @myorg/ui, @myorg/web
• Running build in 2 packages
• 2 packages in graph are affected by changes
```

## Baseline Performance Metrics

### Metrics to Capture

| Metric              | Description                     | Target        |
| ------------------- | ------------------------------- | ------------- |
| Cold build time     | Full build with empty cache     | Baseline      |
| Warm build time     | Full build with populated cache | < 10% of cold |
| Affected build time | Build only changed packages     | < 30% of cold |
| Cache hit rate      | Percentage of cached tasks      | > 80% in CI   |

### Performance Worksheet

```markdown
# Monorepo Performance Baseline

**Repository**: [repo-name]
**Date**: YYYY-MM-DD
**Tool**: [Nx/Turborepo/Lerna]
**Packages**: [N] apps, [M] libs

## Build Performance

| Scenario         | Time | Cache Status | Notes                                  |
| ---------------- | ---- | ------------ | -------------------------------------- |
| Cold build (all) | [X]s | No cache     | `nx run-many -t build --skip-nx-cache` |
| Warm build (all) | [X]s | Full cache   | Second run of above                    |
| Affected (1 lib) | [X]s | Partial      | After changing utils                   |
| Affected (1 app) | [X]s | Partial      | After changing web only                |

## CI Performance

| Metric             | Before Optimization | After | Improvement |
| ------------------ | ------------------- | ----- | ----------- |
| Average PR build   | [X]m                | [Y]m  | [Z]%        |
| Cache hit rate     | [X]%                | [Y]%  | +[Z]%       |
| Affected detection | [X]s                | [Y]s  | [Z]%        |

## Verification Commands

# Measure cold build

time npx nx run-many -t build --skip-nx-cache

# Measure warm build (run twice, take second)

npx nx run-many -t build
time npx nx run-many -t build

# Measure affected build

git checkout -b test-affected
echo "// change" >> packages/utils/src/index.ts
time npx nx affected -t build --base=main
git checkout main && git branch -D test-affected

# Check cache statistics (Nx)

npx nx show cache-stats

# Check cache statistics (Turborepo)

npx turbo run build --summarize
```

### Sample CI Evidence

```yaml
# GitHub Actions summary output
Build Summary:
  Total packages: 12
  Affected packages: 3
  Cached tasks: 9/12 (75%)
  Build time: 45s (vs 180s full build)
  Cache savings: 135s (75% reduction)
```
