# AGENTS.md Template

Use this template when creating AGENTS.md for a repository. Replace placeholders
with repository-specific content.

---

## Template Content

Copy the content below to create your AGENTS.md file:

### Agent Onboarding

This document enables agents (with fresh context) to contribute effectively to this repository.

### Repository Overview

**Purpose:** {Brief description of what this repository does}

**Architecture:** {High-level architecture pattern and key components}

**Key Constraints:**

- {Constraint 1: e.g., Must support Node.js 18+}
- {Constraint 2: e.g., Cannot add dependencies over 1MB}
- {Constraint 3: e.g., Must maintain backward compatibility}

### Required Skills

Agents working in this repository must apply these skills:

**External Skills (Superpowers):**

- `superpowers:test-driven-development` - RED-GREEN-REFACTOR for all features
- `superpowers:verification-before-completion` - Evidence before completion claims
- `superpowers:brainstorming` - Explore design before implementing

**Custom Skills (Internal):**

- {skill-name} - {when to use}
- {skill-name} - {when to use}

**Skill Priorities:**

- P0 (Foundation): test-driven-development, verification-before-completion
- P1 (Quality): {quality skills}
- P2 (Architecture): {architecture skills}

### Development Standards

**Code Style:**

- {Linting tool} configured (see {config file})
- {Formatting tool} enforced
- {Language-specific rules}

**Testing:**

- {Coverage requirement}
- {Test location pattern}
- TDD required: write tests before implementation

**Review Process:**

- {Number} approvals required for PR merge
- CI must pass ({list checks})
- Review checklist in {template location}

**Deployment:**

- {Deployment method}
- {Versioning scheme}
- CHANGELOG.md updated for every release

### Repository Conventions

**Directory Structure:**

```text
{root}/
  {dir}/           # {purpose}
    {subdir}/
  {dir}/           # {purpose}
```

**Naming Conventions:**

- Files: {pattern} ({example})
- Classes: {pattern} ({example})
- Functions: {pattern} ({example})
- Constants: {pattern} ({example})

**Documentation:**

- {Where architecture docs live}
- {Where API docs live}
- {Inline documentation requirements}

### Process Guidance

**PR Workflow:**

1. Create feature branch from {main branch} ({pattern})
2. Implement with TDD (tests first)
3. Ensure CI passes locally
4. Create PR with description and testing evidence
5. Address review feedback
6. Await {number} approvals
7. {Merge strategy}

**Deployment Process:**

1. {Step 1}
2. {Step 2}
3. {Step 3}

**Escalation Paths:**

- Technical questions: {contact}
- Architecture decisions: {contact}
- Security concerns: {contact}

### Context Optimization

**What Agents Must Know:**

- {Critical constraint 1}
- {Critical constraint 2}
- {Critical pattern that must not be broken}

**Focus Areas:**

- {Focus 1}
- {Focus 2}

**What Agents Can Skip:**

- Historical context (see git history if needed)
- Team dynamics (focus on technical standards)
- Implementation debates (ADRs record decisions)

### Fresh Context Test

To verify this document enables fresh agent context:

1. Agent with ONLY this document (no conversation history) must be able to:
   - Implement new feature following all standards
   - Know when to use which skills
   - Follow PR and deployment processes
   - Escalate appropriately when needed

2. If fresh agent cannot do above, this document needs improvement.

### Maintenance

- Review AGENTS.md when standards change
- Update when new skills added
- Validate fresh context test still passes
- Keep sections concise (link to detailed docs)

---

## Usage Notes

### Greenfield

- Create AGENTS.md during repository setup
- Document intended standards before first code
- Reference external skills proactively

### Brownfield

- Analyze repository to discover existing standards
- Document discovered patterns in AGENTS.md
- Test fresh context scenario to validate completeness
