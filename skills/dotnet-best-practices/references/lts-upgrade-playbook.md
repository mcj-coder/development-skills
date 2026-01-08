# LTS upgrade playbook (practical guide)

## Objective

Provide a repeatable plan to upgrade any .NET solution to the **latest LTS**, with predictable risk management.

## Inputs

- Current TFM(s) and workload types (web/worker/library/desktop)
- Deployment model (containers/K8s/IIS/serverless)
- Critical non-functionals (startup, throughput, latency SLOs, memory caps)
- Dependency constraints and release cadence

## Steps

1. **Inventory & pinning**
   - Pin SDK in CI.
   - Identify all TFMs and runtime environments.
2. **Dependency readiness**
   - Enable Central Package Management (where supported).
   - Upgrade critical dependencies first (those that block target TFM).
3. **Test gates**
   - Ensure unit + integration coverage is adequate.
   - Add contract tests for externally exposed APIs.
   - Add perf baselines for critical services (startup + steady-state + tail latency).
4. **Upgrade execution**
   - Upgrade target frameworks to latest LTS.
   - Address breaking changes by area (hosting, security defaults, serialization/crypto, networking).
5. **Validation**
   - Run full suite: unit, integration, contract, perf/load.
   - Validate ingress topology behaviors (proxy headers, HTTPS enforcement, timeouts).
6. **Rollout**
   - Canary/staged rollout where possible.
   - Monitor new/changed metrics and error rates; define rollback criteria.

## Outputs

- Upgrade ADR (decision, scope, risks, rollback plan)
- Backlog of "Adopt now" items from version references
- Evidence pack (test results, perf diffs, scan results)
