---
name: incremental-change-impact
description: Use when user proposes changes, refactoring, or feature additions; asks about impact, affected components, or what needs testing; or before making structural changes. Identifies blast radius and cascading effects.
metadata:
  type: Process
  priority: P3
---

# Incremental Change Impact

## Overview

Identify full impact scope **before** making changes. Trace dependencies, enumerate affected
components, and assess cascading effects. Prevents blind changes that break unrelated systems.

**REQUIRED:** superpowers:verification-before-completion

## When to Use

- User proposes changes, refactoring, or feature additions
- User asks "what will this affect?" or "what needs testing?"
- Before structural changes (renaming, moving, deleting)
- Before configuration changes (timeouts, thresholds, limits)
- When reviewing change proposals for impact

## Core Workflow

1. **Identify change type** (rename, add, modify, delete, config)
2. **Trace direct dependencies** (callers, imports, references)
3. **Trace indirect dependencies** (reflection, serialization, dynamic loading)
4. **Identify affected tests** (unit, integration, e2e)
5. **Check non-code impacts** (docs, configs, external APIs)
6. **Assess cascading effects** (timeouts, retries, error handling)
7. **Provide risk assessment** (breaking vs non-breaking, severity)
8. **Recommend verification approach**

See `references/dependency-analysis.md`, `references/impact-matrix.md`,
and `references/tooling.md` for detailed techniques.

## Quick Reference

| Change Type      | Typical Impact Areas                                  |
| ---------------- | ----------------------------------------------------- |
| Method rename    | Callers, tests, reflection, serialization, docs, APIs |
| Add caching      | Invalidation points, transactions, all consumers      |
| Config change    | Cascading timeouts, retries, health checks            |
| Schema change    | Data access, migrations, backward compatibility       |
| Delete component | All dependents, error handling, fallback paths        |

## Red Flags - STOP

- "It's just a rename/config change"
- "IDE/compiler will catch it"
- "Tests will tell us if it breaks"
- "Too urgent to analyze"
- "Already done, let's ship"

**All mean: Apply skill to identify full impact before proceeding.**

## Rationalizations Table

| Excuse                       | Reality                                                           |
| ---------------------------- | ----------------------------------------------------------------- |
| "It's just a simple rename"  | Dynamic usage, reflection, external APIs make renames risky.      |
| "IDE will catch all usages"  | IDE misses reflection, serialization, config files, docs.         |
| "Tests will fail if broken"  | Tests may not cover all paths. Identify impact before, not after. |
| "This is an internal change" | Internal changes cascade through timeouts, retries, monitoring.   |
| "Too urgent to analyze"      | 5-minute analysis prevents hours of production debugging.         |
| "Already done, just ship"    | Sunk cost fallacy. Identify impact before deployment.             |

## Evidence Checklist

- [ ] Change type identified explicitly
- [ ] All direct dependencies listed with file paths
- [ ] Indirect dependencies checked (reflection, serialization, configs)
- [ ] Affected tests identified by category (unit, integration, e2e)
- [ ] Non-code impacts included (docs, external APIs, configs)
- [ ] Cascading effects assessed if applicable
- [ ] Risk assessment provided (breaking/non-breaking, severity)
- [ ] Verification approach recommended

## Dependency Tracing Commands

### .NET (C#)

```bash
# Find all references to a type/method using dotnet CLI
dotnet build --no-incremental 2>&1 | grep "error CS"

# Using grep for direct references
grep -rn "ClassName" --include="*.cs" src/

# Using Roslyn analyzers (via dotnet format)
dotnet format analyzers --diagnostics=IDE0051  # Find unused members

# NuGet dependency graph
dotnet list package --include-transitive
```

### TypeScript/JavaScript

```bash
# Find imports of a module
grep -rn "from ['\"].*moduleName" --include="*.ts" --include="*.tsx" src/

# Using madge for dependency graph
npx madge --circular src/  # Find circular deps
npx madge --depends-on src/utils/helper.ts src/  # Find dependents

# TypeScript compiler for unused exports
npx ts-prune  # Find unused exports
```

### Python

```bash
# Find imports using grep
grep -rn "^from module import\|^import module" --include="*.py" src/

# Using pipdeptree for package dependencies
pipdeptree --reverse --packages mypackage

# Using vulture for dead code
vulture src/  # Find unused code

# AST-based analysis
python -c "import ast; print(ast.dump(ast.parse(open('file.py').read())))"
```

### Go

```bash
# Find package usages
go list -f '{{.ImportPath}} {{.Imports}}' ./... | grep "target/package"

# Reverse dependencies
go mod why -m github.com/org/package

# Find all callers of a function
grep -rn "FunctionName(" --include="*.go" .
```

### Java

```bash
# Using jdeps for module dependencies
jdeps --module-path mods -s myapp.jar

# Gradle dependencies
./gradlew dependencies --configuration compileClasspath

# Find class references
grep -rn "ClassName" --include="*.java" src/
```

## Recording Findings Template

```markdown
# Impact Analysis: [Change Description]

**Date**: YYYY-MM-DD
**Analyst**: [Name]
**Change Type**: [rename|add|modify|delete|config]

## Summary

[1-2 sentence description of the proposed change]

## Direct Dependencies

| File                        | Line | Usage Type            | Risk   |
| --------------------------- | ---- | --------------------- | ------ |
| src/api/UserController.cs   | 42   | Method call           | Medium |
| src/services/AuthService.cs | 118  | Constructor injection | High   |

## Indirect Dependencies

| Category      | Finding                            | Risk   |
| ------------- | ---------------------------------- | ------ |
| Reflection    | Used in DI container registration  | High   |
| Serialization | JSON property name in API response | Medium |
| Configuration | Referenced in appsettings.json     | Low    |

## Affected Tests

| Test Category | Count | Files                         |
| ------------- | ----- | ----------------------------- |
| Unit          | 12    | tests/unit/UserTests.cs, ...  |
| Integration   | 3     | tests/integration/ApiTests.cs |
| E2E           | 1     | tests/e2e/LoginFlow.spec.ts   |

## Non-Code Impacts

- [ ] API documentation needs update
- [ ] README references this component
- [ ] External API consumers may be affected

## Risk Assessment

**Breaking Change**: Yes/No
**Severity**: High/Medium/Low
**Recommended Approach**: [Incremental migration with feature flag / Direct replacement / etc.]

## Verification Plan

1. Run affected unit tests: `dotnet test --filter "Category=User"`
2. Run integration tests: `dotnet test --filter "Category=Integration"`
3. Manual verification: [specific steps]
```
