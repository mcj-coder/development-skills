# Repository Guidelines

## Development Practices

**CRITICAL**: Follow a clean build principal, when changes are committed there
should be 0 warnings or errors. During the development process there should be
no unresolved warnings such as during git commits or package management
operations. Warnings need to be resolved immediately.

- All work in this repo should follow TDD principal
- Use skills in combination, if multiple skills are applicable to a combination
  they should all be combined to achieve the "best of both".

## Prerequisites First

Before any task or response in this repo:

1. Run the Superpowers bootstrap to load the skills list.
2. Load any relevant skill with `superpowers-codex use-skill <skill-name>`.

## Canonical Skill Priority Model

Skills can be classified into the following priorities:

- **P0 – Safety & Integrity**: security, immutability, provenance, traceability, data integrity.
- **P1 – Quality & Correctness**: behavioural correctness, clean builds, contract stability, test validity.
- **P2 – Consistency & Governance**: repository conventions, versioning discipline, pipeline conformance.
- **P3 – Delivery & Flow**: incremental execution, developer experience improvements.
- **P4 – Optimisation & Convenience**: ergonomics and non-critical improvements.

### Conflict resolution

1. Higher priority wins.
2. If equal priority: prefer narrower scope.
3. If scope equal: prefer stronger guardrails.

## Multi-Skill Application

A single task may require the application of multiple skills. It is the
responsibility of the agent (or human) to:

- Identify the complete set of relevant skills before starting execution.
- Analyze how these skills interact and identify any conflicts.
- Resolve conflicts as per the "Conflict Resolution" process

## Skill Structure

- `README.md` describes the purpose and prerequisites for developing skills.
- New skill specs and supporting assets should live in clearly named top-level
  folders (for example, `skills/skill-name/` with a short `README.md`).
- Skills should be progressively loaded, keep non-critical detail and examples
  in focused documents within a `references/` folder with the skill and
  reference the file from the main `SKILL.md`.
- If in doubt refer to the [agentskills.io specification](https://agentskills.io/specification)
- Keep any shared reference documents in the top level `docs/` folder

## Superpowers Onboarding

Superpowers is the source of truth for the skill library: <https://github.com/obra/superpowers>

- **CRITICAL**: Ensure that you run the bootstrap script with Node when using
  powershell (or on windows), for example
  `node %USERPROFILE%\.codex\superpowers\.codex\superpowers-codex bootstrap`.
- **LOCAL POLICY**: Run all Superpowers scripts via Node (for example,
  `node %USERPROFILE%\.codex\superpowers\.codex\superpowers-codex <command>`).
  This does not apply to skill content.

- **CRITICAL**: Do not proceed with any task until the bootstrap has been run,
  the superpowers skills are available and you've applied the
  `using-superpowers` skill.

- Follow the Codex install guide in `README.md`.
- Always run the bootstrap via Node:
  `node %USERPROFILE%\.codex\superpowers\.codex\superpowers-codex bootstrap`.
- Superpowers agents live in `~/.codex/superpowers/agents` and are referenced by
  skills that dispatch subagents.

### References

- Superpowers Codex install guide:
  <https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.codex/INSTALL.md>
- Codex docs:
  <https://github.com/obra/superpowers/blob/main/docs/README.codex.md>

## Coding Style & Naming Conventions

Follow a clean, documentation-first style.

- Ensure `.editorconfig` formatting is enforced
- Linting and Static Analysis Tools must be run and passing cleanly before committing
- Naming: use kebab-case for directories and files (for example, `skill-creator/`).
- Keep files small and scoped; prefer one concept per file.

## Testing Guidelines

There is no testing framework in place, so skills testing will need to
"simulated". Tests should be defined in a BDD manner with a list of easily
understood assertions to prove success.

When tests are added, colocate them in the skills folder:

- Use clear file naming (for example, `skill-name.test.md` or `skill-name.test.js`).

## Commit & Pull Request Guidelines

The Git history currently has a single commit, so no convention is established.

- Use Conventional Commits: `<type>(optional-scope): <summary>`.
- Common types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.
- Example: `docs(readme): add prerequisites section`.
- Use GitHub Flow for branching.
- Keep commit messages concise.
- PRs should describe the skill, its purpose, and any dependencies or setup steps.
- Include screenshots or output examples when adding new tools or scripts.

## Security & Configuration Tips

- Do not commit secrets or API keys.
- Keep prerequisites explicit (for example, "superpowers installed") in `README.md`.

## Agent-Specific Instructions

- Keep skills interoperable with superpowers and document any integration assumptions.
- Update `README.md` when adding a new skill or changing prerequisites.
