# scoped-colocation - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: New Feature Creation - Layer-First Organization

**Given** agent WITHOUT scoped-colocation skill
**And** user says: "Add a new user profile feature"
**When** agent creates files
**Then** record baseline behaviour:

- Does agent organize by feature? (expected: NO - creates UserController in controllers/, UserService in services/)
- Does agent colocate tests? (expected: NO - puts tests in separate test directory)
- Does agent keep related assets together? (expected: NO - scatters files across technical layers)
- Rationalizations observed: "Following existing project structure", "Separation of concerns"

### Test R2: Test File Placement

**Given** agent WITHOUT scoped-colocation skill
**And** existing feature in `src/features/orders/`
**When** user says: "Add tests for the Orders feature"
**Then** record baseline behaviour:

- Does agent colocate tests? (expected: NO - creates tests/orders/ or **tests**/)
- Does agent check existing conventions? (expected: MAYBE - but defaults to separate tree)
- Rationalizations observed: "Tests should be separate from source", "Standard testing convention"

### Test R3: Utility Function Creation

**Given** agent WITHOUT scoped-colocation skill
**And** user says: "Add a date formatting function for the invoice feature"
**When** agent creates the utility
**Then** record baseline behaviour:

- Does agent place in feature directory? (expected: NO - creates utils/dateUtils.ts)
- Does agent check if truly shared? (expected: NO - assumes utilities should be shared)
- Rationalizations observed: "Utilities should be reusable", "Might need this elsewhere"

### Expected Baseline Failures Summary

- [ ] Agent organizes by technical layer (controllers/, services/, models/)
- [ ] Agent places tests in separate directory tree
- [ ] Agent extracts utilities to shared location prematurely
- [ ] Agent does not consider feature ownership when placing code
- [ ] Agent scatters related files across the codebase

## GREEN Phase - WITH Skill

### Test G1: New Feature Creation with Colocation

**Given** agent WITH scoped-colocation skill
**When** user says: "Add a new user profile feature with service, controller, and tests"
**Then** agent responds with colocation proposal including:

- Feature directory structure
- All related files in one location
- Colocated tests

**And** agent creates:

```text
src/features/user-profile/
  UserProfileController.cs
  UserProfileService.cs
  UserProfile.cs
  UserProfileController.test.cs
  UserProfileService.test.cs
```

**And** agent provides completion evidence:

- [ ] All feature code in single directory
- [ ] Tests colocated with implementation
- [ ] No files scattered to layer directories
- [ ] Directory name reflects feature/domain

### Test G2: Test File Colocation

**Given** agent WITH scoped-colocation skill
**And** existing feature at `src/features/orders/OrderService.ts`
**When** user says: "Add tests for OrderService"
**Then** agent creates test at `src/features/orders/OrderService.test.ts`

**And** agent provides completion evidence:

- [ ] Test file in same directory as implementation
- [ ] Test file naming follows convention (implementation.test.extension)
- [ ] No separate test tree created

### Test G3: Utility Placement Decision

**Given** agent WITH scoped-colocation skill
**And** user says: "Add a date formatting function for the invoice feature"
**When** agent evaluates placement
**Then** agent:

1. Asks: "Is this used only by invoices, or by multiple features?"
2. If single-feature: Creates `src/features/invoices/formatDate.ts`
3. If multi-feature (3+): Creates `src/shared/utils/formatDate.ts`

**And** agent provides completion evidence:

- [ ] Placement decision documented
- [ ] Single-feature code stays in feature
- [ ] Shared code only extracted when needed

### Test G4: Refactoring Scattered Code

**Given** agent WITH scoped-colocation skill
**And** existing codebase with layer-based organization
**When** user says: "The orders feature is scattered across controllers, services, and models"
**Then** agent proposes refactoring:

1. Identifies all order-related files
2. Proposes feature directory structure
3. Lists files to move
4. Updates import paths

**And** agent provides completion evidence:

- [ ] All order files identified
- [ ] Target structure proposed
- [ ] Migration steps defined
- [ ] Import updates planned

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Existing Pattern Pressure

