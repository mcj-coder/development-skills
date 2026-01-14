# BDD Checklist: Worktrees Preference Documentation

## RED: Failing Checklist (Before Implementation)

- [ ] `CLAUDE.md` mentions `.worktrees/` as the preferred worktree directory
- [ ] `AGENTS.md` mentions `.worktrees/` as the preferred worktree directory
- [ ] Guidance is consistent across both files

**Failure Evidence:**

- `rg -n "\\.worktrees/" CLAUDE.md AGENTS.md` returns no matches.

## GREEN: Passing Checklist (After Implementation)

- [x] `CLAUDE.md` mentions `.worktrees/` as the preferred worktree directory
- [x] `AGENTS.md` mentions `.worktrees/` as the preferred worktree directory
- [x] Guidance is consistent across both files

**Evidence:**

- Implementation: <https://github.com/mcj-coder/development-skills/commit/3e0303a>
- Verification: `rg -n "\\.worktrees/" CLAUDE.md AGENTS.md`
