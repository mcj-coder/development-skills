# local-dev-experience - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Pressure Scenario 1: Deadline + Complex Setup

```gherkin
Given agent WITHOUT local-dev-experience skill
And pressure: deadline ("need feature done by end of day")
When user says: "Set up this .NET project for local development"
Then record:
  - Does agent optimize build times? (likely NO - uses defaults)
  - Does agent configure hot reload? (likely NO - assumes manual restart)
  - Does agent set up file watchers? (likely NO - not considered)
  - Does agent minimize startup friction? (likely NO - long manual steps)
  - Rationalizations: "Default settings work fine", "Can optimize later", "Just run dotnet build"
```

**Expected Baseline Failure:**
Agent uses default tooling without optimizing for developer iteration speed.

### Pressure Scenario 2: Legacy Codebase + Slow Builds

```gherkin
Given agent WITHOUT local-dev-experience skill
And pressure: sunk cost ("project has 500+ files, builds take 3 minutes")
When user says: "Development is too slow, how can we speed things up?"
Then record:
  - Does agent suggest incremental builds? (likely PARTIAL - mentions but no setup)
  - Does agent configure build caching? (likely NO - not aware of options)
  - Does agent optimize test execution? (likely NO - runs full suite)
  - Does agent reduce IDE lag? (likely NO - not considered)
  - Rationalizations: "Large projects are slow", "Can't change architecture", "Just wait for builds"
```

**Expected Baseline Failure:**
Agent accepts slow iteration as inevitable rather than optimizing feedback loops.

### Pressure Scenario 3: Multi-Service Architecture

```gherkin
Given agent WITHOUT local-dev-experience skill
And pressure: complexity ("microservices with 5 different services")
When user says: "I need to develop locally against these services"
Then record:
  - Does agent suggest container orchestration? (likely PARTIAL - mentions Docker)
  - Does agent configure service discovery for local dev? (likely NO - production patterns)
  - Does agent set up efficient local mocking? (likely NO - runs all services)
  - Does agent optimize resource usage? (likely NO - runs everything)
  - Rationalizations: "Use docker-compose", "Same as production", "Need all services running"
```

**Expected Baseline Failure:**
Agent uses production-oriented patterns that waste resources and slow local development.

### Baseline Observations (Simulated)

Without the skill, a typical agent response includes:

- "Just run `dotnet build` to compile your project."
- "Use `docker-compose up` to start all services."
- "Builds take time for large projects, that's normal."
- "You can restart the application after making changes."
- "Run the full test suite to verify changes."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario 1: Fast Feedback Loop Setup for .NET

```gherkin
Given agent WITH local-dev-experience skill
When user says: "Set up fast local development for this .NET API"
Then agent responds with:
  "Configuring fast feedback development environment. Setting up:
   - Hot reload with dotnet watch for instant code changes
   - Incremental builds with Directory.Build.props optimizations
   - Test filtering with dotnet test --filter for targeted testing
   - File watcher patterns to rebuild only changed assemblies
   - Launch profiles for quick F5 debugging with minimal startup"
And agent creates/configures:
  - dotnet watch configuration in launchSettings.json
  - Directory.Build.props with incremental build settings
  - Test run scripts with category filters
  - .vscode/tasks.json for quick keyboard shortcuts
  - Development-specific appsettings.Development.json
```

**Evidence Checklist:**

- [ ] Hot reload configured (dotnet watch)
- [ ] Incremental build optimizations documented
- [ ] Test filtering strategy provided
- [ ] IDE task shortcuts configured
- [ ] Development configuration separated from production
- [ ] Sub-second feedback on code changes achievable

### Scenario 2: Node.js/TypeScript Fast Development

```gherkin
Given agent WITH local-dev-experience skill
When user says: "Optimize this TypeScript project for fast development"
Then agent responds with:
  "Optimizing TypeScript development experience. Configuring:
   - ts-node-dev or tsx for instant TypeScript execution
   - Jest with --watch and --onlyChanged for targeted testing
   - ESLint with --cache for fast linting
   - Vite or esbuild for sub-second bundling
   - TypeScript incremental compilation with tsBuildInfoFile"
And agent creates/configures:
  - package.json scripts with watch modes
  - tsconfig.json with incremental: true
  - jest.config.js with cache and coverage thresholds
  - .eslintcache in .gitignore
  - Dev server with HMR (Hot Module Replacement)
```

**Evidence Checklist:**

- [ ] TypeScript incremental compilation enabled
- [ ] Watch mode scripts configured
- [ ] Test watch with change detection
- [ ] Lint caching enabled
- [ ] HMR or fast refresh configured
- [ ] Build times under 1 second for incremental changes

### Scenario 3: Multi-Service Local Development