**Given** agent WITH scoped-colocation skill
**And** existing codebase uses layer-based organization
**And** user says: "Follow the existing project structure"
**When** agent is tempted to scatter files across layers
**Then** agent responds:

- Acknowledges existing structure
- Explains benefits of colocation
- Proposes gradual migration for new features
- Offers to document new convention

**And** agent does NOT:

- Blindly follow anti-pattern
- Scatter new feature across layers
- Create tests in separate tree

### Test P2: Resist Premature Extraction Pressure

**Given** agent WITH scoped-colocation skill
**And** user says: "Put this utility in shared, we might need it elsewhere"
**When** agent is tempted to extract prematurely
**Then** agent responds:

- Asks about current usage (how many features need this?)
- Explains "might need" is not sufficient reason
- Proposes keeping in feature until shared by 3+
- Shows easy extraction later when needed

**And** agent does NOT:

- Extract to shared based on speculation
- Create premature abstractions
- Assume utilities should always be shared

### Test P3: Resist Separation of Concerns Misapplication

**Given** agent WITH scoped-colocation skill
**And** user says: "Tests should be separate from production code"
**When** agent is tempted to create separate test tree
**Then** agent responds:

- Clarifies: Separation of concerns is about dependencies, not directories
- Colocated tests do not violate separation of concerns
- Shows benefits of test proximity
- Build tools can exclude tests from production

**And** agent does NOT:

- Create separate tests/ directory tree
- Move tests away from implementation
- Conflate directory structure with architectural boundaries

## Integration Scenarios

### Test I1: Integration with verification-before-completion

**Given** agent WITH scoped-colocation skill
**And** agent WITH superpowers:verification-before-completion
**When** feature structure is "complete"
**Then** agent verifies:

1. All feature code in feature directory
2. Tests colocated
3. No orphaned files in wrong locations
4. Shared code genuinely shared

**Evidence:**

- [ ] Verification checklist completed
- [ ] Directory listing provided
- [ ] No scattered files found

### Test I2: Integration with test-driven-development

**Given** agent WITH scoped-colocation skill
**And** agent WITH superpowers:test-driven-development
**When** implementing new feature
**Then** agent:

1. Creates test file in feature directory (RED)
2. Creates implementation in same directory (GREEN)
3. Keeps both files together through refactoring

**Evidence:**

- [ ] Test and implementation colocated from start
- [ ] TDD cycle does not scatter files
- [ ] Feature directory contains both

## Rationalizations Closure

### Test RC1: "Following existing project structure"

**Given** agent WITH scoped-colocation skill
**When** user or agent rationalizes: "Following existing project structure"
**Then** agent responds:

- "Existing structure may predate colocation patterns. New features can use better organization."
- Proposes colocation for new code, gradual migration for existing
- Shows coexistence is possible

### Test RC2: "Separation of concerns requires separate directories"

**Given** agent WITH scoped-colocation skill
**When** user or agent rationalizes: "Separation of concerns requires separate directories"
**Then** agent responds:

- "Separation of concerns is about code dependencies, not file location."
- A test in the same directory does not couple test to production code
- Build tools handle inclusion/exclusion

### Test RC3: "We might need this utility elsewhere"

**Given** agent WITH scoped-colocation skill
**When** user or agent rationalizes: "We might need this utility elsewhere"
**Then** agent responds:

- "Premature extraction creates unused shared code. Keep in feature until 3+ consumers exist."
- Extraction is easy when genuinely needed
- "Might need" is not a requirement

### Test RC4: "Tests belong in a tests directory"

**Given** agent WITH scoped-colocation skill
**When** user or agent rationalizes: "Tests belong in a tests directory"
**Then** agent responds:

- "Colocated tests improve discoverability and ensure tests stay current with implementation."
- Moving tests away increases maintenance burden
- Test frameworks support any location

## Verification Assertions

Each GREEN test should verify:

- [ ] Feature code organized by feature, not layer
- [ ] Tests colocated with implementation
- [ ] Related assets in same directory
- [ ] Shared code has 3+ consumers
- [ ] No premature extraction
- [ ] Clear feature boundaries visible in structure
- [ ] Evidence checklist provided
- [ ] Rationalizations closed (cannot be bypassed)
