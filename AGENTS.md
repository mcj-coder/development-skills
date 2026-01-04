# Agent Guidelines

## Agent Execution Rules

Agents must follow the standards in `README.md` before taking any action.
These rules tighten the workflow for autonomous execution.

- **No changes without a Taskboard issue.** All non-read-only work must be tied
  to a Taskboard issue. Read-only work and reviews are allowed without a ticket.
- **Traceability required.** Every change must be traceable to a Taskboard
  issue; create one if it does not exist.
- **Applied-skill evidence required.** If a skill drives concrete configuration,
  documentation, or code changes, BDD verification must include evidence that
  the skill was actually applied in this repo. For process-only or hypothetical
  skills, analysis-based BDD is acceptable and must be stated as such.
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

1. Load `development-skills:skills-first-workflow` to enforce workflow.
2. Ensure Superpowers is installed and bootstrapped.
3. Load `superpowers:using-superpowers`.
4. Load any other relevant skills for the task.

## Skills-First Default Workflow

The default in this repo is **skills-first, not implementation-first**. Do not
start coding or editing files until the skills workflow is active.

The `development-skills:skills-first-workflow` skill enforces this workflow:

1. Verifies Superpowers is installed and bootstrapped (AutoFix if not).
2. Verifies `superpowers:using-superpowers` is loaded (AutoFix if not).
3. Verifies AGENTS.md exists and is current (AutoFix if not).
4. Ensures process skills are loaded before implementation:
   - `superpowers:brainstorming` (for unclear requirements or new features)
   - `superpowers:writing-plans` (for multi-step tasks)
   - `superpowers:test-driven-development` (for code changes)
   - `superpowers:verification-before-completion` (always)
5. Blocks implementation until all verifications pass.

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

## Prerequisite Repositories

Skills in this repository depend on external skill libraries. Install these
before using skills from this repo:

- **Superpowers**: <https://github.com/obra/superpowers>
  - Follow installation and bootstrap instructions for your agent

- **development-skills**: <https://github.com/mcj-coder/development-skills>
  - This repository (install per your agent's skill installation mechanism)

## Superpowers Bootstrap

Superpowers is the source of truth for the skill library.

- **CRITICAL**: Do not proceed with any task until Superpowers has been
  installed, bootstrapped, and you've applied the `using-superpowers` skill.
- Follow the installation instructions in the Superpowers repository for your
  specific agent.
- Use your agent's default skill locations and loading mechanisms.

## Agent-Specific Instructions

- Keep skills interoperable with superpowers and document any integration assumptions.
- Update `README.md` when adding a new skill or changing prerequisites.
