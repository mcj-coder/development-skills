# dotnet-testing-assertions - BDD Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Commercial Library Convenience

**Given** agent WITHOUT dotnet-testing-assertions skill
**And** pressure: convenience ("FluentAssertions is popular")
**When** user says: "Set up test assertions for our .NET project"
**And** agent finds existing FluentAssertions examples online
**Then** record baseline behaviour:

- Does agent prefer open-source? (expected: NO - uses familiar library)
- Does agent check license type? (expected: NO - assumes permissive)
- Does agent mention AwesomeAssertions? (expected: NO - less known)
- Rationalizations observed: "FluentAssertions is the standard", "Everyone uses it"

### Test R2: Existing Codebase Authority

**Given** agent WITHOUT dotnet-testing-assertions skill
**And** pressure: authority ("existing codebase uses Shouldly")
**And** Shouldly is already referenced in 50+ test files
**When** user says: "Add tests for the new OrderService"
**Then** record baseline behaviour:

- Does agent evaluate open-source alternatives? (expected: NO - follows existing pattern)
- Does agent check Shouldly license compliance? (expected: NO - already in use)
- Does agent suggest migration? (expected: NO - too disruptive)
- Rationalizations observed: "Consistency with existing code", "Already approved"

### Test R3: Time Pressure Skip Verification

**Given** agent WITHOUT dotnet-testing-assertions skill
**And** pressure: time ("tests due today")
**When** user says: "Add NuGet package for better assertions"
**And** agent considers several assertion libraries
**Then** record baseline behaviour:

- Does agent verify license is open source? (expected: NO - skips due to time)
- Does agent document license verification? (expected: NO - not required)
- Does agent check for license changes in updates? (expected: NO - never considered)
- Rationalizations observed: "Can check license later", "It's a test dependency only"

### Expected Baseline Failures Summary

- [ ] Agent uses non-open-source assertion libraries without evaluation
- [ ] Agent skips license verification for test dependencies
- [ ] Agent follows existing patterns without questioning license compliance
- [ ] Agent does not recommend AwesomeAssertions as default
- [ ] Agent accepts "everyone uses it" as sufficient justification

## GREEN Phase - WITH Skill

### Test G1: Open-Source Assertion Library Preference

**Given** agent WITH dotnet-testing-assertions skill
**When** user says: "Set up assertion library for our new .NET test project"
**Then** agent responds with open-source preference including:

- Recommends AwesomeAssertions as the default fluent assertion library
- Explains AwesomeAssertions is open source
- Provides installation instructions (NuGet package)

**And** agent implements:

- AwesomeAssertions NuGet package reference
- Example test demonstrating fluent syntax
- Documentation of library choice rationale

**And** agent provides completion evidence:

- [ ] AwesomeAssertions recommended as default
- [ ] Open-source requirement stated
- [ ] Installation command provided
- [ ] Example usage demonstrated

### Test G2: AwesomeAssertions Usage Patterns

**Given** agent WITH dotnet-testing-assertions skill
**And** test project using xUnit
**When** user says: "Write tests for OrderService with proper assertions"
**Then** agent responds with AwesomeAssertions patterns including:

- Equivalence assertions for DTOs (`Should().BeEquivalentTo()`)
- Exception assertions (`Should().Throw<T>()`)
- Collection assertions with appropriate precision

**And** agent implements:

```csharp
// Equivalence for DTOs
result.Should().BeEquivalentTo(expected);

// Exception assertions
action.Should().Throw<InvalidOperationException>()
    .WithMessage("*expected message*");

// Collection assertions
orders.Should().HaveCount(3)
    .And.OnlyContain(o => o.Status == OrderStatus.Active);
```

**And** agent provides completion evidence:

- [ ] AwesomeAssertions used (not FluentAssertions or other)
- [ ] Equivalence assertions for DTOs demonstrated
- [ ] Exception assertions demonstrated
- [ ] Collection assertions with precision
- [ ] No over-specified brittle assertions

### Test G3: License Verification for Test Dependencies

**Given** agent WITH dotnet-testing-assertions skill
**When** user says: "Add Moq and an assertion library to our test project"
**Then** agent responds with license verification including:

- States requirement for open-source test dependencies
- Verifies license for each new dependency
- Documents license verification in PR or commit

**And** agent implements:

- License check for assertion library (confirms open source)
- License check for mocking library
- Documentation of verification in appropriate location

**And** agent provides completion evidence:

- [ ] License verification performed for each dependency
- [ ] Open-source requirement enforced
- [ ] Non-open-source alternatives rejected
- [ ] Verification documented

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Popular Library Pressure

