# dotnet-bespoke-code-minimisation - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Custom Mapper Temptation

**Given** agent WITHOUT dotnet-bespoke-code-minimisation skill
**And** pressure: control ("we need full control over mapping")
**When** user says: "Create a mapper to convert DTOs to domain entities"
**And** no guidance on library selection
**Then** record baseline behaviour:

- Does agent suggest OSS mapper? (expected: NO - builds custom mapper)
- Does agent evaluate existing solutions? (expected: NO - jumps to implementation)
- Does agent mention maintenance burden? (expected: NO - not considered)
- Rationalizations observed: "Custom gives full control", "Simple enough to build"

### Test R2: Custom Validation Framework

**Given** agent WITHOUT dotnet-bespoke-code-minimisation skill
**And** pressure: uniqueness ("our validation needs are special")
**When** user says: "Create a validation framework for our entities"
**And** no explicit OSS requirement
**Then** record baseline behaviour:

- Does agent prefer OSS validation? (expected: NO - builds custom framework)
- Does agent consider FluentValidation/DataAnnotations? (expected: MAYBE - briefly)
- Does agent document ownership? (expected: NO - not addressed)
- Rationalizations observed: "Our needs are unique", "FluentValidation is overkill"

### Test R3: Custom Build Script Creation

**Given** agent WITHOUT dotnet-bespoke-code-minimisation skill
**And** pressure: deadline ("we need this CI pipeline today")
**When** user says: "Create a build script for our solution"
**And** complex multi-project solution
**Then** record baseline behaviour:

- Does agent suggest OSS build tools? (expected: NO - writes PowerShell/bash)
- Does agent evaluate FAKE/Nuke/Cake? (expected: NO - custom is faster)
- Does agent version the script? (expected: MAYBE - basic versioning)
- Rationalizations observed: "Simple script is enough", "No need for build framework"

### Test R4: Internal Framework Layer

**Given** agent WITHOUT dotnet-bespoke-code-minimisation skill
**And** pressure: authority ("senior dev says we need abstraction")
**When** user says: "Create an abstraction layer for HTTP calls"
**And** no explicit library requirement
**Then** record baseline behaviour:

- Does agent consider Polly/Refit? (expected: NO - builds wrapper)
- Does agent implement retry logic? (expected: YES - custom implementation)
- Does agent document support model? (expected: NO - assumed obvious)
- Rationalizations observed: "Abstractions are cleaner", "We control the implementation"

### Expected Baseline Failures Summary

- [ ] Agent builds custom mappers without evaluating AutoMapper/Mapster/Mapperly
- [ ] Agent creates custom validation without evaluating FluentValidation
- [ ] Agent writes bespoke build scripts without evaluating Nuke/FAKE/Cake
- [ ] Agent implements custom retry/circuit breaker without evaluating Polly
- [ ] Agent doesn't document ownership or support model for internal tools
- [ ] Agent doesn't consider versioning and deprecation for bespoke code

## GREEN Phase - WITH Skill

### Test G1: OSS Preference Over Bespoke Implementations

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** user says: "Create a mapper to convert DTOs to domain entities"
**Then** agent responds with OSS-first approach including:

- Evaluation of OSS mapping libraries (Mapperly, Mapster, AutoMapper)
- Recommendation based on project needs
- Clear reasoning for library selection

**And** agent recommends:

- Source-generated mapper (Mapperly) for performance
- Configuration-based mapper (AutoMapper/Mapster) for flexibility
- Explanation of maintenance benefits

**And** agent provides completion evidence:

- [ ] OSS alternatives evaluated before custom code considered
- [ ] Selected library documented with rationale
- [ ] No custom reflection-based mapping implemented
- [ ] NuGet package referenced (not custom code)

### Test G2: Library Before Framework Principle

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** user says: "We need resilience patterns for our HTTP calls"
**Then** agent responds with library-first approach including:

- Small, composable library recommendation (Polly)
- Avoidance of framework-level abstractions
- Configuration-based setup

**And** agent recommends:

- Polly for retries/circuit breakers
- Direct HTTP client configuration (not wrapper framework)
- Minimal abstraction surface

**And** agent provides completion evidence:

- [ ] Composable library selected (not framework)
- [ ] No custom wrapper layer created
- [ ] Configuration transparent and maintainable
- [ ] Library version pinned and documented

### Test G3: Bespoke Justification Rubric Requirements

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** legitimate need for custom tooling identified
**When** user says: "We've evaluated OSS options and need custom code generator"
**And** OSS alternatives confirmed insufficient
**Then** agent enforces justification rubric including:

- Explicit rationale why OSS is insufficient
- Ownership (team/person) designation
- Versioning and deprecation policy
- Test coverage requirements
- Security and supply-chain considerations

**And** agent requires documentation of:

- Which OSS alternatives were evaluated and why rejected
- Named owner responsible for maintenance
- Version scheme and breaking change policy
- Test suite covering core functionality
- Security review process

**And** agent provides completion evidence:

- [ ] OSS evaluation documented with rejection reasons
- [ ] Owner designated for ongoing maintenance
- [ ] Versioning policy established
- [ ] Tests covering critical paths
- [ ] Security considerations addressed

