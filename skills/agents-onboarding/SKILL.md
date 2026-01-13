---
name: agents-onboarding
description: Use when user integrates agents into repository, asks to set up agent guidance/rules/onboarding, or repo missing agent-specific onboarding docs (AGENTS.md). Ensures fresh agent context can apply all repo standards and external skills.
compatibility: Requires Superpowers skill system to be installed
metadata:
  type: Foundation
  priority: P0 (Safety & Integrity)
---

# Agents-Onboarding

## Overview

Create AGENTS.md at repository root to enable fresh agent context to apply all
repository standards and external skills. Fresh agents (no conversation history)
must understand how to work in the repository by reading only AGENTS.md.

**REQUIRED SUB-SKILL:** `superpowers:brainstorming`
**REQUIRED SUB-SKILL:** `superpowers:verification-before-completion`

## Core Workflow

1. **Announce** skill and why it applies.
2. **Analyze** repository for existing standards (brownfield) or define new (greenfield).
3. **Create** AGENTS.md at repository root with required sections.
4. **Validate** fresh context test: agent with only AGENTS.md can apply standards.
5. **Commit** with evidence.

## AGENTS.md Required Sections

- **Repository Overview:** Purpose, architecture, key constraints
- **Required Skills:** External (`superpowers:*`) and custom skills with triggers
- **Development Standards:** Code style, testing, review, deployment
- **Repository Conventions:** Directory structure, naming, documentation
- **Process Guidance:** PR workflow, deployment, escalation paths
- **Context Optimization:** What agents must know, focus areas

## Red Flags - STOP

- "Agent can figure it out"
- "We'll document standards later"
- "Just need basic agent help"
- "Only one person uses agents here"

All of these mean: Apply skill, create comprehensive AGENTS.md.

## References

- `references/AGENTS-TEMPLATE.md` - Complete template with annotations
- `references/standards-discovery.md` - Repository analysis techniques
- `references/rationalizations.md` - Excuses and reality checks
