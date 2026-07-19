# Work Item Estimation (Optional)

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Estimation helps with sprint planning, velocity tracking, and identifying work that
should be decomposed. Sizing is optional - teams choose whether and how to estimate.

### Sizing Approaches

Choose one approach and use it consistently:

| Approach       | Scale                         | When to Use                          |
| -------------- | ----------------------------- | ------------------------------------ |
| Story Points   | 1, 2, 3, 5, 8, 13 (Fibonacci) | Teams familiar with agile estimation |
| T-Shirt Sizing | XS, S, M, L, XL               | Quick relative sizing, new teams     |
| Time-Based     | Hours or Days                 | Fixed-scope work, client billing     |

**Guidance:** Start with T-shirt sizing if new to estimation. Story points are more
precise but require team calibration. Time-based estimates are useful for external
commitments but can create pressure.

### When to Size

- **During refinement:** Size work items before transitioning to implementation (step 7)
- **Before sprint planning (Scrum):** Sized items enable capacity planning
- **Optional DoR item:** Teams can add sizing to their Definition of Ready

### Recording Estimates

**GitHub Projects:**

```bash
# Set Size field in project (requires project field configured)
gh project item-edit --project-id PROJECT_ID --id ITEM_ID \
  --field-id FIELD_ID --single-select-option-id OPTION_ID

# Or add size label
gh issue edit N --add-label "size:M"
```

**Azure DevOps:**

```bash
# Set Story Points field
az boards work-item update --id N \
  --fields "Microsoft.VSTS.Scheduling.StoryPoints=5"

# Or set Effort field
az boards work-item update --id N \
  --fields "Microsoft.VSTS.Scheduling.Effort=8"
```

**Jira:**

```bash
# Set Story Points (requires jira CLI)
jira issue edit ISSUE-123 --custom "Story Points=5"

# Or set Time Estimate
jira issue edit ISSUE-123 --time-estimate "2d"
```

**Fallback:** Add estimate in issue body:

```markdown
## Estimate

Size: M (3 story points)
```

### Decomposition Thresholds

Large items should be decomposed into smaller work items. Thresholds are guidance,
not hard rules - use judgement based on team context.

| Approach     | Threshold    | Recommendation                              |
| ------------ | ------------ | ------------------------------------------- |
| Story Points | >5 points    | Consider decomposition into smaller stories |
| T-Shirt      | XL or larger | Should be decomposed into M or smaller      |
| Time-Based   | >2 days      | Consider breaking into smaller tasks        |

**When threshold exceeded:**

1. Review if work can be split into independent deliverables
2. Use `requirements-gathering` skill decomposition workflow
3. Create child issues for each deliverable
4. Re-estimate children (sum should approximate original)

See [requirements-gathering skill](../requirements-gathering/SKILL.md) for
decomposition guidance.

### Team Sizing Preferences

Document your team's sizing decisions in ways-of-working:

```markdown
# docs/ways-of-working/estimation.md

## Estimation Approach

Our team uses **T-shirt sizing** (XS, S, M, L, XL).

### Calibration Reference

| Size | Typical Scope                    | Example                     |
| ---- | -------------------------------- | --------------------------- |
| XS   | Config change, typo fix          | Update environment variable |
| S    | Single function/component change | Add validation to endpoint  |
| M    | Feature with tests               | New API endpoint            |
| L    | Cross-cutting change             | Refactor authentication     |
| XL   | Should be decomposed             | N/A - too large             |

### Decomposition Threshold

Items sized **L or larger** should be reviewed for decomposition.

### Sizing Ceremony

We size during **sprint planning** after grooming.
```

Reference your team's estimation approach in AGENTS.md or repository documentation.
