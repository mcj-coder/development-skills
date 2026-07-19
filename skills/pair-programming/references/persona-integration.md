# Persona Integration

> Reference material for the [`pair-programming`](../SKILL.md) skill.


Pair programming uses `persona-switching` to manage identity and attribution across
different workflow phases. This ensures commits are properly attributed and the
correct account permissions are used for each operation.

### Account Usage by Persona Type

| Persona Type | Account                 | Examples                      |
| ------------ | ----------------------- | ----------------------------- |
| Development  | Developer account       | Backend Engineer, QA Engineer |
| Management   | Team/maintainer account | Tech Lead, Scrum Master       |

**Development personas** perform implementation work using a contributor-level
developer account. This includes writing code, creating tests, and addressing
review feedback.

**Management personas** perform elevated operations using a team or maintainer
account. This includes approving PRs, managing labels, and closing issues.

### Commit Attribution Format

All commits include persona attribution in the author name:

```text
Claude (<Persona Name>)
```

Examples:

- `Claude (Backend Engineer)` - Implementation commit
- `Claude (QA Engineer)` - Test commit
- `Claude (Tech Lead)` - Review-related commit

This format provides clear audit trail of which persona authored each change
while maintaining GPG signature validity (GPG validates against email, not name).

### Persona Switching Triggers

Persona switches occur automatically at workflow phase transitions:

| Workflow Phase   | Trigger                     | Persona        |
| ---------------- | --------------------------- | -------------- |
| Planning         | Issue enters refinement     | Tech Lead      |
| Implementation   | Implementation phase begins | Domain expert  |
| Review Loop      | Self-review requested       | Tech Lead / QA |
| Human Checkpoint | PR created                  | Tech Lead      |
| Merge            | PR approved                 | Tech Lead      |

**Within Implementation phase**, switches occur based on task type:

- Backend tasks: Backend Engineer
- Frontend tasks: Frontend Engineer
- Test writing: QA Engineer
- Security fixes: Security Engineer

### Integration with persona-switching Skill

This skill delegates identity management to `persona-switching`:

1. **Setup**: `persona-switching` configures security profiles and shell functions
2. **Runtime**: Use `use_persona <role>` to switch before commits
3. **Verification**: Use `show_persona` to confirm current identity

For full configuration and security details, see:
`skills/persona-switching/SKILL.md`
