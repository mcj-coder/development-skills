# Library Governance Models

## Ownership Models

### Dedicated Team

A single team owns the library full-time.

**When to use:**

- Critical shared infrastructure
- High consumer count (10+)
- Frequent changes expected
- Strong SLA requirements

**Responsibilities:**

- Feature development
- Bug fixes (2-day SLA)
- Breaking change management
- Consumer support
- Documentation maintenance

### Rotating Ownership

Ownership rotates between consuming teams.

**When to use:**

- Stable, low-change library
- Multiple teams with equal stake
- No team has dedicated capacity
- Community-driven development

**Rotation schedule:**

- Quarterly rotation recommended
- 2-week handoff overlap
- Clear runbook for owners
- Escalation path documented

### Community Model

All consumers contribute equally.

**When to use:**

- Utility libraries with minimal changes
- Self-service model appropriate
- Low support expectations
- Open-source-style governance

**Requirements:**

- Clear contribution guidelines
- Automated testing and CI
- Self-service documentation
- Minimal breaking changes

## Support Models

### SLA-Based Support

| Severity | Response Time | Resolution Time |
| -------- | ------------- | --------------- |
| Critical | 4 hours       | 24 hours        |
| High     | 1 day         | 3 days          |
| Medium   | 3 days        | 1 week          |
| Low      | 1 week        | Best effort     |

**Appropriate when:**

- Business-critical library
- Dedicated ownership team
- Clear escalation path exists

### Best-Effort Support

- No guaranteed response time
- Community answers questions
- Bug fixes as capacity allows
- Breaking changes with notice

**Appropriate when:**

- Utility or convenience library
- Consumers can fork if needed
- Low change frequency
- Community ownership model

## Documentation Requirements

Every library must document:

```markdown
## {Library Name}

**Owner:** {Team/Individual}
**Support:** {SLA-based | Best-effort}
**Repository:** {URL}
**Package:** {Registry URL}

**Purpose:**
{What problem does this solve}

**Consumers:**

- service-a (since v2.3.0)
- service-b (since v1.8.0)

**Contact:**

- Issues: {repo}/issues
- Slack: #lib-{name}-support
- Email: {team}@example.com
```

## Ownership Transfer

When transferring ownership:

1. **Document transfer** in CHANGELOG
2. **Update CODEOWNERS** file
3. **Handoff meeting** with new owner
4. **Shadow period** (2 weeks minimum)
5. **Announce to consumers** via changelog/email
