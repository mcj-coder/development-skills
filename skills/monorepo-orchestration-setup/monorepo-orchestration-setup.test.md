# monorepo-orchestration-setup - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Tool Selection Paralysis

**Given** agent WITHOUT monorepo-orchestration-setup skill
**And** user is starting a new multi-project repository
**When** user says: "Set up a monorepo for our web app and API"
**Then** record baseline behaviour:

- Does agent systematically evaluate tool options? (expected: NO - picks arbitrarily)
- Does agent consider team requirements? (expected: NO - jumps to implementation)
- Does agent document selection rationale? (expected: NO - no ADR created)
- Rationalizations observed: "Nx is popular", "Just use what you know"

### Test R2: Missing Task Dependencies

**Given** agent WITHOUT monorepo-orchestration-setup skill
**And** user has an existing multi-package repository
**When** user says: "Add build orchestration to our packages"
**Then** record baseline behaviour:

- Does agent define task pipelines correctly? (expected: NO - tasks in wrong order)
- Does agent configure caching? (expected: NO - no cache setup)
- Does agent test dependency order? (expected: NO - assumes it works)
- Rationalizations observed: "Tasks will run in parallel", "It worked locally"

### Test R3: CI/CD Without Affected Detection

**Given** agent WITHOUT monorepo-orchestration-setup skill
**And** user has a monorepo with many packages
**When** user says: "Set up CI/CD for our monorepo"
**Then** record baseline behaviour:

- Does agent configure affected-only execution? (expected: NO - runs everything)
- Does agent enable remote caching? (expected: NO - rebuilds from scratch)
- Does agent optimise for incremental builds? (expected: NO - full builds every time)
- Rationalizations observed: "CI should run everything for safety", "Caching is complex"

### Expected Baseline Failures Summary

- [ ] Agent doesn't provide structured tool selection guidance
- [ ] Agent doesn't define task dependencies correctly
- [ ] Agent doesn't configure caching strategies
- [ ] Agent doesn't set up affected detection in CI/CD
- [ ] Agent doesn't document monorepo conventions
- [ ] Agent doesn't verify configuration before declaring complete

## GREEN Phase - WITH Skill

### Test G1: New Monorepo Setup with Tool Selection

**Given** agent WITH monorepo-orchestration-setup skill
**When** user says: "Set up a monorepo for our web app and shared UI library"
**Then** agent responds with assessment questions:

- Team size and experience level
- Primary technology stack (JavaScript/TypeScript, full-stack, etc.)
- CI/CD platform (GitHub Actions, Azure DevOps, etc.)
- Publishing requirements (npm packages or internal only)

**And** agent provides tool recommendation with rationale:

- Comparison of relevant options (Nx vs Turborepo for this case)
- Selection based on stated requirements
- Tradeoffs explained

**And** agent implements:

- Workspace configuration with selected tool
- Standard directory structure (apps/, packages/)
- Task pipeline with correct dependencies
- Local caching enabled

**And** agent provides completion evidence:

- [ ] Tool selection documented with rationale
- [ ] Workspace configuration validates successfully
- [ ] Directory structure follows conventions
- [ ] Task dependencies defined correctly
- [ ] Local caching verified working
- [ ] Basic documentation created

### Test G2: Task Pipeline Configuration

**Given** agent WITH monorepo-orchestration-setup skill
**And** existing monorepo with packages that have build dependencies
**When** user says: "Configure task pipelines for build, test, and lint"
**Then** agent responds with:

- Analysis of package dependencies
- Task dependency graph proposal
- Caching configuration for each task

**And** agent implements:

- Task pipeline configuration (nx.json or turbo.json)
- Correct `dependsOn` for tasks with dependencies
- Cache configuration with appropriate outputs

**And** agent verifies:

- Tasks run in correct order
- Second run uses cache (significantly faster)
- Changes to one package only rebuild affected

**And** agent provides completion evidence:

- [ ] Task dependencies correctly defined
- [ ] Build order verified correct
- [ ] Caching working (second run fast)
- [ ] Incremental builds working (only affected rebuilt)
- [ ] Configuration documented

### Test G3: CI/CD Integration with Affected Detection

**Given** agent WITH monorepo-orchestration-setup skill
**And** monorepo with Nx or Turborepo configured
**When** user says: "Set up GitHub Actions for our monorepo"
**Then** agent responds with:

- CI/CD strategy for monorepo (affected-only execution)
- Remote caching recommendation
- Branch strategy for base comparison

**And** agent implements:

- GitHub Actions workflow with affected commands
- Remote caching configuration (if approved)
- Proper base branch configuration for PRs and main

**And** agent verifies:

- Workflow syntax is valid
- Affected detection works correctly
- Remote cache integrates (if configured)

**And** agent provides completion evidence:

- [ ] CI/CD workflow created and valid
- [ ] Affected detection configured
- [ ] Base branch strategy documented
- [ ] Remote caching configured (optional)
- [ ] PR workflow runs only affected projects
- [ ] Main branch workflow runs with correct base

### Test G4: Migration from Polyrepo to Monorepo

**Given** agent WITH monorepo-orchestration-setup skill
**And** user has multiple separate repositories to consolidate
**When** user says: "Migrate our frontend and backend repos into a monorepo"
**Then** agent responds with migration plan:

- Repository consolidation approach
- Git history preservation options
- Shared dependency management
- Phased migration timeline

**And** agent implements:

- New monorepo workspace structure
- Package migration with dependency updates
- Shared configuration extraction
- Build pipeline covering all projects

**And** agent provides completion evidence:

- [ ] Migration plan documented and approved
- [ ] Workspace structure accommodates all projects
- [ ] Dependencies consolidated correctly
- [ ] Build pipeline covers all projects
- [ ] No regressions in individual project builds
- [ ] Team onboarding documentation updated

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Over-Engineering Pressure

