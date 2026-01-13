# Library Migration Planning

## Migration Strategy

### Incremental Migration

Migrate consumers one at a time to reduce risk.

**Process:**

1. **Publish library** to package registry
2. **Migrate pilot consumer** (lowest risk service)
3. **Validate in production** (1-2 weeks)
4. **Migrate remaining consumers** one by one
5. **Remove duplicated code** after all migrated
6. **Keep safety net** for 1 sprint after removal

### Big Bang Migration

Migrate all consumers simultaneously.

**When appropriate:**

- Small number of consumers (2-3)
- Same team owns all consumers
- Monorepo with atomic commits
- Low production risk

**Caution:** Higher risk, harder rollback.

## Pre-Migration Checklist

Before starting migration:

- [ ] Library published to registry
- [ ] Version number established (v1.0.0)
- [ ] README with installation instructions
- [ ] API documentation complete
- [ ] Ownership documented (CODEOWNERS)
- [ ] Support channel established
- [ ] Changelog initialized
- [ ] CI/CD pipeline for library

## Migration Steps

### Step 1: Prepare Library

```bash
# Create library repository
mkdir validation-lib && cd validation-lib

# Initialize package
npm init -y

# Copy code from first consumer
cp ../service-a/utils/validation.ts src/

# Add tests
cp ../service-a/utils/validation.test.ts src/

# Publish initial version
npm publish --tag beta
```

### Step 2: Migrate First Consumer

```bash
# In consumer service
npm install validation-lib@beta

# Update imports
# Before:
# import { validate } from './utils/validation';

# After:
# import { validate } from 'validation-lib';

# Run tests
npm test

# Deploy to staging
npm run deploy:staging

# Validate functionality
# ...

# Deploy to production
npm run deploy:production
```

### Step 3: Validate and Stabilize

Wait 1-2 weeks after first consumer migration:

- Monitor error rates
- Check performance metrics
- Gather feedback from team
- Fix any issues discovered

### Step 4: Migrate Remaining Consumers

For each additional consumer:

```bash
# Install library
npm install validation-lib@1.0.0

# Update imports (same pattern)

# Run tests, deploy staging, validate, deploy production

# Document migration in issue/PR
```

### Step 5: Cleanup

After all consumers migrated:

```bash
# Remove duplicated code
rm service-a/utils/validation.ts
rm service-b/utils/validation.ts
rm service-c/utils/validation.ts

# Update documentation
# Update dependency diagrams
```

## Rollback Strategy

### Consumer-Level Rollback

If a consumer has issues:

```bash
# Revert to local copy
git revert <migration-commit>

# Or pin previous version
npm install validation-lib@0.9.0
```

### Library-Level Rollback

If library has critical bug:

1. **Publish patch** with fix (preferred)
2. **Yank version** from registry (last resort)
3. **Notify all consumers** of issue

### Rollback Triggers

Rollback immediately if:

- Error rate increases >10%
- Performance degrades >20%
- Critical functionality broken
- Security vulnerability discovered

## Communication Plan

### Before Migration

- Announce migration timeline
- Share migration guide
- Establish support channel
- Set expectations for issues

### During Migration

- Update progress in tracking issue
- Report any issues discovered
- Share lessons learned

### After Migration

- Announce completion
- Document migration in ADR
- Update architecture diagrams
- Archive duplicated code (don't delete history)

## Tracking Template

Track migration progress in GitHub issue:

```markdown
## Library Migration: validation-lib

**Status:** In Progress
**Library Version:** v1.0.0
**Target Completion:** 2024-02-15

### Consumers

| Consumer  | Status      | PR   | Notes              |
| --------- | ----------- | ---- | ------------------ |
| service-a | Complete    | #123 | Pilot              |
| service-b | In Progress | #124 |                    |
| service-c | Pending     | -    | Blocked on PR #124 |
| service-d | Pending     | -    |                    |

### Timeline

- [x] Library published (2024-01-15)
- [x] Pilot migration (2024-01-22)
- [ ] All consumers migrated
- [ ] Duplicated code removed
- [ ] Documentation updated

### Issues

- #125: Type definitions missing (fixed in v1.0.1)
```

## Post-Migration Validation

Verify migration success:

- [ ] All consumers using library (no local copies)
- [ ] Tests passing in all consumers
- [ ] No increase in error rates
- [ ] Performance within acceptable range
- [ ] Documentation updated
- [ ] Architecture diagrams reflect new structure
- [ ] Old code removed (after safety period)
