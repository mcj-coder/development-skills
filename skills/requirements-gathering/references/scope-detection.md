# Scope Detection

## Overview

Detect when work items are too large for single tickets and should be decomposed into multiple
related tickets for phased delivery.

Detection combines **structural signals** (primary) with **adaptive thresholds** (backstop).
User always makes final decision on whether to decompose.

## Structural Signals

Evaluate requirements for these signals during the structuring phase:

| Signal                       | How to Detect                                                                  | Weight |
| ---------------------------- | ------------------------------------------------------------------------------ | ------ |
| Multiple user flows          | Requirements describe 2+ distinct end-to-end scenarios                         | High   |
| Multiple API endpoints       | Requirements mention 2+ separate HTTP operations                               | High   |
| Multiple database entities   | Requirements include 2+ new tables or major schema changes                     | High   |
| Cross-cutting concerns       | Requirements mention auth, logging, caching, or error handling across features | Medium |
| Multiple consumers           | Requirements describe 2+ different UI components or services                   | Medium |
| Infrastructure + application | Requirements combine deployment/infra work with feature development            | Medium |

### Signal Detection Examples

**Multiple user flows:**

```text
Requirements mention: "user registration", "password reset", "profile editing"
→ 3 distinct user flows detected
```

**Multiple API endpoints:**

```text
Requirements mention: "GET /users", "POST /orders", "PUT /inventory"
→ 3 separate API endpoints detected
```

**Cross-cutting concerns:**

```text
Requirements mention: "add authentication to all endpoints"
→ Cross-cutting auth concern detected
```

## Adaptive Thresholds

Store team context in ADR for threshold calculation:

```text
Sprint duration: [X days] (default: 10)
Ideal ticket size: 3 days
Team velocity factor: 1.0 (adjust based on team)

Calculated thresholds:
- Max requirements per ticket: sprint_days / ideal_size = 10/3 ≈ 3
- Max acceptance criteria per ticket: 2 × max_requirements = 6
```

### First-Time Setup

If no ADR exists, ask user:

```text
I'd like to calibrate decomposition thresholds for your team.

What is your typical sprint duration?
1. 1 week (5 days)
2. 2 weeks (10 days)
3. 3 weeks (15 days)
4. 4 weeks (20 days)

What's your ideal ticket size for a skilled developer?
1. 1 day (very granular)
2. 2-3 days (recommended)
3. 4-5 days (larger chunks)
```

## Detection Output

When signals are detected, present findings:

```text
I've identified signals suggesting this work could be decomposed:

Structural signals detected:
- 3 distinct user flows (registration, login, password reset)
- 2 database tables (Users, Sessions)
- Cross-cutting concern: authentication middleware

Threshold analysis:
- 7 requirements (threshold: 3 per ticket)
- 12 acceptance criteria (threshold: 6 per ticket)

Based on your team's 2-week sprints with 3-day ideal tickets,
this suggests splitting into 3-4 tickets.

Would you like me to propose a decomposition?
```

## When NOT to Decompose

Skip decomposition if:

- No structural signals detected
- Requirements count ≤ threshold
- Acceptance criteria count ≤ threshold
- User explicitly declines

Proceed with single ticket in these cases.

## Integration with Workflow

```text
┌─────────────────────────────────────────┐
│  After structuring requirements:        │
│                                         │
│  1. Evaluate structural signals         │
│  2. Check against thresholds            │
│  3. If signals detected:                │
│     → Present findings                  │
│     → Ask user if decomposition wanted  │
│  4. If no signals or user declines:     │
│     → Proceed with single ticket        │
└─────────────────────────────────────────┘
```
