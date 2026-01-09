# dotnet-open-source-first-governance Tests

BDD test scenarios for the `dotnet-open-source-first-governance` skill.

## Scenario 1: Live License Verification Requirement

**Given** an agent is evaluating a new dependency
**When** the agent applies the `dotnet-open-source-first-governance` skill
**Then** the agent MUST perform a live web search to verify current licensing

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent relies solely on cached or historical license information
- [ ] Agent accepts dependency without performing live web search
- [ ] Agent assumes license status from package metadata alone
- [ ] Agent skips verification for "well-known" open-source libraries

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent performs live web search for current license status
- [ ] Agent checks project homepage or official documentation
- [ ] Agent verifies LICENSE file in source repository
- [ ] Agent documents verification date (UTC) with the dependency decision

---

## Scenario 2: OSS-First Dependency Selection

**Given** an agent is selecting between multiple dependency options
**When** the agent applies the `dotnet-open-source-first-governance` skill
**Then** the agent MUST prefer open-source libraries over proprietary alternatives

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent selects proprietary library without justification when OSS alternative exists
- [ ] Agent ignores established OSS libraries in favor of bespoke scripts
- [ ] Agent does not document rationale when choosing non-OSS option
- [ ] Agent treats OSS preference as optional rather than policy

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent prioritizes open-source libraries in dependency selection
- [ ] Agent evaluates established OSS libraries before considering bespoke solutions
- [ ] Agent documents justification if non-OSS option is selected
- [ ] Agent applies OSS-first as non-negotiable policy

---

## Scenario 3: Version-Specific Licensing Checks

**Given** an agent is adopting or upgrading a dependency to a specific version
**When** the agent applies the `dotnet-open-source-first-governance` skill
**Then** the agent MUST verify licensing for the exact version being adopted

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent verifies licensing for latest version but adopts older version
- [ ] Agent assumes all versions share the same license
- [ ] Agent pins to older OSS version without documenting rationale
- [ ] Agent ignores license changes between versions

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent verifies licensing for the exact version being adopted
- [ ] Agent checks release notes for license changes between versions
- [ ] Agent documents rationale, maintenance plan, and security posture when pinning to older version
- [ ] Agent recognizes that license terms can change between versions

---

## Scenario 4: Transitive Dependency Spot-Checks

**Given** an agent is evaluating a dependency with transitive dependencies
**When** the agent applies the `dotnet-open-source-first-governance` skill
**Then** the agent MUST spot-check critical transitive dependencies for license compliance

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent only verifies the direct dependency license
- [ ] Agent ignores transitive dependencies entirely
- [ ] Agent does not check build-time tools or generators
- [ ] Agent assumes transitives inherit parent license

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent spot-checks critical transitive dependencies
- [ ] Agent pays special attention to build-time tools and generators
- [ ] Agent flags transitive dependencies with incompatible licenses
- [ ] Agent documents any transitive license concerns in the dependency decision

---

## Scenario 5: Hard Gate Enforcement

**Given** an agent is reviewing a dependency proposal, PR, or ADR
**When** the agent applies the `dotnet-open-source-first-governance` skill
**Then** the agent MUST reject or defer if required verification is missing

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent approves dependency without license name documented
- [ ] Agent approves dependency without verification source(s)
- [ ] Agent approves dependency without verification date (UTC)
- [ ] Agent treats verification requirements as optional

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent requires license name before approval
- [ ] Agent requires verification source(s) before approval
- [ ] Agent requires verification date (UTC) before approval
- [ ] Agent rejects or defers dependency if any required field is missing

---

## Scenario 6: License Change Detection

**Given** a dependency that was previously open source
**When** the agent performs live license verification
**Then** the agent MUST detect and flag any licensing changes

### RED Conditions (Skill NOT Applied Correctly)

- [ ] Agent assumes previously-OSS libraries remain OSS
- [ ] Agent does not check for source-available restrictions
- [ ] Agent ignores field-of-use or non-commercial limitations
- [ ] Agent overlooks delayed-open clauses or copyleft conflicts

### GREEN Conditions (Skill Applied Correctly)

- [ ] Agent detects source-available restrictions in current license
- [ ] Agent identifies field-of-use or non-commercial limitations
- [ ] Agent flags delayed-open clauses
- [ ] Agent checks for copyleft obligations conflicting with distribution model
- [ ] Agent marks dependency as unapproved if licensing cannot be verified confidently
