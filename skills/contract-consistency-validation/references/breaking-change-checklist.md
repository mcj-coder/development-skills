# Breaking Change Checklist

## Quick Reference

Use this checklist when evaluating contract changes for breaking impact.

## Change Classification

### Definitely Breaking

- [ ] Removed field from response
- [ ] Removed endpoint/method
- [ ] Changed field type (string to int, etc.)
- [ ] Changed null handling (null to error, empty to null)
- [ ] Changed HTTP status codes for same conditions
- [ ] Changed error format or codes
- [ ] Renamed required parameters
- [ ] Changed authentication requirements

### Potentially Breaking

- [ ] Added required field to request
- [ ] Changed default values
- [ ] Changed field optionality (optional to required)
- [ ] Changed validation rules (stricter)
- [ ] Changed rate limits
- [ ] Changed pagination behavior

### Usually Safe (But Verify)

- [ ] Added optional field to response
- [ ] Added new endpoint
- [ ] Added optional parameter with default
- [ ] Relaxed validation rules
- [ ] Extended enum values (consumer-dependent)

## SemVer Decision Tree

```text
Is this a breaking change?
├── YES → Major version bump (v1.0.0 → v2.0.0)
│   └── Pre-1.0? → Minor bump + ADR required
└── NO → Is this new functionality?
    ├── YES → Minor version bump (v1.0.0 → v1.1.0)
    └── NO → Patch version bump (v1.0.0 → v1.0.1)
```

## Consumer Impact Assessment

### Questions to Answer

1. **Who consumes this contract?**
   - Public API (external, unknown consumers)
   - Internal services (known, controllable)
   - SDKs/Client libraries (versioned separately)

2. **What is the migration effort?**
   - Code changes required?
   - Testing required?
   - Deployment coordination needed?

3. **What is the timeline?**
   - Immediate break acceptable?
   - Deprecation period needed?
   - Parallel version support required?

## CHANGELOG Entry Template

When documenting a breaking change in CHANGELOG.md, include:

- **Change:** Description of what changed
- **Impact:** Which consumers/use cases affected
- **Migration:** Steps to update consumer code
- **Example:** Before/after code showing the migration
- **Timeline:** Breaking in vX.0.0 (release date)

## Alternatives to Breaking Changes

| Approach      | When to Use            | Trade-offs             |
| ------------- | ---------------------- | ---------------------- |
| **Extend**    | Add new optional field | May accumulate cruft   |
| **Version**   | Add v2 endpoint        | Maintenance overhead   |
| **Deprecate** | Mark old, add new      | Requires communication |
| **Break**     | Clean slate needed     | Requires coordination  |

## Pre-1.0 ADR Requirements

When requesting pre-1.0 relaxed enforcement, the ADR must include:

- **Status:** Accepted
- **Date:** When decision was made
- **Scope:** Valid until v1.0.0 release
- **Context:** Why rapid iteration is needed
- **Decision:** Allow breaking changes without major version bumps
- **Requirements:**
  1. Every breaking change requires user confirmation
  2. Every breaking change documented in CHANGELOG
  3. Migration guides provided for each break
  4. Relaxation expires at v1.0.0
- **Graduation:** At v1.0.0, switch to strict SemVer enforcement

## V1+ Exception ADR Requirements

When requesting a v1+ breaking change exception, the ADR must include:

- **Status:** Proposed, Accepted, or Rejected
- **Date:** When proposed
- **Version Impact:** Which version affected
- **Business Justification:** Why exception is necessary
- **Technical Rationale:** Why alternatives do not work
- **Consumer Impact:**
  - Affected consumers (list)
  - Migration timeline (dates)
  - Communication plan (how notified)
- **Approvals Required:**
  - Tech Lead
  - Product Lead
  - Consumer Representatives
- **Rollback Plan:** Procedure if consumers break
