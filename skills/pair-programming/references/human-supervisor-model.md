# Human Supervisor Model

> Reference material for the [`pair-programming`](../SKILL.md) skill.


### Supervisor vs Collaborator

| Aspect            | Collaborator (Traditional) | Supervisor (This Skill)    |
| ----------------- | -------------------------- | -------------------------- |
| Human involvement | Constant                   | Periodic checkpoints       |
| Decision making   | Joint                      | Agent with human oversight |
| Code authorship   | Shared                     | Primarily agent            |
| Review timing     | During implementation      | After automated reviews    |
| Best for          | Learning, exploration      | Production throughput      |

### Autonomy Boundaries

**Agent decides autonomously:**

- Implementation details within approved plan
- Sub-agent dispatch and coordination
- Addressing automated review feedback
- Parallel task selection when blocked

**Agent escalates to human:**

- Architectural decisions outside plan scope
- Security-sensitive changes
- Ambiguous requirements
- Blocked with no parallel work available

### Intervention Points

Human can intervene at any time:

1. **Comment on issue** - Agent sees and responds
2. **Comment on PR** - Agent addresses feedback
3. **Take over command** - Agent hands off gracefully
4. **Direct instruction** - Agent follows human direction

### Notification Preferences

Default: **Async notifications**

- Agent posts updates to issue/PR comments
- Human reviews when convenient
- No blocking waits for human response

Configure in ways-of-working if different preference needed.
