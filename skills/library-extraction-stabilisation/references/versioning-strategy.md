# Library Versioning Strategy

## Semantic Versioning (SemVer)

Use SemVer (`MAJOR.MINOR.PATCH`) for all extracted libraries.

### Version Semantics

| Change Type                       | Version Bump | Example          |
| --------------------------------- | ------------ | ---------------- |
| Breaking change                   | MAJOR        | v1.x.x to v2.0.0 |
| New feature (backward compatible) | MINOR        | v1.0.x to v1.1.0 |
| Bug fix                           | PATCH        | v1.0.0 to v1.0.1 |

### Pre-1.0 Libraries

For libraries not yet stable (v0.x.x):

- MINOR version for breaking changes
- PATCH version for bug fixes and features
- Document "pre-release" status clearly
- Set expectations for frequent changes

**Promotion criteria to v1.0.0:**

- 3+ consumers in production
- Less than 2 changes/month for 3 months
- Ownership and support model defined
- Breaking change policy established

## Breaking Change Policy

### What Constitutes a Breaking Change

- Removing public API methods
- Changing method signatures
- Changing return types
- Changing configuration format
- Dropping runtime/language support

### Breaking Change Process

1. **RFC required** - Document change rationale
2. **Notice period** - Minimum 1 quarter (3 months)
3. **Deprecation phase** - Mark old API deprecated
4. **Migration guide** - Document upgrade path
5. **Support window** - Previous major for 6 months

### Deprecation Workflow

```typescript
/**
 * @deprecated Use `newMethod()` instead. Will be removed in v3.0.0.
 * Migration guide: https://docs.example.com/lib/migration-v2-v3
 */
export function oldMethod(): void {
  console.warn("oldMethod is deprecated. Use newMethod() instead.");
  return newMethod();
}
```

## Support Windows

### Active Support

| Version        | Status      | Support Until            |
| -------------- | ----------- | ------------------------ |
| Latest major   | Active      | Ongoing                  |
| Previous major | Maintenance | 6 months after new major |
| Older majors   | EOL         | No support               |

### Maintenance Mode

For previous major versions:

- Security fixes only
- Critical bug fixes only
- No new features
- Consumers encouraged to upgrade

## Release Cadence

### Recommended Cadence

| Release Type | Frequency     | Notice         |
| ------------ | ------------- | -------------- |
| Patch        | As needed     | None           |
| Minor        | Monthly       | Release notes  |
| Major        | Quarterly max | 3-month notice |

### Pre-Release Versions

Use pre-release tags for testing:

- `v2.0.0-alpha.1` - Early testing
- `v2.0.0-beta.1` - Feature complete
- `v2.0.0-rc.1` - Release candidate

## Changelog Format

Use [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

## [Unreleased]

### Added

- New validation method `validateEmail()`

### Changed

- Improved error messages

### Deprecated

- `oldValidate()` - use `validate()` instead

### Removed

- Nothing

### Fixed

- Race condition in async validation

### Security

- Updated dependency to patch CVE-2024-1234

## [1.2.0] - 2024-01-15

### Added

- Phone number validation
```

## Version Pinning Recommendations

### For Consumers

```json
{
  "dependencies": {
    "validation-lib": "^1.2.0"
  }
}
```

- Use caret (`^`) for minor/patch updates
- Pin exact version for critical production
- Use lock files (package-lock.json, yarn.lock)

### For Library Authors

- Pin exact versions of dependencies
- Avoid peer dependency conflicts
- Test against multiple consumer environments
