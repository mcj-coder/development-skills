# Issue-Driven Delivery Scripts Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create reference bash scripts for issue-driven-delivery prioritization and unblocking to
save agent tokens on repetitive tasks.

**Architecture:** Two standalone bash scripts using `gh` CLI with jq for JSON parsing. Scripts
output simple lists by default for agent consumption, with optional verbose/graph modes.
Dry-run by default for safety.

**Tech Stack:** Bash, GitHub CLI (`gh`), jq, standard Unix tools

---

## Task 1: Create scripts directory structure

### Files

- Create: `skills/issue-driven-delivery/scripts/` (directory)

#### Step 1: Create the scripts directory

```bash
mkdir -p skills/issue-driven-delivery/scripts
```

#### Step 2: Verify directory created

```bash
ls -la skills/issue-driven-delivery/
```

Expected: `scripts/` directory exists alongside `references/`

#### Step 3: Commit

```bash
git add skills/issue-driven-delivery/scripts
git commit -m "chore: create scripts directory for issue-driven-delivery"
```

---

## Task 2: Create get-priority-order.sh script

### Files

- Create: `skills/issue-driven-delivery/scripts/get-priority-order.sh`

#### Step 1: Write the script

Create `skills/issue-driven-delivery/scripts/get-priority-order.sh`:

