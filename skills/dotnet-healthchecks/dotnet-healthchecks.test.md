# dotnet-healthchecks - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Bespoke Health Check Implementation

**Given** agent WITHOUT dotnet-healthchecks skill
**And** user says: "Add a health check for our PostgreSQL database"
**When** agent implements health check
**Then** record baseline behaviour:

- Does agent suggest Xabaril package? (expected: NO - writes custom)
- Does agent research existing implementations? (expected: NO - implements directly)
- Does agent consider OSS ecosystem? (expected: NO - assumes custom is standard)
- Rationalizations observed: "Simple to write", "We need custom logic"

### Test R2: Liveness and Readiness Confusion

**Given** agent WITHOUT dotnet-healthchecks skill
**And** user says: "Add health checks for Kubernetes"
**When** agent implements health endpoints
**Then** record baseline behaviour:

- Does agent distinguish liveness from readiness? (expected: NO - single endpoint)
- Does agent explain semantic difference? (expected: NO - treats as same)
- Does agent configure dependency checks appropriately? (expected: NO - all in one)
- Rationalizations observed: "One endpoint is enough", "Kubernetes handles it"

### Test R3: Configuration Hygiene Neglect

**Given** agent WITHOUT dotnet-healthchecks skill
**And** user says: "Add Redis health check with connection string from config"
**When** agent implements Redis health check
**Then** record baseline behaviour:

- Does agent avoid inline secrets? (expected: NO - embeds connection string)
- Does agent use named health checks? (expected: NO - unnamed defaults)
- Does agent consider dashboard clarity? (expected: NO - generic names)
- Rationalizations observed: "It works", "We'll fix naming later"

### Expected Baseline Failures Summary

- [ ] Agent writes bespoke health checks when Xabaril packages exist
- [ ] Agent does not research existing OSS implementations
- [ ] Agent conflates liveness and readiness endpoints
- [ ] Agent embeds secrets directly in health check registration
- [ ] Agent uses unnamed health checks reducing operational clarity
- [ ] Agent does not justify custom implementations

## GREEN Phase - WITH Skill

### Test G1: Prefer Xabaril Over Bespoke

**Given** agent WITH dotnet-healthchecks skill
**When** user says: "Add a health check for our SQL Server database"
**Then** agent responds with Xabaril approach including:

- Reference to AspNetCore.Diagnostics.HealthChecks.SqlServer package
- NuGet installation command
- Registration using `AddSqlServer()` extension

**And** agent implements:

- Package reference added to project
- Health check registered via Xabaril extension method
- Named health check for clarity

**And** agent provides completion evidence:

- [ ] Xabaril package identified and recommended
- [ ] Package installation specified
- [ ] Extension method used (not custom IHealthCheck)
- [ ] Health check has meaningful name
- [ ] No bespoke implementation when Xabaril exists

### Test G2: Liveness vs Readiness Separation

**Given** agent WITH dotnet-healthchecks skill
**When** user says: "Configure health checks for Kubernetes probes"
**Then** agent responds with proper separation including:

- Liveness endpoint explanation (process running)
- Readiness endpoint explanation (dependencies available)
- Tag-based filtering for endpoint separation

**And** agent implements:

- Separate `/health/live` and `/health/ready` endpoints
- Liveness checks without dependency checks
- Readiness checks with infrastructure dependencies
- Tag-based filtering using `Predicate`

**And** agent provides completion evidence:

- [ ] Liveness endpoint configured (no dependencies)
- [ ] Readiness endpoint configured (with dependencies)
- [ ] Semantic difference explained
- [ ] Tag-based filtering implemented
- [ ] Kubernetes probe configuration guidance provided

### Test G3: Configuration Hygiene

**Given** agent WITH dotnet-healthchecks skill
**When** user says: "Add Redis health check to our API"
**Then** agent responds with hygiene guidance including:

- Named health check recommendation
- Connection string from configuration (not inline)
- Dashboard clarity considerations

**And** agent implements:

- Named health check (`name: "redis-cache"`)
- Connection string retrieved from IConfiguration
- No secrets embedded in registration code

**And** agent provides completion evidence:

- [ ] Health check has descriptive name
- [ ] Connection string from configuration (not hardcoded)
- [ ] No secrets visible in registration code
- [ ] Dashboard naming considered
- [ ] Configuration pattern follows best practices

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Bespoke Pressure

**Given** agent WITH dotnet-healthchecks skill
**And** user says: "Just write a quick custom health check, Xabaril is overkill"
**When** agent is tempted to write custom implementation
**Then** agent responds:

- Acknowledges simplicity appeal
- Explains Xabaril is battle-tested and widely adopted
- Shows custom checks require maintenance and testing
- Proposes Xabaril with link to package

**And** agent does NOT:

- Write bespoke IHealthCheck when Xabaril exists
- Accept "overkill" rationalization for standard dependencies
- Skip research of existing implementations

### Test P2: Resist Single Endpoint Pressure

**Given** agent WITH dotnet-healthchecks skill
**And** user says: "One /health endpoint is fine, don't overcomplicate it"
**When** agent is tempted to use single endpoint
**Then** agent responds:

