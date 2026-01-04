# Agent Guidelines

## Agent Execution Rules

Agents must follow the standards in `README.md` before taking any action.
These rules tighten the workflow for autonomous execution.

- **No changes without a Taskboard issue.** All non-read-only work must be tied
  to a Taskboard issue. Read-only work and reviews are allowed without a ticket.
- **Traceability required.** Every change must be traceable to a Taskboard
  issue; create one if it does not exist.
- **Feature branch only.** If you are on `main`, stop and create a feature
  branch before any edits or commits. Do not commit on `main`.
- **Skills-first enforcement.** Bootstrap, load skills, and follow process
  skills before any implementation.
- **TDD enforcement.** Apply the README TDD standard. For documentation work,
  capture and verify a failing BDD checklist before editing.
- **Fallback stays compliant.** If handing off to a human, the same skills-first
  workflow still applies.
- **PR close policy.** Follow the README merge policy (rebase, then choose
  squash or fast-forward only) and use a Conventional Commit squash message
  with ticket footer when appropriate.

## Prerequisites First

Before any task or response in this repo:

1. Run the Superpowers bootstrap to load the skills list.
2. Load any relevant skill with `superpowers-codex use-skill <skill-name>`.

## Superpowers-First Default Workflow

The default in this repo is **skills-first, not implementation-first**. Do not
start coding or editing files until the skills workflow is active.

1. Run bootstrap via Node.
2. Load `superpowers:using-superpowers`, then all relevant skills.
3. Use process skills (for example, `superpowers:brainstorming`,
   `superpowers:writing-plans`, `superpowers:test-driven-development`) before
   implementation.
4. Implement only after skills and (if required) plans are in place.
5. Verify with the appropriate checks before claiming completion.

If autonomous execution is blocked or uncertain, hand off to a human but keep
the skills-first workflow intact. Human-driven fallback still requires the same
skills and guardrails.

## No Implementation First

Jumping straight into implementation is an exception and must be explicitly
requested by the user. The default is to load and apply skills before any repo
actions.

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

## Agent-Specific Instructions

- Keep skills interoperable with superpowers and document any integration assumptions.
- Update `README.md` when adding a new skill or changing prerequisites.
