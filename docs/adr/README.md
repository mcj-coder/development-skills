# Architecture Decision Records

## Overview

Architecture Decision Records (ADRs) document significant architectural and process decisions
for future reference. This repository uses the [MADR format](https://adr.github.io/madr/)
(Markdown Architectural Decision Records).

## Frontmatter Standard

All ADR documents MUST include YAML frontmatter with these fields:

```yaml
---
name: adr-name
description: |
  When to load/apply this ADR. Include trigger conditions.
decision: Imperative verb + specific action + context.
status: accepted
---
```

### Required Fields

| Field         | Description                                                            |
| ------------- | ---------------------------------------------------------------------- |
| `name`        | Kebab-case identifier matching filename without number prefix          |
| `description` | When to load/apply this ADR; trigger conditions for agents (1-3 lines) |
| `decision`    | One-line actionable outcome; imperative verb format                    |
| `status`      | One of: `accepted`, `superseded`, `deprecated`                         |

### Field Specifications

#### `name`

- Kebab-case identifier (e.g., `use-adrs`, `adopt-tdd`)
- Must match filename without number prefix (e.g., `0000-use-adrs.md` → `use-adrs`)
- Do NOT include the ADR number in the name

#### `description`

- When to load or apply this ADR
- Include trigger conditions agents can match
- 1-3 sentences using format: "Apply when {condition}. Use when {context}."
- Must be sufficient for agents to decide relevance without reading full ADR

#### `decision`

- One-line actionable outcome
- Use imperative verb format: `{verb} {specific action} {location/context}`
- Must answer: "What do we do?"
- Agent must be able to apply directly without reading body content

#### `status`

One of:

| Value        | Meaning                 | Agent Behavior                               |
| ------------ | ----------------------- | -------------------------------------------- |
| `accepted`   | Decision is current     | SHOULD apply when description matches        |
| `superseded` | Replaced by another ADR | MUST NOT apply; load superseding ADR instead |
| `deprecated` | No longer applicable    | MUST NOT apply; decision is obsolete         |

### Examples

#### Accepted ADR

```yaml
---
name: use-adrs
description: |
  Apply when deciding how to document architectural decisions
  or questioning why ADRs are used in this repository.
decision: Use MADR format ADRs in docs/adr/ for significant architectural and process decisions.
status: accepted
---
```

#### Superseded ADR

```yaml
---
name: use-wiki-docs
description: |
  Apply when deciding where to store documentation.
  Note: This ADR has been superseded - see body for replacement.
decision: Store documentation in GitHub wiki.
status: superseded
---
```

When `status: superseded`, the ADR body MUST reference the superseding ADR:

```markdown
## Status

Superseded by [ADR-0042: Use In-Repo Documentation](0042-use-in-repo-docs.md)
```

#### Deprecated ADR

```yaml
---
name: use-legacy-auth
description: |
  Apply when implementing authentication.
  Note: This ADR is deprecated - do not apply.
decision: Use legacy authentication system for all services.
status: deprecated
---
```

When `status: deprecated`, the ADR body MUST explain why it's no longer applicable.

## Agent Workflow Guidance

### When to Read Full ADR vs Frontmatter Only

| Scenario                                   | Action                            |
| ------------------------------------------ | --------------------------------- |
| Checking if ADR applies to current task    | Read frontmatter only             |
| Applying a decision                        | Read frontmatter `decision` field |
| Understanding rationale or alternatives    | Read full ADR body                |
| ADR status is `superseded` or `deprecated` | Read body for replacement/reason  |

### Handling Status Values

1. **`accepted`**: SHOULD apply the decision when the description matches your context
2. **`superseded`**: MUST NOT apply. Read the `## Status` section in body to find replacement ADR
3. **`deprecated`**: MUST NOT apply. Read body to understand why it's obsolete

### Conflict Resolution

When multiple ADRs have overlapping `description` triggers:

1. Check `status` - only `accepted` ADRs should be applied
2. Prefer newer ADR (higher number) when both are `accepted`
3. If still ambiguous, read full ADR bodies to determine which is more specific

## ADR Index

- [0000-use-adrs.md](0000-use-adrs.md) - Use MADR format ADRs for architectural decisions

## Creating New ADRs

See [ADR 0000](0000-use-adrs.md) for guidelines on when to create ADRs and the MADR format.

### Quick Reference

1. Copy template from existing ADR
2. Number sequentially (e.g., `0001-decision-name.md`)
3. Add frontmatter with all required fields
4. Follow MADR format for body content
5. Run `npm run lint` to validate

## Validation

ADR frontmatter is validated during:

- **Pre-commit hooks**: Format and syntax validation via prettier
- **CI pipeline**: Markdown linting via markdownlint-cli2
- **Manual check**: Run `npm run lint` to validate all ADR files

Required fields (`name`, `description`, `decision`, `status`) are enforced by convention.
Invalid frontmatter will cause YAML parsing errors when ADRs are loaded by agents.
