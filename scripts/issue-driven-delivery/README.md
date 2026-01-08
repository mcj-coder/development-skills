# Issue-Driven Delivery Scripts

Scripts implementing the issue-driven-delivery workflow automation for this repository.

## Scripts

### unblock-dependents.sh

Processes dependents when a blocker closes.

```bash
./scripts/issue-driven-delivery/unblock-dependents.sh [ISSUE_NUMBER] [--apply] [--graph]
```

**Options:**

- `ISSUE_NUMBER` - Specific issue (auto-detects recently closed if omitted)
- `--apply` - Actually make changes (dry-run by default)
- `--graph` - Show dependency graph

**Triggered by:** `.github/workflows/auto-unblock.yml` on issue close

### get-priority-order.sh

Outputs unblocked issues in delivery priority order.

```bash
./scripts/issue-driven-delivery/get-priority-order.sh [--verbose]
```

## Origin

These scripts are installed from the skill templates at
`skills/issue-driven-delivery/scripts/`. See that location for full documentation
and customization guidance.

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Bash 4.0+
