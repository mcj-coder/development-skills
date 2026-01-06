# Issue-Driven Delivery Scripts

Reference scripts implementing prioritization and unblocking logic from the issue-driven-delivery
skill.

## Scripts

### get-priority-order.sh

Outputs unblocked issues in delivery priority order.

```bash
./get-priority-order.sh [--verbose]
```

**Implements 5-tier prioritization hierarchy:**

1. **Finish started work** - Unassigned issues in progress states (refinement, implementation,
   verification)
2. **P0 critical issues** - Production outages, security, data loss
3. **Priority order** - P0 → P1 → P2 → P3 → P4
4. **Priority inheritance** - Blocking tasks inherit priority from blocked tasks
5. **Tie-breaker** - Most items unblocked, then FIFO (lower issue number)

**Output:** Issue numbers, one per line (for agent parsing)

**Verbose:** `#42 | P2 -> P0 | blocks:3 | inherited-P0 | Feature title...`

### unblock-dependents.sh

Processes dependents when a blocker closes.

```bash
./unblock-dependents.sh [ISSUE_NUMBER] [--apply] [--graph]
```

**Options:**

- `ISSUE_NUMBER` - Specific issue (auto-detects recently closed if omitted)
- `--apply` - Actually make changes (dry-run by default)
- `--graph` - Show dependency graph (ASCII terminal, Mermaid when piped)

**Features:**

- Finds issues with "Blocked by #N" in comments
- Removes resolved blocker from blocked-by list
- Removes `blocked` label when all blockers resolved
- Detects circular dependencies with resolution suggestions
- Distinguishes manual vs dependency blocks

## Customization

These scripts are **templates** for the default GitHub setup. When applying to a specific
repository:

1. Copy scripts to `scripts/issue-driven-delivery/` in the target repo
2. Modify label names if different (e.g., `priority:p0` → `P0`)
3. Adjust state labels if using different names
4. Update any org-specific patterns

**Default labels expected:**

- Priority: `priority:p0`, `priority:p1`, `priority:p2`, `priority:p3`, `priority:p4`
- State: `state:new-feature`, `state:refinement`, `state:implementation`, `state:verification`
- Blocking: `blocked`

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Bash 4.0+
- No external dependencies (uses `gh`'s built-in `--jq` for JSON parsing)

## Examples

**Get next issue to work on:**

```bash
./get-priority-order.sh | head -1
# Output: #42
```

**See full priority list with reasoning:**

```bash
./get-priority-order.sh --verbose
# Output:
# #42 | P2 -> P0 | blocks:3 | inherited-P0 | Critical path item
# #17 | P1 -> P1 | blocks:0 | P1 | High priority feature
# #88 | P2 -> P2 | blocks:0 | P2 | Medium priority
```

**Check what would be unblocked (dry-run):**

```bash
./unblock-dependents.sh 42
# [DRY-RUN] Would remove 'blocked' label from #17
# [DRY-RUN] Would add comment: 'Auto-unblocked: #42 completed'
```

**Actually unblock dependents:**

```bash
./unblock-dependents.sh 42 --apply
# [ACTION] Unblocked #17 (was blocked by #42)
```

**View dependency graph:**

```bash
./unblock-dependents.sh 42 --graph
#   #42 (closed/processing)
#     └── #17 (will unblock) - Feature depending on #42
#     ├── #23 (still blocked by #50) - Multi-blocked item
```

**Generate Mermaid for documentation:**

```bash
./unblock-dependents.sh 42 --graph | cat
# graph TD
#     42["#42 (closed)"]
#     42 --> 17["#17"]
#     42 --> 23["#23"]
```

## Integration with issue-driven-delivery skill

These scripts automate the prioritization and unblocking logic described in:

- `references/prioritization-rules.md` - 5-tier hierarchy, priority inheritance, tie-breakers
- `SKILL.md` step 20 - Auto-unblock when blockers complete

**Typical agent workflow:**

```bash
# 1. Find highest priority issue to work on
NEXT_ISSUE=$(./get-priority-order.sh | head -1)

# 2. After closing an issue, unblock dependents
./unblock-dependents.sh $CLOSED_ISSUE --apply
```
