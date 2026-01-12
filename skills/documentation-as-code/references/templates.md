# Documentation Templates

## ADR Template

Architecture Decision Records follow a standard structure:

```markdown
# ADR-NNN: {Title}

**Status:** {Proposed | Accepted | Deprecated | Superseded}
**Date:** YYYY-MM-DD
**Deciders:** {Names}

## Context

{Describe the issue motivating this decision, and any context that influences
or constrains the decision.}

## Decision

{Describe the decision and its rationale.}

## Consequences

**Benefits:**

- {Positive outcome}

**Drawbacks:**

- {Negative outcome or trade-off}

**Risks:**

- {Risk to monitor}

## Alternatives Considered

### Alternative 1: {Name}

- {Description}
- {Why rejected}
```

## API Documentation Template

```markdown
# {API Name} API

## Overview

{Brief description of what this API provides}

## Authentication

{Authentication method and requirements}

## Endpoints

### GET /resource

**Description:** {What this endpoint does}

**Parameters:**

| Name | Type   | Required | Description |
| ---- | ------ | -------- | ----------- |
| id   | string | Yes      | Resource ID |

**Response:** JSON object with resource data

**Errors:**

| Code | Description        |
| ---- | ------------------ |
| 404  | Resource not found |
```

## Runbook Template

```markdown
# {Runbook Title}

## Purpose

{What this runbook addresses}

## Prerequisites

- {Required access/permissions}
- {Required tools}

## Steps

### 1. {First Step}

{Detailed instructions}

### 2. {Second Step}

{Detailed instructions}

## Troubleshooting

### {Common Issue}

**Symptom:** {What you observe}
**Cause:** {Why it happens}
**Resolution:** {How to fix}
```

## Template Validation

Ensure templates are followed by checking:

1. All required sections present
2. Placeholders replaced with content
3. Status field has valid value (ADRs)
4. Date format consistent (YYYY-MM-DD)
