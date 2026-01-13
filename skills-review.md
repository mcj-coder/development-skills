# Skills Review Report

## Scope and intent

This review covers every skill under `skills/` and the files in each skill folder
(`SKILL.md`, tests, references, templates, and scripts). The library is a draft
intended for iterative improvement, greenfield bootstrap, and brownfield
migration. The review assesses purpose, effectiveness, and whether tests validate
the spirit of each skill, with actionable next steps.

## Method

- Read each skill’s `SKILL.md`, tests, and references/templates/scripts.
- Assessed alignment with agent- and platform-agnostic intent, and with the
  stated governance goals.
- Evaluated test files for behavioral validation vs narrative/checklist-only
  descriptions.

## Summary themes

1. Tests are mostly narrative/checklist-based. Many rely on “Given/When/Then” or
   grep checks but don’t provide concrete, verifiable outcomes or commands. This
   weakens loophole closure.
2. Many skills are very comprehensive and heavy. A “minimum viable” or
   lightweight variant would help adoption in small teams or low-risk work.
3. Several skills assume Node tooling (commitlint, husky, cspell) even when the
   skill is not Node-specific. Platform-agnostic fallbacks would improve fit.
4. Some skills lack concrete validation guidance (exact commands, evidence
   capture patterns), making verification and audit trails harder to enforce.
5. A few skills reference missing or incomplete tests (notably architecture- and
   Aspire-related skills). These are high-priority gaps.

## Per-skill review

### agent-workitem-automation

- Purpose: Enforce autonomous work item lifecycle via taskboard discovery, CLI setup, phased delivery, and evidence-
  backed updates.
- Effectiveness: Strong structure and safeguards; very prescriptive and platform-aware. Some risk of overreach (ADR
  creation, README edits) without explicit repo policy alignment.
- Test alignment: Tests are extensive but mix policy and behavior; some checks rely on grep counts and assume
  scripts/templates exist, which may not validate actual use in runtime.
- Next steps: Add explicit platform-agnostic fallbacks for non-CLI environments; tighten test cases to assert behavioral
  outcomes vs keyword counts; clarify when ADR creation is optional vs mandatory.

### agents-onboarding

- Purpose: Create a comprehensive AGENTS.md onboarding doc so fresh agents can follow repo standards.
- Effectiveness: Strong, concrete checklist and template; aligns with repo goals. Risk of being heavy without
  prioritization guidance.
- Test alignment: Tests are exhaustive but mostly document expectations rather than verify behavior; lacks negative
  tests for minimal onboarding quality.
- Next steps: Add an explicit minimal baseline vs full template; add test scenarios for missing key sections leading to
  fail; clarify when to update README to reference AGENTS.md.

### architecture-testing

- Purpose: Establish and enforce architectural boundaries with automated tests and documentation.
- Effectiveness: Strong guidance, templates, and brownfield approach; clear opt-out and decision capture. Some platform
  bias toward .NET, though mentions ArchUnit.
- Test alignment: Missing the referenced `architecture-testing.test.md` file (only philosophy/baseline). Philosophy test
  checks keywords/templates but not actual adoption workflow.
- Next steps: Add a concrete behavior test file; add non-.NET template or explicit steps for Java/other stacks; clarify
  how to apply in non-ADR repos.

### aspire-integration-testing

- Purpose: Define integration testing approach for .NET Aspire distributed apps, including health/observability checks
  and templates.
- Effectiveness: Clear workflow and strong reference material; highly .NET/Aspire-specific (acceptable given scope) but
  mentions opt-out and documentation.
- Test alignment: Missing `aspire-integration-testing.test.md`; philosophy/baseline exist but no concrete behavior test.
  Tests focus on detection/templates, not execution.
- Next steps: Add concrete behavior test; clarify how to validate observability (logs/traces) beyond placeholder;
  consider versioning guidance for Aspire packages.

### automated-standards-enforcement

- Purpose: Establish automated quality gates (lint, format, spell, tests, security) with brownfield baseline support.
- Effectiveness: Very strong and comprehensive; practical references and templates across CI platforms. Potential
  overload for small repos; some assumptions about Node tooling even for non-Node.
- Test alignment: BDD tests are detailed, but many assertions are about file presence and word counts; some cross-
  reference README expectations without enforcement.
- Next steps: Add guidance for minimal viable setup; ensure non-Node examples for spell/lint where Node is undesirable;
  add explicit non-GitHub CI examples beyond Azure.

### best-practice-introduction

