# Risk Quantification

## Overview

Risk measures the probability and severity of harm if technical debt is not
addressed. Higher risk means greater urgency. All scores require evidence.

## Risk Categories

### Failure Risk

What is the probability of system failure due to this debt?

- Service outages
- Data loss or corruption
- Cascading failures
- Recovery difficulty

### Security Risk

What is the exposure to security vulnerabilities?

- Known CVEs in dependencies
- Authentication/authorisation gaps
- Data exposure risks
- Compliance violations

### Compliance Risk

What is the exposure to regulatory or policy violations?

- Data protection (GDPR, CCPA)
- Industry regulations (PCI-DSS, HIPAA)
- Internal policy violations
- Audit findings

### Velocity Risk

What is the risk to future development speed?

- Increasing technical debt interest
- Difficulty adding features
- Testing becoming harder
- Knowledge loss (key person dependency)

## Risk Scoring Scale

| Score | Level    | Probability | Severity    | Description                       |
| ----- | -------- | ----------- | ----------- | --------------------------------- |
| 1     | Minimal  | Unlikely    | Negligible  | Theoretical issue, no incidents   |
| 2     | Low      | Rare        | Minor       | Isolated incidents, easy recovery |
| 3     | Moderate | Occasional  | Moderate    | Some incidents, manageable impact |
| 4     | High     | Likely      | Significant | Regular incidents, notable impact |
| 5     | Critical | Certain     | Severe      | Incidents expected, major impact  |

## Evidence Requirements

Each risk score must be supported by evidence:

### Quantitative Evidence (Preferred)

- Incident history (frequency, duration, severity)
- Security scan results (CVE counts, severity levels)
- Audit findings and compliance reports
- Dependency age and update frequency
- Test failure rates and patterns

### Qualitative Evidence (When Quantitative Unavailable)

- Expert assessment (security team, architects)
- Industry knowledge (common vulnerability patterns)
- Historical patterns in similar codebases
- Team concerns raised in retrospectives

## Risk Assessment Template

```markdown
## Risk Assessment: [Debt Item Name]

### Failure Risk

- Score: [1-5]
- Probability: [rare/occasional/likely/certain]
- Evidence: [incident history, system analysis]
- Potential impact: [outage duration, data loss]

### Security Risk

- Score: [1-5]
- Exposure: [CVE details, vulnerability type]
- Evidence: [scan results, audit findings]
- Potential impact: [data breach, compliance violation]

### Compliance Risk

- Score: [1-5]
- Regulations: [GDPR, PCI-DSS, etc.]
- Evidence: [audit reports, policy gaps]
- Potential impact: [fines, certifications]

### Velocity Risk

- Score: [1-5]
- Trend: [stable/increasing/critical]
- Evidence: [development slowdown, feature delays]
- Potential impact: [delivery delays, team burnout]

### Overall Risk Score: [highest or weighted average]
```

## Risk Probability Matrix

Use this matrix to determine risk score:

|                | Negligible Impact | Minor Impact | Moderate Impact | Major Impact | Severe Impact |
| -------------- | ----------------- | ------------ | --------------- | ------------ | ------------- |
| **Certain**    | 3                 | 4            | 5               | 5            | 5             |
| **Likely**     | 2                 | 3            | 4               | 5            | 5             |
| **Occasional** | 1                 | 2            | 3               | 4            | 5             |
| **Rare**       | 1                 | 1            | 2               | 3            | 4             |
| **Unlikely**   | 1                 | 1            | 1               | 2            | 3             |

## Common Risk Patterns

### High Risk Indicators

- Dependency with known CVEs (especially high/critical severity)
- No security updates available (end-of-life)
- Previous incidents related to this debt
- Single point of failure (no redundancy)
- Key person dependency (only one person understands)

### Low Risk Indicators

- No incidents in past 12 months
- Dependencies actively maintained
- Multiple team members understand the code
- Redundancy and failover in place
- Regular security scanning with no findings

## Risk Evolution

Risk is not static. Track risk trend:

| Trend      | Indicator                                  | Action                    |
| ---------- | ------------------------------------------ | ------------------------- |
| Increasing | New CVEs discovered, incidents increasing  | Escalate priority         |
| Stable     | No new vulnerabilities, incident rate flat | Maintain current priority |
| Decreasing | Mitigations applied, incidents reducing    | Consider deprioritising   |

## Integration with Impact and Effort

Risk alone does not determine priority:

- High risk + High impact + Low effort = **Immediate action**
- High risk + Low impact + Low effort = **Quick fix**
- High risk + Any impact + High effort = **Plan carefully**
- Low risk + Any impact + Any effort = **Consider deprioritising**

See the main SKILL.md for the priority calculation formula.
