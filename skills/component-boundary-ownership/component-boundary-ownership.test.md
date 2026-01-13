# component-boundary-ownership - Test Scenarios

## RED Phase - Baseline Testing (WITHOUT Skill)

### Test R1: Time Pressure - Quick Organization

**Given** agent WITHOUT component-boundary-ownership skill
**And** pressure: time ("need to ship feature this week")
**When** user says: "Where should I put the new payment processing code and its docs?"
**Then** record baseline behaviour:

- Does agent evaluate deployment boundaries? (expected: NO - just picks convenient location)
- Does agent consider ownership and coupling? (expected: NO - skips analysis)
- Does agent define component boundaries? (expected: NO - adds to existing structure)
- Rationalizations observed: "Can reorganize later", "Just need it working", "Existing structure is fine"

### Test R2: Sunk Cost - Existing Structure

**Given** agent WITHOUT component-boundary-ownership skill
**And** pressure: sunk cost ("already have 20 files in /src")
**When** user says: "Should we split this into separate services or keep it together?"
**Then** record baseline behaviour:

- Does agent analyze current coupling? (expected: NO - too disruptive)
- Does agent evaluate deployment independence? (expected: NO - would require restructure)
- Does agent consider team ownership? (expected: NO - organizational question)
- Rationalizations observed: "Current structure works", "Split when it becomes a problem", "Not worth refactoring now"

### Test R3: Authority - Just Put It Somewhere

**Given** agent WITHOUT component-boundary-ownership skill
**And** pressure: authority ("tech lead said just add it")
**When** user says: "Where does the notification service documentation go?"
**Then** record baseline behaviour:

- Does agent evaluate ownership boundaries? (expected: NO - follows directive)
- Does agent consider documentation grouping strategy? (expected: NO - picks arbitrary location)
- Does agent check for existing conventions? (expected: NO - minimal effort)
- Rationalizations observed: "Tech lead knows best", "Documentation location doesn't matter much", "Just need it documented"

### Expected Baseline Failures Summary

- [ ] Agent places code/docs in convenient locations without analyzing boundaries
- [ ] Agent doesn't evaluate coupling, ownership, or deployment independence
- [ ] Agent rationalizes deferring boundary decisions to "when we scale"
- [ ] Agent doesn't distinguish component-level (macro) from file-level (micro) organization
- [ ] Agent doesn't check well-known location conventions

## GREEN Phase - WITH Skill

### Test G1: Greenfield - Defining Initial Boundaries

**Given** agent WITH component-boundary-ownership skill
**And** new repository without established boundaries
**When** user says: "I'm building an e-commerce platform with products, orders, and payments. How should I organize this?"
**Then** agent responds with:

- Deployment independence evaluation
- Team ownership considerations
- Coupling analysis (dependencies identified)
- Recommendation with rationale (e.g., modular monolith with clear boundaries)

**And** agent creates:

- Component directories with proper structure (docs/, src/, tests/)
- Shared contracts directory for inter-component interfaces
- Architecture documentation describing boundaries

**Evidence checklist:**

- [ ] Deployment independence evaluated
- [ ] Team ownership considered
- [ ] Coupling analysis documented (dependencies identified)
- [ ] Component boundaries defined with rationale
- [ ] Directory structure created
- [ ] Architecture doc describes boundaries
- [ ] Cross-references scoped-colocation for intra-component layout

### Test G2: Brownfield - Refactoring Boundaries

**Given** agent WITH component-boundary-ownership skill
**And** existing codebase with mixed concerns in /src
**When** user says: "This codebase has grown to 500 files in /src. Should we reorganize?"
**Then** agent responds with:

- Current coupling analysis
- Natural boundaries identified with evidence
- Team ownership mapping
- Incremental migration recommendation (phases)

**And** agent provides:

- Coupling analysis report
- Migration plan (incremental, preserves imports)
- Component ownership matrix
- Architecture tests planned for boundary enforcement

**Evidence checklist:**

- [ ] Current coupling analyzed
- [ ] Natural boundaries identified with evidence
- [ ] Deployment independence evaluated
- [ ] Team ownership mapped
- [ ] Incremental migration plan provided
- [ ] Automated migration tooling offered
- [ ] Architecture tests planned for boundary enforcement

### Test G3: Documentation Placement Decision

**Given** agent WITH component-boundary-ownership skill
**And** established component structure
**When** user says: "Where should the API versioning strategy doc go?"
**Then** agent responds with:

- Scope analysis (cross-cutting vs component-specific)
- Audience identification
- Well-known location conventions check
- Ownership determination
- Placement decision with rationale

**And** agent creates:

- Document in appropriate location (e.g., docs/architecture/)
- Cross-links from README and relevant component docs

**Evidence checklist:**

- [ ] Scope analyzed (cross-cutting vs component-specific)
- [ ] Audience identified
- [ ] Well-known location conventions checked
- [ ] Ownership determined
- [ ] Placement decision documented with rationale
- [ ] Cross-links established

## Pressure Scenarios (WITH Skill)

### Test P1: Resist Time Pressure