- Purpose: Guide phased rollout of new practices with pilots, success criteria, and rollback triggers.
- Effectiveness: Strong change-management framing and rollout templates; clear opt-out and rationale handling.
- Test alignment: Tests are thorough but heavy; they describe expected responses rather than verifiable outcomes. Good
  rationalization coverage.
- Next steps: Add a minimal template for small teams; add explicit link to issue-driven delivery evidence requirements
  for rollout tracking.

### branching-strategy-and-conventions

- Purpose: Establish branching model, commit conventions, and merge strategy to support SemVer and governance.
- Effectiveness: Clear, comprehensive, and actionable with strong references; biased toward commitlint/Husky (Node
  tooling) but offers concept-level guidance.
- Test alignment: Tests are detailed and scenario-based but mostly descriptive; no automated validation strategy for
  non-Node stacks.
- Next steps: Add platform-agnostic enforcement options (server-side hooks, GitHub rulesets); clarify how to enforce
  commit conventions without Node tooling.

### broken-window

- Purpose: Enforce immediate fixing of warnings/errors via a 2x rule, with tech-debt issues when deferring.
- Effectiveness: Strong operational guardrails and scenario coverage; clear decision process and examples.
- Test alignment: Only philosophy test exists; no concrete BDD test file. Scenarios are good but not tied to
  verification steps.
- Next steps: Add a concrete test file and minimal checklist; define how to record 2x calculations in issues
  consistently.

### change-risk-rollback

- Purpose: Force pre-deployment risk analysis with failure modes, rollback procedures, and go/no-go criteria.
- Effectiveness: Strong and structured; practical templates and decision tree; good for both app and infra changes.
- Test alignment: Tests are extensive; still narrative and not tied to verification artifacts. Could be heavy for small
  changes.
- Next steps: Add a lightweight variant for low-risk changes; add requirement to link to monitoring dashboards/log
  locations in evidence.

### ci-cd-conformance

- Purpose: Enforce CI/CD quality gates, immutable releases, and platform security features by default.
- Effectiveness: Very comprehensive with provider-specific guidance; strong for greenfield and brownfield. Can be heavy
  and assumes CLI availability.
- Test alignment: BDD tests are strong but long; focus on expected configuration rather than validation in repo context.
- Next steps: Add minimal baseline path for tiny repos; add non-CLI fallback for platforms without CLI access; ensure
  separation between CI vs CD decisions.

### component-boundary-ownership

- Purpose: Decide macro boundaries and ownership, and delegate intra-component layout to scoped-colocation.
- Effectiveness: Good criteria and documentation guidance; clear macro/micro split. Heavy for small repos.
- Test alignment: Tests are detailed and scenario-based; still narrative and lack concrete verification mechanics.
- Next steps: Add a lightweight “single-team repo” variant; add explicit metrics/commands for coupling analysis.

### contract-consistency-validation

- Purpose: Enforce compatibility checks and SemVer-aware handling for public contract changes.
- Effectiveness: Clear stop points and ADR requirements; solid guardrails for breaking changes.
- Test alignment: Tests use GWT with checklists; some grep-based checks in references, but not direct behavioral
  verification.
- Next steps: Add explicit contract test examples (OpenAPI/schema) and a minimal checklist for non-HTTP contracts.

### csharp-best-practices

- Purpose: Apply C# version-specific best practices based on effective language version with progressive reference
  loading.
- Effectiveness: Strong version-detection and optional analyzer governance; good for avoiding style churn.
- Test alignment: Tests are scenario-heavy but mostly procedural; could be more explicit about evidence artifacts.
- Next steps: Add a quick decision tree for mixed TFMs; include examples of optional analyzer decisions recorded in
  docs.

### deployment-provenance

- Purpose: Ensure traceability for deployments (commit, build, actor, artifact) with audit-ready metadata.
- Effectiveness: Strong schema and practical patterns (labels, annotations, version endpoint); good platform tooling
  pointers.
- Test alignment: Tests are scenario-based; some checklists but no concrete validation commands.
- Next steps: Add a minimal “how to verify” checklist with commands to read labels/annotations; add example retention
  policy mapping.

### documentation-as-code

- Purpose: Apply code-quality rigor to documentation with linting, spelling, link checks, and templates.
- Effectiveness: Clear workflow with brownfield baseline; strong cross-reference to tooling.
- Test alignment: Tests are scenario-driven; no explicit validation commands in tests to prove enforcement.
- Next steps: Add sample verification commands and evidence capture patterns for doc-only changes.

### dotnet-bespoke-code-minimisation

