# Architecture Overview

This document describes the architectural patterns, structure, and design principles for this repository.

## Project Purpose

This repository hosts skill specifications and guidance that interoperate with the Superpowers
skills system. It is intentionally lightweight and avoids duplicating the upstream skill library.

**Key Goals:**

- Backlog and specification of new skills to be implemented
- Documentation and references for skills that integrate with Superpowers
- Record decisions without copying upstream skills

## Repository Structure

```text
development-skills/
├── README.md                    # Concise overview, references detailed docs
├── AGENTS.md                    # Agent-specific execution rules
├── CONTRIBUTING.md              # Contribution process and guidelines
├── docs/                        # Human-readable documentation
│   ├── adr/                     # Architecture Decision Records
│   ├── exclusions.md            # Opted-out patterns and suppressions
│   ├── architecture-overview.md # This file
│   ├── coding-standards.md      # Code and documentation standards
│   ├── testing-strategy.md      # Testing approach and patterns
│   └── getting-started.md       # Developer onboarding
├── skills/                      # Agent-facing skill specifications
│   └── {skill-name}/
│       ├── SKILL.md             # Main skill specification
│       └── references/          # Optional: heavy reference material
└── .github/
    └── ISSUE_TEMPLATE/          # Issue templates for consistent specs
```

## Architectural Principles

### Separation of Concerns by Audience

Documentation is separated by audience:

**Human-Centric Documentation** (`docs/`):

- Uses industry-standard terminology
- Aggregated by topic (architecture, coding standards, testing)
- Examples: "Clean Architecture", "TDD", "Integration Testing"

**Agent-Centric Documentation** (`skills/`):

- Uses skill names as identifiers
- Follows agentskills.io specification
- Examples: `architecture-testing`, `greenfield-baseline`

**Key Principle:** Agents translate skill names into human concepts when updating documentation.

### Progressive Loading

Skills follow progressive loading pattern:

- **Main SKILL.md:** Core content, <300 words for frequently-loaded skills
- **references/ subdirectory:** Heavy reference material, loaded on-demand
- **Cross-references:** Point to existing skills to avoid duplication (DRY)

### Integration Architecture

This repository integrates with:

**Superpowers** (Upstream):

- Core skill library: <https://github.com/obra/superpowers>
- Skills here extend and complement (don't duplicate) Superpowers
- Cross-reference Superpowers skills using `**REQUIRED SUB-SKILL:** superpowers:{skill-name}`

**agentskills.io Specification**:

- Standard format for skill specifications
- Ensures interoperability across agent systems
- Reference: <https://agentskills.io/specification>

**GitHub Issues**:

- Work item tracking and task management
- Issue-driven delivery workflow
- Traceability from issue to implementation

## Development Workflow Architecture

### Skills-First Approach

This repository enforces a **skills-first workflow**:

1. Bootstrap Superpowers
2. Load relevant skills (starting with `superpowers:using-superpowers`)
3. Follow process skills (brainstorming, planning, TDD)
4. Implement after skills and plans in place
5. Verify before claiming completion

**No implementation-first:** Jumping straight to code/edits requires explicit user request.

### RED-GREEN-REFACTOR for Documentation

Skill creation follows TDD methodology applied to documentation:

- **RED Phase:** Run baseline scenarios WITHOUT skill, document failures
- **GREEN Phase:** Write minimal skill addressing failures, verify
- **REFACTOR Phase:** Close loopholes, add rationalizations, re-verify

This ensures skills actually solve observed problems, not hypothetical ones.

## Quality Architecture

### Clean Build Principle

**Zero tolerance for warnings or errors:**

- During development: No unresolved warnings in commits or package operations
- Before commits: All linting and static analysis must pass
- Warnings must be resolved immediately

### TDD Enforcement

Test-Driven Development is mandatory for **all changes, including documentation:**

**For code/features:**

- Write failing test first
- Minimal implementation to pass
- Refactor with tests passing

**For documentation:**

- Create BDD checklist of expected statements
- Checklist must fail against current docs
- Edit to make checklist pass

No "verify after" changes allowed.

## Documentation Architecture

### Decision Recording

**ADRs (Architecture Decision Records):**

- Location: `docs/adr/`
- Format: MADR (Markdown Architectural Decision Records)
- Purpose: Record major architectural, tooling, and process decisions
- See: [docs/adr/0000-use-adrs.md](adr/0000-use-adrs.md)

**Exclusions:**

- Location: `docs/exclusions.md`
- Purpose: Track patterns/practices explicitly opted out
- Prevents repeated prompting by agents

### Canonical Skill Priority Model

Skills are classified by priority for conflict resolution:

- **P0 – Safety & Integrity:** Security, immutability, provenance, traceability
- **P1 – Quality & Correctness:** Behavioural correctness, clean builds, contract stability
- **P2 – Consistency & Governance:** Repository conventions, versioning, pipeline conformance
- **P3 – Delivery & Flow:** Incremental execution, developer experience
- **P4 – Optimisation & Convenience:** Ergonomics and non-critical improvements

**Conflict Resolution:**

1. Higher priority wins
2. If equal priority: prefer narrower scope
3. If scope equal: prefer stronger guardrails

## Branching and Merge Strategy

**Branching:**

- GitHub Flow (feature branches from `main`)
- Never commit directly to `main`
- Sub-task branches from feature branches

**Merging:**

- Rebase on latest `main` before merging
- Squash and merge if excessive commits
- Fast-forward only otherwise
- Conventional Commit messages required

See [docs/coding-standards.md](coding-standards.md) for details.

## Testing Architecture

Skills testing is "simulated" (no automated test framework):

- BDD-style assertions defined upfront
- Manual verification against checklists
- Baseline testing (without skill) to identify failures
- Pressure testing (time, sunk cost, exhaustion) for discipline skills

See [docs/testing-strategy.md](testing-strategy.md) for comprehensive testing approach.

## Security Architecture

- **No secrets in commits:** Enforce via git hooks (future)
- **Explicit prerequisites:** Document all required tools and access
- **Least privilege:** Skills should request minimal necessary permissions

## Future Architecture Considerations

Potential additions as repository grows:

- Automated skill validation (schema checking)
- Skill dependency graph visualization
- Automated exclusion checking for agents
- Performance metrics for skill effectiveness

## See Also

- [README.md](../README.md) - Repository standards and quick reference
- [AGENTS.md](../AGENTS.md) - Agent-specific execution rules
- [docs/coding-standards.md](coding-standards.md) - Detailed coding standards
- [docs/testing-strategy.md](testing-strategy.md) - Testing approach
- [docs/adr/](adr/) - Architecture Decision Records
