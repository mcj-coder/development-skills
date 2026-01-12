# Branching Models

## Model Comparison

| Model       | Complexity | Release Frequency | Best For                    |
| ----------- | ---------- | ----------------- | --------------------------- |
| Trunk-Based | Low        | Continuous        | CI/CD mature teams          |
| GitHub Flow | Low        | Frequent          | Web apps, small teams       |
| Git Flow    | High       | Scheduled         | Enterprise, strict releases |

## Trunk-Based Development

**Structure:** Single `main` branch with short-lived feature branches (< 2 days).

**Workflow:**

1. Branch from `main`: `git checkout -b feature/user-auth`
2. Make small commits (Conventional Commits)
3. PR to `main` within 24-48 hours
4. Squash merge preserving SemVer impact

**Requirements:**

- Feature flags for incomplete work
- Strong CI/CD pipeline
- High test coverage

**When to choose:** Continuous deployment, mature CI, experienced team.

## GitHub Flow

**Structure:** `main` branch + feature branches merged via PR.

**Workflow:**

1. Branch from `main`: `git checkout -b feature/add-search`
2. Commit work (Conventional Commits)
3. Open PR for review
4. Merge to `main` after approval
5. Deploy from `main`

**When to choose:** Simple workflow, web applications, frequent deploys.

## Git Flow

**Structure:** `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`.

**Branch Types:**

- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: From develop, merge to develop
- `release/*`: From develop, merge to main and develop
- `hotfix/*`: From main, merge to main and develop

**Workflow:**

1. Feature work: `develop` -> `feature/*` -> `develop`
2. Release prep: `develop` -> `release/*` -> `main` + `develop`
3. Production fix: `main` -> `hotfix/*` -> `main` + `develop`

**When to choose:** Scheduled releases, compliance requirements, large teams.

## Decision Guide

**Choose Trunk-Based if:**

- Deploying multiple times per day
- Strong automated testing
- Feature flags available

**Choose GitHub Flow if:**

- Deploying daily to weekly
- Simple release process
- Small to medium team

**Choose Git Flow if:**

- Scheduled release cycles
- Multiple supported versions
- Strict production controls
