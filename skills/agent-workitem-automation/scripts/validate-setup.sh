#!/usr/bin/env bash
# validate-setup.sh - Check agent work item automation prerequisites
#
# Usage: ./validate-setup.sh [--readme PATH]
#
# Checks:
# - README.md Work Items section exists
# - Taskboard URL is present
# - Platform CLI is installed
# - CLI is authenticated
#
# Exit codes:
# 0 - All checks pass, ready for automation
# 1 - One or more checks failed

set -euo pipefail

README_PATH="${1:-README.md}"
ERRORS=0

# Colors for output (if terminal supports it)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

print_status() {
    local label="$1"
    local status="$2"
    local detail="${3:-}"

    case "$status" in
        "OK"|"CONFIGURED"|"INSTALLED"|"AUTHENTICATED")
            printf "%-20s: ${GREEN}%s${NC}" "$label" "$status"
            ;;
        "MISSING"|"NOT FOUND"|"NOT INSTALLED"|"NOT AUTHENTICATED")
            printf "%-20s: ${RED}%s${NC}" "$label" "$status"
            ERRORS=$((ERRORS + 1))
            ;;
        "WARN"|"OPTIONAL")
            printf "%-20s: ${YELLOW}%s${NC}" "$label" "$status"
            ;;
        *)
            printf "%-20s: %s" "$label" "$status"
            ;;
    esac

    if [[ -n "$detail" ]]; then
        printf " (%s)" "$detail"
    fi
    printf "\n"
}

echo "Agent Work Item Automation - Setup Validation"
echo "=============================================="
echo ""

# Check README exists
if [[ ! -f "$README_PATH" ]]; then
    print_status "README" "NOT FOUND" "$README_PATH"
    echo ""
    echo "Status: NOT READY"
    exit 1
fi

# Check Work Items section
if grep -q "^## Work Items" "$README_PATH" 2>/dev/null; then
    print_status "Work Items Section" "CONFIGURED"
else
    print_status "Work Items Section" "MISSING" "Add '## Work Items' section to README"
fi

# Check Taskboard URL
TASKBOARD_URL=""
if grep -q "Taskboard:" "$README_PATH" 2>/dev/null; then
    TASKBOARD_URL=$(grep "Taskboard:" "$README_PATH" | head -1 | sed 's/.*Taskboard:[[:space:]]*//' | tr -d '<>')
    print_status "Taskboard URL" "CONFIGURED" "$TASKBOARD_URL"
else
    print_status "Taskboard URL" "MISSING" "Add 'Taskboard: <url>' to Work Items section"
fi

# Detect platform from URL
PLATFORM=""
CLI=""
if [[ -n "$TASKBOARD_URL" ]]; then
    case "$TASKBOARD_URL" in
        *github.com*)
            PLATFORM="GitHub"
            CLI="gh"
            ;;
        *dev.azure.com*|*visualstudio.com*)
            PLATFORM="Azure DevOps"
            CLI="az"
            ;;
        *atlassian.net*|*jira.*)
            PLATFORM="Jira"
            CLI="jira"
            ;;
        *)
            print_status "Platform" "UNKNOWN" "Could not detect from URL"
            ;;
    esac

    if [[ -n "$PLATFORM" ]]; then
        print_status "Platform" "OK" "$PLATFORM"
    fi
fi

# Check CLI installation
if [[ -n "$CLI" ]]; then
    if command -v "$CLI" &>/dev/null; then
        CLI_VERSION=$("$CLI" --version 2>/dev/null | head -1 || echo "version unknown")
        print_status "CLI ($CLI)" "INSTALLED" "$CLI_VERSION"
    else
        print_status "CLI ($CLI)" "NOT INSTALLED" "Install $CLI CLI for $PLATFORM"
    fi
fi

# Check CLI authentication
if [[ -n "$CLI" ]] && command -v "$CLI" &>/dev/null; then
    case "$CLI" in
        gh)
            if gh auth status &>/dev/null; then
                AUTH_USER=$(gh auth status 2>&1 | grep "Logged in" | head -1 || echo "authenticated")
                print_status "Auth" "AUTHENTICATED" "$AUTH_USER"
            else
                print_status "Auth" "NOT AUTHENTICATED" "Run 'gh auth login'"
            fi
            ;;
        az)
            if az account show &>/dev/null; then
                print_status "Auth" "AUTHENTICATED"
            else
                print_status "Auth" "NOT AUTHENTICATED" "Run 'az login'"
            fi
            ;;
        jira)
            # Jira CLI auth check varies by implementation
            print_status "Auth" "OPTIONAL" "Verify Jira CLI authentication manually"
            ;;
    esac
fi

echo ""

# Final status
if [[ $ERRORS -eq 0 ]]; then
    echo -e "Status: ${GREEN}READY${NC}"
    echo "All prerequisites satisfied. Agent can proceed with work item automation."
    exit 0
else
    echo -e "Status: ${RED}NOT READY${NC}"
    echo "$ERRORS issue(s) must be resolved before proceeding."
    exit 1
fi
