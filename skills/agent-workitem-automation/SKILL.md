---
name: agent-workitem-automation
description: >
  Use when an agent is asked to autonomously manage a work item and must
  resolve task board source, platform CLI, or step updates across GitHub,
  Azure DevOps, or Jira.
---

# Agent Work Item Automation

## Overview

Treat the work item system as the source of truth and keep progress visible at
all times. If you cannot prove context or tooling, stop and fix that first.

**REQUIRED SUB-SKILL:** superpowers:brainstorming
**REQUIRED SUB-SKILL:** superpowers:test-driven-development
**REQUIRED SUB-SKILL:** superpowers:verification-before-completion

If an issue-driven workflow is required (work item comments, approvals, evidence tracking),
use `issue-driven-delivery`.

## Invocation Signals

Start when a comment mentions the agent and includes a task verb (for example,
"manage", "handle", "take", "own"). If the intent is unclear, ask for
confirmation before acting.

Accept agent identifiers by CLI name:

- `@claude` and `@codex`
- `@agent` aliases to the primary agent

Supported phrases include "manage this ticket", "handle this ticket", or
"own this issue" and should start refinement, planning, and orchestration.

## Brainstorming Gate

Before making changes, use brainstorming to confirm:

- Ticketing system and taskboard source
- CI/CD system for automation
- Agent CLIs to configure and which is primary

Do not proceed until these are explicit.

## Work Item Discovery

1. Read `README.md` and locate a section titled `Work Items`.
2. Expect a single line: `Taskboard: <url>`.
3. If the section is missing, prompt the user and add the section near the top
   of README (after the title and before other sections).

## Platform Resolution

Infer platform from the task board URL:

| Platform     | Example domain patterns             | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

If the URL is not recognised, stop and ask the user to confirm the platform.

## CLI Setup (Auto)

Before reading or updating tickets, ensure the CLI is installed and authenticated.

- If the CLI is missing, run its setup flow using the official install steps.
- If authentication is missing, run the CLI auth flow.
- If setup requires interactive input you cannot complete, stop and ask for help.

## Skill Source Setup (Local and Remote)

For development, a local symlink to the skills repo is acceptable:

```text
ln -s <path-to-development-skills>/skills ~/.codex/skills/development-skills
```

Remove the symlink after the task is complete.

For remote agents (CI), clone the skills repo for the duration of the run and
configure the agent to scan that path. When the task is complete, documentation
must reference the default branch instead of the feature branch.

When creating AGENTS.md in a new repo, include references to prerequisite
skills repositories and where they should be cloned. Use the agent's default
skill location pattern. For example:

- **Superpowers**: <https://github.com/obra/superpowers>
  - Claude: `~/.claude/superpowers`
  - Codex: `~/.codex/superpowers` (Windows: `%USERPROFILE%\.codex\superpowers`)
  - Bootstrap: Follow installation instructions from repository

- **development-skills**: <https://github.com/mcj-coder/development-skills>
  - Claude: `~/.claude/skills/development-skills`
  - Codex: `~/.codex/skills/development-skills` (Windows: `%USERPROFILE%\.codex\skills\development-skills`)

Do not assume these repos are already installed. Reference the agent's
installation guide for platform-specific paths.

## Workflow Integration (Minimal)

Create or update the CI workflow to trigger agent CLIs from ticket events.
Avoid duplicating delivery workflows already covered by
`issue-driven-delivery`. Keep this focused on:

- Event trigger (for example, issue comment)
- CLI invocation for the primary agent
- Evidence comment back to the issue

Prefer non-interactive CLI usage in CI. Examples:

- `claude -p "<prompt>"`
- `codex exec "<command or prompt>"`

## Core Execution Loop

1. Load ticket details, comments, and related PRs from the CLI.
2. Determine the next required step (or identify a missing decision).
3. Execute only the next step; keep changes minimal.
4. Post a step update comment using the template below.
5. If a task is completed, update the issue body checklist.
6. Trigger the next step:
   - If it is part of the current plan, post a follow-up comment.
   - If it is a follow-on task, create a new top-level ticket.

## Delivery Completion (Autonomous)

When all steps in the current plan are complete and all required PRs are merged:

1. Verify completion using `superpowers:verification-before-completion`.
2. Post a final update comment with evidence and completion summary.
3. Ensure the taskboard issue is updated with completion evidence.
4. Close the work item when all in-scope work is delivered, acceptance criteria
   are met, and no blockers remain.
5. If issue requires multiple PRs, keep open until all scope delivered or remaining
   work moved to new ticket.
6. Do not leave work items open after all work complete.

If any acceptance criteria are unclear or evidence is incomplete, hand off to a
human instead of closing.

Before opening a PR, confirm evidence shows required skills were applied for
concrete changes (config, docs, code). For process-only changes, record that
verification is analytical.

## Example

**Scenario:** Comment says "@agent manage this ticket" on a GitHub issue.

1. Read README -> `Work Items` -> `Taskboard: https://github.com/org/repo`.
2. Select `gh`, verify install/auth, then fetch issue details and comments.
3. Identify the next step, execute it, then post a step update comment.
4. Update the issue checklist when a task completes.
5. Post a follow-up comment for the next planned step.

## Step Update Comment Template

```text
Summary:
- <one or two bullets>

Evidence/Links:
- <ticket comment, commit, PR, logs, or note that no code change occurred>

Next Step:
- <explicit next action>

Hand-off/Blocker:
- <none> or <what decision is needed>
```

## Hand-off Triggers

Hand off to a human when:

- Risk or ambiguity is high (security, cost, production impact).
- Scope creep is detected (work exceeds acceptance criteria).
- Loop detection triggers (see below).

## Loop Detection

Trigger hand-off when either condition occurs:

- 3 consecutive cycles without meaningful progress, or
- 60 minutes of active attempts.

Meaningful progress includes: plan changes, code changes, test results, or a
resolved decision recorded on the ticket.

## Common Mistakes

- Skipping the Work Items section or guessing the platform.
- Continuing without CLI setup or auth confirmation.
- Posting updates without evidence links.
- Working multiple steps at once instead of one step per cycle.
- Failing to create a follow-on ticket when scope increases.
- Closing a ticket without verified evidence.

## Red Flags - STOP

- Skipping the README task board check.
- Proceeding without CLI install/auth confirmation.
- Posting updates without evidence or next step.
- Repeating cycles without new evidence or outcomes.

## Rationalisations (and Reality)

| Excuse                             | Reality                                    |
| ---------------------------------- | ------------------------------------------ |
| "We can assume GitHub"             | Use the task board link to prove platform. |
| "I'll set up the CLI later"        | Setup and auth must happen first.          |
| "No need to update the ticket yet" | The ticket is the source of truth.         |

## Quick Reference

- Read README -> `Work Items` -> `Taskboard: <url>`
- Infer platform -> pick `gh` / `ado` / `jira`
- Ensure CLI install + auth
- One step -> comment template -> update checklist
- Hand-off on risk, scope creep, or loop trigger
