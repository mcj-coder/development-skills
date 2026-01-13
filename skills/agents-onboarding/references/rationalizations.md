# Rationalizations and Reality Checks

Common excuses for skipping agent onboarding and why they fail.

## Rationalizations Table

| Excuse                               | Reality                                                                               |
| ------------------------------------ | ------------------------------------------------------------------------------------- |
| "Agent can learn from code"          | Fresh agents have no conversation history. They need explicit onboarding.             |
| "Can document later"                 | Later never comes. Standards get missed. Document now for consistency.                |
| "Just need agent working"            | Incomplete onboarding causes inconsistent agent behavior. Worth 30 minutes setup.     |
| "Standards can evolve"               | Evolution requires baseline. Document current state, then evolve.                     |
| "Don't need documentation yet"       | First agent interaction is when you need it. Proactive beats reactive.                |
| "Other things are working"           | Undocumented standards rely on conversation memory. Breaks with fresh context.        |
| "This is different because..."       | All repositories benefit from agent onboarding. No exceptions.                        |
| "Only one person uses agents"        | That person will have fresh context eventually. Onboarding still needed.              |
| "We're still figuring out standards" | Document what exists now. Update as standards solidify. Baseline enables improvement. |
| "Too much overhead"                  | 30-minute setup prevents hours of fixing inconsistent agent work.                     |

## Red Flags

When you hear these, apply the skill immediately:

- "Agent can figure it out"
- "We'll document standards later"
- "Just need basic agent help"
- "Standards aren't finalized yet"
- "Only one person uses agents here"
- "Don't want to over-document"
- "This repo is simple"
- "Agents have been helping for months" (without AGENTS.md)

## The Fresh Context Test

The fundamental question: **Can an agent with zero conversation history and only
AGENTS.md successfully contribute to this repository?**

If the answer is no, the onboarding is incomplete.

### What Fresh Context Means

- No prior messages in conversation
- No memory of previous work sessions
- No knowledge of team preferences
- No understanding of implicit rules
- Only what is written in AGENTS.md

### Why It Matters

1. **Agent sessions expire** - conversation history is lost
2. **Different agents used** - team members use different agent instances
3. **Handoffs happen** - work passes between agents
4. **Scaling requires consistency** - more agents mean more fresh contexts

## Recovery Path

When standards have been missed due to skipped onboarding:

1. **Stop current work** - do not compound the problem
2. **Analyze repository** - discover existing (implicit) standards
3. **Create AGENTS.md** - document discovered standards
4. **Test fresh context** - verify agent can now succeed
5. **Resume work** - with proper onboarding in place
