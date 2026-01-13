# Contract Consistency Validation - BDD Tests

## Scenario 1: Breaking Change Detection and User Confirmation

### Given

- Agent WITH contract-consistency-validation skill
- v1.2.0 API in production

### When

User says: "Change getUserById to return 404 instead of null when user not found"

### Then

Agent responds with:

- Identifies change as behavior modification (null to 404 error)
- Flags as BREAKING CHANGE
- States consumer impact (consumers expecting null will break)
- Determines SemVer impact: Major version bump required
- Presents alternatives (new endpoint, query parameter, deprecation)
- Requires explicit user confirmation before proceeding

### Evidence Checklist

- [ ] Breaking change explicitly flagged
- [ ] Behavior change described (null to 404)
- [ ] Consumer impact assessed
- [ ] SemVer impact stated (major bump)
- [ ] User confirmation required (blocking)
- [ ] Alternatives offered
- [ ] Migration guidance planned

---

## Scenario 2: Pre-1.0 Relaxation with ADR

### Given

- Agent WITH contract-consistency-validation skill
- v0.8.0 API (pre-1.0)

### When

User says: "I want to iterate quickly on the API design during beta. Can we relax breaking change enforcement?"

### Then

Agent responds with:

- Acknowledges pre-1.0 relaxation request
- Requires ADR creation documenting relaxation scope
- Documents consequences and graduation path to v1.0
- Still requires user confirmation per breaking change
- Mandates CHANGELOG documentation for all changes

### Evidence Checklist

- [ ] ADR created for relaxation
- [ ] Scope limited to pre-1.0
- [ ] Consequences documented
- [ ] User confirmation still required per change
- [ ] CHANGELOG documentation mandatory
- [ ] Migration guides required
- [ ] Graduation to strict enforcement at v1.0

---

## Scenario 3: Non-Breaking Additive Change

### Given

- Agent WITH contract-consistency-validation skill
- v1.5.0 API in production

### When

User says: "Add optional email field to getUserById response"

### Then

Agent responds with:

- Identifies change as additive (new optional field)
- Confirms NOT a breaking change
- Determines SemVer impact: Minor version bump
- Proceeds without requiring user confirmation
- Updates contract artifacts and documentation

### Evidence Checklist

- [ ] Change classified as additive
- [ ] Backward compatibility confirmed
- [ ] SemVer impact correct (minor bump)
- [ ] No user confirmation required
- [ ] Schema validation updated
- [ ] Documentation updated

---

## Scenario 4: Post-1.0 Exception Request

### Given

- Agent WITH contract-consistency-validation skill
- v2.3.0 API in production

### When

User says: "We need to make a breaking change but can't go to v3.0 yet. Can we make an exception?"

### Then

Agent responds with:

- Flags as v1+ exception request
- Lists required justification elements
- States approval requirements (tech lead, product, consumers)
- Requires ADR for exception
- Requires consumer communication plan
- Requires rollback strategy
- Blocks without comprehensive justification

### Evidence Checklist

- [ ] Exception flagged as requiring justification
- [ ] Required justification elements listed
- [ ] Approval requirements stated
- [ ] ADR template provided
- [ ] Consumer communication plan required
- [ ] Migration and rollback plans mandatory
- [ ] Agent blocks without justification

---

## Baseline Failure Scenarios (RED Phase)

### Pressure Scenario 1: Time Constraint

**Without skill present:**

- Given: Time constraint ("customer needs this API change today")
- When: "Change the getUserById endpoint to return additional fields"
- Expected failures:
  - Agent does not check for breaking changes
  - Agent does not validate consumer impact
  - Agent does not require user confirmation

### Pressure Scenario 2: Authority Override

**Without skill present:**

- Given: Authority pressure ("product owner approved changing null handling")
- When: "Change the API to return empty array instead of null when no results"
- Expected failures:
  - Agent does not flag breaking behavior change
  - Agent does not validate consumer expectations
  - Agent proceeds without technical validation

### Pressure Scenario 3: Pre-1.0 Assumption

**Without skill present:**

- Given: Pre-1.0 context (version 0.8.0)
- When: "Remove the deprecated legacy parameter from all endpoints"
- Expected failures:
  - Agent does not require ADR for relaxed enforcement
  - Agent does not document breaking changes
  - Agent assumes pre-1.0 allows unrestricted breaks

---

## Verification Commands

```bash
# Verify skill frontmatter format
head -5 skills/contract-consistency-validation/SKILL.md

# Verify REQUIRED sub-skills referenced
grep -c "REQUIRED.*superpowers" skills/contract-consistency-validation/SKILL.md

# Verify references exist
ls skills/contract-consistency-validation/references/

# Verify rationalizations table present
grep -c "Rationalizations Table" skills/contract-consistency-validation/SKILL.md

# Verify red flags section present
grep -c "Red Flags" skills/contract-consistency-validation/SKILL.md

# Word count check (target <300 words in main SKILL.md)
wc -w skills/contract-consistency-validation/SKILL.md
```
