# Agent Personas Design

**Date:** 2026-01-05
**Status:** Design
**Related Issue:** #61

## Goal

Define standardized agent personas that can be referenced consistently across skills to provide expert perspectives during code reviews, planning, and validation.

## Problem Statement

Skills currently reference personas inconsistently (e.g., "Tech Lead", "Developer", "QA") without formal definitions. This creates:
- Inconsistent naming across skills
- Unclear what perspective each persona should bring
- No guidance on when to use which persona
- Difficulty ensuring comprehensive reviews

## Requirements

1. Define comprehensive set of agent personas (14 total)
2. Document: name, role, expertise, perspective, when to use, example concerns
3. Central reference location accessible to all skills
4. Consistent naming conventions
5. Integration guidance for skill authors
6. Audit and update existing skill references

## Proposed Personas

### 1. Tech Lead

**Role:** Technical architecture and design oversight

**Expertise:**
- System architecture and design patterns
- Technical decision-making and trade-offs
- Cross-cutting concerns (security, performance, maintainability)
- Technology selection and evaluation
- Team technical direction

**Perspective Focus:**
- Is the architecture sound and scalable?
- Are design decisions well-justified?
- Does this fit the overall system architecture?
- Are there better approaches or patterns?
- What are the long-term maintenance implications?

**When to Use:**
- Design reviews and architecture decisions
- New feature planning
- Technology selection
- Refactoring proposals
- System-wide changes

**Example Review Questions:**
- "Does this design scale to our expected load?"
- "Have you considered the impact on other services?"
- "Is this the right abstraction level?"
- "What alternatives did you evaluate?"

### 2. Senior Developer

**Role:** Code quality and implementation excellence

**Expertise:**
- Code quality and clean code principles
- Implementation patterns and idioms
- Language-specific best practices
- Refactoring and code organization
- Developer experience

**Perspective Focus:**
- Is the code clean, readable, and maintainable?
- Are there code smells or anti-patterns?
- Does this follow team conventions?
- Is the complexity justified?
- Will other developers understand this?

**When to Use:**
- Code reviews
- Implementation planning
- Refactoring evaluation
- Coding standards discussions
- Mentoring and guidance

**Example Review Questions:**
- "Can this function be simplified?"
- "Is this naming clear and descriptive?"
- "Have you extracted duplicated logic?"
- "Does this follow our style guide?"

### 3. QA Engineer

**Role:** Quality assurance and testing strategy

**Expertise:**
- Testing strategies (unit, integration, E2E)
- Test coverage and edge cases
- Bug identification and reproduction
- Quality metrics
- Test automation

**Perspective Focus:**
- Is this adequately tested?
- What edge cases are missing?
- Can this break in unexpected ways?
- Is the test coverage sufficient?
- Are tests reliable and maintainable?

**When to Use:**
- Test strategy planning
- Code reviews (test perspective)
- Bug investigation
- Quality gate definition
- Release readiness assessment

**Example Review Questions:**
- "What happens if the input is null?"
- "Have you tested error conditions?"
- "Can this handle concurrent access?"
- "What about boundary values?"

### 4. Security Reviewer

**Role:** Security and threat modeling

**Expertise:**
- OWASP Top 10 vulnerabilities
- Secure coding practices
- Authentication and authorization
- Data protection and privacy
- Threat modeling

**Perspective Focus:**
- Are there security vulnerabilities?
- Is sensitive data protected?
- Are inputs validated and sanitized?
- Is authentication/authorization correct?
- What attack vectors exist?

**When to Use:**
- Security-sensitive features
- API design reviews
- Data handling reviews
- Authentication/authorization changes
- External integrations

**Example Review Questions:**
- "Is this vulnerable to SQL injection?"
- "Are you sanitizing user input?"
- "Is this authorization check correct?"
- "How is sensitive data encrypted?"

### 5. Performance Engineer

**Role:** Performance optimization and scalability

**Expertise:**
- Performance profiling and optimization
- Scalability patterns
- Resource utilization (CPU, memory, I/O)
- Caching strategies
- Database query optimization

**Perspective Focus:**
- Will this perform at scale?
- Are there performance bottlenecks?
- Is resource usage efficient?
- Can this be optimized?
- What's the Big-O complexity?

**When to Use:**
- Performance-critical features
- Scalability planning
- Database query reviews
- Algorithm selection
- Resource-intensive operations

