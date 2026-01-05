# Editor Integration

How to configure editors to use markdownlint and cspell configurations for real-time feedback.

## Overview

While markdown-author skill provides validation during agent markdown writing, human contributors benefit from editor integration that shows linting and spelling errors in real-time.

**Benefits:**

- Immediate visual feedback on violations
- Auto-fix on save
- Consistent with skill behavior
- Uses same configuration files

## Visual Studio Code

### Extensions

Install these VS Code extensions:

1. **markdownlint** by David Anson
   - Extension ID: `DavidAnson.vscode-markdownlint`
   - Provides real-time markdown linting
   - Uses `.markdownlint.json` configuration
   - Auto-fix on save

2. **Code Spell Checker** by Street Side Software
   - Extension ID: `streetsidesoftware.code-spell-checker`
   - Provides real-time spelling check
   - Uses `cspell.json` configuration
   - Language-aware dictionaries

### Installation

```bash
# Via command line
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension streetsidesoftware.code-spell-checker
```

Or via VS Code Extensions view (Ctrl+Shift+X):

1. Search "markdownlint"
2. Install "markdownlint" by David Anson
3. Search "code spell checker"
4. Install "Code Spell Checker" by Street Side Software

### Configuration

#### Workspace Settings (.vscode/settings.json)

```json
{
  "markdownlint.config": {
    "extends": ".markdownlint.json"
  },
  "markdownlint.run": "onType",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.markdownlint": true
  },
  "cSpell.enabled": true,
  "cSpell.showStatus": true,
  "cSpell.diagnosticLevel": "Warning"
}
```

**Settings explained:**

- `markdownlint.config.extends` - Use repository `.markdownlint.json`
- `markdownlint.run: "onType"` - Check as you type
- `editor.formatOnSave` - Format markdown on save
- `source.fixAll.markdownlint` - Auto-fix violations on save
- `cSpell.enabled` - Enable spell checking
- `cSpell.showStatus` - Show spell checker status
- `cSpell.diagnosticLevel` - Show warnings for spelling errors

#### User Settings

For all repositories, add to User settings (Ctrl+,):

```json
{
  "markdownlint.run": "onType",
  "cSpell.enabled": true
}
```

### Visual Indicators

**markdownlint violations:**

- Yellow/orange squiggly underlines
- Problems panel shows all violations
- Hover for explanation and fix options

**Spelling errors:**

- Blue squiggly underlines
- Hover for suggestions
- Quick fix: Add to dictionary

### Quick Fixes

**Fix single violation:**

1. Place cursor on violation
2. Press Ctrl+. (Quick Fix)
3. Select fix option

**Fix all violations in file:**

1. Open Command Palette (Ctrl+Shift+P)
2. Type "Fix All" → Select "Fix All supported markdownlint violations"

**Add word to dictionary:**

1. Place cursor on unknown word
2. Press Ctrl+. (Quick Fix)
3. Select "Add to cSpell.json"

## JetBrains IDEs (IntelliJ, WebStorm, etc.)

### Plugins

1. **Markdown** (built-in, enable if disabled)
2. **Grazie** (built-in spell checker)

### Configuration

#### Enable Markdown Linting

1. Settings → Languages & Frameworks → Markdown
2. Enable "Use markdownlint"
3. Configure path to `.markdownlint.json`

#### Enable Spell Checking

1. Settings → Editor → Proofreading → Grazie
2. Enable "Grazie"
3. Configure dictionaries

#### Custom Dictionary

1. Settings → Editor → Proofreading → Spelling
2. Add project-specific terms
3. Or import from `cspell.json` words list

## Vim/Neovim

### Plugins

Using vim-plug:

```vim
" .vimrc or init.vim
Plug 'dense-analysis/ale'  " Async linting
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
```

### ALE Configuration

```vim
" Enable markdownlint for markdown files
let g:ale_linters = {
\   'markdown': ['markdownlint'],
\}

" Auto-fix on save
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'markdown': ['prettier', 'markdownlint'],
\}

" Use repository .markdownlint.json
let g:ale_markdown_markdownlint_options = '--config .markdownlint.json'
```

