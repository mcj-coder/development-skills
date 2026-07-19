# Trigger Mechanisms

> Reference material for the [`pair-programming`](../SKILL.md) skill.


This section provides detailed configuration for each trigger type. For basic
trigger flow, see Phase 1: Trigger above.

### Issue Assignment Trigger

**How it works:** Agent monitors for `@agent` mentions or direct assignment.

```bash
# Assign agent to issue
gh issue edit N --add-assignee @agent

# Mention agent in comment
gh issue comment N --body "@agent please implement this"
```

**Configuration options:**

| Option            | Description                              | Default |
| ----------------- | ---------------------------------------- | ------- |
| `watch_labels`    | Only respond to issues with these labels | `all`   |
| `watch_milestone` | Only respond to issues in this milestone | `all`   |
| `auto_assign`     | Auto-assign when agent mentioned         | `true`  |
| `require_dor`     | Require Definition of Ready before start | `true`  |

**Filter criteria:**

```bash
# Only issues with specific labels
gh issue list --assignee @agent --label "ready,priority:p1"

# Only issues in current milestone
gh issue list --assignee @agent --milestone "Sprint 5"
```

### Manual Command Trigger

**How it works:** Human invokes `/pair` command in conversation.

```bash
# Start pair programming on specific issue
/pair #123

# Start with specific options
/pair #123 --no-plan  # Skip planning phase
/pair #123 --draft    # Create draft PR only

# Process next priority item from backlog
/pair --next

# Process specific priority levels
/pair --backlog --priority p1,p2
```

**Command options:**

| Option       | Description                     | Default    |
| ------------ | ------------------------------- | ---------- |
| `--no-plan`  | Skip planning phase (use issue) | `false`    |
| `--draft`    | Create draft PR (no merge)      | `false`    |
| `--priority` | Filter by priority labels       | `p1,p2,p3` |
| `--label`    | Filter by additional labels     | none       |
| `--limit`    | Maximum issues to process       | `1`        |

### Scheduled/Batch Trigger

**How it works:** CI/cron job triggers agent to process backlog items.

**GitHub Actions example:**

```yaml
name: Pair Programming Batch
on:
  schedule:
    - cron: "0 9 * * 1-5" # 9am weekdays
  workflow_dispatch: # Manual trigger

jobs:
  process-backlog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Process P1 issues
        run: |
          gh issue list \
            --label "ready,priority:p1" \
            --assignee @agent \
            --state open \
            --json number \
            --jq '.[].number' | \
          while read issue; do
            echo "Processing issue #$issue"
            # Trigger agent processing
          done
```

**Batch configuration:**

| Option       | Description                     | Default    |
| ------------ | ------------------------------- | ---------- |
| `max_issues` | Maximum issues per batch run    | `5`        |
| `priority`   | Priority order for processing   | `p1,p2,p3` |
| `skip_wip`   | Skip issues already in progress | `true`     |
| `dry_run`    | List issues without processing  | `false`    |

### Trigger Response Protocol

When triggered, the agent follows this response protocol:

1. **Acknowledge** - Post comment confirming receipt

   ```markdown
   Acknowledged. Starting pair programming session for #123.

   **Trigger:** Issue assignment
   **Agent:** @agent
   **Started:** 2024-01-15 10:00 UTC
   ```

2. **Validate DoR** - Check Definition of Ready

   ```markdown
   **DoR Check:**

   - [x] Clear acceptance criteria
   - [x] Priority assigned
   - [x] Estimated
   - [ ] Dependencies identified ← Missing

   Requesting clarification on dependencies before proceeding.
   ```

3. **Initiate Planning** - Begin planning phase or escalate

   ```markdown
   DoR validated. Proceeding to planning phase.
   Plan will be posted in next comment.
   ```

4. **Update Status** - Add tracking label

   ```bash
   gh issue edit N --add-label "pair-programming:active"
   ```
