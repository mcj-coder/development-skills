# Backlog Grooming Phase Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan
> task-by-task.

**Goal:** Add a backlog grooming phase to issue-driven-delivery for triaging and preparing
issues before they enter the main workflow.

**Architecture:** Insert a new "Grooming" state between "New Feature" and "Refinement" in
the work item lifecycle. The grooming phase contains 6 activities that validate issues
meet quality standards before entering active work. A new playbook documents the full
ticket lifecycle with Mermaid diagrams.

**Tech Stack:** Markdown documentation, BDD test scenarios, Mermaid diagrams for
visualization.

**Status:** Draft

---

## Acceptance Criteria Mapping

| AC                                       | Task |
| ---------------------------------------- | ---- |
| Backlog Grooming phase in SKILL.md       | 2    |
| All 6 grooming activities documented     | 2    |
| ticket-lifecycle.md with Mermaid diagram | 3    |
| Role responsibilities documented         | 3    |
| Git branching compatible with workflow   | 3    |
| Exit criteria for grooming defined       | 2    |
| BDD tests updated for grooming phase     | 1    |
| All linting passes                       | 4    |

---

## Task 1: Create BDD test file for grooming phase

**Files:**

- Create: `skills/issue-driven-delivery/issue-driven-delivery-grooming.test.md`

## Task 2: Add Backlog Grooming phase to issue-driven-delivery

**Files:**

- Modify: `skills/issue-driven-delivery/SKILL.md`
- Modify: `skills/issue-driven-delivery/references/state-tracking.md`

## Task 3: Create ticket-lifecycle playbook

**Files:**

- Create: `docs/playbooks/ticket-lifecycle.md`
- Modify: `docs/playbooks/README.md`

## Task 4: Run verification and create PR

---

## TDD Commit Sequence

| Order | Type | Commit Message                                                         |
| ----- | ---- | ---------------------------------------------------------------------- |
| 1     | Test | test: add BDD scenarios for backlog grooming phase                     |
| 2     | Feat | feat(skill): add backlog grooming phase to issue-driven-delivery       |
| 3     | Docs | docs(playbook): create ticket-lifecycle playbook with Mermaid diagrams |

---

## Approval History

| Phase | Reviewer | Decision | Date | Plan Commit | Comment Link |
| ----- | -------- | -------- | ---- | ----------- | ------------ |
|       |          |          |      |             |              |

## Review History

(To be populated during review process)
