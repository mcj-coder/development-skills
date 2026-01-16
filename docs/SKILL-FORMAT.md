# Skill Format Specification

This document defines the skill format for the development-skills repository, extending
the [agentskills.io specification](https://agentskills.io/specification) with repository-specific
conventions.

## Directory Structure

```text
skills/<skill-name>/
├── SKILL.md                    # Required: Main skill documentation
├── <skill-name>.test.md        # Required: BDD tests for skill behavior
├── <skill-name>.baseline.md    # Optional: Baseline verification checklist
├── references/                 # Optional: Supporting documentation
│   ├── README.md              # Required if references/ exists: Index of reference files
│   └── <topic>.md             # Reference docs (self-contained)
├── templates/                  # Optional: Reusable templates
│   └── <template>.template     # Template files
├── scripts/                    # Optional: Executable scripts
│   ├── README.md              # Required if scripts/ exists: Index of scripts
│   └── <script>.sh            # Script files
└── examples/                   # Optional: Example implementations
    └── <example>.md           # Example documentation
```

## SKILL.md Format

### Required Frontmatter

```yaml
---
name: skill-name
description: >-
  Use when [trigger conditions]. [What the skill does].
  [Additional context about when to apply].
---
```

### Extended Frontmatter (Recommended)

```yaml
---
name: skill-name
description: >-
  Use when [trigger conditions]. [What the skill does].
compatibility: Requires [prerequisites]
metadata:
  type: Process | Implementation | Platform | Quality
  priority: P0 | P1 | P2 | P3 | P4
---
```

### Frontmatter Fields

| Field               | Required | Description                                                                   |
| ------------------- | -------- | ----------------------------------------------------------------------------- |
| `name`              | Yes      | Lowercase kebab-case. Must match directory name. Max 64 chars.                |
| `description`       | Yes      | Trigger conditions and purpose. Max 1024 chars. Should start with "Use when". |
| `compatibility`     | No       | Environment requirements (CLIs, platforms, dependencies).                     |
| `metadata.type`     | No       | Skill category: Process, Implementation, Platform, Quality.                   |
| `metadata.priority` | No       | Skill priority following the Priority Model (P0-P4).                          |

### Priority Model

Skills are classified by priority for conflict resolution:

| Priority | Category                   | Description                                         |
| -------- | -------------------------- | --------------------------------------------------- |
| P0       | Safety & Integrity         | Security, immutability, provenance, traceability    |
| P1       | Quality & Correctness      | Behavioral correctness, clean builds, test validity |
| P2       | Consistency & Governance   | Conventions, versioning, pipeline conformance       |
| P3       | Delivery & Flow            | Incremental execution, developer experience         |
| P4       | Optimization & Convenience | Ergonomics, non-critical improvements               |

When skills conflict: higher priority wins. If equal: prefer narrower scope. If scope equal:
prefer stronger guardrails.

### Skill Type Categories

| Type           | Description                       | Examples                                           |
| -------------- | --------------------------------- | -------------------------------------------------- |
| Process        | Workflow and methodology guidance | TDD, issue-driven-delivery, skills-first-workflow  |
| Implementation | Technology-specific patterns      | dotnet-efcore-practices, architecture-testing      |
| Platform       | Platform/tooling integration      | automated-standards-enforcement, ci-cd-conformance |
| Quality        | Code quality and standards        | broken-window, static-analysis-security            |

## Required Sections

Every SKILL.md must contain these sections in order:

### 1. Title

```markdown
# Skill Name
```

Use title case. Must match the frontmatter `name` field (converted from kebab-case).

### 2. Overview

```markdown
## Overview

[2-4 sentences describing the skill's purpose and core value proposition]

**REQUIRED:** [list of required prerequisite skills, if any]
```

### 3. When to Use

```markdown
## When to Use

[Bullet list of trigger conditions when this skill should be activated]

- Condition 1
- Condition 2
- **Opt-out offered:** [optional: when skill can be declined]
```

### 4. Core Workflow

```markdown
## Core Workflow

[Numbered steps for the primary workflow]

1. Step 1
2. Step 2
3. Step 3
```

## Recommended Sections

### Prerequisites

```markdown
## Prerequisites

- [Required tool or configuration]
- [Required skill or capability]
```

### Red Flags - STOP

```markdown
## Red Flags - STOP

- "Rationalization quote 1"
- "Rationalization quote 2"
```

Use this section to identify anti-patterns or thoughts that indicate the skill is being
circumvented.

### Evidence Requirements

```markdown
## Evidence Requirements

- [ ] Evidence item 1
- [ ] Evidence item 2
```

### References

```markdown
## References

- [Reference Name](references/reference-file.md) - Brief description
- [External Resource](https://example.com) - Brief description
```

### Quick Reference

```markdown
## Quick Reference

| Scenario | Action | Result    |
| -------- | ------ | --------- |
| Case 1   | Do X   | Y happens |
```

## Optional Sections

These sections are included when relevant to the skill:

- `## Detection and Deference` - When to defer to existing patterns
- `## Decision Capture` - How decisions should be documented
- `## Composition` - How this skill interacts with others
- `## Success Criteria` - Measurable outcomes for skill application
- `## Sample Commands` - Executable examples
- `## Templates` - Inline or linked templates

## Test File Format

Every skill requires a colocated test file: `<skill-name>.test.md`

```markdown
# <Skill Name> - BDD Tests

## Scenario: [Scenario Name]

**Given:** [Initial state]
**When:** [Action taken]
**Then:** [Expected outcome]

### Verification

- [ ] [Specific verifiable outcome]
- [ ] [Another verifiable outcome]
```

See [BDD Checklist Templates](references/bdd-checklist-templates.md) for detailed guidance.

## References Directory

When a skill has a `references/` directory, it must contain a `README.md` index:

```markdown
# References

Index of reference documentation for the [skill-name] skill.

## Contents

| File                         | Description                  |
| ---------------------------- | ---------------------------- |
| [file-name.md](file-name.md) | Brief description of content |
```

## Self-Containment Principle

Skills must be self-contained and deployable independently:

**Required:**

- All references must be to files within `skills/<skill-name>/`
- Describe external concepts generically, not with repository-specific links
- Platform-specific examples should cover GitHub, Azure DevOps, and Jira where applicable

**Prohibited:**

- References to `../../docs/` or other paths outside the skill folder
- Links to repository-specific artifacts that may not exist when deployed elsewhere
- Assumptions about repository structure beyond the skill folder

## Validation Checklist

Before committing a skill:

- [ ] Frontmatter has required `name` and `description` fields
- [ ] `name` matches directory name (lowercase kebab-case)
- [ ] `description` starts with "Use when" trigger conditions
- [ ] Overview section present (2-4 sentences)
- [ ] When to Use section present with bullet list
- [ ] Core Workflow section present with numbered steps
- [ ] Test file exists: `<skill-name>.test.md`
- [ ] No `../../` references in any files
- [ ] All internal links resolve to files within skill folder
- [ ] `references/README.md` exists if `references/` directory exists
- [ ] Passes `npm run lint`

## Examples

### Minimal Valid Skill

```yaml
---
name: example-skill
description: Use when example conditions apply. Provides example guidance.
---
```

```markdown
# Example Skill

## Overview

Brief description of what this skill does and its core value.

## When to Use

- Example trigger condition

## Core Workflow

1. First step
2. Second step
3. Third step
```

### Complete Skill with Extensions

See `skills/skills-first-workflow/SKILL.md` for a comprehensive example including
all recommended sections.
