# Rationalizations Table

Common excuses for running full validation/deployment when selective execution is appropriate.

## Excuse Table

| Excuse                                | Reality                                                                                       |
| ------------------------------------- | --------------------------------------------------------------------------------------------- |
| "Better safe - run full test suite"   | Selective tests + core gates provide safety. Full suite wastes 40+ minutes on unaffected code |
| "Might miss cross-service breakage"   | Include consumer contract tests for affected interfaces. Don't test unrelated code            |
| "Deployment is automated anyway"      | Deploying unchanged services risks unnecessary downtime and complicates rollback              |
| "Coverage delta is complex"           | Git diff + coverage report = simple delta. Absolute coverage punishes unrelated code          |
| "One tag easier than per-service"     | Monolithic tags hide what changed. Service tags enable independent rollback                   |
| "Not a monorepo, doesn't apply"       | Single-repo projects benefit from scoped gates too (frontend vs backend, modules, layers)     |
| "Full validation ensures quality"     | Quality comes from testing changed code thoroughly, not running irrelevant tests              |
| "CI is fast enough"                   | Even fast CI adds up. 10 extra minutes per PR x 50 PRs/week = 8+ hours wasted                 |
| "We've always done it this way"       | Legacy patterns made sense before monorepo tooling existed. Modern tools enable precision     |
| "Risk of missing indirect dependency" | Use dependency graph analysis. Explicit is better than running everything                     |
| "Deployment pipeline expects all"     | Refactor pipeline for selective deployment. One-time cost, ongoing benefit                    |
| "Team prefers full runs"              | Preference is not justification. Show time savings and maintain quality                       |

## Pressure Responses

### Time Pressure

**User says:** "We need to deploy now, no time for selective analysis"

**Response:**
Selective analysis takes seconds (git diff + affected detection). Full deployment takes longer
and risks issues in unchanged components. Fast path IS selective path.

### Authority Pressure

**User says:** "Manager/CTO wants full validation before every release"

**Response:**
Distinguish critical gates (architecture, security - always run) from component tests (scope to
changes). Full validation means thorough testing of changes, not testing everything every time.

### Risk Aversion

**User says:** "What if selective testing misses something?"

**Response:**
Include contract tests for service boundaries. Missing coverage comes from gaps in test design,
not from scoping. Unscoped runs create false confidence without improving coverage.

### Sunk Cost

**User says:** "We've invested in comprehensive test suites, should use them"

**Response:**
Use them for what they test. Auth service tests validate auth service. Running them for payment
service changes adds no value. Investment is in test quality, not test quantity per run.

## Anti-Patterns to Avoid

### Over-Scoping

**Problem:** Scoping too narrowly, missing affected dependencies

**Solution:** Use dependency graph analysis. Include direct consumers and shared library dependents.

### Under-Scoping

**Problem:** Including too many components "just in case"

**Solution:** Trust the dependency graph. If analysis says not affected, don't include.

### Skipping Critical Gates

**Problem:** Scoping removes architecture tests, security scans

**Solution:** Critical gates (architecture, security, lint) always run. Scope component tests only.

### Monolithic Tags

**Problem:** Single version tag for entire repo hides what changed

**Solution:** Service-specific tags. `backend-v2.6.0` clearly shows backend changed.

### Absolute Coverage Enforcement

**Problem:** 80% coverage across entire codebase fails builds for unrelated changes

**Solution:** Coverage delta - 80% of modified lines. Focus quality on changes.

## Greenfield vs Brownfield

### Greenfield (New Projects)

Set up selective execution from the start:

1. Configure monorepo tooling (Nx, Turborepo, Bazel)
2. Establish service-specific tagging convention
3. Set up coverage delta in CI
4. Define critical gates vs component gates
5. Document scoping strategy in CONTRIBUTING.md

### Brownfield (Existing Projects)

Introduce selective execution incrementally:

1. **Start with deployments** - Biggest time savings, clearest boundaries
2. **Add selective CI** - Focus on long-running test suites first
3. **Retrofit git hooks** - Scope pre-commit validation to staged files
4. **Migrate to service tags** - Incrementally for new releases
5. **Preserve full-suite for main** - Run everything on main branch merges

### Hybrid Approach

Balance safety and efficiency:

- **Core gates (always run):** Architecture tests, security scans, lint
- **Component gates (scope to changes):** Unit tests, integration tests
- **Full suite triggers:** Main branch, release branches, manual override

## Evidence Requirements

When applying this skill, provide evidence for:

| Action               | Evidence Required                           |
| -------------------- | ------------------------------------------- |
| Identified impact    | List of affected components with rationale  |
| Scoped quality gates | Commands/config showing selective execution |
| Coverage delta       | Modified line coverage percentage           |
| Selective deployment | Service versions before/after               |
| Preserved gates      | List of critical gates that ran             |
| Time savings         | Estimated reduction vs full execution       |