- Acknowledges simplicity preference
- Explains Kubernetes uses liveness/readiness differently
- Shows improper probe configuration causes cascading restarts
- Proposes separate endpoints with clear semantics

**And** agent does NOT:

- Combine all checks in single endpoint for Kubernetes
- Accept "one endpoint is enough" for orchestrated environments
- Skip liveness/readiness semantic explanation

### Test P3: Resist Inline Configuration Pressure

**Given** agent WITH dotnet-healthchecks skill
**And** user says: "Just hardcode the connection string, it's only for health checks"
**When** agent is tempted to embed secrets inline
**Then** agent responds:

- Acknowledges convenience appeal
- Explains secrets in code create security and maintenance issues
- Shows connection strings should come from configuration
- Proposes proper IConfiguration usage

**And** agent does NOT:

- Embed connection strings directly in registration
- Accept "it's only health checks" rationalization
- Skip configuration hygiene guidance

## Review Scenarios

### Test RV1: PR Review - Bespoke Health Check

**Given** agent WITH dotnet-healthchecks skill
**And** PR contains custom IHealthCheck implementation for PostgreSQL
**When** agent reviews the PR
**Then** agent:

- Identifies custom implementation
- Searches for equivalent Xabaril package
- Requests justification if custom is truly needed
- Suggests replacement with `AddNpgSql()` if applicable

**Evidence:**

- [ ] Custom implementation identified
- [ ] Xabaril alternative researched
- [ ] Review comment requesting justification
- [ ] Migration path suggested

### Test RV2: PR Review - Missing Named Checks

**Given** agent WITH dotnet-healthchecks skill
**And** PR adds multiple health checks without names
**When** agent reviews the PR
**Then** agent:

- Identifies unnamed health checks
- Explains operational clarity benefits of naming
- Suggests descriptive names for each check
- References dashboard considerations

**Evidence:**

- [ ] Unnamed checks identified
- [ ] Naming convention suggested
- [ ] Dashboard clarity explained
- [ ] Specific name recommendations provided

## Rationalizations Closure

### Test RC1: "Custom is simpler"

**Given** agent WITH dotnet-healthchecks skill
**When** rationalization: "Writing custom IHealthCheck is simpler than adding a package"
**Then** agent responds:

- "Xabaril packages are well-tested and cover edge cases you might miss."
- "Custom checks require ongoing maintenance. Xabaril is community-maintained."
- "Package installation is one command. Custom implementation is ongoing liability."

### Test RC2: "One health endpoint is enough"

**Given** agent WITH dotnet-healthchecks skill
**When** rationalization: "One /health endpoint covers everything"
**Then** agent responds:

- "Kubernetes liveness and readiness have different purposes."
- "Liveness restarts the pod. Readiness removes from load balancer."
- "Combining them causes unnecessary restarts when dependencies are temporarily unavailable."

### Test RC3: "Naming is unnecessary overhead"

**Given** agent WITH dotnet-healthchecks skill
**When** rationalization: "We don't need named health checks"
**Then** agent responds:

- "Named checks enable clear operational dashboards."
- "When a check fails, 'sql-orders-db' is more actionable than 'Unhealthy'."
- "Names cost nothing at runtime but improve incident response."

### Test RC4: "Health checks don't need security review"

**Given** agent WITH dotnet-healthchecks skill
**When** rationalization: "It's just health checks, security doesn't matter"
**Then** agent responds:

- "Health check code can leak connection strings in logs or error messages."
- "Configuration hygiene applies to all infrastructure code."
- "Secrets management is especially important for monitoring endpoints."

## Integration Scenarios

### Test I1: Integration with Code Review Workflow

**Given** agent WITH dotnet-healthchecks skill
**And** agent performing code review
**When** PR introduces health checks
**Then** agent:

1. Checks if Xabaril package exists for dependency
2. Verifies liveness/readiness separation if orchestrated
3. Reviews configuration hygiene (no inline secrets)
4. Validates named health checks for clarity

**Evidence:**

- [ ] Xabaril alternative checked
- [ ] Endpoint semantics reviewed
- [ ] Configuration hygiene verified
- [ ] Naming convention applied

### Test I2: Integration with ASP.NET Core Setup

**Given** agent WITH dotnet-healthchecks skill
**And** new ASP.NET Core service being created
**When** user says: "Set up health checks for our new API"
**Then** agent:

1. Identifies infrastructure dependencies
2. Selects appropriate Xabaril packages
3. Configures liveness and readiness endpoints
4. Applies configuration hygiene and naming

**Evidence:**

- [ ] Dependencies identified
- [ ] Xabaril packages selected
- [ ] Liveness/readiness configured
- [ ] Hygiene patterns applied
- [ ] Named checks implemented

## Verification Assertions

Each GREEN test should verify:

- [ ] Xabaril package preferred over bespoke implementation
- [ ] Custom implementations justified only for domain-specific needs
- [ ] Liveness checks exclude dependency verification
- [ ] Readiness checks include dependency verification
- [ ] Tag-based filtering used for endpoint separation
- [ ] Health checks have meaningful, descriptive names
- [ ] Connection strings from configuration (not inline)
- [ ] No secrets embedded in registration code
- [ ] Dashboard clarity considered in naming
- [ ] Review comments request justification for custom checks
- [ ] Evidence checklist provided