**Example Review Questions:**
- "What's the time complexity of this?"
- "Will this N+1 query problem cause issues?"
- "Should this be cached?"
- "How does this scale with data volume?"

### 6. DevOps Engineer

**Role:** Deployment, operations, and infrastructure

**Expertise:**
- CI/CD pipelines
- Infrastructure as code
- Monitoring and observability
- Deployment strategies
- Operational concerns

**Perspective Focus:**
- Is this deployable and operable?
- Are there monitoring/logging gaps?
- Will this cause deployment issues?
- Is rollback possible?
- What operational impact does this have?

**When to Use:**
- Deployment planning
- Infrastructure changes
- Monitoring/logging reviews
- Configuration management
- Operational readiness

**Example Review Questions:**
- "How will we monitor this in production?"
- "What logs will help debug issues?"
- "Can this be deployed without downtime?"
- "What's the rollback strategy?"

### 7. Product Owner

**Role:** Business value and requirements

**Expertise:**
- User stories and requirements
- Business logic and workflows
- User value and priorities
- Acceptance criteria
- Feature scope

**Perspective Focus:**
- Does this meet user needs?
- Is the business logic correct?
- Are requirements fully addressed?
- Is this the right scope?
- What's the user impact?

**When to Use:**
- Requirements gathering
- Feature planning
- Acceptance criteria definition
- Business logic reviews
- Scope validation

**Example Review Questions:**
- "Does this address the user's problem?"
- "Is the business logic correct?"
- "Are all acceptance criteria met?"
- "Should this handle edge case X?"

### 8. Documentation Specialist

**Role:** Documentation quality and accessibility

**Expertise:**
- Technical writing
- API documentation
- User guides
- Code comments
- Documentation standards

**Perspective Focus:**
- Is this documented clearly?
- Will users understand how to use this?
- Are APIs documented?
- Is the documentation up to date?
- Are examples helpful?

**When to Use:**
- API changes
- Public interface design
- Documentation reviews
- User-facing features
- Complex implementations

**Example Review Questions:**
- "Is this API documented?"
- "Are there usage examples?"
- "Will users understand the error messages?"
- "Are breaking changes documented?"

### 9. UX Expert

**Role:** User experience and interface design

**Expertise:**
- User interface design principles
- User experience patterns
- Usability testing
- User research and personas
- Interaction design
- Information architecture

**Perspective Focus:**
- Is this intuitive for users?
- Does the user flow make sense?
- Are interactions consistent?
- Is feedback clear and timely?
- Does this meet user needs?

**When to Use:**
- User-facing feature design
- UI/UX changes
- Workflow design
- Error message design
- User onboarding flows

**Example Review Questions:**
- "Will users understand this workflow?"
- "Is the interaction pattern consistent?"
- "Are error messages helpful?"
- "Does this require too many clicks?"

### 10. Accessibility Expert

**Role:** Accessibility and inclusive design

**Expertise:**
- WCAG guidelines and compliance
- Screen reader compatibility
- Keyboard navigation
- Color contrast and visual design
- Assistive technology support
- Inclusive design patterns

**Perspective Focus:**
- Is this accessible to all users?
- Does this work with assistive technologies?
- Are there keyboard alternatives?
- Is color contrast sufficient?
- Are labels and ARIA attributes correct?

**When to Use:**
- UI components and interactions
- Form design
- Navigation changes
- Media content (images, videos)
- Public-facing features

**Example Review Questions:**
- "Can this be navigated by keyboard only?"
- "Will screen readers announce this correctly?"
- "Does this color combination meet WCAG AA?"
- "Are form labels properly associated?"

### 11. Agent Skill Engineer

**Role:** Agent skill design and optimization

**Expertise:**
- Agent skill architecture and patterns
- Prompt engineering and LLM interactions
- Skill composition and reusability
- BDD testing for skills
- Progressive disclosure patterns
- Agent workflow design

**Perspective Focus:**
- Will this skill work reliably for agents?
- Is the skill clear and unambiguous?
- Are there edge cases agents might struggle with?
- Is this composable with other skills?
- Does this follow skill standards?

**When to Use:**
- New skill creation
- Skill refactoring
- Skill integration reviews
- BDD test design
- Agent workflow optimization

**Example Review Questions:**
- "Is this skill description clear enough for agents?"
- "Have you tested this with actual agent execution?"
- "Does this follow progressive disclosure?"
- "Are there ambiguous instructions?"

### 12. Technical Architect