### Spell Checking

```vim
" Enable spell check for markdown
autocmd FileType markdown setlocal spell spelllang=en_gb,en_us

" Add custom dictionary
set spellfile=~/.vim/spell/custom.utf-8.add
```

## Emacs

### Packages

Using `use-package`:

```elisp
;; Markdown mode
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Flycheck for linting
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; markdownlint integration
(flycheck-define-checker markdown-markdownlint-cli
  "Markdown style checker using markdownlint-cli2"
  :command ("markdownlint-cli2" source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column " " (message) line-end))
  :modes (markdown-mode))

(add-to-list 'flycheck-checkers 'markdown-markdownlint-cli)

;; Spell checking
(use-package flyspell
  :ensure t
  :hook (markdown-mode . flyspell-mode))
```

## Command Line Tools

For editors without native integration:

### markdownlint-cli2

```bash
# Check file
markdownlint-cli2 README.md

# Check with auto-fix
markdownlint-cli2 --fix README.md

# Check all markdown
markdownlint-cli2 "**/*.md"
```

### cspell

```bash
# Check file
cspell README.md

# Check with suggestions
cspell --show-suggestions README.md

# Check all markdown
cspell "**/*.md"
```

## Pre-Commit Hook Integration

Ensures consistency between editor and git hooks:

**.husky/pre-commit:**

```bash
#!/bin/sh
npx lint-staged
```

**package.json:**

```json
{
  "lint-staged": {
    "**/*.md": [
      "prettier --write",
      "markdownlint-cli2 --fix",
      "cspell"
    ]
  }
}
```

**Workflow:**

1. Editor shows violations in real-time
2. Auto-fix on save (if configured)
3. Pre-commit hook validates on commit
4. markdown-author skill validates during agent writing

All use same configuration files (`.markdownlint.json`, `cspell.json`).

## Troubleshooting

### VS Code: markdownlint Not Working

**Symptom:** No violations shown in editor
**Solutions:**

1. Verify extension installed and enabled
2. Check `.markdownlint.json` is valid JSON
3. Reload VS Code window (Ctrl+Shift+P → "Reload Window")
4. Check Output panel (View → Output → select "markdownlint")

### VS Code: Spell Checker Not Working

**Symptom:** No spelling errors shown
**Solutions:**

1. Verify "Code Spell Checker" extension installed
2. Check `cspell.json` is valid JSON
3. Verify `cSpell.enabled: true` in settings
4. Check status bar for cSpell status

### Configuration Not Loading

**Symptom:** Editor uses different rules than pre-commit hooks
**Solutions:**

1. Verify `.markdownlint.json` in repository root
2. Verify `cspell.json` in repository root
3. Close and reopen workspace/project
4. Check workspace settings don't override

### Auto-Fix Not Working on Save

**Symptom:** Violations not fixed automatically
**Solutions:**

1. Verify `editor.formatOnSave: true`
2. Verify `source.fixAll.markdownlint: true` in `codeActionsOnSave`
3. Check no conflicting formatters (prettier, etc.)
4. Manually trigger: Ctrl+Shift+P → "Format Document"

## Configuration Files Location

All configuration files should be in repository root:

```
repository/
├── .markdownlint.json       ← markdownlint configuration
├── cspell.json              ← cspell configuration
├── .vscode/
│   └── settings.json        ← VS Code workspace settings
├── .husky/
│   └── pre-commit           ← Git hooks
└── package.json             ← lint-staged configuration
```

## Recommended Workflow

1. **Install editor extensions** (one-time setup)
2. **Configure workspace settings** (per repository)
3. **Write markdown** with real-time feedback
4. **Save file** to trigger auto-fixes
5. **Commit** to trigger pre-commit hooks
6. **All checks pass** with consistent configuration

## See Also

- [Validation Rules Reference](validation-rules.md)
- [Spelling Configuration](spelling-configuration.md)
- VS Code markdownlint: <https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint>
- VS Code Code Spell Checker: <https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker>
