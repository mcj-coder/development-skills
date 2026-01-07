# Team Roles

## Overview

Team role definitions for both human teams and agent perspectives. These roles provide standardized
expert perspectives during code reviews, planning, and validation.

## Frontmatter Standard

All role documents MUST include YAML frontmatter with these fields:

```yaml
---
name: role-name
description: |
  When to use this role and what expertise it provides.
  Include specific trigger conditions for agents.
model: balanced # Task-based model tier
---
```

### Required Fields

| Field         | Description                                                                                  |
| ------------- | -------------------------------------------------------------------------------------------- |
| `name`        | Kebab-case identifier (e.g., `tech-lead`, `senior-developer`)                                |
| `description` | When to use this role; must be sufficient for agents to select without reading full document |
| `model`       | Task-based model tier (see below)                                                            |

### Model Tiers

Task-based values that map to platform-specific models:

| Value       | Use Case                                                   | Claude                | OpenAI      |
| ----------- | ---------------------------------------------------------- | --------------------- | ----------- |
| `reasoning` | Complex analysis, architecture decisions, security reviews | opus, claude-sonnet-4 | o3, gpt-4.1 |
| `balanced`  | General development, code review, implementation           | sonnet                | gpt-4o      |
| `speed`     | Quick lookups, formatting, validation                      | haiku                 | gpt-4o-mini |
| `inherit`   | Use parent/caller's model (default)                        | —                     | —           |

### Example

```yaml
---
name: tech-lead
description: |
  Use for technical architecture decisions, design reviews, and cross-cutting
  concerns. Validates system design, evaluates trade-offs, and ensures
  architectural consistency.
model: reasoning # Complex analysis → opus, o3
---
```

## Role Index

### Development Roles

- **[Tech Lead](tech-lead.md)** - Technical architecture and design oversight
- **[Senior Developer](senior-developer.md)** - Code quality and implementation excellence
- **[QA Engineer](qa-engineer.md)** - Quality assurance and testing strategy

### Security and Performance

- **[Security Reviewer](security-reviewer.md)** - Security and threat modelling
- **[Performance Engineer](performance-engineer.md)** - Performance optimization and scalability
- **[Security Architect](security-architect.md)** - Security architecture and compliance

### Operations and Infrastructure

- **[DevOps Engineer](devops-engineer.md)** - Deployment, operations, and infrastructure
- **[Cloud Architect](cloud-architect.md)** - Cloud infrastructure and platform design

### Product and Design

- **[Product Owner](product-owner.md)** - Business value and requirements
- **[UX Expert](ux-expert.md)** - User experience and interface design
- **[Accessibility Expert](accessibility-expert.md)** - Accessibility and inclusive design

### Documentation and Architecture

- **[Documentation Specialist](documentation-specialist.md)** - Documentation quality and accessibility
- **[Technical Architect](technical-architect.md)** - Enterprise architecture and system design
- **[Agent Skill Engineer](agent-skill-engineer.md)** - Agent skill design and optimization

## Using Roles in Skills

When creating or updating skills:

1. **Identify relevant roles**: Determine which expert perspectives apply
2. **Reference in "When to Use"**: Mention which roles should review
3. **Include in BDD tests**: Test scenarios with role perspectives
4. **Document in examples**: Show role usage in examples

### Example

```markdown
## When to Use

This skill should be reviewed by:

- **Tech Lead**: Validate architecture decisions
- **Senior Developer**: Review code quality
- **Security Reviewer**: Check for vulnerabilities
```

### In BDD Tests

```markdown
### GREEN Scenario: Multi-role review

**Given**: Implementation complete
**When**: Requesting code review
**Then**: Each role provides perspective:

- Tech Lead: ✅ Architecture sound
- Security Reviewer: ✅ No vulnerabilities found
- Senior Developer: ✅ Code quality excellent
```

### In Code Review Requests

```markdown
Please review from these perspectives:

**@role:security** - Authentication flow and input validation
**@role:performance** - Database query efficiency
**@role:senior-dev** - Code organization and clarity
```

## Canonical Names

Use these exact names when referencing roles:

- `Tech Lead` (not: "Technical Lead", "Architect", "Tech Arch")
- `Senior Developer` (not: "Developer", "Sr Dev", "Engineer")
- `QA Engineer` (not: "QA", "Tester", "Quality Assurance")
- `Security Reviewer` (not: "Security", "Sec Engineer", "AppSec")
- `Performance Engineer` (not: "Performance", "Perf Engineer")
- `DevOps Engineer` (not: "DevOps", "SRE", "Ops")
- `Product Owner` (not: "PO", "Product", "Product Manager")
- `Documentation Specialist` (not: "Docs", "Tech Writer")
- `UX Expert` (not: "UX", "UX Designer", "UI/UX")
- `Accessibility Expert` (not: "A11y", "Accessibility", "WCAG Expert")
- `Agent Skill Engineer` (not: "Skill Engineer", "Agent Engineer", "Prompt Engineer")
- `Technical Architect` (not: "Architect", "Enterprise Architect", "Solutions Architect")
- `Security Architect` (not: "Sec Arch", "AppSec Architect", "InfoSec")
- `Cloud Architect` (not: "Cloud Engineer", "Infrastructure Architect", "Platform Architect")

## External Role References

- **Code Reviewer**: See `superpowers:receiving-code-review` (not editable here)

## Reference Format

**In markdown**: `**Tech Lead**` or `@role:tech-lead`

**In code comments**: `@role tech-lead` or `// Review: Tech Lead perspective needed`