**Given** agent WITH component-boundary-ownership skill
**And** user says: "Just put it somewhere, we need to ship"
**When** agent is tempted to skip boundary analysis
**Then** agent responds:

- Acknowledges time concern
- Explains boundary decision takes 5 minutes
- Shows wrong placement creates technical debt
- Proposes quick boundary evaluation

**And** agent does NOT:

- Skip boundary analysis for speed
- Place code/docs in arbitrary locations
- Defer boundary decisions

### Test P2: Resist Sunk Cost Pressure

**Given** agent WITH component-boundary-ownership skill
**And** user says: "We already have everything in /src, too late to restructure"
**When** agent is tempted to accept current structure
**Then** agent responds:

- Acknowledges existing structure
- Proposes incremental migration approach
- Shows value of eventual boundaries
- Offers to start with documentation only

**And** agent does NOT:

- Accept "too late" as valid excuse
- Skip coupling analysis
- Add more files without evaluating boundaries

### Test P3: Resist Authority Pressure

**Given** agent WITH component-boundary-ownership skill
**And** user says: "Tech lead said just add it to /lib"
**When** agent is tempted to follow directive without analysis
**Then** agent responds:

- Respects tech lead's direction
- Suggests quick boundary check (5 minutes)
- Frames as "clarifying placement" not "questioning authority"
- Offers ownership analysis to support decision

**And** agent does NOT:

- Blindly follow without boundary consideration
- Skip ownership analysis
- Place without documenting rationale

## Integration Scenarios

### Test I1: Integration with brainstorming

**Given** agent WITH component-boundary-ownership skill
**And** agent WITH superpowers:brainstorming
**When** user is exploring repository organization
**Then** agent presents options:

1. Monorepo with workspaces
2. Polyrepo (separate repos)
3. Modular monolith

**And** asks about:

- Deployment independence requirements
- Team structure and ownership
- Release cadence differences
- Technology diversity needs

**And** surfaces tradeoffs:

- Monorepo: easier refactoring, shared tooling, complex build
- Polyrepo: independent versioning, deployment isolation, harder cross-repo changes
- Modular monolith: balanced approach, requires discipline

### Test I2: Integration with verification-before-completion

**Given** agent WITH component-boundary-ownership skill
**And** agent WITH superpowers:verification-before-completion
**When** boundary organization is "complete"
**Then** agent:

1. Verifies directory structure matches documented boundaries
2. Confirms ownership matrix created
3. Checks architecture doc updated
4. Only then declares complete

**Evidence:**

- [ ] Directory structure verified
- [ ] Ownership matrix exists
- [ ] Architecture doc references boundaries
- [ ] Evidence provided (not just assertion)

### Test I3: Delegation to scoped-colocation

**Given** agent WITH component-boundary-ownership skill
**And** component boundaries established
**When** user asks: "Where should the OrderValidator class go within the orders component?"
**Then** agent:

- Recognizes this is intra-component (micro) concern
- Delegates to scoped-colocation skill
- Does not re-evaluate component boundaries

**Evidence:**

- [ ] Macro vs micro distinction recognized
- [ ] Delegation to appropriate skill
- [ ] Boundary not unnecessarily reconsidered

## Rationalizations Closure

### Test RC1: "Can reorganize later"

**Given** agent WITH component-boundary-ownership skill
**When** user or agent rationalizes: "Can reorganize later when we scale"
**Then** agent responds:

- "Boundaries are harder to add later. Establish early with minimal effort."
- Shows cost of late restructuring
- Proposes quick boundary evaluation now

### Test RC2: "Current structure works fine"

**Given** agent WITH component-boundary-ownership skill
**When** user or agent rationalizes: "Current structure works fine"
**Then** agent responds:

- "Lack of boundaries couples components, slows changes, obscures ownership."
- Shows impact on team velocity
- Offers coupling analysis to surface hidden costs

### Test RC3: "Documentation location doesn't matter"

**Given** agent WITH component-boundary-ownership skill
**When** user or agent rationalizes: "Documentation location doesn't matter"
**Then** agent responds:

- "Discoverability matters. Component-scoped vs global placement affects maintainability."
- Shows how wrong placement harms discoverability
- Proposes quick placement evaluation

### Test RC4: "Split when it becomes a problem"

**Given** agent WITH component-boundary-ownership skill
**When** user or agent rationalizes: "Split when it becomes a problem"
**Then** agent responds:

- "Problems are symptom of missing boundaries. Proactive boundaries prevent problems."
- Shows cost of reactive vs proactive
- Proposes minimal boundary definition now

## Verification Assertions

Each GREEN test should verify:

- [ ] Deployment independence evaluated
- [ ] Team ownership considered
- [ ] Coupling analysis performed
- [ ] Reuse patterns identified
- [ ] Organization pattern selected with rationale
- [ ] Well-known location conventions respected
- [ ] Macro vs micro placement distinction clear
- [ ] Boundaries documented
- [ ] Component ownership matrix provided
- [ ] Evidence checklist provided
- [ ] Rationalizations closed (cannot be bypassed)
