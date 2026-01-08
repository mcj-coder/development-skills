# Playbooks

## Overview

Playbooks are process guides that describe step-by-step procedures for handling specific
situations. Unlike roles (which describe expertise) and ADRs (which document decisions),
playbooks describe **processes** with explicit trigger conditions.

## Frontmatter Standard

All playbook documents MUST include YAML frontmatter with these fields in this order:

```yaml
---
name: playbook-name
description: |
  What this playbook covers and its purpose.
summary: |
  Step 1: First action
  Step 2: Second action
  Step 3: Third action
triggers:
  - trigger condition one
  - trigger condition two
---
```

### Required Fields

| Field         | Description                                                    |
| ------------- | -------------------------------------------------------------- |
| `name`        | Kebab-case identifier (e.g., `incident-response`)              |
| `description` | What this playbook covers; context, not action (1-2 sentences) |
| `summary`     | Actionable step-by-step overview; executable without full read |
| `triggers`    | YAML list of conditions when this playbook applies             |

### Field Specifications

#### `name`

- Kebab-case identifier (e.g., `incident-response`, `release-process`)
- Must match filename (e.g., `incident-response.md` → `name: incident-response`)

#### `description`

- What this playbook covers (context, not action)
- 1-2 sentences explaining the playbook's purpose and scope
- Should NOT contain steps or instructions

**Example:**

```yaml
description: |
  Production incident handling and response procedures for service outages.
```

#### `summary`

- Actionable step-by-step overview
- Must contain all critical steps so agents can execute using only the summary
- Format: numbered or bulleted list of steps
- Each step should be a clear, imperative action

**Example:**

```yaml
summary: |
  1. Acknowledge incident and assess severity
  2. Notify stakeholders via #incidents channel
  3. Identify root cause and implement mitigation
  4. Document timeline and actions taken
  5. Schedule post-mortem within 48 hours
```

#### `triggers`

- YAML list of explicit conditions when this playbook applies
- Lowercase with spaces, present tense
- Include synonym variations for better matching
- Be specific enough for agents to pattern-match

**Format rules:**

- Use present tense: "production incident detected" (not "was detected")
- Use lowercase: "service down" (not "Service Down")
- Include variations: "prod outage", "production incident", "service unavailable"

**Anti-patterns (avoid these):**

```yaml
triggers:
  - help # Too vague
  - something wrong # Not specific enough
  - issue # Could match anything
```

**Good examples:**

```yaml
triggers:
  - production incident detected
  - prod outage reported
  - service unavailable in production
  - pager alert triggered
```

### Trigger Matching

Agents use **case-insensitive substring matching** against current context.

**Example:** If context contains "Production incident detected in payment service",
it will match triggers:

- "production incident detected" ✓
- "prod incident" ✗ (no match - "prod" not in context)
- "incident detected" ✓

## Agent Workflow (Progressive Disclosure)

1. **Scan triggers**: Check all playbook triggers against current context
2. **Load summaries**: For matching playbooks, read only the `summary` field
3. **Select playbook**: Apply conflict resolution rules (see below)
4. **Execute from summary**: Follow steps in the `summary` field
5. **Load full body**: Only if summary references details not provided

### Conflict Resolution

When multiple playbooks match the current context:

1. **Most specific trigger wins**: Prefer playbook with more specific trigger match
2. **Prefer recent**: If tie, use more recently created/updated playbook
3. **Apply multiple**: Non-conflicting playbooks may be applied sequentially

**Example:**

- "production incident detected" matches both `incident-response` and
  `security-incident-response`
- If context also contains "security breach", prefer `security-incident-response`
  (more specific match)

## Example Playbook Template

