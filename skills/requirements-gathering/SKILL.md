---
name: requirements-gathering
description: Gather requirements through interactive questions and create work items without committing design documents
---

# Requirements Gathering

## Overview

Drive out requirements through interactive questions and capture them in work items. This skill focuses solely on
understanding WHAT needs to be built and WHY, not HOW to build it.

**Core principle**: Gather requirements, create ticket, stop. No design, no plan, no commits.

## When to Use This Skill

Use requirements-gathering when:

- **Creating a new work item** - No ticket exists yet for the work
- **Requirements are unclear** - Need to ask questions to understand what's needed
- **Before planning** - Gathering input for future planning work
- **Capturing user requests** - User describes a feature/fix but details are fuzzy

Do NOT use requirements-gathering when:

- **Ticket already exists** - Use brainstorming or writing-plans instead
- **Ready to plan implementation** - Use writing-plans skill
- **Doing actual implementation** - Work on existing ticket
- **Requirements are already documented** - Load ticket and proceed to planning

## Skill Comparison

| Activity                   | requirements-gathering | brainstorming | writing-plans              |
| -------------------------- | ---------------------- | ------------- | -------------------------- |
| Gather requirements        | ✅ Yes                 | ✅ Yes        | ❌ No (assumes reqs exist) |
| Create design              | ❌ No                  | ✅ Yes        | ❌ No                      |
| Create implementation plan | ❌ No                  | ✅ Yes        | ✅ Yes                     |
| Create ticket              | ✅ Yes                 | ❌ No         | ❌ No                      |
| Commit documents           | ❌ No                  | ✅ Yes        | ✅ Yes                     |

**Key distinction**: requirements-gathering creates tickets WITHOUT committing design documents. Brainstorming creates
designs and commits them. Writing-plans assumes requirements exist and creates implementation plans.

## Prerequisites

**Required**: One of the following ticketing CLIs:

- `gh` (GitHub CLI) - for GitHub repositories
- `ado` (Azure DevOps CLI) - for Azure DevOps repositories
- `jira` (Jira CLI) - for Jira-based workflows

**Optional**:

- Access to repository README.md to detect platform from taskboard URL
- Superpowers with `brainstorming` and `writing-plans` skills for full implementation workflow

**Verification**:

```bash
# Check CLI is installed and authenticated
gh auth status        # For GitHub
ado login --check     # For Azure DevOps
jira me               # For Jira
```

## Core Workflow

### 1. Understand the Request

Start by understanding the current state:

- **Read repository context**: README, recent commits, existing docs
- **Identify the gap**: What's missing or broken?
- **Clarify scope**: Is this a feature, fix, refactor, or something else?

### 2. Ask Questions One at a Time

Drive out requirements through focused questions:

**Focus areas**:

- **Purpose**: Why is this needed? What problem does it solve?
- **Success criteria**: How will we know it's done correctly?
- **Constraints**: What limitations exist? (time, resources, compatibility)
- **Users/stakeholders**: Who will use this? Who cares about it?
- **Dependencies**: What does this depend on? What depends on this?

**Question style**:

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended
- **Build on previous answers** - Each answer informs next question
- **Stop when clear** - Don't over-gather; get essentials and move on

**Example question flow**:

```text
Agent: "What problem are you trying to solve with this feature?"
User: [Answers]

Agent: "Who will be using this feature - end users, developers, or both?"
User: [Answers]

Agent: "What would successful implementation look like from your perspective?"
User: [Answers]
```

### 3. Structure the Requirements

Once you have enough information, structure it into four sections:

#### Goal (One Sentence)

A clear, concise statement of what this work achieves.

**Format**: `[Action] [target] to [benefit]`

**Examples**:

- "Add authentication middleware to protect API endpoints from unauthorized access"
- "Refactor database connection pooling to improve query performance"
- "Create requirements-gathering skill to prevent designs without tickets"

#### Requirements (Numbered List)