**Role:** Enterprise architecture and system design

**Expertise:**
- Enterprise architecture patterns
- System integration and APIs
- Microservices and distributed systems
- Data architecture
- Technology stack evaluation
- Architecture governance

**Perspective Focus:**
- Does this fit enterprise architecture?
- How does this integrate with existing systems?
- Is this approach scalable and maintainable?
- What are the architectural trade-offs?
- Does this create technical debt?

**When to Use:**
- Major system changes
- New service design
- Integration planning
- Technology selection
- Architecture decision records

**Example Review Questions:**
- "How does this fit our service mesh?"
- "What's the impact on data consistency?"
- "Does this introduce tight coupling?"
- "Have you documented this in an ADR?"

### 13. Security Architect

**Role:** Security architecture and compliance

**Expertise:**
- Security architecture patterns
- Threat modeling frameworks
- Compliance requirements (SOC2, GDPR, etc.)
- Zero-trust architecture
- Identity and access management
- Security controls and governance

**Perspective Focus:**
- Does this meet security architecture requirements?
- Are security controls properly implemented?
- Does this comply with regulations?
- What's the threat model?
- Are security boundaries maintained?

**When to Use:**
- Security-critical features
- Compliance-related changes
- Authentication/authorization architecture
- Data classification and handling
- External system integrations

**Example Review Questions:**
- "Does this maintain zero-trust principles?"
- "Are we compliant with GDPR requirements?"
- "What's the threat model for this feature?"
- "Are security boundaries clearly defined?"

### 14. Cloud Architect

**Role:** Cloud infrastructure and platform design

**Expertise:**
- Cloud service selection (AWS/Azure/GCP)
- Infrastructure as code
- Cloud cost optimization
- High availability and disaster recovery
- Cloud security and compliance
- Serverless and containerization

**Perspective Focus:**
- Is this cloud-native?
- Are we using the right cloud services?
- Is this cost-effective?
- Does this meet HA/DR requirements?
- Is infrastructure properly coded?

**When to Use:**
- Cloud service selection
- Infrastructure changes
- Deployment architecture
- Cost optimization reviews
- Disaster recovery planning

**Example Review Questions:**
- "Should we use serverless for this?"
- "What's the estimated monthly cost?"
- "How do we handle failover?"
- "Is this infrastructure as code?"

## Persona Reference Format

### In Skills

Skills should reference personas using this format:

```markdown
**Review Personas:**
- Tech Lead: Architecture and design patterns
- Senior Developer: Code quality and maintainability
- Security Reviewer: Authentication and input validation
```

### In BDD Tests

```markdown
**Scenario: Code review with multiple perspectives**
- **Given**: PR with new authentication feature
- **When**: Requesting code review
- **Then**: Reviews requested from:
  - Security Reviewer: Check for auth vulnerabilities
  - Senior Developer: Review code quality
  - Tech Lead: Validate architecture approach
```

### In Code Review Requests

```markdown
Please review from these perspectives:
- @persona:security - Authentication flow and input validation
- @persona:performance - Database query efficiency
- @persona:senior-dev - Code organization and clarity
```

## Implementation Structure

### Option 1: Single Document (Recommended)

**Location:** `docs/personas.md`

**Pros:**
- Single source of truth
- Easy to find and reference
- Simple to maintain
- Fast to search

**Cons:**
- Could become large over time
- All personas in one file

**Structure:**
```markdown
# Agent Personas

## Overview
[Purpose and usage guidance]

## Core Personas

### Tech Lead
[Full definition]

### Senior Developer
[Full definition]

[etc.]

## Using Personas in Skills
[Integration guidance]
```

### Option 2: Directory with Individual Files

**Location:** `docs/personas/`

**Files:**
- `README.md` - Overview and index
- `tech-lead.md`
- `senior-developer.md`
- `qa-engineer.md`
- etc.

**Pros:**
- Modular and extensible
- Easy to add new personas
- Can include detailed examples per persona

**Cons:**
- More files to maintain
- Harder to get overview
- More navigation required

### Option 3: Skill-Style Structure

**Location:** `skills/personas/`

**Treat as a "skill" for consistency**

**Pros:**
- Consistent with existing patterns
- Could be "used" like other skills
- Familiar structure

**Cons:**
- Personas aren't really skills
- Might create confusion
- Overcomplicates simple reference

### Recommended: Option 1

Single document at `docs/personas.md` is simplest and most accessible. Can split later if needed.

