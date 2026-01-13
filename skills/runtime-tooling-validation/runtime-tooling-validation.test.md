# runtime-tooling-validation - BDD Tests

## RED Phase - Baseline Testing (WITHOUT Skill Present)

### Test R1: Missing Dependencies - Project Won't Build

```gherkin
Given agent WITHOUT runtime-tooling-validation skill
And pressure: time ("need this feature urgently")
When user says: "Clone and run this .NET project"
Then record:
  - Does agent verify .NET SDK version installed? (likely NO - assumes installed)
  - Does agent check for required global tools? (likely NO - proceeds blindly)
  - Does agent validate NuGet package sources? (likely NO - assumes defaults)
  - Does agent verify required environment variables? (likely NO - discovers at runtime)
  - Rationalizations: "Just run dotnet restore", "Error will tell us what's missing"
```

**Expected Baseline Failure:**
Agent attempts to run project without validating prerequisites, leading to cryptic errors.

### Test R2: Environment Setup - Missing Variables

```gherkin
Given agent WITHOUT runtime-tooling-validation skill
And pressure: delivery ("get the tests passing")
When user says: "Run the integration tests for this service"
Then record:
  - Does agent check for required env vars? (likely NO - runs and fails)
  - Does agent verify database connection available? (likely NO - discovers at runtime)
  - Does agent validate API keys configured? (likely NO - fails with auth error)
  - Does agent check for required services running? (likely NO - timeout errors)
  - Rationalizations: "Run tests and see what happens", "Error messages will guide us"
```

**Expected Baseline Failure:**
Agent runs tests blindly, encountering cascading failures from missing configuration.

### Test R3: Node.js Project - Version Mismatch

```gherkin
Given agent WITHOUT runtime-tooling-validation skill
And pressure: complexity ("monorepo with multiple services")
When user says: "Set up the development environment for this project"
Then record:
  - Does agent verify Node.js version matches .nvmrc? (likely NO - uses system default)
  - Does agent check npm/yarn/pnpm version requirements? (likely NO - assumes any version)
  - Does agent validate peer dependencies? (likely NO - npm install and hope)
  - Does agent check for required native build tools? (likely NO - fails on node-gyp)
  - Rationalizations: "npm install will work", "We'll fix errors as they come"
```

**Expected Baseline Failure:**
Agent uses wrong Node version, causing subtle compatibility issues or build failures.

### Baseline Observations (Simulated)

Without the skill, a typical agent response includes:

- "Let's run `dotnet build` and see what happens."
- "Try `npm install` and we'll fix any errors."
- "Run the tests - the error messages will tell us what's missing."
- "Start the application and see if it works."
- "Just git clone and run the start script."

## GREEN Phase - Concrete BDD Scenarios (WITH Skill Present)

### Scenario G1: .NET Project Setup Validation

```gherkin
Given agent WITH runtime-tooling-validation skill
When user says: "Set up this .NET project for local development"
Then agent responds with:
  "Validating development environment before setup. Checking:
   - .NET SDK version matches global.json requirement
   - Required global tools installed (dotnet-ef, etc.)
   - NuGet package sources configured correctly
   - Required environment variables present
   - Database and service dependencies available"
And agent performs:
  - Check dotnet --version against global.json
  - Verify dotnet tool list --global for required tools
  - Validate nuget.config sources
  - Check environment variables from .env.example or appsettings
  - Test connectivity to required services
And agent reports:
  - Missing prerequisites with installation commands
  - Mismatched versions with upgrade/downgrade instructions
  - Missing environment variables with setup guidance
```

**Evidence Checklist:**

- [ ] SDK version validated against global.json
- [ ] Required global tools checked
- [ ] Package sources verified
- [ ] Environment variables validated
- [ ] Service dependencies tested
- [ ] Clear remediation steps for any issues
- [ ] Build attempted only after validation passes

### Scenario G2: Node.js Project Setup Validation

