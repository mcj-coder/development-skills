---
name: csharp-best-practices
description: >-
  Use when implementing or refactoring C# code and you must apply best practices aligned to the
  project's effective C# language version and .NET target/runtime. Detect the language/runtime,
  prefer the newest supported features, and consult version-specific references progressively
  from C# 10 upward.
---

# C# Best Practices (Version-Aware Skill)

## Overview

Apply C# best practices appropriate to the project's effective language version. This skill
detects the language/runtime configuration, prefers the newest supported features, and
consults version-specific references progressively from C# 10 upward while respecting
repository conventions.

## When to Use

- Implementing or refactoring C# code in any .NET project
- Reviewing C# code for best practice alignment
- Upgrading code to use newer C# language features
- Resolving analyzer warnings or style issues
- Onboarding to an existing C# codebase to understand effective patterns

## Core Workflow

1. **Detect language version**: Check LangVersion in csproj, Directory.Build.props, or infer from TFM
2. **Record determination**: Document effective C# version and how it was determined
3. **Load references progressively**: Load reference docs from C# 10 up to the effective version
4. **Apply highest-priority guidance**: When conflicts exist, newest version guidance wins
5. **Handle optional analyzers**: Pause and request clarification for optional/contentious rules
6. **Apply to touched code only**: Avoid unrelated formatting changes unless broader refactor requested
7. **Validate build and tests**: Ensure changes compile and pass tests
8. **Emit summary**: Document applied practices and any pending analyzer decisions

## Intent

Apply C# best practices appropriate to the project's **effective language version**.
Prefer the newest supported features while remaining compatible with the configured
target framework and repository conventions.

## Detect language version precedence (authoritative order)

### Precedence

1. Explicit `<LangVersion>` in the project (`*.csproj`)
2. `<LangVersion>` in `Directory.Build.props` (nearest first, then parents)
3. Imported props/targets explicitly setting `<LangVersion>` (including `Directory.Build.targets`)
4. Target Framework Moniker (TFM) inference
5. SDK pinning / build evidence (diagnostics only; never overrides explicit LangVersion)

### Target framework mapping

- net6.0 → C# 10
- net7.0 → C# 11
- net8.0 → C# 12
- net9.0 → C# 13
- net10.0 → C# 14

### Multi-targeting

- Shared code uses the **minimum** supported C# version across TFMs.
- Higher-version features are allowed only inside TFM-guarded regions
  (e.g. `#if NET9_0_OR_GREATER`) or TFM-specific source sets.

### Output requirements

Record:

- Effective C# version
- How it was determined (csproj / Directory.Build.props / import / inferred)
- Active configuration/platform assumptions used

## Progressive reference loading and prioritization

### Principle

Best practices accumulate across C# versions. The agent must load and apply guidance
**in sequence** from the baseline (C# 10) up to the project's effective C# version.

### Loading order (progressive)

Given an effective C# version `V`, load reference docs in ascending order:

- Always load: `references/csharp-10.md`
- Then load each subsequent version up to `V`:
  - If `V` >= 11: load `csharp-11.md`
  - If `V` >= 12: load `csharp-12.md`
  - If `V` >= 13: load `csharp-13.md`
  - If `V` >= 14: load `csharp-14.md`

### Priority rule (conflicts and overlap)

When guidance overlaps or conflicts across versions:

- The **highest supported version wins** (latest loaded reference has highest priority).
- Older guidance remains applicable only if it does not conflict with newer guidance
  and is still relevant.

### Reporting requirement

In the change summary or PR description, record:

- Effective C# version
- Ordered list of reference docs consulted (e.g., C#10 → C#11 → C#12)
- Highest-version feature(s) applied and where

## Optional analyzer governance (mandatory clarification)

### Definition

An analyzer rule or formatting recommendation is considered **optional** if:

- It is context-sensitive or contentious (readability trade-offs).
- It can introduce widespread churn when enabled globally.
- It changes construction/architecture patterns rather than correcting defects.
- It is marked as "Optional (requires clarification)" in any reference document.

Examples include (non-exhaustive):

- `IDE0290` – Use primary constructor
- `IDE0305` – Use collection expression for fluent

### Mandatory agent behavior

When encountering an **optional** analyzer recommendation, the agent MUST:

1. **Pause global enforcement**
   - Do NOT enable the rule globally in `.editorconfig`, `Directory.Build.props`,
     `Directory.Build.targets`, or equivalent.
   - Do NOT mass-refactor existing code to satisfy the rule.

2. **Request clarification from the user**
   - Ask whether the rule should be:
     - Enabled globally
     - Enabled only for new/modified code
     - Left disabled (status quo)
   - Provide a short explanation of what it enforces and key trade-offs.

3. **Default if no response**
   - Leave the rule disabled globally.
   - Apply the recommendation only opportunistically in newly written or directly
     modified code if it improves clarity and aligns with local conventions.

### Documentation requirement

If clarification is requested, record:

- Analyzer ID
- User decision
- Enforcement scope (global / touched code / none)

## Execution flow

1. Detect and record the effective C# version.
2. Load reference documents progressively from C# 10 up to the effective version
   (latest has highest priority).
3. Apply best practices only to touched code unless a broader refactor is requested.
4. Validate build and tests.
5. Emit a summary of applied practices and any optional analyzer decisions pending
   or confirmed.

## Guardrails

- Do not enable preview features unless explicitly configured.
- Do not upgrade SDK or TFM unless requested.
- Avoid unrelated formatting changes and "style churn".

## Red Flags - STOP

These statements indicate misalignment with C# best practices:

| Thought                                    | Reality                                                             |
| ------------------------------------------ | ------------------------------------------------------------------- |
| "Let's use C# 14 features everywhere"      | Match the project's effective language version; don't assume latest |
| "Enable all analyzers globally"            | Optional analyzers need clarification; mass changes cause churn     |
| "Preview features are fine for production" | Avoid preview unless explicitly configured and justified            |
| "Upgrade the TFM while fixing this bug"    | Don't upgrade SDK/TFM unless explicitly requested                   |
| "This code style is better"                | Avoid unrelated formatting changes; focus on the task at hand       |
| "Apply the latest patterns to all code"    | Only modify touched code unless broader refactor is requested       |
