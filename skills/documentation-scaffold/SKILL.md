---
name: documentation-scaffold
description: Use this skill when bootstrapping or migrating a repository to ensure the minimum documentation set (including AGENTS.md) is created and aligned before implementation work proceeds.
---

# Documentation Scaffold

## Intent

Ensure every repository has a minimal, consistent documentation foundation
that supports both humans and agents, with `AGENTS.md` as the canonical assistant
context (and optional `CLAUDE.md` compatibility where required).

---

## When to Use

- Starting a new repository (greenfield).
- Migrating a brownfield repo missing or inconsistent docs.
- Establishing or revising assistant context and onboarding docs.

---

## Precondition Failure Signal

- No `AGENTS.md` or equivalent assistant context file exists.
- README lacks setup, verification, or contribution guidance.
- ADRs or decision records are missing for major structural decisions.

---

## Postcondition Success Signal

- `AGENTS.md` exists and reflects current repo expectations.
- README provides accurate setup and verification instructions.
- ADRs are created for significant structural or tooling decisions.
- Documentation passes `documentation-as-code` checks.

---

## Process

1. **Source Review**: Inspect existing docs for accuracy and gaps.
2. **Scope**: Decide whether this is greenfield bootstrap or brownfield cleanup.
3. **Authoring**:
   - Create or update `AGENTS.md` as canonical context.
   - Add a compatible `CLAUDE.md` only if the repo needs it.
   - Ensure README contains setup and verification steps.
   - Add ADRs for material decisions.
   - If local secrets are used, include a safe `.env.example` and ensure real
     secrets are excluded from version control.
4. **Verification**: Run doc quality gates (`documentation-as-code`).
5. **Review**: Tech Lead and Software Engineer validate doc accuracy and scope.

---

## Example Test / Validation

- Documentation checks pass and onboarding steps are reproducible.

---

## Common Red Flags / Guardrail Violations

- Writing new docs that contradict the actual repo state.
- Using `CLAUDE.md` as the only context file when `AGENTS.md` is required.
- Skipping ADRs for structural decisions.

---

## Recommended Review Personas

- **Tech Lead** - validates architectural intent and decision coverage.
- **Software Engineer** - validates onboarding clarity and accuracy.

---

## Skill Priority

P2 - Consistency & Governance

---

## Conflict Resolution Rules

- If documentation conflicts with implementation, implementation evidence wins
  and docs must be corrected before proceeding.

---

## Conceptual Dependencies

- documentation-as-code

---

## Classification

Governance
Core

---

## Notes

Use `AGENTS.md` as the default context file for this repo. Only add
`CLAUDE.md` when compatibility is explicitly required.
