# Git Worktree Isolation

> Reference material for the [`pair-programming`](../SKILL.md) skill.


Sub-agents work in isolated git worktrees to enable true parallel development
without file conflicts. This section documents worktree lifecycle and integration
with the `superpowers:using-git-worktrees` skill.

### When to Use Worktrees

| Scenario                          | Use Worktree | Reason                        |
| --------------------------------- | ------------ | ----------------------------- |
| Multiple sub-agents same issue    | Yes          | Prevents file conflicts       |
| Sequential tasks same issue       | No           | Single worktree sufficient    |
| Parallel feature development      | Yes          | Isolation enables concurrency |
| Quick fix while other work paused | Yes          | Don't disturb paused work     |
| Single sub-agent task             | Optional     | Overhead may not be justified |

### Worktree Lifecycle

```text
CREATE → WORK → INTEGRATE → CLEANUP
```

#### 1. Create Worktree

When dispatching a sub-agent to an independent task:

```bash
# Create worktree for sub-agent task
git worktree add ../.worktrees/wt-backend-123 -b feat/123-backend-work main

# Sub-agent works in isolated directory
cd ../.worktrees/wt-backend-123
```

**Naming convention:** `wt-<domain>-<issue>`

- `wt-backend-123` - Backend work for issue #123
- `wt-frontend-123` - Frontend work for issue #123
- `wt-qa-123` - QA work for issue #123

#### 2. Work in Worktree

Sub-agent operates normally within worktree:

- Make changes and commits
- Run tests
- Push to feature branch

```bash
# In worktree directory
git add .
git commit -m "feat: implement backend endpoint (#123)"
git push -u origin feat/123-backend-work
```

#### 3. Integrate Back

After sub-agent completes, primary agent integrates:

```bash
# From main worktree
git fetch origin
git merge origin/feat/123-backend-work --no-ff

# Or rebase if preferred
git rebase origin/feat/123-backend-work
```

**Integration order matters:**

1. Integrate in dependency order (backend before frontend)
2. Run tests after each integration
3. Resolve conflicts as they arise

#### 4. Cleanup

After successful integration:

```bash
# Remove worktree
git worktree remove ../.worktrees/wt-backend-123

# Delete remote branch if merged
git push origin --delete feat/123-backend-work
```

### Worktree CLI Commands

```bash
# List all worktrees
git worktree list

# Add worktree from main
git worktree add <path> -b <branch> main

# Add worktree from existing branch
git worktree add <path> <existing-branch>

# Remove worktree (must be clean)
git worktree remove <path>

# Force remove (discards changes)
git worktree remove <path> --force

# Prune stale worktree references
git worktree prune
```

### Integration with using-git-worktrees Skill

This skill delegates worktree operations to `superpowers:using-git-worktrees`:

1. **Automatic creation**: Worktrees created when dispatching sub-agents
2. **Path management**: Standard `.worktrees/` directory for isolation
3. **Cleanup tracking**: Worktrees tracked for cleanup after task completion

For full worktree patterns and edge cases, see the `superpowers:using-git-worktrees`
skill documentation.
