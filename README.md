# development-skills

This repository hosts skill specs and guidance that interoperate with the
Superpowers skills system. It is intentionally lightweight and avoids
duplicating the upstream skill library.

## Purpose

- Backlog and specification of new skills to be implemented.
- Documentation and references for skills that integrate with Superpowers.
- A place to record decisions without copying the upstream skills.

## Repository Standards (All Contributors)

**CRITICAL**: Follow a clean build principle. When changes are committed there
should be 0 warnings or errors. During development there should be no unresolved
warnings such as during git commits or package management operations. Warnings
must be resolved immediately.

### TDD Behaviour (Including Documentation)

TDD is mandatory for all changes, including documentation. This repo does not
allow "verify after" changes.

- **No production change without a failing test first.**
- For docs, the "test" is a BDD checklist of expected statements. The checklist
  must fail against current docs before edits begin.
- Record the failure reason (missing section, missing rule, incorrect wording)
  before editing.
- Only after the failing checklist is established may implementation begin.

## Superpowers-First Default Workflow

This repo defaults to a **skills-first workflow**. Do not jump straight into
implementation. All work begins by loading Superpowers skills, following the
process skills, and only then editing files.

- Bootstrap Superpowers, then load `superpowers:using-superpowers` plus any
  relevant skills.
- Follow process skills (brainstorming, planning, TDD) before implementation.
- Use verification skills before claiming completion.
- Human-driven fallback still follows the same skills-first flow.

See `AGENTS.md` for agent-specific enforcement rules.

## Coding Style & Naming Conventions

Follow a clean, documentation-first style.

- Ensure `.editorconfig` formatting is enforced.
- Linting and Static Analysis Tools must be run and passing cleanly before
  committing.
- Naming: use kebab-case for directories and files (for example, `skill-creator/`).
- Keep files small and scoped; prefer one concept per file.

## Testing Guidelines

There is no testing framework in place, so skills testing will need to be
"simulated". Tests should be defined in a BDD manner with a list of easily
understood assertions to prove success.

When tests are added, colocate them in the skills folder:

- Use clear file naming (for example, `skill-name.test.md` or `skill-name.test.js`).

## Branching and Commits

- Use the GitHub Flow branching strategy.
- Use concise Conventional Commit messages.
- All tickets should be implemented within a separate transient branch.
- Sub-tasks should be implemented in a branch from the main ticket feature
  branch.
- When a sub-task is verified and complete the related branch should be merged
  back into the feature branch.
- When a ticket has all sub-tasks completed and verified it should be merged
  back into the default branch via PR.

## Security & Configuration Tips

- Do not commit secrets or API keys.
- Keep prerequisites explicit (for example, "superpowers installed") in `README.md`.

## Skills

- `github-issue-driven-delivery` (requires `gh`)
