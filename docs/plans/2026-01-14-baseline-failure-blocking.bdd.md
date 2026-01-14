# BDD Checklist: Baseline Failure Blocking Rule

## RED: Failing Checklist (Before Implementation)

- [ ] AGENTS.md documents that baseline failures must be addressed immediately
- [ ] AGENTS.md documents that work is blocked until baseline passes
- [ ] CLAUDE.md mirrors the same baseline failure rule
- [ ] Guidance requires creating a blocking issue if none exists

**Failure Evidence:**

- `rg -n "baseline.*failure|block.*baseline" AGENTS.md CLAUDE.md` returns no matches.

## GREEN: Passing Checklist (After Implementation)

- [ ] AGENTS.md documents that baseline failures must be addressed immediately
- [ ] AGENTS.md documents that work is blocked until baseline passes
- [ ] CLAUDE.md mirrors the same baseline failure rule
- [ ] Guidance requires creating a blocking issue if none exists