```bash
#!/usr/bin/env bash
# get-priority-order.sh - Output unblocked issues in delivery priority order
#
# Usage: ./get-priority-order.sh [--verbose]
#
# Implements 5-tier prioritization hierarchy:
#   1. Finish started work (unassigned in-progress states)
#   2. P0 critical production issues
#   3. Priority order (P0 -> P1 -> P2 -> P3 -> P4)
#   4. Blocking task priority inheritance
#   5. Tie-breaker: unblock count, then FIFO
#
# Output: Issue numbers, one per line, in priority order
# With --verbose: Issue number, title, priority, effective priority, reason

set -euo pipefail

VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--verbose]"
            echo ""
            echo "Output unblocked issues in delivery priority order."
            echo ""
            echo "Options:"
            echo "  --verbose, -v  Show detailed output with priorities and reasons"
            echo "  --help, -h     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Fetch all open, unblocked issues with relevant labels
fetch_issues() {
    gh issue list \
        --state open \
        --json number,title,labels,assignees \
        --limit 500
}

# Extract label names as comma-separated string
get_labels() {
    echo "$1" | jq -r '[.labels[].name] | join(",")'
}

# Check if issue has a specific label
has_label() {
    local labels="$1"
    local target="$2"
    echo "$labels" | grep -q "$target"
}

# Get priority level from labels (returns 5 if no priority label)
get_priority() {
    local labels="$1"
    if echo "$labels" | grep -q "priority:p0"; then echo 0
    elif echo "$labels" | grep -q "priority:p1"; then echo 1
    elif echo "$labels" | grep -q "priority:p2"; then echo 2
    elif echo "$labels" | grep -q "priority:p3"; then echo 3
    elif echo "$labels" | grep -q "priority:p4"; then echo 4
    else echo 5  # No priority = lowest
    fi
}

# Get state from labels
get_state() {
    local labels="$1"
    if echo "$labels" | grep -q "state:verification"; then echo "verification"
    elif echo "$labels" | grep -q "state:implementation"; then echo "implementation"
    elif echo "$labels" | grep -q "state:refinement"; then echo "refinement"
    elif echo "$labels" | grep -q "state:new-feature"; then echo "new-feature"
    else echo "unknown"
    fi
}

# Check if issue is in a progress state
is_in_progress() {
    local state="$1"
    [[ "$state" == "refinement" || "$state" == "implementation" || "$state" == "verification" ]]
}

# Check if issue is unassigned
is_unassigned() {
    local assignees="$1"
    [[ "$assignees" == "[]" || -z "$assignees" ]]
}

# Count issues blocked by this issue
count_blocked_by() {
    local issue_num="$1"
    gh issue list --state open --search "Blocked by #$issue_num" --json number --jq 'length' 2>/dev/null || echo 0
}

# Calculate effective priority considering blocked issues
calculate_effective_priority() {
    local issue_num="$1"
    local own_priority="$2"
    local min_priority="$own_priority"

    # Find issues blocked by this one
    local blocked_issues
    blocked_issues=$(gh issue list --state open --search "Blocked by #$issue_num" --json number,labels --jq '.[] | "\(.number):\([.labels[].name] | join(","))"' 2>/dev/null || echo "")

    while IFS= read -r blocked_info; do
        [[ -z "$blocked_info" ]] && continue
        local blocked_labels="${blocked_info#*:}"
        local blocked_priority
        blocked_priority=$(get_priority "$blocked_labels")
        if [[ "$blocked_priority" -lt "$min_priority" ]]; then
            min_priority="$blocked_priority"
        fi
    done <<< "$blocked_issues"

    echo "$min_priority"
}

main() {
    local issues
    issues=$(fetch_issues)

    # Build prioritized list
    local prioritized=()

    while IFS= read -r issue; do
        local number title labels assignees
        number=$(echo "$issue" | jq -r '.number')
        title=$(echo "$issue" | jq -r '.title')
        labels=$(echo "$issue" | jq -r '[.labels[].name] | join(",")')
        assignees=$(echo "$issue" | jq -c '.assignees')

        # Skip blocked issues
        if has_label "$labels" "blocked"; then
            continue
        fi

        local state priority effective_priority reason unassigned
        state=$(get_state "$labels")
        priority=$(get_priority "$labels")
        unassigned=$(is_unassigned "$assignees" && echo "true" || echo "false")

        # Tier 1: Finish started work (unassigned in-progress)
        if is_in_progress "$state" && [[ "$unassigned" == "true" ]]; then
            # P0 still goes first even among in-progress
            if [[ "$priority" -eq 0 ]]; then
                effective_priority=0
                reason="P0 in-progress (highest)"
            else
                effective_priority=0  # Treat as P0 equivalent for sorting
                reason="finish-started-work"
            fi
        # Tier 2 & 3: Priority order
        else
            effective_priority=$(calculate_effective_priority "$number" "$priority")
            if [[ "$effective_priority" -lt "$priority" ]]; then
                reason="inherited-P${effective_priority}"
            else
                reason="P${priority}"
            fi
        fi

        # Tier 5: Count blocked issues for tie-breaking
        local blocked_count
        blocked_count=$(count_blocked_by "$number")

        # Store: effective_priority|blocked_count|number|title|priority|reason
        prioritized+=("${effective_priority}|${blocked_count}|${number}|${title}|${priority}|${reason}")

    done < <(echo "$issues" | jq -c '.[]')

    # Sort: by effective_priority ASC, blocked_count DESC, number ASC (FIFO)
    local sorted
    sorted=$(printf '%s\n' "${prioritized[@]}" | sort -t'|' -k1,1n -k2,2nr -k3,3n)

    # Output
    while IFS='|' read -r eff_pri blocked_cnt num title pri reason; do
        if [[ "$VERBOSE" == "true" ]]; then
            echo "#${num} | P${pri} -> P${eff_pri} | blocks:${blocked_cnt} | ${reason} | ${title:0:50}"
        else
            echo "#${num}"
        fi
    done <<< "$sorted"
}

main
```

#### Step 2: Make script executable

```bash
chmod +x skills/issue-driven-delivery/scripts/get-priority-order.sh
```

#### Step 3: Test script runs without error

```bash
./skills/issue-driven-delivery/scripts/get-priority-order.sh --help
```

Expected: Help message displayed

#### Step 4: Test with actual issues

```bash
./skills/issue-driven-delivery/scripts/get-priority-order.sh --verbose
```

Expected: List of issues with priority info (may be empty if no unblocked issues)

#### Step 5: Commit

```bash
git add skills/issue-driven-delivery/scripts/get-priority-order.sh
git commit -m "feat(issue-driven-delivery): add get-priority-order.sh script

Implements 5-tier prioritization hierarchy:
1. Finish started work (unassigned in-progress states)
2. P0 critical production issues
3. Priority order (P0 -> P4)
4. Blocking task priority inheritance
5. Tie-breaker: unblock count, then FIFO

Refs #88"
```

