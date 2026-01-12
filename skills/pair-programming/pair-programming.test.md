# Pair Programming - BDD Test Scenarios

## RED: Failure Scenarios (Expected Without Feature)

### Scenario A: No Structured Trigger Mechanism

**Context:** Human wants to start pair programming session.

**Baseline failure to record:**

- No defined trigger mechanisms
- Unclear how to assign work to agent
- No acknowledgement protocol

**Observed baseline (RED):**

- Agent doesn't know when to start work
- Human assignment not recognised
- No status updates posted

### Scenario B: No Blocked State Handling

**Context:** Agent encounters external blocker during implementation.

**Baseline failure to record:**

- Agent waits indefinitely
- No notification to human
- No parallel work switching

**Observed baseline (RED):**

- Agent stuck on single task
- Human unaware of blocker
- Productivity drops to zero

### Scenario C: No Automated Review Before Human

**Context:** Agent completes implementation, requests human review.

**Baseline failure to record:**

- Human receives unreviewed code
- Basic issues not caught
- Review cycles wasted on obvious problems

**Observed baseline (RED):**

- PRs with linting errors
- Missing test coverage
- Security issues not flagged

## GREEN: Expected Behaviour With Feature

### Trigger Mechanisms

#### Issue Assignment Trigger

- [ ] Agent monitors for `@agent` mentions
- [ ] Agent monitors for direct assignment
- [ ] On assignment, agent posts acknowledgement comment
- [ ] Agent validates Definition of Ready before starting
- [ ] If DoR fails, agent requests clarification
- [ ] If DoR passes, agent proceeds to planning

#### Manual Command Trigger

- [ ] `/pair #N` starts session on specific issue
- [ ] `/pair --next` processes next priority item
- [ ] `/pair --backlog` enables batch processing
- [ ] Command options respected (`--no-plan`, `--draft`, etc.)

#### Scheduled/Batch Trigger

- [ ] Batch job can trigger agent processing
- [ ] Priority order respected
- [ ] Max issues per batch enforced
- [ ] Skip already in-progress issues

### Sub-Agent Orchestration

#### Dispatch by Domain

- [ ] Backend tasks dispatched to backend sub-agent
- [ ] Frontend tasks dispatched to frontend sub-agent
- [ ] QA tasks dispatched to QA sub-agent
- [ ] Appropriate persona used for each domain

#### Parallel Execution

- [ ] Multiple sub-agents can work simultaneously
- [ ] Each sub-agent has isolated worktree
- [ ] No file conflicts between sub-agents
- [ ] Results aggregated correctly

#### Coordination

- [ ] Status updates posted to issue comments
- [ ] Primary agent tracks sub-agent progress
- [ ] Blockers communicated promptly
- [ ] Integration happens in dependency order

### Git Worktree Isolation

#### Worktree Creation

- [ ] Worktree created when sub-agent dispatched
- [ ] Naming convention followed (`wt-<domain>-<issue>`)
- [ ] Worktree based on correct branch (main or feature)

#### Work in Worktree

- [ ] Sub-agent commits work in worktree
- [ ] Commits attributed to correct persona
- [ ] Branch pushed to remote

#### Integration

- [ ] Primary agent merges worktree work
- [ ] Conflicts resolved if any
- [ ] Tests run after integration

#### Cleanup

- [ ] Worktree removed after successful integration
- [ ] Remote branch deleted if merged
- [ ] Stale worktrees pruned

### Persona Switching

#### Workflow Phase Transitions

- [ ] Tech Lead persona for planning phase
- [ ] Domain persona for implementation
- [ ] Tech Lead/QA for review phase
- [ ] Tech Lead for merge

#### Commit Attribution

- [ ] Commits include persona in author name
- [ ] Format: `Claude (<Persona Name>)`
- [ ] GPG signature valid
- [ ] Email matches GPG key

#### Account Switching

- [ ] Developer account for implementation
- [ ] Team account for elevated operations
- [ ] GitHub CLI auth switches correctly

### Blocked State Handling

#### Detection

- [ ] External dependency detected
- [ ] Human input required detected
- [ ] Review pending detected
- [ ] Resource unavailable detected

#### Response

- [ ] Blocker documented in issue comment
- [ ] `pair-programming:blocked` label added
- [ ] Human notified per preferences
- [ ] Agent switches to parallel work

#### Parallel Work Selection

- [ ] Selects highest priority unblocked task
- [ ] Respects dependencies
- [ ] Posts notification of task switch

#### Resumption

- [ ] Monitors for blocker resolution
- [ ] Posts acknowledgement when unblocked
- [ ] Resumes from saved state
- [ ] Updates labels correctly

#### Escalation

- [ ] Auto-escalates after timeout
- [ ] Escalation goes to configured recipient
- [ ] Stale blocked issues handled

### Automated Review Loop

#### Test Gate

- [ ] All tests must pass before reviews
- [ ] Coverage threshold checked
- [ ] Linting passes

#### Tech Lead Review

- [ ] Checks architecture alignment
- [ ] Checks code organization
- [ ] Checks naming conventions
- [ ] Documents findings

#### QA Review

- [ ] Checks test coverage
- [ ] Checks edge cases
- [ ] Checks error handling
- [ ] Documents findings

#### Security Review (When Triggered)

- [ ] Invoked for auth changes
- [ ] Invoked for user input handling
- [ ] Checks OWASP top 10
- [ ] Documents findings

#### Feedback Iteration

- [ ] Critical issues fixed before proceeding
- [ ] Auto-fixes applied where possible
- [ ] Iteration count tracked
- [ ] Escalates after max iterations

#### Human Checkpoint

- [ ] Only reached when all reviews pass
- [ ] All tests green
- [ ] No unresolved critical issues
- [ ] PR created with comprehensive description

### Human Supervisor Interface

#### Progress Visibility

- [ ] Status comments at phase transitions
- [ ] Labels reflect current state
- [ ] Draft PRs show work in progress

#### Intervention Commands

- [ ] `@agent status` returns current state
- [ ] `@agent pause` stops work
- [ ] `@agent continue` resumes work
- [ ] `@agent note:` accepts guidance

#### Takeover

- [ ] `@agent I'm taking over` initiates handoff
- [ ] Agent posts state summary
- [ ] Agent removes self from assignment
- [ ] Partial takeover supported

#### Graceful Handoff

- [ ] Handoff includes completed tasks
- [ ] Handoff includes in-progress state
- [ ] Handoff includes remaining work
- [ ] Files modified listed

### User Playbook

- [ ] Playbook exists at `docs/playbooks/pair-programming.md`
- [ ] Setup instructions complete
- [ ] Daily usage documented
- [ ] Common scenarios with examples
- [ ] Troubleshooting section included

## Verification Checklist

### Skill Structure

- [ ] SKILL.md exists with valid frontmatter
- [ ] All workflow phases documented
- [ ] All integration points documented
- [ ] Detection and deference section included

### Content Completeness

- [ ] Trigger mechanisms comprehensive
- [ ] Sub-agent orchestration detailed
- [ ] Worktree isolation explained
- [ ] Persona switching integrated
- [ ] Blocked handling documented
- [ ] Review loop specified
- [ ] Human interface defined

### Documentation Quality

- [ ] Playbook user-friendly
- [ ] Examples actionable
- [ ] Commands copy-paste ready
- [ ] Troubleshooting practical

### Linting

- [ ] Prettier formatting passes
- [ ] Markdownlint passes
- [ ] cspell passes
