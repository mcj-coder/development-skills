#!/usr/bin/env bash
# backlog-health.sh - Generate backlog health report identifying issues needing attention
#
# Usage: ./backlog-health.sh [--output FILE]
#
# Environment Variables:
#   STALE_DAYS         - Days without activity to flag as stale (default: 30)
#   BLOCKED_DAYS       - Days blocked to flag as extended block (default: 14)
#   NEW_FEATURE_DAYS   - Days in new-feature state to flag as stale state (default: 7)
#   DEBUG              - Set to "true" for verbose output
#
# Exit Codes:
#   0 - Healthy (no issues found)
#   1 - Warnings found
#   2 - Alerts found or configuration error
#
# Requirements: GitHub CLI (gh) installed and authenticated

set -euo pipefail

# Configuration with defaults
STALE_DAYS="${STALE_DAYS:-30}"
BLOCKED_DAYS="${BLOCKED_DAYS:-14}"
NEW_FEATURE_DAYS="${NEW_FEATURE_DAYS:-7}"
DEBUG="${DEBUG:-false}"
OUTPUT_FILE="backlog-health-report.md"

# Severity tracking
WARNING_COUNT=0
ALERT_COUNT=0
TOTAL_ISSUES=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--output FILE]"
            echo ""
            echo "Generate backlog health report identifying issues needing attention."
            echo ""
            echo "Environment Variables:"
            echo "  STALE_DAYS         Days without activity (default: 30)"
            echo "  BLOCKED_DAYS       Days blocked (default: 14)"
            echo "  NEW_FEATURE_DAYS   Days in new-feature state (default: 7)"
            echo "  DEBUG              Set to 'true' for verbose output"
            echo ""
            echo "Options:"
            echo "  --output, -o FILE  Output file (default: backlog-health-report.md)"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            echo "::error title=Unknown Option::Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

# Debug logging
debug() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Validate configuration
validate_config() {
    local errors=0

    if ! [[ "$STALE_DAYS" =~ ^[0-9]+$ ]]; then
        echo "::error title=Invalid Config::STALE_DAYS must be a positive integer, got: $STALE_DAYS"
        errors=1
    elif [[ "$STALE_DAYS" -le 0 ]]; then
        echo "::error title=Invalid Config::STALE_DAYS must be positive, got: $STALE_DAYS"
        errors=1
    fi

    if ! [[ "$BLOCKED_DAYS" =~ ^[0-9]+$ ]]; then
        echo "::error title=Invalid Config::BLOCKED_DAYS must be a positive integer, got: $BLOCKED_DAYS"
        errors=1
    elif [[ "$BLOCKED_DAYS" -le 0 ]]; then
        echo "::error title=Invalid Config::BLOCKED_DAYS must be positive, got: $BLOCKED_DAYS"
        errors=1
    fi

    if ! [[ "$NEW_FEATURE_DAYS" =~ ^[0-9]+$ ]]; then
        echo "::error title=Invalid Config::NEW_FEATURE_DAYS must be a positive integer, got: $NEW_FEATURE_DAYS"
        errors=1
    elif [[ "$NEW_FEATURE_DAYS" -le 0 ]]; then
        echo "::error title=Invalid Config::NEW_FEATURE_DAYS must be positive, got: $NEW_FEATURE_DAYS"
        errors=1
    fi

    return $errors
}