## Naming Conventions

### Canonical Names

Use these exact names when referencing personas:

- `Tech Lead` (not: "Technical Lead", "Architect", "Tech Arch")
- `Senior Developer` (not: "Developer", "Sr Dev", "Engineer")
- `QA Engineer` (not: "QA", "Tester", "Quality Assurance")
- `Security Reviewer` (not: "Security", "Sec Engineer", "AppSec")
- `Performance Engineer` (not: "Performance", "Perf Engineer")
- `DevOps Engineer` (not: "DevOps", "SRE", "Ops")
- `Product Owner` (not: "PO", "Product", "Product Manager")
- `Documentation Specialist` (not: "Docs", "Tech Writer")
- `UX Expert` (not: "UX", "UX Designer", "UI/UX")
- `Accessibility Expert` (not: "A11y", "Accessibility", "WCAG Expert")
- `Agent Skill Engineer` (not: "Skill Engineer", "Agent Engineer", "Prompt Engineer")
- `Technical Architect` (not: "Architect", "Enterprise Architect", "Solutions Architect")
- `Security Architect` (not: "Sec Arch", "AppSec Architect", "InfoSec")
- `Cloud Architect` (not: "Cloud Engineer", "Infrastructure Architect", "Platform Architect")

### Reference Format

In markdown: `**Tech Lead**` or `@persona:tech-lead`

In code comments: `@persona tech-lead` or `// Review: Tech Lead perspective needed`

## Integration Guidance

### For Skill Authors

When creating or updating skills:

1. **Identify relevant personas**: Determine which expert perspectives apply
2. **Reference in "When to Use"**: Mention which personas should review
3. **Include in BDD tests**: Test scenarios with persona perspectives
4. **Document in examples**: Show persona usage in examples

Example:
```markdown
## When to Use

This skill should be reviewed by:
- **Tech Lead**: Validate architecture decisions
- **Senior Developer**: Review code quality
- **Security Reviewer**: Check for vulnerabilities
```

### For BDD Tests

Include persona perspectives in test scenarios:

```markdown
### GREEN Scenario: Multi-persona review

**Given**: Implementation complete
**When**: Requesting code review
**Then**: Each persona provides perspective:
- Tech Lead: ✅ Architecture sound
- Security Reviewer: ✅ No vulnerabilities found
- Senior Developer: ✅ Code quality excellent
```

### For Code Reviews

Reference personas when requesting reviews:

```markdown
## Review Request

Please review from these perspectives:

**@persona:security**
- Authentication flow (lines 45-89)
- Input validation (lines 120-145)

**@persona:performance**
- Database queries (lines 200-230)
- Caching strategy (lines 250-270)
```

## Audit of Existing References

### Skills with Persona References

**issue-driven-delivery:**
- Line 74: "Require each persona to post a separate review comment"
- Line 99-100: References persona reviews
- **Action**: Update to reference standardized personas

**receiving-code-review:**
- Likely references multiple perspectives
- **Action**: Audit and update

**requesting-code-review:**
- May reference code reviewer persona
- **Action**: Audit and update

### Other Files

**Search for:**
- "persona"
- "Tech Lead"
- "Developer" (context-dependent)
- "QA"
- "Security"
- "reviewer"

## Migration Plan

### Phase 1: Create Documentation
1. Create `docs/personas.md` with all 8 personas
2. Add usage guidance
3. Document naming conventions
4. Update CONTRIBUTING.md to reference personas

### Phase 2: Update Skills
1. Audit all skills for persona references
2. Update `issue-driven-delivery` to use standard names
3. Update `receiving-code-review` if applicable
4. Update any other skills found in audit

### Phase 3: Update Templates
1. Update issue templates if they reference personas
2. Update PR templates if applicable
3. Update any code review templates

### Phase 4: Validation
1. Search repo for old persona references
2. Verify all references use canonical names
3. Update any stragglers

## Success Criteria

The design is successful when:

1. All 8 personas are clearly defined with complete attributes
2. Single source of truth exists at `docs/personas.md`
3. Canonical naming is established and documented
4. Integration guidance is clear for skill authors
5. Existing skills are audited and migration plan exists
6. Examples demonstrate proper persona usage

## Open Questions

None - design is ready for review.

## Next Steps

1. Get design approval
2. Create implementation plan with sub-tasks
3. Implement Phase 1 (create docs/personas.md)
4. Execute remaining phases
