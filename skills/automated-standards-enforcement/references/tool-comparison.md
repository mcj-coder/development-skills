# Tool Comparison

Comprehensive comparison of automated standards enforcement tools by category.

## Selection Principles

1. **Prefer cross-platform, open-source tools** - Consistency across environments
2. **Prefer Node-based tooling** - Reliable unless language-specific tool is superior
3. **Configure via files** - Not command-line flags, for IDE integration
4. **Prefer staged-only checks locally** - Fast feedback with lint-staged

## Linting Tools

### JavaScript/TypeScript

| Tool   | Strengths                                  | Weaknesses                     | Recommendation                      |
| ------ | ------------------------------------------ | ------------------------------ | ----------------------------------- |
| ESLint | Highly configurable, vast plugin ecosystem | Can be slow on large codebases | **Recommended** - Industry standard |
| Biome  | Very fast, unified linting + formatting    | Smaller plugin ecosystem       | Consider for new projects           |

### Python

| Tool   | Strengths                               | Weaknesses           | Recommendation                  |
| ------ | --------------------------------------- | -------------------- | ------------------------------- |
| Ruff   | Extremely fast, replaces multiple tools | Newer, fewer rules   | **Recommended** - Modern choice |
| Pylint | Comprehensive, mature                   | Slow, verbose config | Legacy projects                 |
| flake8 | Simple, fast                            | Limited rules        | Basic needs only                |

### .NET

| Tool               | Strengths                      | Weaknesses       | Recommendation           |
| ------------------ | ------------------------------ | ---------------- | ------------------------ |
| dotnet-format      | Built into SDK, IDE-consistent | Requires SDK 6+  | **Recommended** - Native |
| StyleCop.Analyzers | Detailed C# style rules        | NuGet dependency | Add for strict style     |
| .NET Analyzers     | Built-in, zero config          | Basic coverage   | Enable by default        |

### Go

| Tool          | Strengths              | Weaknesses     | Recommendation               |
| ------------- | ---------------------- | -------------- | ---------------------------- |
| golangci-lint | Aggregates 50+ linters | Complex config | **Recommended** - All-in-one |
| go vet        | Built-in, fast         | Limited checks | Baseline only                |

## Formatting Tools

### Universal

| Tool         | Languages                         | Recommendation                   |
| ------------ | --------------------------------- | -------------------------------- |
| Prettier     | JS, TS, JSON, MD, YAML, HTML, CSS | **Recommended** - Multi-language |
| EditorConfig | All (editor-level)                | Always use for consistency       |

### Language-Specific

| Tool          | Language   | Recommendation                            |
| ------------- | ---------- | ----------------------------------------- |
| Black         | Python     | **Recommended** - Opinionated, consistent |
| dotnet-format | C#, F#, VB | **Recommended** - Native                  |
| gofmt         | Go         | **Required** - Built-in standard          |
| rustfmt       | Rust       | **Required** - Built-in standard          |

## Spelling Tools

| Tool      | Strengths                        | Weaknesses        | Recommendation                  |
| --------- | -------------------------------- | ----------------- | ------------------------------- |
| cspell    | Configurable, code-aware         | Node dependency   | **Recommended** - Most flexible |
| typos     | Fast (Rust), low false positives | Less configurable | Consider for speed              |
| codespell | Simple Python tool               | Basic dictionary  | Minimal setup only              |

**Configuration tip:** Set language at install time (en-US default).

## Security Tools

### Dependency Scanning

| Tool                             | Ecosystem      | Recommendation                    |
| -------------------------------- | -------------- | --------------------------------- |
| npm audit                        | Node.js        | **Default** - Built-in            |
| pip-audit                        | Python         | **Recommended** - Replaces safety |
| dotnet list package --vulnerable | .NET           | **Default** - Built-in            |
| Dependabot                       | Multi-language | Enable on GitHub repos            |
| Renovate                         | Multi-language | Alternative to Dependabot         |

### SAST (Static Application Security Testing)

| Tool      | Languages      | Recommendation                      |
| --------- | -------------- | ----------------------------------- |
| Semgrep   | Multi-language | **Recommended** - Open source, fast |
| Bandit    | Python         | **Recommended** - Python security   |
| CodeQL    | Multi-language | GitHub Advanced Security            |
| SonarQube | Multi-language | Enterprise option                   |

### Secrets Detection

| Tool           | Recommendation                    |
| -------------- | --------------------------------- |
| gitleaks       | **Recommended** - Fast, Git-aware |
| trufflehog     | Alternative with more sources     |
| detect-secrets | Baseline approach for brownfield  |

## Testing Frameworks

### Unit Testing

| Language              | Framework          | Coverage Tool   |
| --------------------- | ------------------ | --------------- |
| JavaScript/TypeScript | Jest, Vitest       | Built-in        |
| Python                | pytest             | pytest-cov      |
| .NET                  | xUnit, NUnit       | coverlet        |
| Go                    | testing (built-in) | go test -cover  |
| Rust                  | cargo test         | cargo-tarpaulin |

### Coverage Thresholds

Recommended starting thresholds:

- **Greenfield**: 80% line coverage
- **Brownfield**: Current coverage (baseline) + incremental improvement
- **Critical paths**: 90%+ for business-critical code

## Tool Selection Decision Tree

```text
New Project?
├── Yes → Use modern tools (Ruff, Biome, cspell)
└── No (Brownfield)
    ├── Has existing config? → Keep and enhance
    └── No config? → Add incrementally
        ├── Week 1: Linting (language-specific)
        ├── Week 2: Formatting (Prettier/native)
        ├── Week 3: Spelling (cspell)
        └── Week 4: Security scanning
```

## Cross-Platform Consistency

For teams using multiple IDEs (VS Code, Rider, Visual Studio):

1. **EditorConfig** - Consistent formatting basics
2. **File-based configs** - `.eslintrc`, `ruff.toml`, `.cspell.json`
3. **Same tools in CI** - Match local and CI tooling exactly
4. **Document in README** - IDE-specific setup instructions
