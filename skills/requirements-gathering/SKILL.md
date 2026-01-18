---
name: requirements-gathering
description: Gather requirements through interactive questions and create work items without committing design documents
metadata:
  type: Process
  priority: P3
---

# Requirements Gathering

## Overview

Drive out requirements through interactive questions and capture them in work items. This skill focuses solely on
understanding WHAT needs to be built and WHY, not HOW to build it.

**Core principle**: Gather requirements, create ticket, stop. No design, no plan, no commits.

## When to Use

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

## Precondition Check

**Before proceeding, verify this condition is met:**

- [ ] No open ticket exists for this work

**How to verify:**

```bash
# Search for existing tickets related to this work
gh issue list --search "[keywords from user request]" --state open
```

**If a ticket already exists:**

> **STOP** - This skill is for creating NEW tickets only.
>
> Use `process-skill-router` to find the correct skill:
>
> - Ticket exists, requirements unclear → `brainstorming`
> - Ticket exists, ready to plan → `writing-plans`
> - Ticket exists, ready to implement → `test-driven-development`

**Ticket state considerations:**

| Ticket State         | Action                                        |
| -------------------- | --------------------------------------------- |
| No ticket exists     | ✅ Proceed with requirements-gathering        |
| Open ticket exists   | ❌ Redirect to brainstorming or writing-plans |
| Closed ticket exists | ✅ Proceed (create new ticket for new work)   |
| Draft ticket exists  | ❌ Redirect to brainstorming to refine draft  |

**If multiple tickets might match:**

Do not assume. Ask the user:

```text
I found existing tickets that might relate to this work:
- #123: [Title]
- #456: [Title]

Does this work relate to any of these existing tickets, or should I create a new one?
```

## Skill Comparison

| Activity                   | requirements-gathering   | brainstorming | writing-plans              |
| -------------------------- | ------------------------ | ------------- | -------------------------- |
| Gather requirements        | ✅ Yes                   | ✅ Yes        | ❌ No (assumes reqs exist) |
| Create design              | ❌ No                    | ✅ Yes        | ❌ No                      |
| Create implementation plan | ❌ No                    | ✅ Yes        | ✅ Yes                     |
| Create ticket              | ✅ Yes                   | ❌ No         | ❌ No                      |
| Decompose large work       | ✅ Yes (epic + children) | ❌ No         | ❌ No                      |
| Commit documents           | ❌ No                    | ✅ Yes        | ✅ Yes                     |

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

### 4. Evaluate Scope for Decomposition

After structuring requirements, evaluate whether the work should be decomposed into multiple tickets.
See `references/scope-detection.md` for detailed detection criteria.

**Structural signals to check:**

| Signal                     | How to Detect                                              |
| -------------------------- | ---------------------------------------------------------- |
| Multiple user flows        | Requirements describe 2+ distinct end-to-end scenarios     |
| Multiple API endpoints     | Requirements mention 2+ separate HTTP operations           |
| Multiple database entities | Requirements include 2+ new tables or major schema changes |
| Cross-cutting concerns     | Auth, logging, caching mentioned across features           |
| Multiple consumers         | 2+ different UI components or services                     |
| Infrastructure + app       | Deployment/infra work combined with feature development    |

**Threshold backstop:**

If no structural signals but requirements exceed configured thresholds (stored in `docs/adr/`), consider decomposition.

**Decision point:**

```text
I've identified signals suggesting this work could be decomposed:
- [List detected signals]
- [Requirements count vs threshold]

Would you like me to propose a decomposition into smaller tickets?
```

If user declines or no signals detected, proceed with single ticket creation (section 7).

### 5. Present Decomposition Proposal (If Applicable)

When decomposition is warranted, present a complete proposal using three views.
See `references/decomposition-formats.md` for detailed format specifications.

**Outline view** (hierarchical):

```text
Epic: [Epic Title]
├── #1 [Ticket Title] [Category]
│   └── [Brief description]
│   └── blocked by: —
├── #2 [Ticket Title] [Category]
│   └── [Brief description]
│   └── blocked by: #1
└── #N Remove Feature Flags [Cleanup]
    └── Remove all feature flags, verify flows
    └── blocked by: [all feature tickets]
```

