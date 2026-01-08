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
#
# Requirements: GitHub CLI (gh) installed and authenticated

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
            # Validate it's purely numeric
            if [[ ! "$1" =~ ^[0-9]+$ ]]; then
                echo "[ERROR] Invalid issue number: $1 (must be numeric)" >&2
                exit 1
            fi
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
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Auto-detect recently closed issues (within last hour)
detect_closed_issues() {
    gh issue list --state closed --limit 20 \
        --json number,closedAt \
        --jq '[.[] | select(.closedAt > (now - 3600 | todate))] | .[].number' \
        2>/dev/null || echo ""
}

# Find issues blocked by a specific issue (excludes the blocker itself)
# Uses tab delimiter to avoid issues with pipe characters in titles
# Verifies each result actually contains "Blocked by.*#N" pattern to avoid false positives
find_blocked_by() {
    local blocker="$1"
    local candidates
    local verified=""

    # First pass: find candidates via GitHub search
    candidates=$(gh issue list --state open --search "Blocked by #$blocker" \
        --json number,title \
        --jq ".[] | select(.number != $blocker) | \"\(.number)\t\(.title | gsub(\"\t\"; \" \"))\"" \
        2>/dev/null || echo "")

    # Second pass: verify each candidate:
    # 1. Has the "blocked" label (is actually blocked)
    # 2. Has "Blocked by: #N" or "Blocked by #N, #M, ..." in body/comments
    while IFS=$'\t' read -r num title; do
        [[ -z "$num" ]] && continue

        # Check if issue has 'blocked' label
        local has_blocked_label
        has_blocked_label=$(gh issue view "$num" --json labels \
            --jq '.labels | any(.name == "blocked")' \
            2>/dev/null || echo "false")

        if [[ "$has_blocked_label" != "true" ]]; then
            continue
        fi

        # Check if issue body/comments contain "Blocked by: #N" or "Blocked by #N, #M, ..."
        # Pattern matches: "Blocked by: #142" or "Blocked by #100, #142, #200"
        local has_blocker
        has_blocker=$(gh issue view "$num" --json body,comments \
            --jq "([.body // \"\"] + [.comments[].body]) | any(. != null and test(\"(?i)blocked by:?\\\\s*(#\\\\d+[\\\\s,]*)*#$blocker\\\\b\"))" \
            2>/dev/null || echo "false")

        if [[ "$has_blocker" == "true" ]]; then
            if [[ -n "$verified" ]]; then
                verified+=$'\n'
            fi
            verified+="${num}"$'\t'"${title}"
        fi
    done <<< "$candidates"

    echo "$verified"
}

# Get the line that mentions blocking (extracts the specific line, not whole body)
get_blocking_info() {
    local issue="$1"
    # Split body/comments into lines and find the one containing "blocked by"
    gh issue view "$issue" --json body,comments \
        --jq '([.body // ""] + [.comments[].body]) | .[] | select(. != null) | split("\n")[] | select(test("(?i)blocked by"))' \
        2>/dev/null | head -1 || echo ""
}

# Parse blockers from comment (e.g., "Blocked by #100, #101, #102")
parse_blockers() {
    local comment="$1"
    # Use || true to avoid failing when no matches found (set -e)
    echo "$comment" | grep -oE '#[0-9]+' | tr -d '#' | sort -u || true
}

# Check if block is manual (external) vs dependency
is_manual_block() {
    local comment="$1"
    echo "$comment" | grep -qiE 'waiting for|external|approval|client|vendor|third.?party' 2>/dev/null
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
            gh issue comment "$issue" --body "Auto-unblocked: #$blocker completed [$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S)]"
            log_action "Unblocked #$issue (was blocked by #$blocker)"
        fi
    else
        # Some blockers remain - update comment
        local remaining_list
        remaining_list=$(echo "$remaining" | sed 's/^/#/' | paste -sd, - 2>/dev/null || echo "$remaining")
        if [[ "$DRY_RUN" == "true" ]]; then
            log_dry "Would update #$issue: still blocked by $remaining_list"
        else
            gh issue comment "$issue" --body "Blocker #$blocker resolved. Still blocked by: $remaining_list"
            log_action "Updated #$issue: removed #$blocker from blockers, still blocked by $remaining_list"
        fi
    fi
}