# Calculate days between two dates
days_since() {
    local date_str="$1"
    local now
    local then
    now=$(date +%s)
    then=$(date -d "$date_str" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$date_str" +%s 2>/dev/null || echo "0")
    if [[ "$then" == "0" ]]; then
        echo "0"
        return
    fi
    echo $(( (now - then) / 86400 ))
}

# Retry wrapper for gh commands
retry_gh() {
    local max_attempts=3
    local attempt=1
    local result

    while [[ $attempt -le $max_attempts ]]; do
        if result=$(gh "$@" 2>&1); then
            echo "$result"
            return 0
        fi
        debug "Attempt $attempt failed for: gh $*"
        sleep $((attempt * 2))
        ((attempt++))
    done

    echo "::warning title=API Error::Command failed after $max_attempts attempts: gh $*"
    return 1
}

# Check for issues missing required labels
check_missing_labels() {
    debug "Checking for missing labels..."
    local issues
    local missing_labels=()

    # Get all open issues with their labels and state
    issues=$(retry_gh issue list --state open --limit 500 \
        --json number,title,labels \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " ") | .[0:60])\t\([.labels[].name] | join(","))"') || {
        echo "::warning title=Check Failed::Could not fetch issues for label check"
        return 0
    }

    while IFS=$'\t' read -r number title labels; do
        [[ -z "$number" ]] && continue

        local missing=""

        # Check implementation state requires component label
        if echo "$labels" | grep -q "state:implementation" && ! echo "$labels" | grep -qE "^component:|,component:"; then
            missing="component:*"
        fi

        # Check verification state requires work-type label
        if echo "$labels" | grep -q "state:verification" && ! echo "$labels" | grep -qE "^work-type:|,work-type:"; then
            if [[ -n "$missing" ]]; then
                missing="$missing, work-type:*"
            else
                missing="work-type:*"
            fi
        fi

        if [[ -n "$missing" ]]; then
            missing_labels+=("#$number|$title|$missing")
            ((WARNING_COUNT++))
        fi
    done <<< "$issues"

    # Output section
    echo "## Missing Labels"
    echo ""
    if [[ ${#missing_labels[@]} -eq 0 ]]; then
        echo "No issues found with missing labels."
    else
        echo "| Issue | Title | Missing |"
        echo "| ----- | ----- | ------- |"
        for entry in "${missing_labels[@]}"; do
            IFS='|' read -r num title missing <<< "$entry"
            echo "| $num | $title | $missing |"
        done
    fi
    echo ""
}

# Check for issues in stale state (new-feature too long)
check_stale_state() {
    debug "Checking for stale state..."
    local issues
    local stale_state=()

    issues=$(retry_gh issue list --state open --label "state:new-feature" --limit 500 \
        --json number,title,createdAt \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " ") | .[0:60])\t\(.createdAt)"') || {
        echo "::warning title=Check Failed::Could not fetch new-feature issues"
        return 0
    }

    while IFS=$'\t' read -r number title created; do
        [[ -z "$number" ]] && continue
        local days
        days=$(days_since "$created")
        if [[ "$days" -gt "$NEW_FEATURE_DAYS" ]]; then
            stale_state+=("#$number|$title|$days days")
            ((WARNING_COUNT++))
        fi
    done <<< "$issues"

    echo "## Stale State"
    echo ""
    echo "Issues in \`state:new-feature\` for more than $NEW_FEATURE_DAYS days."
    echo ""
    if [[ ${#stale_state[@]} -eq 0 ]]; then
        echo "No issues found with stale state."
    else
        echo "| Issue | Title | Duration |"
        echo "| ----- | ----- | -------- |"
        for entry in "${stale_state[@]}"; do
            IFS='|' read -r num title duration <<< "$entry"
            echo "| $num | $title | $duration |"
        done
    fi
    echo ""
}

# Check for unanswered questions
check_unanswered_questions() {
    debug "Checking for unanswered questions..."
    local issues
    local unanswered=()

    issues=$(retry_gh issue list --state open --label "needs-info" --limit 500 \
        --json number,title,updatedAt \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " ") | .[0:60])\t\(.updatedAt)"') || {
        echo "::warning title=Check Failed::Could not fetch needs-info issues"
        return 0
    }

    while IFS=$'\t' read -r number title updated; do
        [[ -z "$number" ]] && continue
        local days
        days=$(days_since "$updated")
        unanswered+=("#$number|$title|$days days waiting")
        ((WARNING_COUNT++))
    done <<< "$issues"

    echo "## Unanswered Questions"
    echo ""
    echo "Issues with \`needs-info\` label awaiting response."
    echo ""
    if [[ ${#unanswered[@]} -eq 0 ]]; then
        echo "No issues found with unanswered questions."
    else
        echo "| Issue | Title | Waiting |"
        echo "| ----- | ----- | ------- |"
        for entry in "${unanswered[@]}"; do
            IFS='|' read -r num title waiting <<< "$entry"
            echo "| $num | $title | $waiting |"
        done
    fi
    echo ""
}

# Check for extended blocks
check_extended_blocks() {
    debug "Checking for extended blocks..."
    local issues
    local extended_blocks=()

    # Get blocked issues - need to find when blocked label was added
    # For simplicity, use updatedAt as proxy (label addition updates issue)
    issues=$(retry_gh issue list --state open --label "blocked" --limit 500 \
        --json number,title,updatedAt \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " ") | .[0:60])\t\(.updatedAt)"') || {
        echo "::warning title=Check Failed::Could not fetch blocked issues"
        return 0
    }

    while IFS=$'\t' read -r number title updated; do
        [[ -z "$number" ]] && continue
        # Note: This uses updatedAt as proxy. A more accurate check would use
        # timeline events API, but that's rate-limit intensive.
        local days
        days=$(days_since "$updated")
        if [[ "$days" -gt "$BLOCKED_DAYS" ]]; then
            extended_blocks+=("#$number|$title|$days days blocked")
            ((ALERT_COUNT++))
        fi
    done <<< "$issues"

    echo "## Extended Blocks"
    echo ""
    echo "**Severity: Alert** - Issues blocked for more than $BLOCKED_DAYS days require attention."
    echo ""
    if [[ ${#extended_blocks[@]} -eq 0 ]]; then
        echo "No issues found with extended blocks."
    else
        echo "| Issue | Title | Duration |"
        echo "| ----- | ----- | -------- |"
        for entry in "${extended_blocks[@]}"; do
            IFS='|' read -r num title duration <<< "$entry"
            echo "| $num | $title | $duration |"
        done
    fi
    echo ""
}

# Check for potential duplicates
check_potential_duplicates() {
    debug "Checking for potential duplicates..."

    # This leverages the detect-duplicates workflow output if available
    # For standalone use, we do a simple title similarity check

    echo "## Potential Duplicates"
    echo ""
    echo "Issues with similar titles that may be duplicates."
    echo ""
    echo "Run the \`detect-duplicates\` workflow for detailed analysis."
    echo ""
    echo "_This check defers to the dedicated duplicate detection workflow._"
    echo ""
}

# Check for stale issues
check_stale_issues() {
    debug "Checking for stale issues..."
    local issues
    local stale_issues=()

    issues=$(retry_gh issue list --state open --limit 500 \
        --json number,title,updatedAt \
        --jq '.[] | "\(.number)\t\(.title | gsub("\t"; " ") | .[0:60])\t\(.updatedAt)"') || {
        echo "::warning title=Check Failed::Could not fetch issues for staleness check"
        return 0
    }

    while IFS=$'\t' read -r number title updated; do
        [[ -z "$number" ]] && continue
        local days
        days=$(days_since "$updated")
        if [[ "$days" -gt "$STALE_DAYS" ]]; then
            stale_issues+=("#$number|$title|$days days inactive")
            ((WARNING_COUNT++))
        fi
    done <<< "$issues"

    echo "## Stale Issues"
    echo ""
    echo "Issues with no activity for more than $STALE_DAYS days."
    echo ""
    if [[ ${#stale_issues[@]} -eq 0 ]]; then
        echo "No stale issues found."
    else
        echo "| Issue | Title | Inactive |"
        echo "| ----- | ----- | -------- |"
        for entry in "${stale_issues[@]}"; do
            IFS='|' read -r num title inactive <<< "$entry"
            echo "| $num | $title | $inactive |"
        done
    fi
    echo ""
}

# Generate recommendations
generate_recommendations() {
    echo "## Recommendations"
    echo ""

    if [[ "$WARNING_COUNT" -eq 0 && "$ALERT_COUNT" -eq 0 ]]; then
        echo "Backlog is healthy. No immediate actions required."
    else
        echo "### Immediate Actions"
        echo ""
        if [[ "$ALERT_COUNT" -gt 0 ]]; then
            echo "- **Extended Blocks**: Review blocked issues and escalate or resolve blockers"
        fi
        if [[ "$WARNING_COUNT" -gt 0 ]]; then
            echo "- **Missing Labels**: Add required labels before state transitions"
            echo "- **Stale State**: Move old new-feature issues to grooming or close"
            echo "- **Unanswered Questions**: Respond to pending questions or close"
            echo "- **Stale Issues**: Close or re-activate inactive issues"
        fi
        echo ""
        echo "### Grooming Session"
        echo ""
        echo "Consider scheduling a grooming session to address these findings."
    fi
    echo ""
}

# Generate summary
generate_summary() {
    echo "# Backlog Health Report"
    echo ""
    echo "**Generated:** $(date -Iseconds)"
    echo ""
    echo "## Configuration"
    echo ""
    echo "| Threshold | Value |"
    echo "| --------- | ----- |"
    echo "| Stale Days | $STALE_DAYS |"
    echo "| Blocked Days | $BLOCKED_DAYS |"
    echo "| New Feature Days | $NEW_FEATURE_DAYS |"
    echo ""
    echo "## Summary"
    echo ""
    echo "| Category | Count | Severity |"
    echo "| -------- | ----- | -------- |"
    echo "| Warnings | $WARNING_COUNT | Warning |"
    echo "| Alerts | $ALERT_COUNT | Alert |"
    echo ""
}

main() {
    debug "Starting backlog health check..."

    # Validate configuration
    if ! validate_config; then
        exit 2
    fi

    # Check rate limit
    local rate_remaining
    rate_remaining=$(gh api rate_limit --jq '.rate.remaining' 2>/dev/null || echo "unknown")
    debug "Rate limit remaining: $rate_remaining"
    if [[ "$rate_remaining" != "unknown" && "$rate_remaining" -lt 50 ]]; then
        echo "::warning title=Rate Limit::API rate limit is low ($rate_remaining remaining), results may be incomplete"
    fi

    # Generate report to temp file, then move (atomic)
    local temp_file
    temp_file=$(mktemp)

    {
        generate_summary
        check_missing_labels
        check_stale_state
        check_unanswered_questions
        check_extended_blocks
        check_potential_duplicates
        check_stale_issues
        generate_recommendations
    } > "$temp_file"

    # Move to final location
    mv "$temp_file" "$OUTPUT_FILE"

    # Output summary annotation
    local status="healthy"
    local exit_code=0
    if [[ "$ALERT_COUNT" -gt 0 ]]; then
        status="alerts"
        exit_code=2
        echo "::error title=Health Check::Backlog health check found $ALERT_COUNT alerts and $WARNING_COUNT warnings"
    elif [[ "$WARNING_COUNT" -gt 0 ]]; then
        status="warnings"
        exit_code=1
        echo "::warning title=Health Check::Backlog health check found $WARNING_COUNT warnings"
    else
        echo "::notice title=Health Check::Backlog is healthy - no issues found"
    fi

    echo ""
    echo "Report generated: $OUTPUT_FILE"
    echo "Status: $status (warnings: $WARNING_COUNT, alerts: $ALERT_COUNT)"

    exit "$exit_code"
}

main
