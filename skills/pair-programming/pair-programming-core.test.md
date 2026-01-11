# Pair Programming - Core Structure Tests

## RED: Failure scenarios (expected without feature)

### Scenario A: No guidance for autonomous agent workflow

**Context:** Agent needs to work autonomously on issues with human supervision.

**Baseline failure to record:**

- No skill defining autonomous workflow phases
- No integration points with existing skills documented
- No supervisor vs collaborator model defined

**Observed baseline (RED):**

- Agent lacks structured approach for autonomous work
- Human intervention points unclear
- Integration with issue-driven-delivery ad-hoc

### Scenario B: Skill integration points undefined

**Context:** Agent needs to coordinate with persona-switching, worktrees, and sub-agents.

**Baseline failure to record:**

- No documentation of how skills integrate
- No clear handoff points between skills
- Dependencies between skills unclear

**Observed baseline (RED):**

- Agent uses skills inconsistently
- Missing integration causes workflow gaps
- No coherent end-to-end process

## GREEN: Expected behaviour with feature

### Core Skill Structure

- [ ] Skill file exists at `skills/pair-programming/SKILL.md`
- [ ] Valid YAML frontmatter with name, description, model
- [ ] Overview section explaining pair programming model
- [ ] When to Use section with clear triggers

### Workflow Phases

- [ ] Trigger phase documented (how work starts)
- [ ] Planning phase documented (architecture decisions)
- [ ] Implementation phase documented (sub-agent dispatch)
- [ ] Review Loop phase documented (automated reviews)
- [ ] Human Checkpoint phase documented (PR review)
- [ ] Merge phase documented (completion)

### Integration Points

- [ ] `issue-driven-delivery` integration documented
- [ ] `persona-switching` integration documented
- [ ] `superpowers:using-git-worktrees` integration documented
- [ ] `superpowers:dispatching-parallel-agents` integration documented

### Human Supervisor Model

- [ ] Supervisor vs collaborator distinction explained
- [ ] High autonomy between checkpoints documented
- [ ] Human intervention points clearly marked
- [ ] Async notification preference documented

### ADR-0001 Compliance

- [ ] Detection and Deference section included
- [ ] Checks for existing pair programming setup
- [ ] Respects existing workflow conventions

## Verification Checklist

### Structure

- [ ] Skill directory exists at `skills/pair-programming/`
- [ ] SKILL.md has valid frontmatter
- [ ] All required sections present

### Content

- [ ] Workflow phases are complete
- [ ] Integration points reference correct skills
- [ ] Human supervisor model is clear

### Linting

- [ ] Prettier formatting passes
- [ ] Markdownlint passes
- [ ] cspell passes
