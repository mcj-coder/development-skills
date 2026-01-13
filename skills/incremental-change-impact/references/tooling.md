# Impact Analysis Tooling

## Language-Specific Tools

### .NET

**Dependency Analysis:**

```bash
# List package dependencies
dotnet list package

# List project dependencies
dotnet list reference

# Find unused packages
dotnet list package --outdated
```

**Code Analysis:**

```bash
# Find usages (with grep/ripgrep)
rg "MethodName" --type cs

# AST-based analysis
dotnet tool install -g dotnet-depends
dotnet-depends analyze
```

**Reflection Detection:**

```bash
rg "GetMethod|GetProperty|Invoke|CreateInstance" --type cs
rg "nameof\(" --type cs  # Safe references
```

### JavaScript/TypeScript

**Dependency Analysis:**

```bash
# List dependencies
npm ls

# Find unused dependencies
npx depcheck

# Analyze bundle
npx webpack-bundle-analyzer
```

**Code Analysis:**

```bash
# Find usages
rg "functionName" --type js --type ts

# Dynamic property access
rg "\[.*\]" --type js --type ts
```

### Python

**Dependency Analysis:**

```bash
# List installed packages
pip list

# Show package dependencies
pip show package-name

# Generate dependency graph
pipdeptree
```

**Code Analysis:**

```bash
# Find usages
rg "function_name" --type py

# Dynamic attribute access
rg "getattr|setattr" --type py
```

## Cross-Language Tools

### Ripgrep (rg)

Fast code search across any language:

```bash
# Find all references
rg "ClassName" -l

# Find with context
rg "MethodName" -C 3

# Find in specific file types
rg "pattern" --type-add 'config:*.{json,yaml,yml}' -t config
```

### AST-Based Analysis

- **Tree-sitter**: Multi-language AST parsing
- **Semgrep**: Pattern-based code analysis
- **CodeQL**: Semantic code analysis

### IDE Features

Most IDEs provide:

- Find all references
- Call hierarchy
- Type hierarchy
- Dependency graph

**Note:** IDE analysis misses dynamic/reflection usage.

## Configuration Analysis

### Find Config References

```bash
# JSON/YAML configs
rg "\"setting-name\"" --type json --type yaml

# Environment variables
rg "SETTING_NAME" --type-add 'env:*.env*' -t env

# Docker configs
rg "setting" Dockerfile* docker-compose*
```

### Infrastructure as Code

```bash
# Terraform
rg "variable_name" --type tf

# Kubernetes
rg "configMapKeyRef|secretKeyRef" -t yaml
```

## Test Impact Analysis

### Find Affected Tests

```bash
# Find test files referencing component
rg "ComponentName" --type-add 'test:*test*.{cs,js,ts,py}' -t test

# Find test fixtures
rg "ComponentName" --type-add 'fixture:*fixture*' -t fixture
```

### Coverage Tools

- **Coverage reports**: Identify code covered by tests
- **Mutation testing**: Identify untested behavior
- **Test impact analysis**: Map code to tests

## Documentation Analysis

### Find Doc References

```bash
# Markdown docs
rg "ComponentName" --type md

# API specs
rg "ComponentName" --type-add 'api:*.{json,yaml}' -t api

# Comments
rg "// TODO.*ComponentName|/\*.*ComponentName"
```

## Automation Opportunities

### Pre-commit Hooks

Validate impact analysis before commit:

```yaml
# .pre-commit-config.yaml
- repo: local
  hooks:
    - id: impact-check
      name: Check impact documentation
      entry: scripts/check-impact.sh
      language: script
```

### CI Integration

Add impact analysis to PR checks:

```yaml
# GitHub Actions example
- name: Impact Analysis
  run: |
    # Compare changed files against known dependencies
    ./scripts/analyze-impact.sh ${{ github.event.pull_request.base.sha }}
```

### Impact Report Template

Generate structured impact reports:

```markdown
## Impact Report

**Change:** [Description]
**Files Changed:** [Count]

### Direct Impact

- [ ] Component A (file:line)
- [ ] Component B (file:line)

### Indirect Impact

- [ ] Reflection usage checked
- [ ] Serialization checked
- [ ] Config references checked

### Test Impact

- [ ] Unit tests: [count] affected
- [ ] Integration tests: [count] affected

### Risk: [HIGH/MEDIUM/LOW]
```
