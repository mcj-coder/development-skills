# Excluded Patterns and Suppressions

This document lists patterns, checks, and automated processes that have been explicitly excluded or
suppressed for this repository.

**Purpose:** Prevents agents from repeatedly prompting about declined patterns. Agents must check this
file before suggesting excluded patterns.

**Format:** Each exclusion includes the human-readable pattern name, agent skill mapping (for agent
reference), reason, date, and scope.

---

## How to Use This Document

### For Agents

**Before suggesting any pattern or practice:**

1. Search this document for related exclusions
2. If pattern is excluded with matching scope, DO NOT re-prompt user
3. Only mention the pattern if context has changed significantly (note this briefly)

**When user opts out of a pattern:**

1. Add entry to appropriate section below
2. Use human-readable terminology (primary)
3. Include agent skill mapping (parenthetical reference)
4. Keep concise (1-3 sentences)

### For Humans

Review this document to understand what automated patterns and practices have been explicitly declined for this project.

If context changes and you want to reconsider an exclusion, open a discussion issue or PR to remove it.

---

## Architecture and Design

_No exclusions currently._

**Example format:**

```markdown
### Automated Architecture Boundary Enforcement

- **Agent Skill:** `architecture-testing`
- **Description:** Automated validation of architectural boundaries using tools like NetArchTest
- **Status:** Excluded
- **Reason:** Simple learning project without production deployment requirements
- **Date:** 2026-01-05
- **Scope:** Project-wide
- **Reconsider When:** Project moves to production or team size grows beyond 3 developers
```

---

## Observability and Monitoring

_No exclusions currently._

---

## Testing Patterns

_No exclusions currently._

---

## Quality Gates

_No exclusions currently._

---

## Development Workflow

_No exclusions currently._

---

## Security Practices

_No exclusions currently._

---

## Notes

### Adding Exclusions

- Create PR updating this file with clear rationale
- Use human-readable pattern names
- Include enough context for future reference
- Specify scope (project-wide, component-specific, temporary)

### Challenging Exclusions

- If context has changed significantly, open discussion issue
- Don't repeatedly re-propose excluded patterns without new context
- Document why context change makes pattern relevant again

### Exclusions vs Suppressions

- **Exclusion:** Pattern declined entirely (not applicable or not wanted)
- **Suppression:** Pattern applied but with specific warnings/checks disabled
  - List suppressions with rationale
  - Example: "Architecture tests enabled but suppressing validation for legacy module X"

### Temporary Exclusions

Some exclusions may be temporary (e.g., "not until we reach production"). Mark these clearly:

- **Status:** Excluded (Temporary)
- **Reconsider When:** {Specific condition or milestone}