---

## Task 3: Create unblock-dependents.sh script

### Files

- Create: `skills/issue-driven-delivery/scripts/unblock-dependents.sh`

#### Step 1: Write the script

Create `skills/issue-driven-delivery/scripts/unblock-dependents.sh`:

```bash
#!/usr/bin/env bash
# unblock-dependents.sh - Process dependents when a blocker closes
#
# Usage: ./unblock-dependents.sh [ISSUE_NUMBER] [--apply] [--graph]
#
# Arguments:
#   ISSUE_NUMBER  Issue that was closed (auto-detects recently closed if omitted)
#
# Options:
#   --apply       Actually make changes (dry-run by default)
#   --graph       Show dependency graph (ASCII to terminal, Mermaid when piped)
#
# Behavior:
#   - Finds issues blocked by the specified/detected closed issue(s)
#   - Removes blocker from blocked-by list
#   - Removes 'blocked' label if no blockers remain
#   - Detects circular dependencies and suggests resolution

set -euo pipefail

ISSUE_NUMBER=""
DRY_RUN=true
SHOW_GRAPH=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --apply)
            DRY_RUN=false
            shift
            ;;
        --graph)
            SHOW_GRAPH=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [ISSUE_NUMBER] [--apply] [--graph]"
            echo ""
            echo "Process dependents when a blocker closes."
            echo ""
            echo "Arguments:"
            echo "  ISSUE_NUMBER  Issue that was closed (auto-detects if omitted)"
            echo ""
            echo "Options:"
            echo "  --apply   Actually make changes (dry-run by default)"
            echo "  --graph   Show dependency graph"
            echo "  --help    Show this help message"
            exit 0
            ;;
        [0-9]*)
            ISSUE_NUMBER="$1"
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# ANSI colors (disabled if not terminal)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_action() { echo -e "${GREEN}[ACTION]${NC} $1"; }
log_dry() { echo -e "${YELLOW}[DRY-RUN]${NC} $1"; }

# Auto-detect recently closed issues (within last hour)
detect_closed_issues() {
    gh issue list \
        --state closed \
        --json number,closedAt \
        --jq '[.[] | select(.closedAt > (now - 3600 | todate))] | .[].number' \
        2>/dev/null || echo ""
}

# Find issues blocked by a specific issue
find_blocked_by() {
    local blocker="$1"
    gh issue list \
        --state open \
        --search "Blocked by #$blocker" \
        --json number,title,body \
        --jq '.[] | "\(.number)|\(.title)"' \
        2>/dev/null || echo ""
}

# Get blocking comment from issue
get_blocking_comment() {
    local issue="$1"
    gh issue view "$issue" --json body,comments \
        --jq '([.body] + [.comments[].body]) | .[] | select(. != null) | select(test("(?i)blocked by"))' \
        2>/dev/null | head -1 || echo ""
}

# Parse blockers from comment (e.g., "Blocked by #100, #101, #102")
parse_blockers() {
    local comment="$1"
    echo "$comment" | grep -oE '#[0-9]+' | tr -d '#' | sort -u
}

# Check if block is manual (external) vs dependency
is_manual_block() {
    local comment="$1"
    echo "$comment" | grep -qiE 'waiting for|external|approval|client|vendor'
}

# Remove a blocker from the blocked-by list
remove_blocker() {
    local issue="$1"
    local blocker="$2"
    local current_blockers="$3"

    # Remove the blocker from list
    local remaining
    remaining=$(echo "$current_blockers" | grep -v "^${blocker}$" || echo "")

    if [[ -z "$remaining" ]]; then
        # No blockers remain - fully unblock
        if [[ "$DRY_RUN" == "true" ]]; then
            log_dry "Would remove 'blocked' label from #$issue"
            log_dry "Would add comment: 'Auto-unblocked: #$blocker completed'"
        else
            gh issue edit "$issue" --remove-label "blocked"
            gh issue comment "$issue" --body "Auto-unblocked: #$blocker completed [$(date -Iseconds)]"
            log_action "Unblocked #$issue (was blocked by #$blocker)"
        fi
    else
        # Some blockers remain - update comment
        local remaining_list
        remaining_list=$(echo "$remaining" | sed 's/^/#/' | paste -sd, -)
        if [[ "$DRY_RUN" == "true" ]]; then
            log_dry "Would update #$issue: still blocked by $remaining_list"
        else
            gh issue comment "$issue" --body "Blocker #$blocker resolved. Still blocked by: $remaining_list"
            log_action "Updated #$issue: removed #$blocker from blockers, still blocked by $remaining_list"
        fi
    fi
}

# Detect circular dependencies
detect_circular_deps() {
    local start="$1"
    local visited=()
    local path=()

    detect_cycle() {
        local current="$1"
        local -n vis=$2
        local -n pth=$3

        # Check if already in current path (cycle!)
        for p in "${pth[@]}"; do
            if [[ "$p" == "$current" ]]; then
                echo "${pth[*]} $current"
                return 0
            fi
        done

        # Check if already fully visited
        for v in "${vis[@]}"; do
            [[ "$v" == "$current" ]] && return 1
        done

        pth+=("$current")

        # Find what this issue blocks
        local blocked_by_current
        blocked_by_current=$(find_blocked_by "$current")

        while IFS='|' read -r num title; do
            [[ -z "$num" ]] && continue
            if detect_cycle "$num" vis pth; then
                return 0
            fi
        done <<< "$blocked_by_current"

        # Remove from path, add to visited
        unset 'pth[-1]'
        vis+=("$current")
        return 1
    }

    if detect_cycle "$start" visited path; then
        return 0
    fi
    return 1
}

# Suggest circular dependency resolution
suggest_resolution() {
    local cycle="$1"
    log_warn "Circular dependency detected: $cycle"
    echo ""
    echo "Resolution suggestion based on rework-cost heuristics:"
    echo ""

    local issues=($cycle)
    for issue in "${issues[@]}"; do
        [[ -z "$issue" ]] && continue
        local comment
        comment=$(get_blocking_comment "$issue")

        # Estimate rework cost based on blocking reason
        local cost="MEDIUM"
        if echo "$comment" | grep -qiE 'interface|mock|stub|config'; then
            cost="LOW"
        elif echo "$comment" | grep -qiE 'schema|migration|architecture|breaking'; then
            cost="HIGH"
        fi

        echo "  #$issue: $cost rework cost"
        if is_manual_block "$comment"; then
            echo "    WARNING: Manual blocker detected - cannot auto-resolve"
        fi
    done

    echo ""
    echo "Recommendation: Unblock the issue with LOWEST rework cost first."
    echo "Create a follow-up task for rework after the cycle completes."
}

# Generate dependency graph
generate_graph() {
    local root="$1"
    local blocked
    blocked=$(find_blocked_by "$root")

    if [[ -t 1 ]]; then
        # ASCII graph for terminal
        echo ""
        echo "Dependency Graph (issues blocked by #$root):"
        echo "============================================="
        echo ""
        echo "  #$root (closed)"

        while IFS='|' read -r num title; do
            [[ -z "$num" ]] && continue
            local comment
            comment=$(get_blocking_comment "$num")
            local all_blockers
            all_blockers=$(parse_blockers "$comment")
            local blocker_count
            blocker_count=$(echo "$all_blockers" | grep -c . || echo 0)

            if [[ "$blocker_count" -le 1 ]]; then
                echo "    └── #$num (will unblock) - ${title:0:40}"
            else
                local others
                others=$(echo "$all_blockers" | grep -v "^${root}$" | sed 's/^/#/' | paste -sd, -)
                echo "    ├── #$num (still blocked by $others) - ${title:0:40}"
            fi
        done <<< "$blocked"
    else
        # Mermaid graph for piped output
        echo "graph TD"
        echo "    ${root}[\"#$root (closed)\"]"

        while IFS='|' read -r num title; do
            [[ -z "$num" ]] && continue
            echo "    ${root} --> ${num}[\"#$num\"]"
        done <<< "$blocked"
    fi
}

main() {
    local issues_to_process=()

    if [[ -n "$ISSUE_NUMBER" ]]; then
        issues_to_process+=("$ISSUE_NUMBER")
    else
        log_info "Auto-detecting recently closed issues..."
        while IFS= read -r num; do
            [[ -n "$num" ]] && issues_to_process+=("$num")
        done < <(detect_closed_issues)

        if [[ ${#issues_to_process[@]} -eq 0 ]]; then
            log_info "No recently closed issues found."
            exit 0
        fi
        log_info "Found ${#issues_to_process[@]} recently closed issue(s): ${issues_to_process[*]}"
    fi

    for issue in "${issues_to_process[@]}"; do
        log_info "Processing dependents of #$issue..."

        # Show graph if requested
        if [[ "$SHOW_GRAPH" == "true" ]]; then
            generate_graph "$issue"
            echo ""
        fi

        # Check for circular dependencies
        if detect_circular_deps "$issue" 2>/dev/null; then
            suggest_resolution "$(detect_circular_deps "$issue" 2>&1)"
            continue
        fi

        # Find and process blocked issues
        local blocked
        blocked=$(find_blocked_by "$issue")

        if [[ -z "$blocked" ]]; then
            log_info "No issues blocked by #$issue"
            continue
        fi

        while IFS='|' read -r num title; do
            [[ -z "$num" ]] && continue

            log_info "Found #$num blocked by #$issue: $title"

            # Get current blockers
            local comment
            comment=$(get_blocking_comment "$num")
            local blockers
            blockers=$(parse_blockers "$comment")

            # Check for manual block
            if is_manual_block "$comment"; then
                log_warn "#$num has manual blocker - skipping auto-unblock"
                continue
            fi

            # Remove this blocker
            remove_blocker "$num" "$issue" "$blockers"

        done <<< "$blocked"
    done

    if [[ "$DRY_RUN" == "true" ]]; then
        echo ""
        log_info "Dry-run complete. Use --apply to make changes."
    fi
}

main
```