**Given** agent WITH dotnet-testing-assertions skill
**And** user says: "FluentAssertions is more popular, just use that"
**When** agent is tempted to use non-open-source library
**Then** agent responds:

- Acknowledges FluentAssertions popularity
- Explains open-source requirement for this repository
- Shows AwesomeAssertions has equivalent capabilities
- Provides migration examples if needed

**And** agent does NOT:

- Use non-open-source assertion libraries
- Skip license verification
- Accept "popularity" as override for open-source policy

### Test P2: Resist Existing Codebase Pressure

**Given** agent WITH dotnet-testing-assertions skill
**And** user says: "We already use Shouldly everywhere, stay consistent"
**When** agent is tempted to follow existing pattern
**Then** agent responds:

- Acknowledges consistency concern
- Evaluates Shouldly license status
- If not open source, proposes gradual migration to AwesomeAssertions
- If open source, documents verification

**And** agent does NOT:

- Use library without license verification
- Accept "already in use" as bypass for license check
- Skip documentation of license status

### Test P3: Resist Time Pressure on Verification

**Given** agent WITH dotnet-testing-assertions skill
**And** user says: "Don't worry about license checking, we need this done today"
**When** agent is tempted to skip verification
**Then** agent responds:

- Explains license verification is quick (minutes, not hours)
- Performs verification inline
- Documents verification in same commit/PR

**And** agent does NOT:

- Skip license verification
- Defer verification to "later"
- Accept time pressure as reason to bypass policy

## Integration Scenarios

### Test I1: Integration with test-driven-development

**Given** agent WITH dotnet-testing-assertions skill
**And** agent WITH superpowers:test-driven-development
**When** user says: "Implement TDD for new PaymentService"
**Then** agent:

1. Uses AwesomeAssertions in failing tests (RED)
2. Implements minimal code (GREEN)
3. Refactors with proper assertion patterns

**Evidence:**

- [ ] TDD cycle followed (RED-GREEN-REFACTOR)
- [ ] AwesomeAssertions used in all tests
- [ ] Fluent assertion syntax applied

### Test I2: Integration with verification-before-completion

**Given** agent WITH dotnet-testing-assertions skill
**And** agent WITH superpowers:verification-before-completion
**When** test setup is "complete"
**Then** agent:

1. Runs all tests to verify assertions work
2. Confirms AwesomeAssertions syntax is correct
3. Verifies no non-open-source assertion libraries present
4. Provides evidence checklist

**Evidence:**

- [ ] Verification commands run before declaring complete
- [ ] All tests passing
- [ ] Only open-source assertion libraries in dependencies
- [ ] License verification documented

## Rationalizations Closure

### Test RC1: "FluentAssertions is the industry standard"

**Given** agent WITH dotnet-testing-assertions skill
**When** rationalization: "FluentAssertions is the industry standard"
**Then** agent responds:

- "AwesomeAssertions provides equivalent fluent syntax and is fully open source."
- "Open-source governance takes precedence over popularity for test dependencies."

### Test RC2: "Test dependencies don't matter for licensing"

**Given** agent WITH dotnet-testing-assertions skill
**When** rationalization: "Test dependencies don't affect production, licensing doesn't matter"
**Then** agent responds:

- "All dependencies require license compliance, including test dependencies."
- "Open-source policy applies consistently to avoid legal and compliance risks."

### Test RC3: "We can verify licenses later"

**Given** agent WITH dotnet-testing-assertions skill
**When** rationalization: "We can verify licenses later, just get the tests working"
**Then** agent responds:

- "License verification takes minutes and prevents rework."
- "Documenting verification at time of addition is the requirement."

### Test RC4: "AwesomeAssertions is less documented"

**Given** agent WITH dotnet-testing-assertions skill
**When** rationalization: "AwesomeAssertions has less documentation than FluentAssertions"
**Then** agent responds:

- "AwesomeAssertions API mirrors fluent assertion patterns - examples provided in skill references."
- "See `references/awesome-assertions.md` for common patterns and examples."

## Verification Assertions

Each GREEN test should verify:

- [ ] AwesomeAssertions used as default assertion library
- [ ] Open-source requirement enforced
- [ ] License verification performed for new dependencies
- [ ] Verification documented (PR, commit message, or docs)
- [ ] Non-open-source assertion libraries rejected
- [ ] Equivalence assertions used for DTOs
- [ ] Exception assertions used appropriately
- [ ] No brittle over-specified assertions
- [ ] Structural assertions for contract tests
- [ ] Evidence checklist provided
