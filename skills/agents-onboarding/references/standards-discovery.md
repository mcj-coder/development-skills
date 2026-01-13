# Standards Discovery for Brownfield Repositories

When documenting existing standards in a brownfield repository, analyze these
sources to identify patterns agents must follow.

## Discovery Sources

### Tooling Configuration

| File                              | Standards Found                          |
| --------------------------------- | ---------------------------------------- |
| `.eslintrc.json`, `.eslintrc.js`  | JavaScript/TypeScript code style rules   |
| `.prettierrc`, `.prettierrc.json` | Formatting rules                         |
| `tsconfig.json`                   | TypeScript strictness, target version    |
| `.editorconfig`                   | Indentation, line endings, file encoding |
| `pyproject.toml`, `setup.cfg`     | Python linting, formatting (ruff, black) |
| `.rubocop.yml`                    | Ruby style rules                         |
| `Directory.Build.props`           | .NET project-wide settings               |
| `.csproj` files                   | .NET SDK, target framework, analyzers    |

### Testing Configuration

| File                   | Standards Found                      |
| ---------------------- | ------------------------------------ |
| `package.json`         | Test scripts, coverage thresholds    |
| `jest.config.js`       | Test patterns, coverage requirements |
| `vitest.config.ts`     | Test configuration for Vite projects |
| `pytest.ini`           | Python test configuration            |
| `xunit.runner.json`    | .NET test settings                   |
| `coverlet.runsettings` | .NET coverage thresholds             |
| `.nycrc`               | JavaScript coverage configuration    |

### CI/CD Configuration

| File                      | Standards Found                        |
| ------------------------- | -------------------------------------- |
| `.github/workflows/*.yml` | Build steps, test requirements, checks |
| `azure-pipelines.yml`     | Azure DevOps pipeline requirements     |
| `.gitlab-ci.yml`          | GitLab CI configuration                |
| `Jenkinsfile`             | Jenkins pipeline requirements          |
| `.circleci/config.yml`    | CircleCI configuration                 |

### Repository Settings

| Location                           | Standards Found                   |
| ---------------------------------- | --------------------------------- |
| `.github/branch_protection`        | Required approvals, status checks |
| `.github/CODEOWNERS`               | Required reviewers by path        |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR requirements and checklists    |
| `.github/ISSUE_TEMPLATE/`          | Issue structure requirements      |

### Documentation Sources

| Location             | Standards Found                         |
| -------------------- | --------------------------------------- |
| `docs/architecture/` | Architecture patterns, boundaries, ADRs |
| `docs/api/`          | API documentation requirements          |
| `CONTRIBUTING.md`    | Contribution process, code style        |
| `README.md`          | Setup requirements, prerequisites       |
| `docs/conventions/`  | Naming conventions, patterns            |

### Code Analysis

| Technique            | Standards Found                          |
| -------------------- | ---------------------------------------- |
| Directory structure  | Organization patterns, colocation        |
| File naming patterns | Naming conventions (kebab, camel, etc.)  |
| Test file locations  | Test colocation vs separate directory    |
| Import patterns      | Module organization, barrel files        |
| Comment patterns     | Documentation requirements (JSDoc, etc.) |

## Discovery Workflow

1. **Scan configuration files** in repository root and common locations.
2. **Extract explicit rules** from linting and formatting configs.
3. **Identify CI requirements** from workflow files.
4. **Check branch protection** for review requirements.
5. **Analyze directory structure** for organizational patterns.
6. **Read existing documentation** for stated conventions.
7. **Examine code samples** for implicit patterns.

## Example Discovery Output

```text
Repository Analysis Results:
- Code Style: ESLint + Prettier (see .eslintrc.json, .prettierrc)
- Testing: 80% coverage required (from package.json scripts)
- Architecture: Clean Architecture (from docs/architecture/)
- PR Process: 2 approvals required (from branch protection)
- Skills: TDD required (from CONTRIBUTING.md)
- Conventions: Scoped colocation (features/*/tests/)
```

## Handling Gaps

When analysis reveals gaps:

1. **Document what exists** first.
2. **Note gaps** in AGENTS.md as areas for improvement.
3. **Do not invent standards** that do not exist.
4. **Suggest improvements** if requested, but clearly mark as proposals.
