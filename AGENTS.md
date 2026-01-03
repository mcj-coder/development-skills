# Repository Guidelines

## Project Structure & Module Organization
This repository is currently minimal and primarily documentation-driven.
- `README.md` describes the purpose and prerequisites for developing skills.
- New skill specs and supporting assets should live in clearly named top-level folders (for example, `skills/skill-name/` with a short `README.md`).
- Keep any shared references in a `docs/` or `references/` folder so they are easy to locate.
- Do not copy Superpowers skills into this repository; treat https://github.com/obra/superpowers as the source of truth.

## Build, Test, and Development Commands
No build or test scripts are defined yet. If you add tooling, document it here and in `README.md`.
Examples:
- `npm run build` to package skills for deployment.
- `npm test` to run automated checks.

## Superpowers Onboarding
Developers should keep Superpowers inside this repo's workarea.
- Follow the Codex install guide in `README.md` (clone to `.tmp/superpowers`, add the bootstrap to local `AGENTS.md`).
- Keep local overrides in `.tmp/skills/` instead of copying upstream skills here.
- `.tmp/` is gitignored to keep these assets out of commits.
- Use the repo-local bootstrap command in `README.md` when you want to avoid `~/.codex` and keep all state in `.tmp/`.

## Coding Style & Naming Conventions
Follow a clean, documentation-first style.
- Indentation: 2 spaces for Markdown lists and YAML blocks (if introduced).
- Naming: use kebab-case for directories and files (for example, `skill-creator/`).
- Keep files small and scoped; prefer one concept per file.

## Testing Guidelines
There is no testing framework in place. If tests are added:
- Use clear file naming (for example, `skill-name.test.md` or `skill-name.test.js`).
- Document how to run the suite in this section.

## Commit & Pull Request Guidelines
The Git history currently has a single commit, so no convention is established.
- Use Conventional Commits: `<type>(optional-scope): <summary>`.
- Common types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.
- Example: `docs(readme): add prerequisites section`.
- PRs should describe the skill, its purpose, and any dependencies or setup steps.
- Include screenshots or output examples when adding new tools or scripts.

## Security & Configuration Tips
- Do not commit secrets or API keys.
- Keep prerequisites explicit (for example, "superpowers installed") in `README.md`.

## Agent-Specific Instructions
- Keep skills interoperable with superpowers and document any integration assumptions.
- Update `README.md` when adding a new skill or changing prerequisites.