**Given** agent WITH monorepo-orchestration-setup skill
**And** user says: "Set up everything - remote caching, distributed execution, all plugins"
**When** agent is tempted to configure everything at once
**Then** agent responds:

- Acknowledges desire for full setup
- Proposes incremental approach (local first, then remote)
- Explains complexity tradeoffs
- Recommends proving basics before advanced features

**And** agent does NOT:

- Configure remote caching without understanding needs
- Enable distributed execution for small teams
- Install unnecessary plugins

### Test P2: Resist Premature Tool Migration

**Given** agent WITH monorepo-orchestration-setup skill
**And** user says: "Everyone uses Nx now, let's switch from Lerna"
**When** agent is tempted to migrate immediately
**Then** agent responds:

- Assesses current Lerna setup and pain points
- Compares migration cost vs benefits
- Identifies specific gaps in current setup
- Recommends migration only if justified

**And** agent does NOT:

- Migrate without assessing current state
- Assume newer tool is always better
- Ignore team retraining cost

### Test P3: Resist Skipping Verification

**Given** agent WITH monorepo-orchestration-setup skill
**And** user says: "The config looks right, let's just commit it"
**When** agent is tempted to skip verification
**Then** agent responds:

- Explains importance of validating configuration
- Runs verification commands before committing
- Tests caching with clean and cached runs
- Verifies affected detection works

**And** agent does NOT:

- Commit configuration without verification
- Assume config is correct based on appearance
- Skip cache and affected testing

## Integration Scenarios

### Test I1: Integration with walking-skeleton-delivery

**Given** agent WITH monorepo-orchestration-setup skill
**And** agent WITH walking-skeleton-delivery skill
**When** user says: "Build a walking skeleton for our new microservices monorepo"
**Then** agent:

1. First proposes monorepo structure for multiple services
2. Creates minimal E2E skeleton spanning services
3. Configures task pipelines for skeleton apps
4. Establishes CI/CD with affected detection

**Evidence:**

- [ ] Monorepo structure accommodates skeleton services
- [ ] Task pipelines work across skeleton apps
- [ ] CI/CD runs affected skeleton builds only
- [ ] Clear separation: infrastructure vs skeleton services

### Test I2: Integration with automated-standards-enforcement

**Given** agent WITH monorepo-orchestration-setup skill
**And** agent WITH automated-standards-enforcement skill
**When** user says: "Set up linting for all packages in our monorepo"
**Then** agent:

1. Configures root-level linting configuration
2. Adds lint task to pipeline with caching
3. Ensures lint runs on affected packages only
4. Integrates with pre-commit hooks

**Evidence:**

- [ ] Linting configured at monorepo root
- [ ] Lint task cached and incremental
- [ ] CI runs lint on affected packages only
- [ ] Pre-commit hooks configured

### Test I3: Integration with ci-cd-conformance

**Given** agent WITH monorepo-orchestration-setup skill
**And** agent WITH ci-cd-conformance skill
**When** user says: "Our CI needs to be fast and correct for the monorepo"
**Then** agent:

1. Reviews CI/CD requirements from ci-cd-conformance
2. Configures affected-only execution
3. Enables remote caching if appropriate
4. Ensures all quality gates are enforced

**Evidence:**

- [ ] CI/CD meets conformance requirements
- [ ] Affected detection reduces build time
- [ ] Remote caching enabled (if approved)
- [ ] Quality gates enforced on all affected packages

## Tool-Specific Scenarios

### Test T1: Nx-Specific Configuration

**Given** agent WITH monorepo-orchestration-setup skill
**And** user has selected Nx for their monorepo
**When** agent configures Nx workspace
**Then** configuration includes:

- Valid nx.json with targetDefaults
- Project.json files or package.json inference
- Proper namedInputs for cache keys
- Nx Cloud setup documentation (optional)

**And** agent provides evidence:

- [ ] `nx show projects` lists all projects
- [ ] `nx graph` displays dependency graph
- [ ] `nx affected -t build` detects changes correctly
- [ ] Caching verified with repeated runs

### Test T2: Turborepo-Specific Configuration

**Given** agent WITH monorepo-orchestration-setup skill
**And** user has selected Turborepo for their monorepo
**When** agent configures Turborepo workspace
**Then** configuration includes:

- Valid turbo.json with tasks object
- Correct outputs for each task
- Package.json workspaces configuration
- Remote cache setup documentation (optional)

**And** agent provides evidence:

- [ ] `turbo run build --dry-run` shows correct order
- [ ] `turbo run build --graph` displays pipeline
- [ ] `--filter` correctly identifies affected packages
- [ ] Caching verified with repeated runs

### Test T3: Lerna-Specific Configuration

**Given** agent WITH monorepo-orchestration-setup skill
**And** user needs npm package publishing
**When** agent configures Lerna workspace
**Then** configuration includes:

- Valid lerna.json with version mode
- Package.json workspaces configuration
- Version synchronisation strategy
- Publishing configuration

**And** agent provides evidence:

- [ ] `lerna ls` lists all packages
- [ ] `lerna run build` executes in dependency order
- [ ] `lerna changed` detects modified packages
- [ ] Version bumping workflow documented

## Verification Assertions

Each GREEN test should verify:

- [ ] Tool selection documented with clear rationale
- [ ] Workspace configuration validates successfully
- [ ] Task pipelines execute in correct dependency order
- [ ] Caching reduces build time on subsequent runs
- [ ] Affected detection limits scope correctly
- [ ] CI/CD optimised for monorepo patterns
- [ ] Documentation covers team onboarding
- [ ] No hardcoded paths or environment-specific values
- [ ] Configuration tested, not just written