# Detect circular dependencies starting from an issue
detect_circular_deps() {
    local start="$1"
    local -a visited=()
    local -a path=()

    detect_cycle_inner() {
        local current="$1"

        # Check if already in current path (cycle!)
        for p in "${path[@]}"; do
            if [[ "$p" == "$current" ]]; then
                echo "${path[*]} $current"
                return 0
            fi
        done

        # Check if already fully visited
        for v in "${visited[@]}"; do
            [[ "$v" == "$current" ]] && return 1
        done

        path+=("$current")

        # Find what this issue blocks
        local blocked_by_current
        blocked_by_current=$(find_blocked_by "$current")

        while IFS=$'\t' read -r num title; do
            [[ -z "$num" ]] && continue
            if detect_cycle_inner "$num"; then
                return 0
            fi
        done <<< "$blocked_by_current"

        # Remove from path, add to visited
        unset 'path[-1]' 2>/dev/null || path=("${path[@]:0:${#path[@]}-1}")
        visited+=("$current")
        return 1
    }

    if detect_cycle_inner "$start"; then
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

    local issues
    read -ra issues <<< "$cycle"
    for issue in "${issues[@]}"; do
        [[ -z "$issue" ]] && continue
        local comment
        comment=$(get_blocking_info "$issue")

        # Estimate rework cost based on blocking reason
        local cost="MEDIUM"
        if echo "$comment" | grep -qiE 'interface|mock|stub|config' 2>/dev/null; then
            cost="LOW"
        elif echo "$comment" | grep -qiE 'schema|migration|architecture|breaking' 2>/dev/null; then
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
        echo "  #$root (closed/processing)"

        local count=0
        local total
        total=$(echo "$blocked" | grep -c . 2>/dev/null || echo 0)

        while IFS=$'\t' read -r num title; do
            [[ -z "$num" ]] && continue
            ((count++))

            local comment
            comment=$(get_blocking_info "$num")
            local all_blockers
            all_blockers=$(parse_blockers "$comment")
            local blocker_count
            blocker_count=$(echo "$all_blockers" | grep -c . 2>/dev/null || echo 0)

            local connector="├──"
            [[ "$count" -eq "$total" ]] && connector="└──"

            if [[ "$blocker_count" -le 1 ]]; then
                echo "    $connector #$num (will unblock) - ${title:0:40}"
            else
                local others
                others=$(echo "$all_blockers" | grep -v "^${root}$" | sed 's/^/#/' | paste -sd, - 2>/dev/null || echo "")
                echo "    $connector #$num (still blocked by $others) - ${title:0:40}"
            fi
        done <<< "$blocked"

        [[ "$total" -eq 0 ]] && echo "    (no issues blocked by #$root)"
    else
        # Mermaid graph for piped output
        echo "graph TD"
        echo "    ${root}[\"#$root (closed)\"]"

        while IFS=$'\t' read -r num title; do
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
            local cycle
            cycle=$(detect_circular_deps "$issue" 2>&1 || echo "")
            suggest_resolution "$cycle"
            continue
        fi

        # Find and process blocked issues
        local blocked
        blocked=$(find_blocked_by "$issue")

        if [[ -z "$blocked" ]]; then
            log_info "No issues blocked by #$issue"
            continue
        fi

        while IFS=$'\t' read -r num title; do
            [[ -z "$num" ]] && continue

            log_info "Found #$num blocked by #$issue: $title"

            # Get current blockers
            local comment
            comment=$(get_blocking_info "$num")
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