#### Step 2: Make script executable

```bash
chmod +x skills/issue-driven-delivery/scripts/unblock-dependents.sh
```

#### Step 3: Test script runs without error

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh --help
```

Expected: Help message displayed

#### Step 4: Test dry-run mode

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh
```

Expected: Auto-detects (or reports no) recently closed issues, shows dry-run output

#### Step 5: Test graph output (ASCII)

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh 88 --graph
```

Expected: ASCII dependency graph in terminal

#### Step 6: Test graph output (Mermaid when piped)

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh 88 --graph | cat
```

Expected: Mermaid diagram syntax

#### Step 7: Commit

```bash
git add skills/issue-driven-delivery/scripts/unblock-dependents.sh
git commit -m "feat(issue-driven-delivery): add unblock-dependents.sh script

Features:
- Issue number argument or auto-detect recently closed
- Dry-run by default, --apply to execute
- --graph shows ASCII (terminal) or Mermaid (piped)
- Circular dependency detection with resolution suggestions
- Manual vs dependency block detection

Refs #88"
```

---

## Task 4: Create README for scripts directory

### Files

- Create: `skills/issue-driven-delivery/scripts/README.md`

#### Step 1: Write the README

Create `skills/issue-driven-delivery/scripts/README.md`:

````markdown
# Issue-Driven Delivery Scripts