```gherkin
Given agent WITH runtime-tooling-validation skill
When user says: "Get this Node.js project running locally"
Then agent responds with:
  "Validating development environment before setup. Checking:
   - Node.js version matches .nvmrc or engines field
   - Package manager version (npm/yarn/pnpm) correct
   - Native build dependencies available (Python, C++ tools)
   - Required environment variables configured
   - Peer dependencies compatible"
And agent performs:
  - Check node --version against .nvmrc or package.json engines
  - Verify package manager version requirements
  - Check for node-gyp dependencies if native modules present
  - Validate .env file against .env.example
  - Run npm ls to check for peer dependency issues
And agent reports:
  - Version mismatches with nvm/volta commands to switch
  - Missing native build tools with install instructions
  - Missing environment variables with descriptions
```

**Evidence Checklist:**

- [ ] Node version validated against project requirements
- [ ] Package manager version verified
- [ ] Native build tools checked if needed
- [ ] Environment variables validated
- [ ] Peer dependencies verified
- [ ] Clear remediation steps for any issues
- [ ] Install attempted only after validation passes

### Scenario G3: Python Project Setup Validation

```gherkin
Given agent WITH runtime-tooling-validation skill
When user says: "Set up this Python project for development"
Then agent responds with:
  "Validating development environment before setup. Checking:
   - Python version matches pyproject.toml or .python-version
   - Virtual environment tooling available (venv, poetry, uv)
   - System dependencies for compiled packages
   - Required environment variables configured
   - External service connectivity"
And agent performs:
  - Check python --version against project requirements
  - Verify pip/poetry/uv installation
  - Check for system libraries needed by wheels
  - Validate environment from .env.example
  - Test external service connectivity
And agent reports:
  - Version mismatches with pyenv commands
  - Missing system dependencies with apt/brew commands
  - Environment variable gaps with setup guidance
```

**Evidence Checklist:**

- [ ] Python version validated
- [ ] Virtual environment tooling verified
- [ ] System dependencies checked
- [ ] Environment variables validated
- [ ] Service connectivity tested
- [ ] Clear remediation steps provided
- [ ] pip install attempted only after validation

### Scenario G4: Docker-Based Development Validation

```gherkin
Given agent WITH runtime-tooling-validation skill
And project uses Docker for development
When user says: "Set up the development environment"
Then agent responds with:
  "Validating container development environment. Checking:
   - Docker daemon running and accessible
   - Docker Compose version meets requirements
   - Required Docker networks exist
   - Volume mounts accessible
   - Required images available or buildable
   - Port conflicts with existing services"
And agent performs:
  - Check docker version and daemon status
  - Verify docker compose version
  - Check for port conflicts on required ports
  - Validate volume mount paths exist
  - Test image pull/build capability
And agent reports:
  - Docker issues with specific remediation
  - Port conflicts with process identification
  - Volume permission issues with fix commands
```

**Evidence Checklist:**

- [ ] Docker daemon status verified
- [ ] Docker Compose version checked
- [ ] Port availability confirmed
- [ ] Volume paths validated
- [ ] Image availability confirmed
- [ ] Clear remediation for any issues
- [ ] docker compose up attempted only after validation

## REFACTOR Phase - Rationalization Closing

### Rationalizations Table

| Excuse                                | Reality                                                                                        | Skill Enforcement                           |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------- |
| "Just run it and see"                 | Runtime failures waste time debugging missing prerequisites. Validate first.                   | Pre-flight check before any build/run       |
| "Error messages tell us what's wrong" | Cryptic errors waste time. Explicit validation surfaces clear requirements.                    | Structured validation with clear output     |
| "Works on my machine"                 | Environment differences cause most setup failures. Validation catches differences.             | Environment comparison against requirements |
| "We'll fix issues as they come"       | Cascading failures hide root cause. Systematic validation reveals all issues upfront.          | Complete validation before attempting build |
| "npm install will handle it"          | Package managers don't validate runtime requirements. Tools and services need explicit checks. | Validate beyond package.json dependencies   |
| "The README has setup instructions"   | README often outdated or incomplete. Automated validation catches drift.                       | Automated checks complement documentation   |

### Red Flags - STOP

The skill includes these red flags to trigger immediate attention:

- "Let's try it and see what happens"
- "The error will tell us what's missing"
- "Just run npm install / dotnet restore"
- "It should work"
- "Works on CI so should work locally"
- "Skip validation, we're in a hurry"

**All of these mean:** Run validation checks before attempting build/run operations.

## Pressure Scenarios (WITH Skill)

### Test P1: Resist "Just Try It" Pressure

