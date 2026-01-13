# SAST Tool Selection Guide

## Selection Criteria

When selecting SAST tools, evaluate:

1. **Language coverage** - Does it support all languages in your stack?
2. **Rule quality** - Are rules well-maintained with low false positive rates?
3. **Integration** - Does it integrate with your CI/CD and IDE?
4. **Output format** - Does it support SARIF for unified reporting?
5. **Performance** - Can it run in reasonable time on your codebase?
6. **Customisation** - Can you add custom rules for your patterns?
7. **Licensing** - Open source vs commercial considerations

## Tool Comparison

### General-Purpose SAST

| Tool      | Languages | Licence         | SARIF      | Custom Rules | Notes                           |
| --------- | --------- | --------------- | ---------- | ------------ | ------------------------------- |
| Semgrep   | 30+       | LGPL/Commercial | Yes        | Yes (YAML)   | Best general-purpose choice     |
| CodeQL    | 10+       | Free for OSS    | Yes        | Yes (QL)     | GitHub native, powerful queries |
| SonarQube | 25+       | Commercial      | Via plugin | Limited      | Enterprise-focused              |

### Language-Specific SAST

#### JavaScript/TypeScript

| Tool                   | Focus               | Integration | Recommendation       |
| ---------------------- | ------------------- | ----------- | -------------------- |
| eslint-plugin-security | Security patterns   | ESLint      | Always use           |
| @typescript-eslint     | Type-aware security | ESLint      | For TypeScript       |
| Semgrep                | Deep analysis       | CI/IDE      | Recommended addition |

#### Python

| Tool    | Focus                      | Integration   | Recommendation       |
| ------- | -------------------------- | ------------- | -------------------- |
| Bandit  | Security vulnerabilities   | Standalone/CI | Primary SAST tool    |
| Ruff    | Fast linting with security | Standalone/CI | Replace flake8       |
| Semgrep | Pattern matching           | CI/IDE        | Recommended addition |

#### Go

| Tool          | Focus            | Integration   | Recommendation           |
| ------------- | ---------------- | ------------- | ------------------------ |
| gosec         | Security issues  | Standalone/CI | Primary SAST tool        |
| golangci-lint | Meta-linter      | Standalone/CI | Include security linters |
| govulncheck   | Dependency vulns | Standalone/CI | Official Go tool         |

#### Java/Kotlin

| Tool                          | Focus             | Integration  | Recommendation         |
| ----------------------------- | ----------------- | ------------ | ---------------------- |
| SpotBugs + Find Security Bugs | Bytecode analysis | Maven/Gradle | Primary SAST tool      |
| PMD                           | Source analysis   | Maven/Gradle | Complement to SpotBugs |
| Semgrep                       | Pattern matching  | CI/IDE       | Recommended addition   |

#### C#/.NET

| Tool               | Focus            | Integration | Recommendation         |
| ------------------ | ---------------- | ----------- | ---------------------- |
| Security Code Scan | OWASP patterns   | Roslyn      | Primary SAST tool      |
| Roslyn Analyzers   | Code quality     | MSBuild     | Include security rules |
| Semgrep            | Pattern matching | CI/IDE      | Recommended addition   |

#### Ruby

| Tool          | Focus                 | Integration   | Recommendation    |
| ------------- | --------------------- | ------------- | ----------------- |
| Brakeman      | Rails security        | Standalone/CI | Primary for Rails |
| RuboCop       | Linting with security | Standalone/CI | Always use        |
| Bundler Audit | Dependency vulns      | Standalone/CI | Always use        |

## Recommended Combinations

### Minimal Setup (Any Language)

1. Language-specific linter with security rules
2. Semgrep with language pack
3. Secrets detection (Gitleaks)

### Comprehensive Setup

1. Language-specific SAST tool
2. Security linting in existing linter
3. Semgrep for cross-cutting patterns
4. Secrets detection with custom patterns
5. Dependency scanning

### Enterprise Setup

1. All of comprehensive setup
2. Commercial SAST (SonarQube, Checkmarx, etc.)
3. GitHub Advanced Security or GitLab Ultimate
4. Centralised policy management
5. Trend analytics and reporting

## Performance Considerations

### Optimising CI Time

1. **Incremental scanning** - Only scan changed files where supported
2. **Parallel execution** - Run tools in parallel stages
3. **Caching** - Cache tool installations and rule downloads
4. **Selective scanning** - Full scan on main, incremental on PRs

### Typical Scan Times

| Tool    | Small Repo (<10k LOC) | Medium Repo (<100k LOC) | Large Repo (>100k LOC) |
| ------- | --------------------- | ----------------------- | ---------------------- |
| ESLint  | <30s                  | 1-2m                    | 5-10m                  |
| Semgrep | <1m                   | 2-5m                    | 10-20m                 |
| Bandit  | <30s                  | 1-2m                    | 3-5m                   |
| CodeQL  | 2-5m                  | 10-30m                  | 30m-2h                 |

## Custom Rules

### When to Create Custom Rules

- Organisation-specific security patterns
- Internal API misuse detection
- Compliance requirements not covered by default rules
- Known vulnerability patterns in your codebase

### Semgrep Custom Rule Example

```yaml
rules:
  - id: insecure-api-call
    patterns:
      - pattern: legacyApi.unsafeMethod(...)
    message: Use secureApi.safeMethod() instead of legacy unsafe method
    severity: ERROR
    languages: [typescript, javascript]
```

### ESLint Custom Rule Approach

For complex custom rules, consider:

1. Write as ESLint plugin
2. Use Semgrep for pattern matching (easier)
3. Document custom rules in `docs/security/custom-rules.md`
