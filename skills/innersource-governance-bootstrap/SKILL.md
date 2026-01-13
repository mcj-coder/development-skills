---
name: innersource-governance-bootstrap
description: Use when establishing InnerSource governance in a repository to enable internal open-source collaboration patterns, standardised contribution workflows, and community-driven development practices within an organisation.
---

## Core

### When to use

- Setting up a new repository that will follow InnerSource principles.
- Converting an existing repository to InnerSource governance model.
- Establishing contribution guidelines for internal open-source projects.
- Bootstrapping community documentation (CONTRIBUTING, CODE_OF_CONDUCT, etc.).
- Defining maintainer responsibilities and ownership models.

### Policy (non-negotiable)

- All InnerSource repositories MUST have explicit contribution guidelines.
- Ownership and maintainer responsibilities MUST be documented.
- Decision-making processes MUST be transparent and documented.
- Code review requirements MUST be defined before accepting contributions.

## Load: documentation-requirements

### Required documentation artifacts

Every InnerSource repository MUST contain these files:

| File                 | Purpose                                                 |
| -------------------- | ------------------------------------------------------- |
| `README.md`          | Project overview, getting started, and quick links      |
| `CONTRIBUTING.md`    | How to contribute, coding standards, PR process         |
| `CODE_OF_CONDUCT.md` | Expected behaviour and enforcement procedures           |
| `CODEOWNERS`         | Defines ownership and required reviewers per path       |
| `GOVERNANCE.md`      | Decision-making process and maintainer responsibilities |

### Optional but recommended

| File                      | Purpose                                             |
| ------------------------- | --------------------------------------------------- |
| `SUPPORT.md`              | How to get help, support channels, SLA expectations |
| `SECURITY.md`             | Vulnerability reporting process                     |
| `docs/adr/`               | Architecture Decision Records for major decisions   |
| `docs/getting-started.md` | Detailed onboarding for new contributors            |

## Load: contribution-workflow

### Contribution acceptance criteria

Before a contribution can be accepted:

1. **Issue first** - All non-trivial changes require a linked issue.
2. **Branch naming** - Follow repository conventions (e.g., `feat/`, `fix/`, `docs/`).
3. **PR template** - Use provided template with required sections filled.
4. **Code review** - Minimum one approval from CODEOWNERS.
5. **CI passing** - All automated checks must pass.
6. **Documentation** - User-facing changes require docs updates.

### Review turnaround expectations

- Acknowledgement: Within 2 business days.
- Initial review: Within 5 business days.
- Merge decision: Within 10 business days of addressing feedback.

Document expectations in `CONTRIBUTING.md` or `GOVERNANCE.md`.

## Load: ownership-model

### Maintainer responsibilities

Maintainers MUST:

- Respond to issues and PRs within documented SLA.
- Ensure CI/CD pipeline remains healthy.
- Review and merge contributions meeting quality bar.
- Maintain documentation accuracy.
- Manage releases and versioning.
- Communicate breaking changes and deprecations.

### CODEOWNERS configuration

Define ownership at appropriate granularity:

```text
# Default owners for everything
*                       @org/team-name

# Component-specific owners
/src/api/               @org/api-team
/src/ui/                @org/frontend-team
/docs/                  @org/docs-team

# Critical paths require additional review
/src/security/          @org/security-team @org/team-name
```

### Succession planning

- Document backup maintainers for each component.
- Define process for maintainer rotation or handoff.
- Ensure no single point of failure for critical paths.

## Load: decision-making

### Transparent decision process

All significant decisions MUST be:

1. **Proposed** - Create RFC issue or ADR with context and options.
2. **Discussed** - Allow comment period (minimum 5 business days for major decisions).
3. **Decided** - Document rationale and decision maker.
4. **Communicated** - Announce in appropriate channels.

### Decision categories

| Category             | Decision maker       | Comment period   |
| -------------------- | -------------------- | ---------------- |
| Bug fixes            | Any maintainer       | None required    |
| Minor features       | Component owner      | 2 business days  |
| Major features       | Lead maintainer(s)   | 5 business days  |
| Architecture changes | Maintainer consensus | 10 business days |
| Governance changes   | All maintainers      | 10 business days |

### Conflict resolution

1. Attempt resolution through discussion on the issue/PR.
2. Escalate to lead maintainer for mediation.
3. If unresolved, escalate to organisation's technical leadership.

## Load: bootstrap-checklist

### Initial setup checklist

When bootstrapping InnerSource governance:

- [ ] Create `README.md` with project overview and quick links.
- [ ] Create `CONTRIBUTING.md` with contribution workflow.
- [ ] Create `CODE_OF_CONDUCT.md` (adopt standard like Contributor Covenant).
- [ ] Create `CODEOWNERS` with initial ownership assignments.
- [ ] Create `GOVERNANCE.md` with decision-making process.
- [ ] Configure branch protection requiring CODEOWNERS approval.
- [ ] Set up issue templates for bugs, features, and RFCs.
- [ ] Set up PR template with required sections.
- [ ] Configure CI/CD to run on all PRs.
- [ ] Document review turnaround expectations.
- [ ] Announce InnerSource status to potential contributors.

### Ongoing maintenance

- Review and update CODEOWNERS quarterly or when team changes.
- Audit contribution metrics monthly.
- Review governance effectiveness annually.
- Update documentation when processes change.

## Load: metrics-and-health

### Contribution health indicators

Track these metrics to assess InnerSource health:

| Metric                  | Healthy threshold | Action if below                      |
| ----------------------- | ----------------- | ------------------------------------ |
| PR review time          | < 5 business days | Add reviewers or reduce scope        |
| Issue response time     | < 2 business days | Improve triage process               |
| External contributions  | > 20% of PRs      | Improve documentation and onboarding |
| Documentation freshness | < 6 months stale  | Schedule documentation sprint        |

### Community growth indicators

- Number of unique contributors (monthly).
- Number of external (outside core team) contributors.
- Issue/PR participation from non-maintainers.
- Documentation contributions.

## Agent rule: enforcement

When reviewing a repository claiming InnerSource status:

1. Verify all required documentation exists and is complete.
2. Check CODEOWNERS is configured and enforced.
3. Confirm branch protection is enabled.
4. Validate contribution workflow is documented.
5. Flag any missing or outdated governance documentation.
6. Mark repository as **non-compliant** if core requirements missing.