```gherkin
Given agent WITH runtime-tooling-validation skill
And pressure: time ("we don't have time for setup checks")
When user says: "Just run the project, we'll fix issues later"
Then agent responds:
  - Acknowledges time pressure
  - Explains validation takes 30 seconds, debugging failures takes hours
  - Runs quick validation checks
  - Reports issues with one-liner fixes
  - Proceeds only when environment is valid
And agent does NOT:
  - Skip validation "to save time"
  - Attempt build without checking prerequisites
  - Promise to "fix issues as they come"
```

### Test P2: Resist "Works on CI" Assumption

```gherkin
Given agent WITH runtime-tooling-validation skill
And pressure: confidence ("CI is green, so local should work")
When user says: "CI passes, just run the tests locally"
Then agent responds:
  - Acknowledges CI success
  - Explains local environment differs from CI (versions, services, secrets)
  - Validates local environment matches CI requirements
  - Identifies gaps between local and CI setup
  - Provides commands to align local with CI
And agent does NOT:
  - Assume local matches CI
  - Skip validation because CI works
  - Run tests without checking dependencies
```

### Test P3: Resist "README Says So" Trust

```gherkin
Given agent WITH runtime-tooling-validation skill
And pressure: documentation ("README has all setup steps")
When user says: "Follow the README to set up the project"
Then agent responds:
  - Reads README for requirements
  - Validates each requirement is actually met
  - Identifies gaps between README and actual state
  - Reports README steps that need attention
  - Suggests README updates if outdated
And agent does NOT:
  - Trust README blindly
  - Skip validation because documented
  - Assume documented versions are installed
```

## Integration Scenarios

### Test I1: Integration with local-dev-experience

```gherkin
Given agent WITH runtime-tooling-validation skill
And agent WITH local-dev-experience skill
When user says: "Set up fast local development for this project"
Then agent:
  1. First applies runtime-tooling-validation for prerequisites
  2. Then applies local-dev-experience for optimization
  3. Fast feedback setup builds on validated foundation
  4. Watch modes work because dependencies are correct
```

**Evidence:**

- [ ] Prerequisites validated first
- [ ] Environment confirmed working
- [ ] Then optimization applied
- [ ] Fast feedback loops function correctly

### Test I2: Integration with greenfield-baseline

```gherkin
Given agent WITH runtime-tooling-validation skill
And agent WITH greenfield-baseline skill
When user says: "Create a new project and verify the setup"
Then agent:
  1. Creates baseline structure
  2. Validates created environment is correct
  3. Confirms all tooling versions appropriate
  4. Verifies clean build achievable
```

**Evidence:**

- [ ] Baseline created
- [ ] Validation confirms setup correct
- [ ] All tools at expected versions
- [ ] Build succeeds on validated environment

### Test I3: Integration with CI/CD validation

```gherkin
Given agent WITH runtime-tooling-validation skill
When user says: "Make sure local matches CI for debugging"
Then agent:
  1. Reads CI configuration for requirements
  2. Validates local environment against CI specs
  3. Reports differences between local and CI
  4. Provides alignment commands
```

**Evidence:**

- [ ] CI requirements extracted
- [ ] Local environment compared
- [ ] Differences identified
- [ ] Alignment path provided

## Assertions (Verifiable Post-Implementation)

### Skill Structure

- [ ] Skill exists at `skills/runtime-tooling-validation/SKILL.md`
- [ ] SKILL.md has YAML frontmatter with name and description
- [ ] Description starts with "Use when..."
- [ ] Main SKILL.md is concise (under 400 words)
- [ ] Test file exists at `skills/runtime-tooling-validation/runtime-tooling-validation.test.md`

### Skill Content

- [ ] P1 Quality & Correctness priority documented
- [ ] Prerequisites listed if any
- [ ] Core workflow documented
- [ ] Quick reference table for validation commands
- [ ] Red flags section included
- [ ] Multi-ecosystem coverage (at minimum: .NET, Node.js, Python)

### Key Patterns Documented

- [ ] Pre-flight validation workflow
- [ ] SDK/runtime version checking
- [ ] Environment variable validation
- [ ] Service dependency verification
- [ ] Clear remediation guidance
- [ ] Validation before build/run principle
