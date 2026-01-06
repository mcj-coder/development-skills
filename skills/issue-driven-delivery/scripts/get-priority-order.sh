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
#
# Requirements: GitHub CLI (gh) installed and authenticated

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

# Check if issue has a specific label
has_label() {
    local labels="$1"
    local target="$2"
    echo "$labels" | grep -q "$target" 2>/dev/null
}

# Get priority level from labels (returns 5 if no priority label)
get_priority() {
    local labels="$1"
    if echo "$labels" | grep -q "priority:p0" 2>/dev/null; then echo 0
    elif echo "$labels" | grep -q "priority:p1" 2>/dev/null; then echo 1
    elif echo "$labels" | grep -q "priority:p2" 2>/dev/null; then echo 2
    elif echo "$labels" | grep -q "priority:p3" 2>/dev/null; then echo 3
    elif echo "$labels" | grep -q "priority:p4" 2>/dev/null; then echo 4
    else echo 5  # No priority = lowest
    fi
}

# Get state from labels
get_state() {
    local labels="$1"
    if echo "$labels" | grep -q "state:verification" 2>/dev/null; then echo "verification"
    elif echo "$labels" | grep -q "state:implementation" 2>/dev/null; then echo "implementation"
    elif echo "$labels" | grep -q "state:refinement" 2>/dev/null; then echo "refinement"
    elif echo "$labels" | grep -q "state:new-feature" 2>/dev/null; then echo "new-feature"
    else echo "unknown"
    fi
}

# Check if issue is in a progress state
is_in_progress() {
    local state="$1"
    [[ "$state" == "refinement" || "$state" == "implementation" || "$state" == "verification" ]]
}

# Count issues blocked by this issue
count_blocked_by() {
    local issue_num="$1"
    local count
    count=$(gh issue list --state open --search "Blocked by #$issue_num" \
        --json number --jq 'length' 2>/dev/null || echo 0)
    echo "${count:-0}"
}

# Calculate effective priority considering blocked issues (priority inheritance)
calculate_effective_priority() {
    local issue_num="$1"
    local own_priority="$2"
    local min_priority="$own_priority"

    # Find issues blocked by this one and check their priorities
    local blocked_data
    blocked_data=$(gh issue list --state open --search "Blocked by #$issue_num" \
        --json labels --jq '.[].labels[].name' 2>/dev/null || echo "")

    # Check for higher priority in blocked issues
    if echo "$blocked_data" | grep -q "priority:p0" 2>/dev/null; then
        min_priority=0
    elif [[ "$min_priority" -gt 1 ]] && echo "$blocked_data" | grep -q "priority:p1" 2>/dev/null; then
        min_priority=1
    elif [[ "$min_priority" -gt 2 ]] && echo "$blocked_data" | grep -q "priority:p2" 2>/dev/null; then
        min_priority=2
    elif [[ "$min_priority" -gt 3 ]] && echo "$blocked_data" | grep -q "priority:p3" 2>/dev/null; then
        min_priority=3
    elif [[ "$min_priority" -gt 4 ]] && echo "$blocked_data" | grep -q "priority:p4" 2>/dev/null; then
        min_priority=4
    fi

    echo "$min_priority"
}

main() {
    # Fetch all open issues in a single query using gh's built-in jq
    # Format: number<TAB>title<TAB>labels<TAB>assignee_count
    # Using tab as delimiter to avoid issues with pipe characters in titles
    local issues
    issues=$(gh issue list --state open --limit 500 \
        --json number,title,labels,assignees \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " "))\t\([.labels[].name] | join(","))\t\(.assignees | length)"')

    # Build prioritized list
    local prioritized=()

    while IFS=$'\t' read -r number title labels assignee_count; do
        [[ -z "$number" ]] && continue

        # Skip blocked issues
        if has_label "$labels" "blocked"; then
            continue
        fi

        local state priority effective_priority reason
        state=$(get_state "$labels")
        priority=$(get_priority "$labels")

        # Check if unassigned
        local is_unassigned_flag="false"
        if [[ "$assignee_count" -eq 0 ]]; then
            is_unassigned_flag="true"
        fi

        # Tier 1: Finish started work (unassigned in-progress)
        if is_in_progress "$state" && [[ "$is_unassigned_flag" == "true" ]]; then
            # P0 still goes first even among in-progress
            if [[ "$priority" -eq 0 ]]; then
                effective_priority=0
                reason="P0-in-progress"
            else
                effective_priority=0  # Treat as P0 equivalent for sorting
                reason="finish-started-work"
            fi
        # Tier 2 & 3: Priority order with inheritance
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

    done <<< "$issues"

    # Check if we have any issues
    if [[ ${#prioritized[@]} -eq 0 ]]; then
        if [[ "$VERBOSE" == "true" ]]; then
            echo "No unblocked issues found."
        fi
        exit 0
    fi

    # Sort: by effective_priority ASC, blocked_count DESC, number ASC (FIFO)
    local sorted
    sorted=$(printf '%s\n' "${prioritized[@]}" | sort -t'|' -k1,1n -k2,2nr -k3,3n)

    # Output
    while IFS='|' read -r eff_pri blocked_cnt num title pri reason; do
        [[ -z "$num" ]] && continue
        if [[ "$VERBOSE" == "true" ]]; then
            # Truncate title for display
            local short_title="${title:0:45}"
            echo "#${num} | P${pri} -> P${eff_pri} | blocks:${blocked_cnt} | ${reason} | ${short_title}"
        else
            echo "#${num}"
        fi
    done <<< "$sorted"
}

main
