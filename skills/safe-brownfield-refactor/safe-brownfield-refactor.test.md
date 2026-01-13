# Safe Brownfield Refactor - BDD Test Scenarios

## Scenario: Characterisation Tests Before Refactoring

### Given

- Agent is working on a legacy codebase
- The code to be modified has no existing tests
- Agent needs to make changes to improve code quality

### When

- Agent applies safe-brownfield-refactor skill

### Then

- [ ] Agent writes characterisation tests BEFORE modifying code
- [ ] Tests document current behaviour (not expected behaviour)
- [ ] Tests pass against existing implementation
- [ ] Only after tests pass does agent begin refactoring

### Verification Evidence

```bash
# Git log shows characterisation tests committed before refactoring
git log --oneline --all | grep -E "(characterisation|refactor)"
# Expected: Characterisation test commit appears BEFORE refactoring commit
```

---

## Scenario: Strangler Fig Pattern Application

### Given

- Agent needs to replace a legacy module
- Module is actively used in production
- A big-bang rewrite would be too risky

### When

- Agent applies strangler fig pattern

### Then

- [ ] Agent creates facade/routing layer in front of legacy code
- [ ] New implementation is built behind the facade
- [ ] Traffic is gradually migrated from old to new
- [ ] Legacy code is removed only after new code is proven

### Verification Evidence

```text
Check for:
1. Facade or adapter interface exists
2. Both old and new implementations coexist
3. Routing logic determines which implementation handles requests
4. Feature flag or configuration controls migration
```

---

## Scenario: Risk Assessment Before Refactoring

### Given

- Agent is about to refactor code in a brownfield system
- The code may be high-risk (low coverage, poor documentation)

### When

- Agent begins refactoring work

### Then

- [ ] Agent assesses risk using the risk matrix
- [ ] Risk level determines mitigation strategy
- [ ] High-risk changes include feature flags and rollback plans
- [ ] Documentation of risk assessment is captured in the issue

### Verification Evidence

```text
Issue or PR contains:
- Test coverage percentage (or estimate)
- Documentation status
- Deployment frequency
- Rollback capability assessment
- Risk level determination (Low/Medium/High)
```

---

## Scenario: Small Reversible Changes

### Given

- Agent is refactoring a large legacy module
- Multiple improvements are needed

### When

- Agent executes the refactoring

### Then

- [ ] Each commit contains a single logical change
- [ ] Each commit is independently deployable
- [ ] Changes are easily reversible via git revert
- [ ] No commit contains more than ~100 lines of changes

### Verification Evidence

```bash
# Check commit sizes
git log --oneline --stat -10
# Expected: Small, focused commits with clear descriptions

# Verify each commit could be reverted independently
git log --oneline | head -5
# Each should represent one logical change
```

---

## Scenario: Emergency Rollback During Refactoring

### Given

- Agent has deployed a refactoring change
- Production issues are detected

### When

- Agent needs to respond to the incident

### Then

- [ ] Feature flag is reverted (if applicable)
- [ ] Deployment is rolled back to last known good state
- [ ] System stability is verified
- [ ] Root cause analysis is performed before retry
- [ ] Characterisation test is added for discovered behaviour

### Verification Evidence

```text
Check for:
1. Rollback commit or feature flag change
2. Monitoring showing system recovery
3. Issue updated with root cause analysis
4. New test added to prevent regression
```

---

## Scenario: Legacy Code Without Documentation

### Given

- Agent encounters legacy code with no documentation
- Behaviour of the code is unclear
- Changes are required for a business need

### When

- Agent applies safe-brownfield-refactor skill

### Then

- [ ] Agent maps dependencies before making changes
- [ ] Agent documents discovered behaviour
- [ ] Agent identifies seams for safe modification
- [ ] Agent creates characterisation tests for discovered behaviour

### Verification Evidence

```text
Check for:
1. Dependency diagram or list in documentation
2. Characterisation tests that document behaviour
3. Comments or documentation explaining discovered logic
4. Seams identified and documented for future changes
```

---

## Scenario: Anti-Pattern Detection - Big Bang Rewrite Proposal

### Given

- Agent is tempted to propose a complete rewrite
- Legacy system is complex but functional
- "Starting fresh" seems easier than incremental improvement

### When

- Agent considers approach to modernisation

### Then

- [ ] Agent recognises big-bang rewrite as anti-pattern
- [ ] Agent proposes strangler fig pattern instead
- [ ] Incremental migration plan is created
- [ ] Each increment is independently valuable

### Verification Evidence

```text
Check for:
1. No PR titled "Rewrite X" or "Replace Y completely"
2. Migration plan shows incremental steps
3. Each step delivers working functionality
4. Rollback possible at each stage
```

---

## Scenario: Philosophy Compliance - Skill Design Verification

### Given

- Skill is loaded by an agent
- Agent is working in a brownfield codebase
- Skill needs to meet design philosophy requirements

### Then

### ADR-0001: Design Philosophy Compliance

#### Detection Mechanism

- [x] Triggers on legacy code/brownfield context
- [x] Identifies missing test coverage
- [x] Detects high-risk refactoring scenarios

#### Deference Mechanism

- [x] Respects existing characterisation tests
- [x] Uses existing monitoring and rollback infrastructure
- [x] Integrates with existing deployment patterns

#### Drives Decision Capture

- [x] Risk assessment documented in issues
- [x] Rollback plans captured before changes
- [x] Characterisation test decisions recorded

### ADR-0002: Automation-First Compliance

#### Automation Opportunities

- [x] Characterisation test generation patterns documented
- [x] Feature flag integration patterns documented
- [x] Rollback checklist provided for quick execution

### Verification Evidence

```bash
# Verify key concepts are documented
grep -ci "characterisation\|strangler\|seam\|rollback" skills/safe-brownfield-refactor/SKILL.md
# Expected: Multiple matches for core concepts

# Verify risk assessment documented
grep -c "Risk" skills/safe-brownfield-refactor/SKILL.md
# Expected: Multiple references to risk management
```

---

## Notes

- Brownfield refactoring requires more caution than greenfield development
- The primary goal is safe, incremental improvement, not perfection
- Production stability takes priority over code cleanliness
- Each refactoring should leave the system in a better, testable state