- Purpose: Bias toward OSS and composable libs over bespoke frameworks/scripts.
- Effectiveness: Clear rubric and enforcement stance; good for governance.
- Test alignment: Tests are general and narrative; no concrete examples to validate rubric use.
- Next steps: Add example PR review checklist entry and a worked example comparing OSS vs bespoke.

### dotnet-best-practices

- Purpose: Version-aware .NET platform guidance across runtime, SDK, hosting, and operations.
- Effectiveness: Comprehensive and progressive; heavy but structured; good separation from C# skill.
- Test alignment: Tests are scenario-based but mostly descriptive; may not validate reference loading order.
- Next steps: Add explicit “reference loading proof” checklist; include a minimal baseline for small services.

### dotnet-domain-primitives

- Purpose: Enforce strongly-typed IDs/value objects to prevent primitive obsession.
- Effectiveness: Clear defaults and boundary rules; good integration guidance.
- Test alignment: Tests use GWT and checklists; no concrete sample assertions.
- Next steps: Add a small before/after example for API boundary mapping and validation steps.

### dotnet-efcore-practices

- Purpose: Standardize EF Core migrations isolation and configuration patterns.
- Effectiveness: Strong non-negotiable defaults with clear review rules.
- Test alignment: Tests are checklist-based; no tooling validation examples for coverage exclusion.
- Next steps: Add specific coverage tool examples (coverlet/xunit) and verification steps.

### dotnet-healthchecks

- Purpose: Standardize health checks using Xabaril ecosystem.
- Effectiveness: Focused and practical; solid anti-bespoke guidance.
- Test alignment: Tests are checklist-based without runtime validation examples.
- Next steps: Add a sample health check endpoint verification and readiness/liveness guidelines in tests.

### dotnet-logging-serilog

- Purpose: Enforce ILogger usage with Serilog provider and startup Critical logging.
- Effectiveness: Strong operational guidance and enforcement heuristics.
- Test alignment: Tests are checklist-based; no explicit verification for startup failure logging.
- Next steps: Add an example “fail-fast” startup test and verification pattern.

### dotnet-mapping-standard

- Purpose: Standardize mapping at boundaries with source-generated mappers and explicit conversions.
- Effectiveness: Clear anti-patterns and DI gating; good alignment with domain primitives.
- Test alignment: Tests are narrative/checklist; no concrete mapping test samples.
- Next steps: Add sample mapping unit test template and a DI gating checklist entry.

### dotnet-open-source-first-governance

- Purpose: Enforce OSS-first dependency selection with live license revalidation.
- Effectiveness: Strong gate; potentially hard to automate; aligns with governance goals.
- Test alignment: Tests lack evidence checklist; more procedural than verifiable.
- Next steps: Add evidence template and clear “acceptable sources” checklist; define fallback when web search
  unavailable.

### dotnet-source-generation-first

- Purpose: Prefer compile-time source generation over runtime reflection.
- Effectiveness: Clear rationale and enforcement triggers; good for AOT.
- Test alignment: Tests are scenario-heavy but non-technical; lacks concrete benchmarks examples.
- Next steps: Add minimal benchmark template and examples of acceptable exceptions.

### dotnet-specification-pattern

- Purpose: Prefer specification pattern for query composition over generic repository.
- Effectiveness: Good guardrails; clear anti-patterns.
- Test alignment: Checklist-based; no specific verification of ORM boundary enforcement.
- Next steps: Add example spec usage and migration path from existing repository patterns.

### dotnet-testing-assertions

- Purpose: Standardize assertions on AwesomeAssertions and OSS license governance.
- Effectiveness: Clear, opinionated, and practical; includes license note.
- Test alignment: Checklist-based; lacks concrete migration steps from FluentAssertions.
- Next steps: Add migration checklist and sample assertion diff.

### finishing-a-development-branch

- Purpose: Enforce pre-PR verification and role-based reviews (shift-left) before integration.
- Effectiveness: Strong guardrails and clear options; good tie-in to issue-driven delivery.
- Test alignment: Tests are present but do not encode the large decision tree; evidence is mostly checklist-based.
- Next steps: Add a concise flowchart and a “minimum viable verification” path for small changes.

### greenfield-baseline

- Purpose: Establish foundational repo structure, quality gates, and standards before first feature.
- Effectiveness: Comprehensive and practical with stack-specific templates; aligns with bootstrap goals.
- Test alignment: Tests are checklist-heavy; may be difficult to validate in non-.NET/Node stacks.
- Next steps: Add stack-agnostic baseline path and a minimal baseline for prototypes.

### impacted-scope-enforcement