**Details table:**

```markdown
| #   | Title   | Description          | Blocked By | Size    | Safe to Ship    |
| --- | ------- | -------------------- | ---------- | ------- | --------------- |
| 1   | [Title] | [What this delivers] | —          | X days  | Yes/No (reason) |
| 2   | [Title] | [What this delivers] | #1         | X days  | Yes/Flag/No     |
| N   | Cleanup | Remove feature flags | #X, #Y     | 0.5 day | Yes             |
```

**Dependency graph** (ASCII for terminal):

```text
                    ┌─────────────────────┐
                    │  #1 Foundation      │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              ▼                ▼                ▼
   ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
   │  #2 Feature A    │ │  #3 Feature B    │ │  #4 Feature C    │
   └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘
            └───────────────┬────┴────────────────────┘
                            ▼
                 ┌─────────────────────┐
                 │  #N Cleanup         │
                 └─────────────────────┘
```

**User editing options:**

After presenting the proposal, allow refinement:

- **Merge**: "combine #3 and #4"
- **Split**: "split #2 into two tickets"
- **Reorder**: "make #5 depend on #1 only"
- **Modify**: "change the title of #2"
- **Add/Remove**: "add a ticket for X" or "remove #4"

Iterate until user confirms with "confirm" or equivalent.

### 6. Check Platform Organization (First Time Only)

Before creating tickets, verify team context is stored for threshold calibration.

**Check for existing ADR:**

```bash
ls docs/adr/*decomposition* docs/adr/*thresholds* 2>/dev/null
```

**If no ADR exists, ask:**

```text
I'd like to store your team's preferences for decomposition thresholds.

What is your typical sprint duration?
1. 1 week (5 days)
2. 2 weeks (10 days)
3. 3 weeks (15 days)
4. 4 weeks (20 days)

What's your ideal ticket size?
1. 1 day (very granular)
2. 2-3 days (recommended)
3. 4-5 days (larger chunks)
```

Store in `docs/adr/NNNN-decomposition-thresholds.md` for future use.

**Skip if:**

- ADR already exists
- User only creating single ticket (no decomposition)

### 7. Detect Platform and Create Ticket(s)

**Platform detection and ticket creation**: See `references/platform-cli-examples.md` for:

- Platform detection from git remote or README
- Platform-specific ticket creation commands
- Component tagging examples for each platform
- CLI verification commands

**For decomposed work:**

When creating an epic with child tickets:

1. Create the epic ticket first (parent)
2. Create each child ticket
3. Link child tickets as sub-issues of the epic (parent/child relationship)
4. Set up blocking relationships between children (via `blocked` label + comment)
5. Include dependency graph (Mermaid) in epic description

**Platform-specific linking:**

- **GitHub**: Use sub-issues for parent/child hierarchy, `blocked` labels for dependencies
- **Azure DevOps**: Use parent/child work item links
- **Jira**: Use epic link field or parent issue

**Sub-issues vs Task lists:**

| Concept        | Use For                           | Creates Separate Ticket? |
| -------------- | --------------------------------- | ------------------------ |
| **Sub-issues** | Decomposed work (epic → children) | Yes - independent items  |
| **Task lists** | Steps within a single ticket      | No - checkboxes only     |

For detailed CLI commands including GitHub sub-issue creation via GraphQL API,
see `references/platform-cli-examples.md`.

For platform organization options comparison, see `references/platform-organization-options.md`.

### 8. Stop - Do Not Proceed to Planning

**Critical**: After creating the ticket(s), STOP. Do not:

- ❌ Create design documents
- ❌ Create implementation plans
- ❌ Commit anything to repository
- ❌ Start implementation

**What to do instead**:

✅ Provide ticket URL(s) to user
✅ Confirm ticket(s) capture requirements
✅ Stop and wait for user to decide when to work on it

**Example completion message (single ticket)**:

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

