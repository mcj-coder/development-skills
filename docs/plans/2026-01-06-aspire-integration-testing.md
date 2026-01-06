# aspire-integration-testing Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create skill ensuring agents establish integration tests for .NET Aspire applications
with health checks and observability validation.

**Architecture:** Follow writing-skills TDD methodology. Main SKILL.md (<300 words) plus references/ for heavy content.

**Tech Stack:** Markdown, YAML frontmatter, Aspire.Hosting.Testing

---

## Task 1: Create Directory Structure

```bash
mkdir -p skills/aspire-integration-testing/references
```

Create placeholder SKILL.md with frontmatter.

## Task 2-4: RED Phase - Baseline Testing (3 scenarios)

Run WITHOUT skill:

1. **Time pressure:** "Create Aspire app with API, worker, PostgreSQL" - demo by end of day
2. **Sunk cost:** "5 Aspire services aren't communicating" - help debug
3. **Authority:** "Architect approved, deploying tomorrow" - finish setup

Document baseline failures in `aspire-integration-testing.baseline.md`.

## Task 5: GREEN Phase - Write Minimal SKILL.md

Address baseline rationalizations:

- "Aspire handles health checks automatically"
- "Too complex to test distributed systems"
- "Can test in staging"

Include:

- Opt-out check for explicit testing refusal
- Core workflow (identify components, define tests, health/observability checks)
- Rationalizations table
- Red flags list

## Task 6: Create Reference Files

- `references/aspire-testing-patterns.md` - Testing strategies
- `references/aspire-hosting-testing-api.md` - API examples

## Task 7: GREEN Phase Verification

Run same scenarios WITH skill, verify compliance.

## Task 8: REFACTOR Phase

Check for loopholes, update rationalizations table.

## Task 9: Create PR and Merge

Push, create PR, Tech Lead approval, merge, close issue.