- Purpose: Scope quality gates/tests/deployments to impacted components with delta coverage.
- Effectiveness: Clear and pragmatic; good for monorepos and large systems.
- Test alignment: Tests are checklist-based; needs examples of affected tooling output.
- Next steps: Add sample commands for popular build tools (Nx, Bazel, Gradle) and a proof of delta coverage workflow.

### incremental-change-impact

- Purpose: Identify blast radius before changes to prevent hidden dependencies and regressions.
- Effectiveness: Strong upfront analysis checklist; good for refactors and config changes.
- Test alignment: Tests are checklist-based; no direct validation mechanics.
- Next steps: Add examples of dependency tracing commands per language and how to record findings.

### innersource-governance-bootstrap

- Purpose: Bootstrap InnerSource governance with required docs, ownership, and decision processes.
- Effectiveness: Clear governance requirements and maintenance expectations; strong policy orientation.
- Test alignment: Tests lack evidence checklist; mostly procedural.
- Next steps: Add a minimal compliance checklist and sample verification commands for CODEOWNERS and branch protection.

### issue-driven-delivery

- Purpose: Enforce full work-item lifecycle with approvals, evidence, state transitions, and prioritization.
- Effectiveness: Extremely thorough and prescriptive; excellent for governance-heavy environments but high overhead.
- Test alignment: Many tests, but mostly narrative and grep-based; coverage is broad, not necessarily deep behavioral
  validation.
- Next steps: Create a concise “lightweight mode” for small teams; add automated validation scripts for issue
  body/evidence.

### library-extraction-stabilisation

- Purpose: Prevent premature library extraction by enforcing stability, ownership, and versioning criteria.
- Effectiveness: Clear readiness criteria and governance guidance; solid for brownfield decisions.
- Test alignment: Tests are checklist-based with narrative scenarios; limited concrete validation.
- Next steps: Add a decision matrix template and a sample migration plan checklist.

### local-dev-experience

- Purpose: Improve local feedback loops with watch modes, incremental builds, and selective execution.
- Effectiveness: Practical, actionable, and focused on productivity targets.
- Test alignment: Tests use scenario checklists; no measurement/benchmark validation.
- Next steps: Add a simple “measure baseline vs target” worksheet and evidence capture.

### markdown-author

- Purpose: Enforce markdown linting and spelling during authoring, not after.
- Effectiveness: Strong, actionable steps and concrete error handling; good as an operational skill.
- Test alignment: Tests are mostly checklist/grep-based; could add real failing/passing examples.
- Next steps: Add example before/after snippets and a simple validation command set.

### monorepo-orchestration-setup

- Purpose: Select and configure monorepo tooling with caching and affected-only execution.
- Effectiveness: Solid, practical; good tool selection guidance and CI integration.
- Test alignment: Tests are checklist-based; no explicit validation of caching/affected commands.
- Next steps: Add evidence examples for `nx graph`/`turbo` outputs and baseline performance metrics.

### observability-logging-baseline

- Purpose: Establish structured logging, metrics, and tracing using OpenTelemetry standards.
- Effectiveness: Strong technical guidance, concrete rules, and phased adoption.
- Test alignment: Tests are checklist-based; missing concrete log/trace verification steps.
- Next steps: Add a minimal validation checklist (sample log entry, metric name, trace propagation) with commands.

### pair-programming

- Purpose: Define structured agent+human pairing phases with checkpoints.
- Effectiveness: Clear phase model; useful for collaboration, but potentially heavy for small tasks.
- Test alignment: Tests are lightweight and do not verify outcomes or evidence.
- Next steps: Add a minimal pairing mode and explicit “handoff record” template.

### persona-switching

- Purpose: Configure role-based personas for git/operations with security profiles.
- Effectiveness: Good for auditability; integrates with governance workflows.
- Test alignment: Tests are narrative; lacks concrete verification of git identity changes.
- Next steps: Add validation commands (`git config`, `gh auth status`) and a rollback procedure.

### process-skill-router

- Purpose: Route to the right process skill based on context and preconditions.
- Effectiveness: Clear priority rules and guardrails; good conflict resolution.
- Test alignment: Tests are checklist-based; limited validation of real routing behavior.
- Next steps: Add a small decision tree test matrix and sample prompts mapped to routes.

### quality-gate-enforcement

- Purpose: Enforce quality gates in CI/CD (coverage, security, performance).
- Effectiveness: Solid, with brownfield strategy and exception handling.
- Test alignment: Tests are scenario-based with checklists; could benefit from tool-specific examples.
- Next steps: Add sample gate configs for common stacks and a baseline coverage ratchet example.

### release-tagging-plan