Specific, measurable things that must be delivered.

**Format**: Numbered list of deliverables

**Examples**:

```markdown
1. Interactive requirement gathering workflow
2. Structured output format for tickets
3. No design document creation
4. Integration with issue-driven-delivery
```

#### Acceptance Criteria (Checklist)

Testable conditions that must be met for the work to be considered complete.

**Format**: Unchecked boxes with specific, verifiable criteria

**Examples**:

```markdown
- [ ] Skill created at `skills/requirements-gathering/SKILL.md`
- [ ] BDD tests validate no design documents created
- [ ] README.md updated with skill listing
- [ ] All linting checks pass
```

#### Context (Background and Constraints)

Why this work is needed, relevant background, and any constraints.

**Format**: 2-4 paragraphs of prose

**Examples**:

```markdown
Current brainstorming skill allows creating design documents without
first creating a work item, violating the issue-driven-delivery workflow.
This creates a loophole where designs can be committed without tickets.

The requirements-gathering skill will close this loophole by separating
requirement gathering (for ticket creation) from implementation planning
(which requires an existing ticket).
```

### 4. Detect Platform and Create Ticket

**Platform detection and ticket creation**: See `references/platform-cli-examples.md` for:

- Platform detection from git remote or README
- Platform-specific ticket creation commands
- Component tagging examples for each platform
- CLI verification commands

### 5. Stop - Do Not Proceed to Planning

**Critical**: After creating the ticket, STOP. Do not:

- ❌ Create design documents
- ❌ Create implementation plans
- ❌ Commit anything to repository
- ❌ Start implementation

**What to do instead**:

✅ Provide ticket URL to user
✅ Confirm ticket captures requirements
✅ Stop and wait for user to decide when to work on it

**Example completion message**:

```text
I've created ticket #123 with the requirements we gathered:
https://github.com/user/repo/issues/123

The ticket captures:
- Goal: [one sentence]
- 4 requirements
- 6 acceptance criteria
- Context explaining why this work is needed

When you're ready to work on this, we can load the ticket and create
an implementation plan using the writing-plans skill.
```

## Integration with Issue-Driven-Delivery

**Workflow**:

```text
requirements-gathering → Create Ticket → STOP
                                          ↓
                        (Later, when ready to work on it)
                                          ↓
        Load Ticket → brainstorming/writing-plans → Implementation
```

**State transitions** (if using state tracking):

1. `requirements-gathering` creates ticket in **New Feature** state
2. Ticket stays in **New Feature** until work begins
3. When planning starts, transition to **Refinement** state
4. When implementation starts, transition to **Implementation** state
5. When testing starts, transition to **Verification** state
6. When complete, close ticket as **Complete**

**References**:

For details on issue-driven-delivery workflow, see:

- `skills/issue-driven-delivery/SKILL.md` - Main workflow
- `skills/issue-driven-delivery/references/platform-resolution.md` - Platform detection
- `skills/issue-driven-delivery/references/component-tagging.md` - Component tagging
- `skills/issue-driven-delivery/references/state-tracking.md` - State management

## Common Mistakes

### Mistake 1: Creating Design Documents

**Anti-pattern**:

```text
Agent: "Let me create a design document to capture these requirements."
Agent: [Creates docs/design/feature-x.md]
Agent: [Commits design document]
```

**Why wrong**: Requirements should live in the ticket, not in design documents. Design documents come LATER during
implementation planning.

**Correct approach**: Create ticket with structured requirements, stop, no commits.

### Mistake 2: Proceeding to Implementation Planning

**Anti-pattern**:

```text
Agent: "Now that we have requirements, let me create an implementation plan."
Agent: [Creates docs/plans/implementation-plan.md]
```

**Why wrong**: requirements-gathering ends at ticket creation. Planning happens later when the ticket is picked up for work.

**Correct approach**: Create ticket, stop, let user decide when to work on it.

### Mistake 3: Using for Existing Tickets

