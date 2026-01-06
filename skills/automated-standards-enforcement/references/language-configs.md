# Language-Specific Configurations

Configuration examples for common language ecosystems. Prefer file-based configuration over
CLI flags for IDE integration consistency.

## TypeScript/JavaScript

### ESLint Configuration

**.eslintrc.cjs** (CommonJS format for compatibility):

```javascript
module.exports = {
  root: true,
  env: {
    browser: true,
    es2022: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
    project: ["./tsconfig.json"],
  },
  plugins: ["@typescript-eslint"],
  rules: {
    // Enforce strict type checking
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    // Prevent common mistakes
    "no-console": "warn",
    "no-debugger": "error",
  },
  ignorePatterns: ["dist/", "node_modules/", "*.config.js"],
};
```

### Prettier Configuration

**.prettierrc**:

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "endOfLine": "lf"
}
```

### package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "spell": "cspell \"**/*.{ts,tsx,js,jsx,md,json}\"",
    "validate": "npm run lint && npm run format:check && npm run spell && npm test"
  }
}
```

## Python

### Ruff Configuration

**ruff.toml**:

```toml
# Ruff configuration (replaces flake8, isort, black, pyupgrade)

[lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # Pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "UP",  # pyupgrade
    "S",   # flake8-bandit (security)
]
ignore = []

[lint.per-file-ignores]
"tests/**/*.py" = ["S101"]  # Allow assert in tests

[format]
quote-style = "double"
indent-style = "space"
line-ending = "lf"

[lint.isort]
known-first-party = ["myproject"]
```

### pytest Configuration

**pytest.ini**:

```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = --cov=src --cov-report=term-missing --cov-fail-under=80
```

### pyproject.toml (Alternative)

```toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing --cov-fail-under=80"

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

### Makefile for Python

```makefile
.PHONY: lint format spell test validate

lint:
	ruff check .

format:
	ruff format .

spell:
	cspell "**/*.py" "**/*.md"

test:
	pytest

validate: lint format spell test
```

## .NET

### Directory.Build.props (Solution-Wide)

Place at solution root for all projects:

```xml
<Project>
  <PropertyGroup>
    <!-- Enforce clean builds -->
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <WarningsAsErrors />
    <NoWarn />

    <!-- Enable all .NET analyzers -->
    <EnableNETAnalyzers>true</EnableNETAnalyzers>
    <AnalysisLevel>latest-recommended</AnalysisLevel>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>

    <!-- Nullable reference types -->
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <!-- Code analysis packages -->
    <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.556">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers</IncludeAssets>
    </PackageReference>
  </ItemGroup>
</Project>
```

### EditorConfig for .NET

**.editorconfig**:

```ini
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.cs]
# Formatting
csharp_new_line_before_open_brace = all
csharp_indent_case_contents = true
csharp_indent_switch_labels = true

# Style preferences
dotnet_style_qualification_for_field = false:suggestion
dotnet_style_qualification_for_property = false:suggestion
dotnet_style_qualification_for_method = false:suggestion
dotnet_style_predefined_type_for_locals_parameters_members = true:warning
dotnet_style_require_accessibility_modifiers = for_non_interface_members:warning

# Naming conventions
dotnet_naming_rule.private_fields_should_be_camel_case.severity = warning
dotnet_naming_rule.private_fields_should_be_camel_case.symbols = private_fields
dotnet_naming_rule.private_fields_should_be_camel_case.style = camel_case_style

dotnet_naming_symbols.private_fields.applicable_kinds = field
dotnet_naming_symbols.private_fields.applicable_accessibilities = private

dotnet_naming_style.camel_case_style.capitalization = camel_case
dotnet_naming_style.camel_case_style.required_prefix = _

# Analyzer severity
dotnet_diagnostic.CA1000.severity = warning
dotnet_diagnostic.CA1001.severity = error
dotnet_diagnostic.CA2000.severity = error

[*.{csproj,props,targets}]
indent_size = 2
```

### PowerShell Validation Script

**validate.ps1**:

```powershell
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "Running dotnet format check..." -ForegroundColor Cyan
dotnet format --verify-no-changes
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Running spell check..." -ForegroundColor Cyan
npx cspell "**/*.cs" "**/*.md"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Building solution..." -ForegroundColor Cyan
dotnet build --configuration Release /p:TreatWarningsAsErrors=true
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Running tests with coverage..." -ForegroundColor Cyan
dotnet test --configuration Release --collect:"XPlat Code Coverage"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "All validations passed!" -ForegroundColor Green
```

## Spell Checking (All Languages)

### cspell Configuration

**.cspell.json**:

```json
{
  "version": "0.2",
  "language": "en",
  "words": ["eslint", "dotnet", "ruff", "pytest", "cspell"],
  "ignorePaths": [
    "node_modules",
    "dist",
    "bin",
    "obj",
    ".git",
    "package-lock.json",
    "*.min.js"
  ],
  "dictionaries": ["typescript", "node", "npm", "csharp", "python"]
}
```

## Configuration Maintenance

1. **Version pin tools** - Lock versions in package.json, requirements.txt, Directory.Build.props
2. **Document deviations** - Any rule disabled must have a comment explaining why
3. **Review quarterly** - Update tools and rules quarterly
4. **Sync with IDE** - Ensure IDE uses same config files (not overrides)
