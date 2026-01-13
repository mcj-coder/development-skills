# Component Boundary Patterns

Detailed guidance for component boundary decisions.

## Organization Patterns

### Monorepo with Workspaces

Single repository with multiple deployable components.

**Structure:**

```text
/
├── components/
│   ├── products/          # Product catalog (Product Team)
│   │   ├── src/
│   │   ├── tests/
│   │   └── docs/
│   ├── orders/            # Order management (Product Team)
│   └── payments/          # Payment processing (Platform Team)
├── shared/
│   ├── contracts/         # Inter-component interfaces
│   └── utilities/         # True utilities (3+ consumers)
└── docs/
    └── architecture/      # Cross-cutting decisions
```

**Pros:** Easier refactoring, shared tooling, atomic changes across components.
**Cons:** Complex build, all teams share infrastructure.

### Polyrepo

Separate repositories per component.

**Pros:** Independent versioning, deployment isolation, team autonomy.
**Cons:** Harder cross-repo changes, dependency management overhead.

### Modular Monolith

Single deployable with internal boundaries.

**Pros:** Balanced approach, simpler deployment, clear boundaries.
**Cons:** Requires discipline, shared runtime.

## Boundary Evaluation Techniques

### Deployment Independence Check

- Can this component be deployed without deploying others?
- Does it have independent scaling requirements?
- Does it have different release cadence?

### Coupling Analysis

- Count imports between logical groups
- Identify cycles (A depends on B, B depends on A)
- Measure change propagation (changing A requires changing B)

### Ownership Clarity

- Which team maintains this code?
- Who reviews changes?
- Who gets paged when it breaks?

### Reuse Threshold

| Usage Count   | Placement           |
| ------------- | ------------------- |
| 1 component   | Keep in component   |
| 2 components  | Evaluate extraction |
| 3+ components | Extract to shared/  |

## Documentation Placement

### Cross-Cutting Concerns

Place in `docs/architecture/` when:

- Affects multiple components
- Audience is all engineers
- Defines system-wide patterns

### Component-Scoped

Place in `components/{name}/docs/` when:

- Specific to one component
- Audience is component team
- Implementation details

## Brownfield Migration

For existing codebases:

1. **Document current state** - Map implicit boundaries
2. **Analyze coupling** - Identify dependency hotspots
3. **Create component directories** - Preserve existing imports
4. **Move files incrementally** - Automated with import updates
5. **Add architecture tests** - Prevent coupling regression
6. **Reduce cross-boundary coupling** - Gradual extraction

### Migration Checklist

- [ ] Coupling analysis completed
- [ ] Natural boundaries identified
- [ ] Incremental plan documented
- [ ] Rollback plan available
- [ ] Architecture tests planned

## Component Ownership Matrix Template

```markdown
| Component | Owner         | Maintainer    | Consulted         | Informed    |
| --------- | ------------- | ------------- | ----------------- | ----------- |
| products  | Product Team  | Alice         | Platform          | Engineering |
| orders    | Product Team  | Bob           | Product, Platform | Engineering |
| payments  | Platform Team | Charlie       | Security, Finance | Engineering |
| shared    | Platform Team | Platform Team | All               | All         |
```

## Architecture Documentation Template

Update `docs/architecture/component-boundaries.md`:

```markdown
## Component Boundaries

**Organization Pattern:** {Monorepo | Polyrepo | Modular Monolith}

**Boundary Criteria:**

- Deployment independence: {description}
- Team ownership: {description}
- Coupling minimization: {description}

**Components:**

### {Component Name}

- **Path:** `components/component-name/`
- **Responsibility:** {what this component owns}
- **Dependencies:** {which other components this depends on}
- **Deployment:** {independent | with main application}
- **Owner:** {team name}
```
