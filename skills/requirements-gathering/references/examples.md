# Requirements Gathering Examples

## Example 1: New Feature Request

### User Request

"I want to add dark mode to the application"

### Requirements Gathering Conversation

```text
Agent: "What triggers dark mode - user preference, system setting, or both?"
User: "Both - follow system but allow manual override"

Agent: "Which parts of the app need dark mode - entire UI or specific sections?"
User: "Entire UI including all pages and components"

Agent: "What's the success criteria - how will we know it works correctly?"
User: "All text readable, proper contrast ratios, smooth transitions"
```

### Ticket Created (#456)

```markdown
## Goal

Add dark mode support to application UI with system detection and manual override

## Requirements

1. Detect system dark mode preference
2. Provide manual dark/light mode toggle
3. Style all pages and components for dark mode
4. Ensure WCAG AA contrast ratios
5. Persist user's manual preference

## Acceptance Criteria

- [ ] Dark mode activates when system preference is dark
- [ ] Manual toggle overrides system preference
- [ ] All UI components render correctly in dark mode
- [ ] Contrast ratios meet WCAG AA standards
- [ ] User preference persists across sessions
- [ ] Smooth transitions between light/dark modes

## Context

Users working in low-light environments have requested dark mode support.
Current application only supports light mode, causing eye strain during
extended use in dark environments.

System preference detection provides seamless experience for users who
prefer dark mode system-wide, while manual override allows per-app control.
```

### Agent Completion Message

```text
I've created ticket #456 with the requirements we gathered:
https://github.com/user/repo/issues/456

The ticket captures:
- Goal: Add dark mode support with system detection and manual override
- 5 requirements covering detection, toggle, styling, contrast, and persistence
- 6 acceptance criteria for validation
- Context explaining user need and approach

When you're ready to work on this, we can load the ticket and create
an implementation plan using the writing-plans skill.
```

**Note**: Agent stops here. No design document, no implementation plan, no commits.

## Example 2: Bug Fix Request

### User Request

"The login form crashes when password field is empty"

### Requirements Gathering Conversation

```text
Agent: "What should happen when password is empty - show error or disable submit?"
User: "Show validation error, don't allow submit"

Agent: "Should this apply to just password or all required fields?"
User: "All required fields - username and password"

Agent: "What error message should display?"
User: "Standard message like 'This field is required'"
```

### Ticket Created (#457)

```markdown
## Goal

Fix login form crash by adding required field validation

## Requirements

1. Validate username field before submit
2. Validate password field before submit
3. Display clear error messages for empty fields
4. Prevent form submission if validation fails

## Acceptance Criteria

- [ ] Empty username shows "This field is required" error
- [ ] Empty password shows "This field is required" error
- [ ] Submit button disabled when fields are empty
- [ ] No crash when attempting to submit with empty fields
- [ ] Error messages clear when user starts typing

## Context

Login form currently crashes when submitted with empty password field,
causing poor user experience. Root cause is missing client-side validation
before form submission.

Adding validation prevents crash and provides clear feedback to users
about required fields.
```

### Agent Completion Message

```text
I've created ticket #457 with the requirements we gathered:
https://github.com/user/repo/issues/457

The ticket captures:
- Goal: Fix login form crash with field validation
- 4 requirements for validation logic
- 5 acceptance criteria to verify the fix
- Context explaining the bug and why validation solves it

When you're ready to work on this, we can load the ticket and investigate
the root cause using the systematic-debugging skill.
```

**Note**: Agent stops here. No code investigation, no implementation approach, no commits.

## Example 3: Refactoring Request

### User Request

"We need to refactor the database connection pooling - it's slow"

### Requirements Gathering Conversation

```text
Agent: "What specific performance issues are you seeing - slow queries, timeouts, or something else?"
User: "Queries that should be fast are taking 2-3 seconds"

Agent: "Do you have metrics on current connection pool size and utilization?"
User: "Current pool size is 5, but we're seeing connection exhaustion during peak load"

Agent: "What's the target performance - what would 'fast enough' look like?"
User: "Sub-second response times even during peak load"

Agent: "Are there any constraints on connection pool size from your database provider?"
User: "Database supports up to 100 connections, so we have room to grow"
```

### Ticket Created (#458)

```markdown
## Goal

Refactor database connection pooling to achieve sub-second query response times during peak load

## Requirements

1. Increase connection pool size from current 5 connections
2. Implement connection pool monitoring and metrics
3. Add connection timeout and retry logic
4. Configure pool to handle peak load scenarios
5. Document pool configuration decisions

## Acceptance Criteria

- [ ] Query response times under 1 second during peak load
- [ ] No connection exhaustion errors during load testing
- [ ] Pool metrics available via monitoring dashboard
- [ ] Connection timeout and retry logic tested
- [ ] Configuration documented with rationale

## Context

Current connection pool size of 5 is insufficient for peak load, causing
connection exhaustion and query response times of 2-3 seconds. This impacts
user experience during high-traffic periods.

Database provider supports up to 100 connections, providing room for growth.
Target is sub-second response times even during peak load.

Refactoring should include monitoring to track pool utilization and prevent
future performance issues.
```

### Agent Completion Message

