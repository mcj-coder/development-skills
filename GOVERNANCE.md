# Governance

This document describes the governance model for the development-skills
repository, including decision-making processes, maintainer responsibilities,
and contribution acceptance criteria.

## Maintainers

The current maintainers of this repository are defined in
[.github/CODEOWNERS](.github/CODEOWNERS).

| Role            | GitHub Handle                              | Responsibilities          |
| --------------- | ------------------------------------------ | ------------------------- |
| Lead Maintainer | [@mcj-coder](https://github.com/mcj-coder) | All repository governance |

## Maintainer Responsibilities

Maintainers are responsible for:

- Responding to issues and pull requests within documented SLA
- Ensuring CI/CD pipeline remains healthy
- Reviewing and merging contributions meeting quality bar
- Maintaining documentation accuracy
- Managing releases and versioning
- Communicating breaking changes and deprecations
- Enforcing the [Code of Conduct](CODE_OF_CONDUCT.md)

### Review Turnaround Expectations

| Activity        | Target                                         |
| --------------- | ---------------------------------------------- |
| Acknowledgement | Within 2 business days                         |
| Initial review  | Within 5 business days                         |
| Merge decision  | Within 10 business days of addressing feedback |

## Contribution Acceptance Criteria

Before a contribution can be accepted:

1. **Issue first** - All non-trivial changes require a linked GitHub issue
2. **Branch naming** - Follow repository conventions (`feat/`, `fix/`, `docs/`)
3. **PR template** - Use provided template with required sections filled
4. **Code review** - Minimum one approval from CODEOWNERS
5. **CI passing** - All automated checks must pass (linting, tests)
6. **Documentation** - User-facing changes require docs updates
7. **TDD compliance** - All changes require failing test/checklist first

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## Decision-Making Process

All significant decisions follow a transparent process:

1. **Proposed** - Create an issue or ADR with context and options
2. **Discussed** - Allow comment period (varies by category)
3. **Decided** - Document rationale and decision maker
4. **Communicated** - Announce in appropriate channels

### Decision Categories

| Category             | Decision Maker       | Comment Period   |
| -------------------- | -------------------- | ---------------- |
| Bug fixes            | Any maintainer       | None required    |
| Minor features       | Component owner      | 2 business days  |
| Major features       | Lead maintainer      | 5 business days  |
| Architecture changes | Maintainer consensus | 10 business days |
| Governance changes   | All maintainers      | 10 business days |

### Architecture Decision Records (ADRs)

Major architectural decisions are documented in [docs/adr/](docs/adr/). ADRs
follow the format defined in [ADR-0001](docs/adr/ADR-0001-use-adrs.md).

## Conflict Resolution

1. **Discussion** - Attempt resolution through discussion on the issue/PR
2. **Mediation** - Escalate to lead maintainer for mediation
3. **Escalation** - If unresolved, escalate to organisation's technical
   leadership

## Changes to Governance

Changes to this governance document require:

- A GitHub issue describing the proposed change
- 10 business days comment period
- Approval from all active maintainers
- PR with the change referencing the issue

## References

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Architecture Decision Records](docs/adr/)
