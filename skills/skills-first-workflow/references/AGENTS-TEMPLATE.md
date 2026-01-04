# AGENTS.md Template

Use this template when creating or updating AGENTS.md in repositories that adopt
skills-first workflow.

```markdown
# Agent Guidelines

## Agent Execution Rules

Agents must follow the standards in `README.md` before taking any action.
These rules tighten the workflow for autonomous execution.

- **Skills-first enforcement.** Bootstrap, load skills, and follow process
  skills before any implementation.
- **No changes without a Taskboard issue.** All non-read-only work must be tied
  to a Taskboard issue.
- **TDD enforcement.** Apply TDD standard - failing test before implementation.
- **Feature branch only.** Do not commit on main/master.

## Prerequisites First

Before any task or response in this repo:

1. Load `development-skills:skills-first-workflow` to enforce workflow
2. Ensure Superpowers is installed and bootstrapped
3. Load `superpowers:using-superpowers`
4. Load relevant skills for the task

## Prerequisite Repositories

Skills in this repository depend on external skill libraries. Install these
before using skills from this repo:

- **Superpowers**: https://github.com/obra/superpowers
  - Follow installation and bootstrap instructions for your agent

- **development-skills**: https://github.com/[org]/development-skills
  - This repository (install per your agent's skill installation mechanism)

## Superpowers Bootstrap

Superpowers is the source of truth for the skill library.

- **CRITICAL**: Do not proceed with any task until Superpowers has been
  installed, bootstrapped, and you've applied the `using-superpowers` skill.
- Follow the installation instructions in the Superpowers repository for your
  specific agent.
- Use your agent's default skill locations and loading mechanisms.

## No Implementation First

Jumping straight into implementation is an exception and must be explicitly
requested by the user. The default is to load and apply skills before any repo
actions.
```

## Customization

Replace `[org]` with the actual GitHub organization or user name for the
development-skills repository.

Add repository-specific rules as needed while maintaining the core skills-first
enforcement sections.