Reference scripts implementing prioritization and unblocking logic from the issue-driven-delivery skill.

## Scripts

### get-priority-order.sh

Outputs unblocked issues in delivery priority order.

```bash
./get-priority-order.sh [--verbose]
```

**Implements 5-tier prioritization hierarchy:**

1. **Finish started work** - Unassigned issues in progress states (refinement, implementation, verification)
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

Options:

- `ISSUE_NUMBER` - Specific issue (auto-detects recently closed if omitted)
- `--apply` - Actually make changes (dry-run by default)
- `--graph` - Show dependency graph (ASCII terminal, Mermaid when piped)

Features:

- Finds issues with "Blocked by #N" in comments
- Removes resolved blocker from blocked-by list
- Removes `blocked` label when all blockers resolved
- Detects circular dependencies with resolution suggestions
- Distinguishes manual vs dependency blocks

## Customization

These scripts are **templates** for the default GitHub setup. When applying to a specific repository:

1. Copy scripts to `scripts/issue-driven-delivery/` in the target repo
2. Modify label names if different (e.g., `priority:p0` → `P0`)
3. Adjust state labels if using different names
4. Update any org-specific patterns

Default labels expected:

- Priority: `priority:p0`, `priority:p1`, `priority:p2`, `priority:p3`, `priority:p4`
- State: `state:new-feature`, `state:refinement`, `state:implementation`, `state:verification`
- Blocking: `blocked`

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- `jq` for JSON parsing
- Bash 4.0+

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
#   #42 (closed)
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
````

