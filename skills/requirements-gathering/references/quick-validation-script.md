# Quick Validation Script

> Reference material for the [`requirements-gathering`](../SKILL.md) skill.


```bash
#!/bin/bash
# validate-requirements.sh - Check if requirements are sufficient

ISSUE_BODY="$1"

ERRORS=0

echo "=== Requirements Validation ==="

# Check for Goal section
if echo "$ISSUE_BODY" | grep -qi "## Goal"; then
  echo "✓ Goal section present"
else
  echo "✗ Goal section missing"
  ((ERRORS++))
fi

# Check for Requirements section
if echo "$ISSUE_BODY" | grep -qi "## Requirements"; then
  REQ_COUNT=$(echo "$ISSUE_BODY" | grep -cE "^[0-9]+\.")
  if [ "$REQ_COUNT" -ge 2 ]; then
    echo "✓ Requirements section has $REQ_COUNT items"
  else
    echo "⚠ Only $REQ_COUNT requirement(s) - consider adding more"
  fi
else
  echo "✗ Requirements section missing"
  ((ERRORS++))
fi

# Check for Acceptance Criteria
if echo "$ISSUE_BODY" | grep -qi "## Acceptance"; then
  AC_COUNT=$(echo "$ISSUE_BODY" | grep -cE "^\s*-\s*\[\s*\]")
  if [ "$AC_COUNT" -ge 2 ]; then
    echo "✓ Acceptance criteria has $AC_COUNT items"
  else
    echo "⚠ Only $AC_COUNT acceptance criterion - add more"
  fi
else
  echo "✗ Acceptance criteria section missing"
  ((ERRORS++))
fi

# Check for TBD markers
TBD_COUNT=$(echo "$ISSUE_BODY" | grep -ciE "tbd|to be determined|unknown|\?\?\?")
if [ "$TBD_COUNT" -eq 0 ]; then
  echo "✓ No TBD markers found"
else
  echo "⚠ Found $TBD_COUNT TBD markers - resolve before proceeding"
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✓ Requirements appear sufficient"
else
  echo "✗ $ERRORS issue(s) found - gather more information"
fi
```
