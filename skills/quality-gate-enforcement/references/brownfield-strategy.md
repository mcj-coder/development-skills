# Brownfield Strategy

Incremental quality gate adoption for existing codebases.

## Coverage Ratchet Implementation

The coverage ratchet pattern ensures coverage can only increase, never decrease.

### Principle

1. Measure current coverage as baseline
2. Set threshold at current level
3. Require each PR to maintain or increase coverage
4. Store coverage baseline in repository
5. Update baseline when coverage increases

### Implementation

#### Coverage Baseline File

Create `.coverage-baseline` in repository root:

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "coverage": {
    "lines": 55.2,
    "branches": 48.7,
    "functions": 62.1
  },
  "target": {
    "lines": 80,
    "branches": 75,
    "functions": 80
  }
}
```

#### Ratchet Script (Node.js)

```javascript
const fs = require("fs");
const baseline = JSON.parse(fs.readFileSync(".coverage-baseline"));
const current = JSON.parse(fs.readFileSync("coverage/coverage-summary.json"));

const checks = [
  {
    name: "lines",
    current: current.total.lines.pct,
    baseline: baseline.coverage.lines,
  },
  {
    name: "branches",
    current: current.total.branches.pct,
    baseline: baseline.coverage.branches,
  },
  {
    name: "functions",
    current: current.total.functions.pct,
    baseline: baseline.coverage.functions,
  },
];

let failed = false;
for (const check of checks) {
  if (check.current < check.baseline) {
    console.error(
      `Coverage regression: ${check.name} dropped from ${check.baseline}% to ${check.current}%`,
    );
    failed = true;
  }
}

if (failed) {
  process.exit(1);
}

// Update baseline if coverage increased
if (checks.every((c) => c.current >= c.baseline)) {
  baseline.coverage = {
    lines: current.total.lines.pct,
    branches: current.total.branches.pct,
    functions: current.total.functions.pct,
  };
  baseline.timestamp = new Date().toISOString();
  fs.writeFileSync(".coverage-baseline", JSON.stringify(baseline, null, 2));
  console.log("Coverage baseline updated");
}
```

#### Ratchet Script (Python)

```python
import json
import sys
from datetime import datetime

with open('.coverage-baseline') as f:
    baseline = json.load(f)

with open('coverage.json') as f:
    current = json.load(f)

checks = [
    ('lines', current['totals']['percent_covered'], baseline['coverage']['lines']),
    ('branches', current['totals'].get('branch_percent', 100), baseline['coverage'].get('branches', 0)),
]

failed = False
for name, current_val, baseline_val in checks:
    if current_val < baseline_val:
        print(f"Coverage regression: {name} dropped from {baseline_val}% to {current_val}%")
        failed = True

if failed:
    sys.exit(1)

# Update baseline if coverage increased
baseline['coverage']['lines'] = current['totals']['percent_covered']
baseline['timestamp'] = datetime.now().isoformat()

with open('.coverage-baseline', 'w') as f:
    json.dump(baseline, f, indent=2)

print('Coverage baseline updated')
```

## Security Baseline

For codebases with existing security findings:

### Document Existing Issues

Create `docs/security-baseline.md`:

```markdown
# Security Baseline

Last updated: 2024-01-15

## Known Vulnerabilities

| ID            | Severity | Package        | Description         | Remediation              |
| ------------- | -------- | -------------- | ------------------- | ------------------------ |
| CVE-2023-1234 | Medium   | lodash@4.17.15 | Prototype pollution | Upgrade to 4.17.21 by Q1 |
| NPM-5678      | Low      | debug@3.1.0    | ReDoS               | Upgrade to 4.x by Q2     |

## Baseline Counts

- Critical: 0
- High: 0
- Medium: 2
- Low: 5

## Gate Policy

- New critical/high: Block immediately
- New medium: Block, must address in PR
- New low: Warning, track for remediation
- Existing: Do not block, track remediation
```

### Baseline Enforcement Script

```bash
#!/bin/bash

# Run security scan
npm audit --json > security-report.json

# Extract new findings vs baseline
NEW_HIGH=$(jq '[.vulnerabilities[] | select(.severity == "high")] | length' security-report.json)
NEW_CRITICAL=$(jq '[.vulnerabilities[] | select(.severity == "critical")] | length' security-report.json)

BASELINE_HIGH=$(jq '.baseline.high // 0' docs/security-baseline.json)
BASELINE_CRITICAL=$(jq '.baseline.critical // 0' docs/security-baseline.json)

if [ "$NEW_CRITICAL" -gt "$BASELINE_CRITICAL" ]; then
  echo "New critical vulnerabilities found!"
  exit 1
fi

if [ "$NEW_HIGH" -gt "$BASELINE_HIGH" ]; then
  echo "New high vulnerabilities found!"
  exit 1
fi

echo "Security gate passed (within baseline)"
```

## Static Analysis Baseline

For codebases with existing linting violations:

### ESLint Baseline

```json
{
  "rules": {
    "no-unused-vars": "warn",
    "prefer-const": "warn"
  },
  "overrides": [
    {
      "files": ["legacy/**/*.js"],
      "rules": {
        "no-unused-vars": "off"
      }
    }
  ]
}
```

### Progressive Enforcement

1. **Week 1-2**: Baseline all violations, warn only
2. **Week 3-4**: Error on new violations in new files
3. **Month 2**: Error on new violations in all files
4. **Month 3+**: Gradually fix existing violations

## Flaky Test Management

### Quarantine Strategy

1. Identify flaky tests via repeated failures
2. Move to `tests/quarantine/` directory
3. Run quarantined tests separately (non-blocking)
4. Create issue for each flaky test
5. Fix or remove within 14 days

### Quarantine Configuration

```yaml
# pytest.ini
[pytest]
testpaths = tests
addopts = --ignore=tests/quarantine

# Separate job for quarantine
quarantine-tests:
  script: pytest tests/quarantine --timeout=60
  allow_failure: true
```

## Incremental Improvement Plan Template

```markdown
# Quality Gate Improvement Plan

## Current State (Baseline)

| Metric          | Current | Target | Timeline |
| --------------- | ------- | ------ | -------- |
| Line Coverage   | 55%     | 80%    | Q2       |
| Branch Coverage | 48%     | 75%    | Q3       |
| Security (High) | 3       | 0      | Q1       |
| Lint Violations | 127     | 0      | Q2       |

## Weekly Targets

- Week 1-4: +2% coverage per week
- Week 5-8: +1.5% coverage per week
- Week 9-12: +1% coverage per week

## Review Schedule

- Weekly: Coverage trend review
- Bi-weekly: Security findings review
- Monthly: Full quality metrics review
```