#### Step 2: Commit

```bash
git add skills/issue-driven-delivery/scripts/README.md
git commit -m "docs(issue-driven-delivery): add README for scripts directory

Documents:
- get-priority-order.sh usage and 5-tier hierarchy
- unblock-dependents.sh usage and features
- Customization guidance for other repos
- Examples for agent and human usage

Refs #88"
```

---

## Task 5: Test scripts end-to-end

### Files

- Test: `skills/issue-driven-delivery/scripts/get-priority-order.sh`
- Test: `skills/issue-driven-delivery/scripts/unblock-dependents.sh`

#### Step 1: Run get-priority-order.sh

```bash
./skills/issue-driven-delivery/scripts/get-priority-order.sh
```

Expected: List of issue numbers (may be empty or show current repo issues)

#### Step 2: Run get-priority-order.sh --verbose

```bash
./skills/issue-driven-delivery/scripts/get-priority-order.sh --verbose
```

Expected: Detailed table with priorities

#### Step 3: Run unblock-dependents.sh (dry-run)

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh
```

Expected: Auto-detect or report no recently closed issues

#### Step 4: Run unblock-dependents.sh with graph

```bash
./skills/issue-driven-delivery/scripts/unblock-dependents.sh 88 --graph 2>/dev/null || echo "No dependents found (expected for new issue)"
```

Expected: Graph output or "no dependents" message

#### Step 5: Verify scripts are executable

```bash
ls -la skills/issue-driven-delivery/scripts/*.sh
```

Expected: Both scripts have executable permission (-rwxr-xr-x)

#### Step 6: Final commit if any fixes needed

If tests reveal issues, fix and commit:

```bash
git add -A
git commit -m "fix(issue-driven-delivery): address test findings in scripts"
```

---

## Task 6: Push branch and post plan for approval

### Step 1: Push feature branch

```bash
git push -u origin feat/issue-88-prioritization-scripts
```

#### Step 2: Get commit SHA for plan link

```bash
COMMIT_SHA=$(git rev-parse HEAD)
echo "Plan commit: $COMMIT_SHA"
```

#### Step 3: Post plan link to issue

```bash
gh issue comment 88 --body "Plan: https://github.com/mcj-coder/development-skills/blob/$COMMIT_SHA/docs/plans/2026-01-06-issue-driven-delivery-scripts.md

**Summary:**
- Task 1: Create scripts directory
- Task 2: get-priority-order.sh (5-tier prioritization)
- Task 3: unblock-dependents.sh (dry-run, --apply, --graph)
- Task 4: README with customization guidance
- Task 5: End-to-end testing
- Task 6: This comment

Ready for review and approval."
```

---

## Acceptance Criteria Mapping

| Acceptance Criterion | Task |
| --- | --- |
| `get-priority-order.sh` outputs issue numbers one per line | Task 2 |
| Implements 5-tier prioritization hierarchy | Task 2 |
| `unblock-dependents.sh` accepts issue number or auto-detects | Task 3 |
| Dry-run by default, requires `--apply` | Task 3 |
| `--graph` outputs ASCII/Mermaid | Task 3 |
| Circular dependency detection with suggestions | Task 3 |
| Uses default GitHub labels | Task 2, 3 |
| README explains customization | Task 4 |
