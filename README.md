# development-skills

This repository hosts skill specs and guidance that interoperate with the
Superpowers skills system. It is intentionally lightweight and avoids
duplicating the upstream skill library.

## Purpose

- Backlog and specification of new skills to be implemented.
- Documentation and references for skills that integrate with Superpowers.
- A place to record decisions without copying the upstream skills.

## Superpowers-First Default Workflow

This repo defaults to a **skills-first workflow**. Do not jump straight into
implementation. All work begins by loading Superpowers skills, following the
process skills, and only then editing files.

- Bootstrap Superpowers, then load `superpowers:using-superpowers` plus any
  relevant skills.
- Follow process skills (brainstorming, planning, TDD) before implementation.
- Use verification skills before claiming completion.
- Human-driven fallback still follows the same skills-first flow.

See `AGENTS.md` for the full workflow and enforcement rules.

## Branching and Commits

- Use the GitHub Flow branching strategy.
- Use concise Conventional Commit messages.
- All tickets should be implemented within a separate transient branch
- Sub-Tasks should be implemented in a branch from the main tickets feature branch
- When a Sub-Task is verified and complete the related branch should be merged back into the feature branch.
- When a ticket has all sub-tasks completed and has been verified it should be merged back into the default branch via PR.

## Skills

- `github-issue-driven-delivery` (requires `gh`)