```gherkin
Given agent WITH local-dev-experience skill
And microservices architecture with 4 services
When user says: "Set up local development without running all services"
Then agent responds with:
  "Configuring minimal local development environment. Setting up:
   - Service mocking with WireMock or similar for dependencies
   - Docker Compose profiles for selective service startup
   - Local service discovery with environment-based URLs
   - Resource-efficient container configurations
   - Hybrid mode: real service under development + mocked dependencies"
And agent creates/configures:
  - docker-compose.override.yml for development
  - Docker Compose profiles (--profile dev, --profile full)
  - Mock service configurations
  - Environment variable templates for local URLs
  - Documentation for minimal startup patterns
```

**Evidence Checklist:**

- [ ] Selective service startup documented
- [ ] Mock services configured for dependencies
- [ ] Docker Compose profiles created
- [ ] Resource usage minimized (not running unused services)
- [ ] Hybrid development mode documented
- [ ] Single service can be developed in isolation

### Scenario 4: IDE and Tooling Optimization

```gherkin
Given agent WITH local-dev-experience skill
When user says: "My IDE is slow when working on this project"
Then agent responds with:
  "Optimizing IDE performance for faster development. Addressing:
   - File exclusion patterns for node_modules, bin, obj directories
   - Language server memory settings for large projects
   - Search scope optimization to exclude generated files
   - Extension audit for performance impact
   - Workspace-specific settings for project type"
And agent creates/configures:
  - .vscode/settings.json with file exclusions
  - .editorconfig for consistent formatting
  - .gitignore patterns for generated files
  - IDE-specific performance recommendations
```

**Evidence Checklist:**

- [ ] File exclusion patterns configured
- [ ] Search scope optimized
- [ ] Language server settings tuned
- [ ] Generated files excluded from indexing
- [ ] IDE responsiveness improved

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

After pressure testing, these excuses emerged. The skill must close each loophole:

| Excuse                       | Reality                                                                                       | Skill Enforcement                           |
| ---------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------- |
| "Default settings work fine" | Defaults optimize for safety, not speed. Sub-second feedback requires configuration.          | Provide optimized configurations from start |
| "Large projects are slow"    | Incremental builds and caching make any project fast. Architecture matters less than tooling. | Incremental build setup mandatory           |
| "Can optimize later"         | Developer time compounds. 30 seconds saved per iteration = hours saved per day.               | Fast feedback is P3 but applies by default  |
| "Need all services running"  | Mocking and profiles enable isolated development. Running everything wastes resources.        | Minimal startup patterns documented         |
| "Just wait for builds"       | Waiting is lost productivity. Watch modes eliminate wait time entirely.                       | Watch mode as default development pattern   |
| "Same as production"         | Local development has different needs than production. Optimize for iteration speed.          | Development-specific configurations         |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Just restart the application"
- "Run the full test suite"
- "Start all services"
- "Wait for the build"
- "Default configuration is fine"
- "Can optimize later"

**All of these mean:** Apply fast feedback patterns or document explicit trade-off decision.

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/local-dev-experience/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Description starts with "Use when..."
- [ ] Main SKILL.md is concise (under 400 words)
- [ ] Test file exists at `skills/local-dev-experience/local-dev-experience.test.md`

### Skill Content

- [ ] P3 Delivery & Flow priority documented
- [ ] Prerequisites listed if any
- [ ] Core workflow documented
- [ ] Quick reference table for common patterns
- [ ] Red flags section included
- [ ] Multi-ecosystem coverage (at minimum: .NET, Node.js/TypeScript)

### Key Patterns Documented

- [ ] Hot reload / watch mode patterns
- [ ] Incremental build configuration
- [ ] Test filtering and watch patterns
- [ ] IDE optimization guidance
- [ ] Multi-service local development
- [ ] Resource-efficient development setups

## Integration Test: Full Workflow Simulation

### Test Case: New .NET API Project

1. **Trigger**: User says "Set up local development for this .NET API"
2. **Expected**: Agent announces local-dev-experience skill
3. **Expected**: Agent configures dotnet watch
4. **Expected**: Agent sets up incremental builds
5. **Expected**: Agent provides test filtering guidance
6. **Verification**: Code changes reflect in < 2 seconds

### Test Case: Slow TypeScript Build

1. **Trigger**: User says "TypeScript builds are taking too long"
2. **Expected**: Agent announces local-dev-experience skill
3. **Expected**: Agent enables incremental compilation
4. **Expected**: Agent configures build caching
5. **Expected**: Agent sets up watch mode
6. **Verification**: Incremental builds complete in < 1 second

### Test Case: Microservices Development

1. **Trigger**: User says "I need to work on just the payment service"
2. **Expected**: Agent announces local-dev-experience skill
3. **Expected**: Agent configures mock services for dependencies
4. **Expected**: Agent sets up Docker Compose profile
5. **Expected**: Agent documents minimal startup
6. **Verification**: Single service starts in < 30 seconds with mocked deps
