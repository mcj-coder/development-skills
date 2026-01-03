# development-skills

This repository hosts skill specs and guidance that interoperate with the
Superpowers skills system. It is intentionally lightweight and avoids
duplicating the upstream skill library.

## Purpose
- Backlog and specification of new skills to be implemented.
- Documentation and references for skills that integrate with Superpowers.
- A place to record decisions without copying the upstream skills.

## Skills
- `architecture-testing`: Skill spec for architectural boundary rules and automated enforcement.

## Superpowers Prerequisite
Superpowers is the source of truth for the skill library:
https://github.com/obra/superpowers

## Codex Onboarding (Recommended)
Keep Superpowers inside this repo's workarea.

If Superpowers is not available locally, install it into `.tmp/superpowers`.

PowerShell:
```powershell
if (-not (Test-Path .tmp/superpowers)) {
  New-Item -ItemType Directory -Force -Path .tmp/superpowers | Out-Null
  git clone https://github.com/obra/superpowers.git .tmp/superpowers
}
```

Bash:
```bash
if [ ! -d ".tmp/superpowers" ]; then
  mkdir -p .tmp/superpowers
  git clone https://github.com/obra/superpowers.git .tmp/superpowers
fi
```

1. Clone Superpowers into `.tmp/superpowers`:
   ```bash
   mkdir -p .tmp/superpowers
   git clone https://github.com/obra/superpowers.git .tmp/superpowers
   ```
2. Create your local skills folder (overrides live here):
   ```bash
   mkdir -p .tmp/skills
   ```
3. Add the Superpowers bootstrap to your local `AGENTS.md`:
   ```markdown
   ## Superpowers System

   <EXTREMELY_IMPORTANT>
   You have superpowers. Superpowers teach you new skills and capabilities.
   RIGHT NOW run: `.tmp/superpowers/.codex/superpowers-codex bootstrap`
   and follow the instructions it returns.
   </EXTREMELY_IMPORTANT>
   ```
4. Verify:
   ```bash
   .tmp/superpowers/.codex/superpowers-codex bootstrap
   ```

Optional (PowerShell): run a repo-local bootstrap that does not touch global paths:
```powershell
$repo = (Get-Location).Path
$tmpCodex = Join-Path $repo '.tmp/.codex'
New-Item -ItemType Directory -Force -Path $tmpCodex | Out-Null
if (-not (Test-Path (Join-Path $tmpCodex 'superpowers'))) {
  New-Item -ItemType Junction -Path (Join-Path $tmpCodex 'superpowers') -Target (Join-Path $repo '.tmp/superpowers') | Out-Null
}
if (-not (Test-Path (Join-Path $tmpCodex 'skills'))) {
  New-Item -ItemType Junction -Path (Join-Path $tmpCodex 'skills') -Target (Join-Path $repo '.tmp/skills') | Out-Null
}
$env:USERPROFILE = (Join-Path $repo '.tmp')
$env:HOME = $env:USERPROFILE
node .tmp/superpowers/.codex/superpowers-codex bootstrap
```

Notes:
- The CLI requires Node.js (v14+; v18+ recommended).
- Update Superpowers with `git -C .tmp/superpowers pull`.
- `.tmp/` is gitignored to keep these assets out of commits.

## Avoid Duplicating Skills
Do not copy Superpowers skills into this repo. Instead:
- Reference upstream skills directly.
- Add local overrides in `.tmp/skills/`.
- Keep new skill ideas here as specs, not as full skill implementations.

## References
- Codex install guide:
  https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.codex/INSTALL.md
- Codex docs:
  https://github.com/obra/superpowers/blob/main/docs/README.codex.md