**Example completion message (epic + children)**:

```text
I've created an epic with 4 child tickets:

Epic: #100 User Authentication System
https://github.com/user/repo/issues/100

Child tickets:
- #101 Database schema for users and sessions (Foundation)
- #102 Login and registration flows (Feature)
- #103 Password reset flow (Feature)
- #104 Remove feature flags (Cleanup)

Dependencies are linked, and the epic contains a dependency graph.

When you're ready to start, begin with ticket #101 (no blockers).
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

## Reference Templates

GitHub issue templates and automation scripts for quick repository setup:

| Template                                                                    | Purpose                              |
| --------------------------------------------------------------------------- | ------------------------------------ |
| [github-feature-issue.md](templates/github-feature-issue.md.template)       | Feature request with structured form |
| [github-bug-issue.md](templates/github-bug-issue.md.template)               | Bug report with reproduction steps   |
| [github-epic-issue.md](templates/github-epic-issue.md.template)             | Epic with child ticket tracking      |
| [validate-issue.sh](templates/validate-issue.sh.template)                   | Validate issue has required sections |
| [install-issue-templates.sh](templates/install-issue-templates.sh.template) | Install templates in repository      |

### Quick Setup

```bash
# Install issue templates in your repository
./install-issue-templates.sh /path/to/repo

# Validate an issue has required sections
./validate-issue.sh 123
```

### Template Sections

All issue templates follow the structured format:

- **Goal**: One sentence describing the outcome
- **Requirements/Steps**: Numbered list of deliverables or reproduction steps
- **Acceptance Criteria**: Testable checkboxes
- **Context**: Background and constraints

## See Also

- `skills/process-skill-router/SKILL.md` - Route to correct skill based on context
- `skills/issue-driven-delivery/SKILL.md` - Work item lifecycle management
- `superpowers:brainstorming` - Creating designs for existing tickets (requires Superpowers)
- `superpowers:writing-plans` - Creating implementation plans (requires Superpowers)

## Question Bank by Work Type

### New Feature

| Category | Question                                    | Why It Matters                |
| -------- | ------------------------------------------- | ----------------------------- |
| Purpose  | "What problem does this feature solve?"     | Establishes value proposition |
| Users    | "Who will use this feature?"                | Identifies target audience    |
| Success  | "How will you know it's working correctly?" | Defines acceptance criteria   |
| Scope    | "What's the minimum viable version?"        | Prevents scope creep          |
| Priority | "Is this blocking other work?"              | Helps with scheduling         |

### Bug Fix

| Category     | Question                                   | Why It Matters           |
| ------------ | ------------------------------------------ | ------------------------ |
| Reproduction | "Can you describe the steps to reproduce?" | Enables debugging        |
| Expected     | "What should happen instead?"              | Defines correct behavior |
| Impact       | "How many users are affected?"             | Determines priority      |
| Workaround   | "Is there a temporary workaround?"         | Assesses urgency         |
| Environment  | "What environment does this occur in?"     | Narrows root cause       |

### Refactoring

| Category    | Question                                   | Why It Matters        |
| ----------- | ------------------------------------------ | --------------------- |
| Motivation  | "What's driving this refactoring?"         | Validates need        |
| Scope       | "Which components are affected?"           | Estimates effort      |
| Risk        | "What could break during this change?"     | Identifies test needs |
| Constraints | "Any backward compatibility requirements?" | Defines boundaries    |
| Success     | "How will we measure improvement?"         | Sets clear goals      |

### Infrastructure/DevOps

| Category     | Question                                       | Why It Matters        |
| ------------ | ---------------------------------------------- | --------------------- |
| Trigger      | "What's prompting this infrastructure change?" | Establishes context   |
| Scale        | "What scale/load requirements exist?"          | Sizes solution        |
| Dependencies | "What systems depend on this?"                 | Identifies risks      |
| Rollback     | "What's the rollback plan if it fails?"        | Ensures safety        |
| Monitoring   | "How will we know it's working?"               | Defines observability |

### Documentation

| Category    | Question                                               | Why It Matters           |
| ----------- | ------------------------------------------------------ | ------------------------ |
| Audience    | "Who is the target reader?"                            | Sets tone and depth      |
| Gap         | "What's missing from current docs?"                    | Identifies scope         |
| Format      | "What format works best (guide, reference, tutorial)?" | Structures content       |
| Examples    | "What examples would be most helpful?"                 | Adds practical value     |
| Maintenance | "How often will this need updating?"                   | Plans for sustainability |

## "Enough Info" Validation Checklist

Before creating the ticket, verify you have gathered sufficient information:

### Minimum Required (All Work Types)

- [ ] **Goal is clear**: Can state in one sentence what this achieves
- [ ] **Success criteria exist**: At least 2 testable acceptance criteria
- [ ] **Scope is bounded**: Know what's included AND excluded
- [ ] **No major unknowns**: No "TBD" or "to be determined" items

### Feature-Specific

- [ ] **User identified**: Know who will use this
- [ ] **MVP defined**: Know minimum viable scope
- [ ] **Dependencies known**: Identified blocking/blocked work

### Bug-Specific

- [ ] **Reproduction steps**: Can reproduce the issue
- [ ] **Expected behavior**: Know correct behavior
- [ ] **Environment**: Know where it occurs

### Refactoring-Specific

- [ ] **Motivation documented**: Know why this is needed
- [ ] **Risk assessed**: Identified what could break
- [ ] **Success measurable**: Can verify improvement

## Quick Validation Script

```bash
#!/bin/bash
# validate-requirements.sh - Check if requirements are sufficient