```text
I've created ticket #458 with the requirements we gathered:
https://github.com/user/repo/issues/458

The ticket captures:
- Goal: Refactor connection pooling for sub-second response times
- 5 requirements covering pool size, monitoring, timeouts, load handling, and docs
- 5 acceptance criteria for performance validation
- Context with current performance issues and constraints

When you're ready to work on this, we can load the ticket and create
an implementation plan using the writing-plans skill.
```

**Note**: Agent stops here. No technical investigation, no pool size recommendations, no commits.

## Example 4: New Skill Request

### User Request

"Create a skill for configuring repository best practices"

### Requirements Gathering Conversation

```text
Agent: "Should this work for greenfield repos, brownfield repos, or both?"
User: "Both - new repos and existing repos being uplifted"

Agent: "Which platforms should it support - GitHub only, or multiple platforms?"
User: "Platform-agnostic - GitHub, Azure DevOps, and GitLab"

Agent: "What specific best practices should it configure?"
User: "Branch protection, immutable releases, prevent merge commits, PR automation,
       SAST, secret scanning, dependency management"

Agent: "Should it use opinionated defaults or ask for each configuration?"
User: "Opinionated defaults with user approval, fallback to prompts if rejected"

Agent: "Should configurations be captured for documentation?"
User: "Yes, in ADR format"
```

### Ticket Created (#123)

```markdown
## Goal

Create platform-agnostic skill for configuring repository best practices on both greenfield and brownfield repositories

## Requirements

1. Support GitHub, Azure DevOps, and GitLab platforms
2. Configure branch protection to prevent direct pushes to main
3. Enable immutable releases
4. Prevent merge commits, require rebase
5. Configure automated PR merging when checks pass
6. Require SAST and secret scanning for PRs
7. Configure automated dependency management
8. Use opinionated defaults with approval workflow
9. Capture decisions in ADR format
10. Idempotent - safe to re-run without duplicating config

## Acceptance Criteria

- [ ] Skill works on GitHub, Azure DevOps, and GitLab
- [ ] Branch protection configured correctly on all platforms
- [ ] Merge commit prevention validated
- [ ] PR automation tested with passing/failing checks
- [ ] SAST and secret scanning required for PRs
- [ ] Dependency management configured where available
- [ ] Opinionated defaults presented for approval
- [ ] Rejected defaults fallback to interactive prompts
- [ ] ADR created documenting all configuration decisions
- [ ] Re-running skill is safe and idempotent

## Context

Teams need consistent repository configuration across greenfield and brownfield
projects. Manual configuration is error-prone and inconsistent.

This skill will enforce best practices automatically while remaining flexible
through approval workflow. Platform-agnostic design supports teams using
different DevOps platforms.

ADR documentation provides audit trail of configuration decisions for compliance
and knowledge sharing.
```

### Agent Completion Message

```text
I've created ticket #123 with the requirements we gathered:
https://github.com/user/repo/issues/123

The ticket captures:
- Goal: Create platform-agnostic repo best practices configuration skill
- 10 requirements covering platforms, branch protection, security, automation, and docs
- 10 acceptance criteria for validation across all platforms
- Context explaining need for consistent configuration

When you're ready to work on this, we can load the ticket and create
an implementation plan using the writing-plans skill.
```

**Note**: Agent stops here. No design document, no implementation approach, no commits.

## Common Patterns

### Pattern 1: Start with "What" and "Why"

Always begin by understanding:

- What problem are you solving?
- Why is this needed?

This provides context for all other questions.

### Pattern 2: Ask About Success Criteria Early

"What would successful implementation look like?" or "How will we know it's done correctly?"

This drives out acceptance criteria naturally.

### Pattern 3: Identify Constraints

"Are there any limitations or constraints?" or "What can't change?"

This surfaces important context early.

### Pattern 4: Know When to Stop

When you have:

- Clear goal (one sentence)
- Core requirements (3-10 items)
- Testable acceptance criteria (5-10 items)
- Enough context (2-4 paragraphs)

Stop gathering and create the ticket.

### Pattern 5: Prefer Multiple Choice Questions

Instead of: "How should authentication work?"

Use: "Should authentication use session cookies, JWT tokens, or OAuth?"

Easier for users to answer quickly.

## Anti-Patterns to Avoid

### Anti-Pattern 1: Over-Gathering

❌ Asking 25 detailed questions
❌ Creating exhaustive 20-section requirements document
❌ Spending hours perfecting requirements

✅ Ask 5-10 focused questions, capture essentials, create ticket

### Anti-Pattern 2: Technical Deep-Dive

❌ "Let me investigate the current codebase architecture..."
❌ "I'll analyze the performance bottlenecks..."
❌ "Here's my technical recommendation for implementation..."

✅ Stay at requirements level, save technical analysis for planning phase

### Anti-Pattern 3: Creating Design Artifacts

❌ Creating design documents
❌ Creating architecture diagrams
❌ Creating implementation plans

✅ Create ticket only, no other artifacts

### Anti-Pattern 4: Committing Anything

❌ `git add` and `git commit` during requirements gathering
❌ Creating files in docs/ directory
❌ "Let me save these requirements to a file..."

✅ Only output is the ticket, nothing committed to repository
