# Cumulative upgrade guidance (multi-major upgrades)

## Purpose

When upgrading across multiple .NET majors (e.g., .NET 6 -> .NET 10), apply improvements cumulatively.
Where a capability or recommendation has been **superseded**, prefer the **latest** guidance (from the newest version)
and do not carry older guidance forward.

## How to use

1. Identify source version and target version (latest LTS).
2. Apply the cumulative checklist in order:
   - tooling/repo governance
   - security posture
   - runtime/perf re-baselining
   - workload-specific improvements
3. Treat "Evaluate" items as opt-in; "Adopt now" items should be backlog'd and tracked.

---

## Cumulative checklist (6 -> 10)

### Adopt now (high value, broadly applicable)

- **Repository governance**
  - Pin SDK versions in CI and align dev toolchain.
  - Adopt **Central Package Management** (`Directory.Packages.props`) and enforce "no versions in csproj".
- **Runtime/performance discipline**
  - Re-baseline performance at the target runtime (CPU, allocations, memory, startup, tail latency).
  - Remove fragile micro-optimizations that depend on older JIT/GC behavior.
- **Observability baseline**
  - Standardize traces/metrics conventions and dashboards; ensure health endpoints do not distort SLO metrics.
- **Web/service hygiene**
  - Standardize Minimal APIs vs controllers at the boundary level and avoid mixed patterns without standards.
  - Re-validate ingress/proxy behavior (forwarded headers, HTTPS enforcement, timeouts, rate limiting) under real topology.
- **Library governance (if publishing packages)**
  - Enforce public API governance (minimize attack surface).
  - Run API-compat checks against the last released baseline and enforce SemVer rules.

### Evaluate (scenario-dependent)

- **AOT/trimming** for CLI/serverless/edge cold-start improvements; validate dependency compatibility.
- **Span-based refactors** in hot paths where allocation reduction matters (avoid broad refactors without measured benefit).
- **File-based apps** and publish options for small utilities and simple deployment footprints.
- **EF Core improvements** where you previously used workarounds; re-check query plans and translation.

### Avoid / caution (common hazards)

- Assuming older defaults still apply (hosting/security/HTTP behavior).
- Allowing SDK/tooling drift (local vs CI vs build agents).
- Carrying forward deprecated or insecure patterns because "they still work."

---

## Superseded guidance rule

If newer versions provide a better mechanism or a safer default, adopt the newer approach and remove older workarounds.