ISSUE_BODY="$1"

ERRORS=0

echo "=== Requirements Validation ==="

# Check for Goal section
if echo "$ISSUE_BODY" | grep -qi "## Goal"; then
  echo "✓ Goal section present"
else
  echo "✗ Goal section missing"
  ((ERRORS++))
fi

# Check for Requirements section
if echo "$ISSUE_BODY" | grep -qi "## Requirements"; then
  REQ_COUNT=$(echo "$ISSUE_BODY" | grep -cE "^[0-9]+\.")
  if [ "$REQ_COUNT" -ge 2 ]; then
    echo "✓ Requirements section has $REQ_COUNT items"
  else
    echo "⚠ Only $REQ_COUNT requirement(s) - consider adding more"
  fi
else
  echo "✗ Requirements section missing"
  ((ERRORS++))
fi

# Check for Acceptance Criteria
if echo "$ISSUE_BODY" | grep -qi "## Acceptance"; then
  AC_COUNT=$(echo "$ISSUE_BODY" | grep -cE "^\s*-\s*\[\s*\]")
  if [ "$AC_COUNT" -ge 2 ]; then
    echo "✓ Acceptance criteria has $AC_COUNT items"
  else
    echo "⚠ Only $AC_COUNT acceptance criterion - add more"
  fi
else
  echo "✗ Acceptance criteria section missing"
  ((ERRORS++))
fi

# Check for TBD markers
TBD_COUNT=$(echo "$ISSUE_BODY" | grep -ciE "tbd|to be determined|unknown|\?\?\?")
if [ "$TBD_COUNT" -eq 0 ]; then
  echo "✓ No TBD markers found"
else
  echo "⚠ Found $TBD_COUNT TBD markers - resolve before proceeding"
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✓ Requirements appear sufficient"
else
  echo "✗ $ERRORS issue(s) found - gather more information"
fi
```

## Stop-and-Ask Triggers

If you encounter these during gathering, STOP and ask clarifying questions:

| Trigger                           | Action                                    |
| --------------------------------- | ----------------------------------------- |
| User says "I'm not sure"          | Ask for what they DO know                 |
| Multiple interpretations possible | Present options, ask which                |
| Scope seems very large            | Ask about MVP/phases                      |
| Technical jargon unclear          | Ask for plain language explanation        |
| Contradictory requirements        | Surface contradiction, ask for resolution |
| Missing stakeholder input         | Ask if others need to be consulted        |