- Purpose: Define release versioning, tags, and cadence with SemVer discipline.
- Effectiveness: Clear workflows and detection; useful for governance.
- Test alignment: Tests are checklist-based; lacks concrete tagging verification steps.
- Next steps: Add sample tag commands and changelog linkage examples.

### repo-best-practices-bootstrap

- Purpose: End-to-end repo bootstrap across security, CI/CD, docs, and agent enablement.
- Effectiveness: Very comprehensive; strong for enterprise bootstrapping, high overhead.
- Test alignment: Tests are scenario-heavy but not verifiable; reliance on interactive steps.
- Next steps: Add a “minimum viable bootstrap” profile and automated checks for configured features.

### requirements-gathering

- Purpose: Interactive requirements elicitation and ticket creation before planning/implementation.
- Effectiveness: Clear precondition checks and structured output; good for process control.
- Test alignment: Tests include guards and philosophy; mostly checklist-based.
- Next steps: Add a concise question bank by work type and a validation checklist for “enough info”.

### runtime-tooling-validation

- Purpose: Verify runtimes/tools before build/test to avoid avoidable failures.
- Effectiveness: Practical checks across stacks; good for pre-flight validation.
- Test alignment: Tests are scenario-based; lacks concrete output verification examples.
- Next steps: Add command-output examples and a minimal “must-pass” checklist by stack.

### safe-brownfield-refactor

- Purpose: Guide incremental refactoring in legacy systems with safety patterns.
- Effectiveness: Strong principles and phased approach; good risk management.
- Test alignment: Tests rely on checklists and grep; no concrete test harness examples.
- Next steps: Add sample characterization test template and a refactor sequencing checklist.

### scoped-colocation

- Purpose: Keep related code together by feature scope to reduce cognitive load.
- Effectiveness: Clear patterns and anti-patterns; aligns with modular organization.
- Test alignment: Checklist-based; lacks concrete verification steps (e.g., repo structure checks).
- Next steps: Add sample directory layouts and a simple audit checklist.

### security-processes

- Purpose: Cross-language security process guidance for SCA/SAST/SBOM/gates.
- Effectiveness: Clear structure and scope; strong governance focus.
- Test alignment: Tests are checklist-based; no concrete enforcement tooling examples.
- Next steps: Add a minimal baseline security pipeline and evidence templates.

### skills-first-workflow

- Purpose: Enforce prerequisite skill loading and repository readiness before implementation.
- Effectiveness: Strong guardrails; aligns with repo governance.
- Test alignment: Tests use checklists; AutoFix behavior not directly verifiable.
- Next steps: Add a validation script or sample commands to prove each prerequisite.

### static-analysis-security

- Purpose: Establish SAST/secrets scanning with tool selection and suppression policy.
- Effectiveness: Solid guidance and tool references; good for cross-language teams.
- Test alignment: Tests are checklist-based; missing real examples of suppression governance.
- Next steps: Add sample suppression entries and evidence capture guidance.

### technical-debt-prioritisation

- Purpose: Score and prioritize tech debt with impact/risk/effort scoring and roadmaps.
- Effectiveness: Strong structure and templates; aligns with governance focus.
- Test alignment: Tests are checklist-based; lacks concrete scoring examples in tests.
- Next steps: Add a worked scoring example and a sample debt register.

### testcontainers-integration-tests

- Purpose: Use Testcontainers for real infra in integration tests with isolation and performance guidance.
- Effectiveness: Clear, practical; good templates and CI guidance.
- Test alignment: Tests are checklist-based; limited verification for container reuse/cleanup.
- Next steps: Add sample CI run logs and a checklist for container lifecycle correctness.

### testing-strategy-agnostic

- Purpose: Define layered testing strategy with architecture and contract governance.
- Effectiveness: Strong principles and rules; good for cross-language guidance.
- Test alignment: Tests are checklist-based; lacks enforcement examples.
- Next steps: Add a minimal “baseline strategy” template for small repos.

### testing-strategy-dotnet

- Purpose: .NET-specific testing tier conventions with architecture and contract enforcement.
- Effectiveness: Strong and detailed; good library/tool references.
- Test alignment: Tests are checklist-based; could use sample project layout verification.
- Next steps: Add example solution structure and sample CI matrix.

### walking-skeleton-delivery

- Purpose: Build minimal end-to-end slice to validate architecture before feature build-out.
- Effectiveness: Clear scope control and ADR capture; good templates.
- Test alignment: Tests are checklist-based with philosophy; lacks concrete validation steps.
- Next steps: Add sample skeleton acceptance test and a minimal deployment pipeline example.
