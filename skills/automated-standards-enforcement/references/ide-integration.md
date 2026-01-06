# IDE Integration

Configure IDEs to use the same standards as CI for consistent developer experience.

## Principle: Configuration Files Over IDE Settings

**Always prefer file-based configuration:**

- `.editorconfig` - Cross-IDE formatting basics
- `.eslintrc.cjs`, `ruff.toml` - Linting rules
- `.prettierrc` - Formatting preferences
- `.cspell.json` - Spelling dictionary

This ensures:

1. Settings travel with the repository
2. All team members have identical configuration
3. CI and local checks match exactly
4. No "works on my machine" issues

## EditorConfig (Universal)

Works across all modern IDEs. Place at repository root:

**.editorconfig**:

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{cs,csx}]
indent_size = 4

[*.py]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

## VS Code

### Required Extensions

**.vscode/extensions.json**:

```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "streetsidesoftware.code-spell-checker",
    "ms-dotnettools.csharp",
    "ms-python.python",
    "charliermarsh.ruff",
    "editorconfig.editorconfig"
  ]
}
```

### Workspace Settings

**.vscode/settings.json**:

```json
{
  // Editor basics
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "files.eol": "\n",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,

  // JavaScript/TypeScript
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "eslint.validate": ["javascript", "typescript"],

  // Python
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.codeActionsOnSave": {
      "source.fixAll.ruff": "explicit",
      "source.organizeImports.ruff": "explicit"
    }
  },

  // C#
  "[csharp]": {
    "editor.defaultFormatter": "ms-dotnettools.csharp"
  },
  "omnisharp.enableRoslynAnalyzers": true,
  "omnisharp.enableEditorConfigSupport": true,

  // Spelling
  "cSpell.enabled": true,
  "cSpell.showStatus": true
}
```

### Tasks for Local Validation

**.vscode/tasks.json**:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "validate",
      "type": "shell",
      "command": "npm run validate",
      "problemMatcher": [],
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "lint",
      "type": "shell",
      "command": "npm run lint",
      "problemMatcher": ["$eslint-stylish"]
    }
  ]
}
```

## JetBrains Rider

### EditorConfig Support

Rider automatically reads `.editorconfig`. Ensure it's enabled:

1. **Settings** > **Editor** > **Code Style**
2. Check "Enable EditorConfig support"

### Inspection Settings

Store in `.idea/inspectionProfiles/Project_Default.xml`:

```xml
<component name="InspectionProjectProfileManager">
  <profile version="1.0">
    <option name="myName" value="Project Default" />
    <inspection_tool class="CSharpWarnings::CS8618" enabled="true" level="ERROR" enabled_by_default="true" />
    <inspection_tool class="UnusedVariable" enabled="true" level="WARNING" enabled_by_default="true" />
    <inspection_tool class="RedundantUsingDirective" enabled="true" level="WARNING" enabled_by_default="true" />
  </profile>
</component>
```

### Code Style Settings

Store in `.idea/codeStyles/codeStyleConfig.xml`:

```xml
<component name="ProjectCodeStyleConfiguration">
  <state>
    <option name="USE_PER_PROJECT_SETTINGS" value="true" />
  </state>
</component>
```

### ESLint Integration

1. **Settings** > **Languages & Frameworks** > **JavaScript** > **Code Quality Tools** > **ESLint**
2. Select "Automatic ESLint configuration"
3. Check "Run eslint --fix on save"

### Spell Checking

1. **Settings** > **Editor** > **Proofreading** > **Spelling**
2. Add custom dictionary path: `.cspell.json`

## Visual Studio

### EditorConfig Support

Visual Studio 2019+ reads `.editorconfig` automatically.

### Code Analysis

Configure via `.editorconfig` or `Directory.Build.props`:

```ini
# .editorconfig additions for Visual Studio

# Severity levels: none, silent, suggestion, warning, error
dotnet_diagnostic.IDE0001.severity = warning  # Simplify name
dotnet_diagnostic.IDE0002.severity = warning  # Simplify member access
dotnet_diagnostic.IDE0003.severity = warning  # Remove this qualification
dotnet_diagnostic.CA1000.severity = warning   # Do not declare static members on generic types
dotnet_diagnostic.CA2000.severity = error     # Dispose objects before losing scope
```

### Extensions

Recommended Visual Studio extensions:

- **CodeMaid** - Code cleanup and formatting
- **Roslynator** - 500+ analyzers and refactorings
- **SonarLint** - Security and quality analysis
- **Spell Checker** - Spelling in code and comments

### Solution-Level Settings

**.vs/ProjectSettings.json** (committed to repo):

```json
{
  "CodeStyle.EnableSpellingChecker": true,
  "CodeStyle.EnableEditorConfig": true
}
```

## Cross-IDE Consistency Checklist

Before committing, verify:

- [ ] `.editorconfig` exists at repo root
- [ ] Language-specific config files present (`.eslintrc.cjs`, `ruff.toml`, etc.)
- [ ] IDE reads config files (not user overrides)
- [ ] Format on save matches CI expectations
- [ ] Spell checker uses same dictionary as CI
- [ ] All team members have required extensions/plugins

## Troubleshooting

### "Works locally but fails in CI"

1. Check if IDE is using project config or user settings
2. Verify tool versions match (ESLint, Prettier, etc.)
3. Run `npm run validate` locally before commit
4. Check `.gitignore` isn't excluding config files

### "Different formatting across team"

1. Ensure EditorConfig is enabled in all IDEs
2. Verify Prettier/formatters are configured identically
3. Run formatter before commit: `npm run format`
4. Consider pre-commit hooks for automatic formatting

### "Spell checker has too many false positives"

1. Add project-specific words to `.cspell.json`
2. Use `cspell:ignore` comments for code-specific terms
3. Configure language dictionaries (typescript, node, csharp, etc.)