### Test G4: Enforcement - PR Rejection Criteria

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** reviewing PR that introduces internal framework layer
**When** PR lacks justification documentation
**Then** agent rejects PR requiring:

- Completed justification rubric
- Documented maintenance plan
- Confirmation OSS options evaluated
- Licensing review completed

**And** agent blocks merge until:

- [ ] Justification rubric satisfied
- [ ] Maintenance plan documented
- [ ] OSS evaluation evidence provided
- [ ] Licensing implications validated

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Control Rationalization

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** user says: "We need full control, OSS libraries are black boxes"
**When** agent is tempted to build custom implementation
**Then** agent responds:

- Acknowledges desire for control
- Explains OSS libraries are source-available and auditable
- Shows maintenance burden of custom code exceeds review effort
- Proposes OSS library with extension points

**And** agent does NOT:

- Build custom mapper/validator/retry logic
- Skip OSS evaluation
- Accept "black box" rationalization

### Test P2: Resist Uniqueness Rationalization

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** user says: "Our requirements are unique, no OSS fits"
**When** agent is tempted to build bespoke solution
**Then** agent responds:

- Acknowledges unique requirements perception
- Requests specific OSS evaluation evidence
- Shows most "unique" needs are configuration options
- Proposes composition of existing libraries

**And** agent does NOT:

- Build custom framework without OSS evaluation
- Accept uniqueness claim without evidence
- Skip justification rubric requirements

### Test P3: Resist Deadline Pressure

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** user says: "We need this today, no time to evaluate libraries"
**When** agent is tempted to write quick script
**Then** agent responds:

- Acknowledges deadline pressure
- Shows library installation is faster than custom code
- Notes technical debt accumulates from shortcuts
- Proposes OSS library with minimal configuration

**And** agent does NOT:

- Write untested custom script
- Skip ownership documentation
- Create unmaintained tooling

## Integration Scenarios

### Test I1: Integration with Code Review

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** agent reviewing PR
**When** PR introduces custom caching layer
**Then** agent:

1. Checks if OSS alternatives evaluated (e.g., Microsoft.Extensions.Caching)
2. Requests justification rubric if custom code
3. Verifies ownership documented
4. Confirms tests and documentation exist

**Evidence:**

- [ ] OSS evaluation documented in PR
- [ ] Justification rubric completed (if custom)
- [ ] Owner assigned for maintenance
- [ ] Tests covering cache behavior

### Test I2: Integration with Architecture Review

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**And** architectural decision for internal tool
**When** decision record created
**Then** agent ensures:

1. ADR documents OSS alternatives considered
2. ADR explains why bespoke is necessary
3. ADR includes maintenance commitment
4. ADR addresses deprecation path

**Evidence:**

- [ ] ADR lists evaluated OSS options
- [ ] Rejection reasons documented per option
- [ ] Maintenance plan in ADR
- [ ] Deprecation/sunset criteria defined

## Rationalizations Closure

### Test RC1: "OSS libraries are too heavy"

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** rationalization: "OSS libraries bring unnecessary dependencies"
**Then** agent responds:

- "Modern packages are modular. Mapperly adds zero runtime deps via source gen."
- "Evaluate actual dependency impact, not perceived bloat."
- "Custom code has hidden deps: maintenance time, testing, documentation."

### Test RC2: "Custom is more performant"

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** rationalization: "Custom code will be more performant than OSS"
**Then** agent responds:

- "OSS libraries are performance-tested at scale. Polly, Mapperly optimized extensively."
- "Custom code performance claims require benchmarks. Provide evidence."
- "Premature optimization via custom code trades maintenance for unproven gains."

### Test RC3: "We'll open source it later"

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** rationalization: "We'll build it now and open source later"
**Then** agent responds:

- "OSS-later is rarely realized. Maintenance debt accumulates internally first."
- "If worth open sourcing, contribute to existing OSS instead."
- "Follow justification rubric now. Don't defer quality to hypothetical OSS release."

### Test RC4: "Simple script doesn't need a framework"

**Given** agent WITH dotnet-bespoke-code-minimisation skill
**When** rationalization: "It's just a simple script, no framework needed"
**Then** agent responds:

- "Simple scripts grow complex. Nuke/FAKE provide tested patterns for evolution."
- "Versioning, testing, documentation required per 'Script last' principle."
- "Unmanaged scripts become tribal knowledge. Framework provides structure."

## Verification Assertions

Each GREEN test should verify:

- [ ] OSS alternatives evaluated before bespoke code written
- [ ] Library selected over framework when both available
- [ ] Configuration preferred over custom code when possible
- [ ] Bespoke code includes justification rubric completion
- [ ] Ownership clearly documented for any internal tool
- [ ] Versioning and deprecation policy established
- [ ] Tests exist for custom tools/scripts
- [ ] Security and supply-chain considerations documented
- [ ] Maintenance plan documented with named owner
- [ ] PR/code review enforces rubric requirements
- [ ] Evidence checklist provided for completion claims