**Anti-pattern**:

```text
User: "Work on ticket #123"
Agent: [Uses requirements-gathering skill]
```

**Why wrong**: If ticket already exists, skip requirements-gathering and go straight to planning or implementation.

**Correct approach**: Use brainstorming or writing-plans skill for existing tickets.

### Mistake 4: Over-gathering Requirements

**Anti-pattern**:

```text
Agent: [Asks 20 detailed questions]
Agent: [Creates 15-section requirements document]
Agent: [Spends hours on perfect requirements]
```

**Why wrong**: Requirements gathering should be lightweight - get essentials, create ticket, stop. Details come out
during planning.

**Correct approach**: Ask essential questions (5-10), capture core requirements, create ticket, stop.

## Red Flags

**Stop immediately if you catch yourself**:

- Creating any `.md` file in `docs/` directory
- Running `git add` or `git commit` commands
- Creating implementation plans or designs
- Discussing HOW to implement (instead of WHAT to deliver)
- Writing detailed technical specifications

**If you see these red flags**: STOP, delete uncommitted files, create ticket with requirements only.

## Output Format Template

```markdown
## Goal

[One sentence describing what this achieves]

## Requirements

1. [Specific deliverable 1]
2. [Specific deliverable 2]
3. [Specific deliverable 3]
   ...

## Acceptance Criteria

- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] [Testable criterion 3]
      ...

## Context

[2-4 paragraphs explaining:

- Why this work is needed
- Relevant background
- Constraints or limitations
- Impact on users/system]
```

## Examples

See `references/examples.md` for detailed examples including:

- **Example 1**: New Feature Request (dark mode)
- **Example 2**: Bug Fix Request (login form validation)
- **Example 3**: Refactoring Request (database connection pooling)
- **Example 4**: New Skill Request (repo best practices configuration)

Each example shows:

- User request and requirements gathering conversation
- Structured ticket content (Goal/Requirements/Acceptance/Context)
- Agent completion message
- What agent does NOT do (no design docs, no commits)

## Best Practices

1. **Ask focused questions** - One topic at a time, build understanding incrementally
2. **Prefer multiple choice** - Easier for users to answer quickly
3. **Know when to stop** - Get essentials, don't over-gather
4. **Use structured format** - Goal/Requirements/Acceptance/Context every time
5. **Tag components** - Add appropriate labels based on repository structure
6. **Verify platform** - Auto-detect GitHub/Azure DevOps/Jira from repo
7. **Stop after ticket creation** - No design, no plan, no commits
8. **Provide ticket URL** - Give user clear reference to created work item

## Troubleshooting

**Problem**: Can't detect platform from repository

**Solution**: Ask user which platform they're using (GitHub/Azure DevOps/Jira)

---

**Problem**: CLI not installed or authenticated

**Solution**: Provide installation and authentication instructions for the platform

---

**Problem**: User wants design document created

**Solution**: Explain requirements go in ticket, design comes later during planning phase

---

**Problem**: Requirements are very detailed/complex

**Solution**: Capture high-level requirements in ticket, details will emerge during planning

---

**Problem**: User wants to start implementation immediately

**Solution**: Create ticket first, then load ticket and proceed to planning/implementation

## Success Indicators

You've successfully used requirements-gathering when:

- ✅ Ticket created with structured requirements
- ✅ No design documents in repository
- ✅ No implementation plans created
- ✅ Git log shows no commits during requirements gathering
- ✅ Ticket has Goal, Requirements, Acceptance Criteria, Context
- ✅ Component tags applied based on repository structure
- ✅ Platform-appropriate CLI used (gh/ado/jira)
- ✅ Ticket URL provided to user for future reference

## See Also

- `skills/issue-driven-delivery/SKILL.md` - Work item lifecycle management
- `superpowers:brainstorming` - Creating designs for existing tickets (requires Superpowers)
- `superpowers:writing-plans` - Creating implementation plans (requires Superpowers)
