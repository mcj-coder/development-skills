# Progressive Loading BDD Tests

This file defines BDD test scenarios for validating agent compliance with progressive
document loading guidelines defined in [AGENTS.md](../../AGENTS.md#progressive-document-loading).

## Overview

Progressive loading means: **frontmatter first, full content when relevant**. Agents should
minimize context consumption by loading only the metadata needed for selection, deferring
full document reads until execution requires them.

## RED Scenarios (Anti-Patterns)

These scenarios represent violations of progressive loading principles.

### RED Scenario 1: Unnecessary Full Document Load for Selection

**Given**: Agent needs to select which role applies to a code review task
**When**: Agent reads full content of all role documents in `docs/roles/`
**Then**: This is a VIOLATION because:

- Selection only requires `name`, `description`, `model` fields
- Full document body (responsibilities, review criteria) not needed for selection
- Context consumed unnecessarily

**Evidence of violation:**

- Agent transcript shows `Read` tool calls for full role documents
- No prior frontmatter-only scan was attempted
- Decision made could have been made from frontmatter alone

### RED Scenario 2: Loading Full ADR When Decision Field Suffices

**Given**: Agent needs to apply an architectural decision
**When**: Agent reads entire ADR body including Context, Consequences, Alternatives
**Then**: This is a VIOLATION if:

- The `decision` field contains the actionable outcome
- No ambiguity exists requiring rationale review
- Agent did not first check if `decision` was sufficient

**Evidence of violation:**

- Full ADR read when `decision` field was self-explanatory
- No evidence agent attempted frontmatter-first approach

### RED Scenario 3: Reading All Playbook Bodies to Find Matching Trigger

**Given**: Agent encounters "production incident detected"
**When**: Agent reads full body of every playbook to find which one applies
**Then**: This is a VIOLATION because:

- `triggers` field in frontmatter is designed for matching
- Full body contains execution details, not selection criteria
- Scanning all bodies wastes context on irrelevant content

**Evidence of violation:**

- Multiple full playbook reads in transcript
- Trigger matching done by reading body content, not frontmatter `triggers`

## GREEN Scenarios (Correct Behavior)

These scenarios represent proper progressive loading implementation.

### GREEN Scenario 1: Frontmatter-Only Selection

**Given**: Agent needs to select a role for security review
**When**: Agent scans frontmatter of role documents
**Then**: Agent correctly:

1. Reads only frontmatter (name, description, model) from each role
2. Identifies `security-reviewer` from description containing "security" and "threat"
3. Loads full `security-reviewer.md` body ONLY after selection confirmed
4. Does NOT load full body of non-selected roles

**Evidence of compliance:**

- Transcript shows frontmatter scan before any full read
- Only selected document's full body loaded
- Decision justification references frontmatter fields

### GREEN Scenario 2: ADR Decision Applied Without Full Read

**Given**: Agent needs to apply ADR for documentation format
**When**: Agent checks ADR frontmatter
**Then**: Agent correctly:

1. Reads frontmatter: `name`, `description`, `decision`, `status`
2. Confirms `status: accepted`
3. Applies `decision` field directly: "Use MADR format ADRs in docs/adr/"
4. Does NOT read full ADR body (Context, Alternatives, Consequences)

**Evidence of compliance:**

- Decision applied from frontmatter `decision` field
- No full ADR body in transcript
- Agent cites `decision` field, not body content

### GREEN Scenario 3: Playbook Trigger Matching from Frontmatter

**Given**: Current context contains "database migration needed"
**When**: Agent searches for applicable playbook
**Then**: Agent correctly:

1. Scans `triggers` field of all playbooks
2. Matches "database migration needed" against trigger list
3. Loads `summary` field to get execution steps
4. Executes from `summary` without loading body
5. Loads body ONLY if summary references unexplained nested steps

**Evidence of compliance:**

- Trigger matching done via frontmatter `triggers` array
- Execution follows `summary` field steps
- Body loaded only if summary was insufficient

### GREEN Scenario 4: Full Document Load When Justified

**Given**: Agent selected an ADR but `decision` field is ambiguous
**When**: Agent needs to understand the rationale
**Then**: Agent correctly:

1. First attempts frontmatter-only approach
2. Identifies that `decision` lacks sufficient context
3. Loads full ADR body to read Context and Consequences
4. Documents WHY full read was necessary

**Evidence of compliance:**

- Frontmatter read attempted first
- Explicit justification for full read: "decision field ambiguous, loading rationale"
- Full read is the exception, not the default

## Evidence Requirements

### How to Verify Compliance

1. **Review agent transcript** for Read tool calls
2. **Check read order**: Frontmatter scans should precede full reads
3. **Verify justification**: Full reads should have documented reasons
4. **Measure context**: Compliant agents use less context for selection tasks

### Compliance Checklist

- [ ] Selection tasks use frontmatter-only reads
- [ ] Full document reads are justified in transcript
- [ ] Trigger matching uses `triggers` field, not body search
- [ ] Decisions applied from `decision` field when sufficient
- [ ] Summary execution attempted before body load

### Non-Compliance Indicators

- Multiple full document reads for selection task
- No frontmatter scan before full reads
- Trigger matching via body content grep
- Decision applied citing body content when `decision` field sufficed
- No justification for full document loads

## Integration with Document Type READMEs

This test file validates the central progressive loading directive in AGENTS.md. For
document-type-specific workflows, see:

- **Roles**: [docs/roles/README.md](../roles/README.md) - Role selection workflow
- **ADRs**: [docs/adr/README.md](../adr/README.md) - ADR application workflow
- **Playbooks**: [docs/playbooks/README.md](../playbooks/README.md) - Playbook progressive disclosure