```yaml
---
name: incident-response
description: |
  Production incident handling and response procedures for service outages
  and degraded performance issues.
summary: |
  1. Acknowledge incident and assess severity (P0/P1/P2)
  2. Notify stakeholders via #incidents Slack channel
  3. Identify root cause using logs and metrics
  4. Implement mitigation (rollback, scale, hotfix)
  5. Document timeline and actions in incident ticket
  6. Schedule post-mortem within 48 hours
triggers:
  - production incident detected
  - prod outage reported
  - service unavailable
  - pager alert triggered
  - system degradation observed
---

# Incident Response Playbook

## Severity Levels

- **P0**: Complete service outage, data loss risk
- **P1**: Major functionality broken, significant user impact
- **P2**: Degraded performance, partial functionality loss

## Detailed Steps

### Step 1: Acknowledge and Assess

...detailed instructions...
```

### Good vs Bad Examples

**Good frontmatter:**

```yaml
name: database-migration
description: |
  Procedures for running database schema migrations in production.
summary: |
  1. Create migration backup point
  2. Run migration in staging first
  3. Apply to production during maintenance window
  4. Verify data integrity
  5. Update runbook with results
triggers:
  - database migration needed
  - schema change required
  - db migration failing
```

**Bad frontmatter:**

```yaml
name: DBMigration # Wrong: should be kebab-case
description: Run migrations # Wrong: too brief, not contextual
summary: Do the migration # Wrong: not actionable steps
triggers:
  - help # Wrong: too vague
  - migration # Wrong: not specific enough
```

## Playbook Index

- [blocked-sync.md](blocked-sync.md) - Automatically unblocks dependent issues when blocking
  issues are closed
- [conducting-pr-reviews.md](conducting-pr-reviews.md) - GitHub-specific PR review process
  (customized from platform-agnostic skill reference)
- [duplicate-detection.md](duplicate-detection.md) - Detects potentially duplicate issues
  when new issues are created
- [enable-signed-commits.md](enable-signed-commits.md) - Process for enabling GPG-signed
  commits with verification
- [label-validation.md](label-validation.md) - Validates issues have required labels before
  state transitions
- [project-sync.md](project-sync.md) - GitHub Project board automation that syncs issue
  state labels to project status columns
- [skill-selection.md](skill-selection.md) - Decision guide for selecting the appropriate
  process skill based on context
- [ticket-lifecycle.md](ticket-lifecycle.md) - Complete ticket lifecycle with grooming,
  refinement, implementation, and verification phases

When adding playbooks, update this index with format:

```markdown
- [playbook-name.md](playbook-name.md) - Brief description from `description` field
```

## Creating New Playbooks

### When to Create a Playbook

**Create playbooks for:**

- Recurring operational procedures (incident response, deployments)
- Multi-step processes requiring coordination
- Procedures with explicit trigger conditions
- Processes that benefit from standardization

**Don't create playbooks for:**

- One-time tasks
- Simple actions that don't need steps
- Decisions (use ADRs instead)
- Role definitions (use roles instead)

### Quick Reference

1. Create file: `docs/playbooks/{name}.md`
2. Add frontmatter with all required fields (name, description, summary, triggers)
3. Write detailed body content
4. Update this README's Playbook Index
5. Run `npm run lint` to validate
6. Create PR for review

## Validation

Playbook frontmatter is validated during:

- **Pre-commit hooks**: Format and syntax validation via prettier
- **CI pipeline**: Markdown linting via markdownlint-cli2
- **Manual check**: Run `npm run lint` to validate all playbook files

Required fields (`name`, `description`, `summary`, `triggers`) are enforced by convention.
Invalid frontmatter will cause YAML parsing errors when playbooks are loaded by agents.

## Troubleshooting

**Issue**: Agent doesn't match expected playbook

- Check trigger specificity - too vague triggers cause mismatches
- Verify trigger uses lowercase with spaces
- Test substring matching against actual context

**Issue**: Multiple playbooks match unexpectedly

- Review trigger overlap between playbooks
- Make triggers more specific to differentiate
- Consider if playbooks should be merged

**Issue**: Summary is insufficient for execution

- Ensure summary contains ALL critical steps
- Add numbered format for clarity
- Include decision points in summary

**Issue**: Frontmatter validation fails

- Ensure YAML syntax is correct (proper indentation, `|` for multiline)
- Check all required fields are present
- Verify `triggers` is a YAML list (with `-` prefix)
- Run `npm run format` to auto-fix formatting issues
