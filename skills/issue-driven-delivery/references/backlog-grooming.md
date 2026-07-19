# Backlog Grooming

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


Before issues enter refinement, they must pass through grooming to ensure quality and
readiness. Grooming validates that issues meet standards, have proper categorization,
and are free of blocking issues.

**When to groom:** When issue has `state:new-feature` label and is being considered for
upcoming work.

**Who grooms:** Tech Lead or Scrum Master recommended for initial triage.

### Grooming Activities

Perform these 6 activities for each issue before transitioning to refinement:

1. **Requirements Validation** - Check if issue originated from `requirements-gathering`
   skill. Verify acceptance criteria exist and are testable. Flag issues created ad-hoc
   without proper requirements process.

2. **Categorization & Labeling** - Apply component label based on affected area (e.g.,
   `component:api`, `skill`). Apply work-type label based on content (e.g.,
   `work-type:new-feature`, `work-type:bug`). Apply priority label based on urgency and
   impact (P0-P4). See [Component Tagging](references/component-tagging.md) for complete
   taxonomy.

3. **Duplicate Detection** - Search open issues for similar scope or functionality. Check
   closed issues for prior attempts at same work. Link related issues in comments. If
   duplicate found, close as duplicate or merge scope.

4. **Blocked/Blocking Verification** - If issue has `blocked` label, verify blocker issues
   exist and are valid. Check if blocker issues are still open. Update dependency comments
   if blockers have been resolved. Verify no circular dependencies exist.

5. **Follow-Up Review** - Read all comments for unanswered questions. Identify questions
   needing stakeholder response. Flag issue as needing response before proceeding. Do not
   transition to refinement until questions addressed.

6. **Standards Alignment** - Verify issue follows repository issue template. Check that
   description is clear and actionable. Validate scope is appropriate (not too large, not
   too small). Confirm issue aligns with current architectural patterns.

### Grooming Exit Criteria

Issue is ready for refinement when:

- [ ] All 6 grooming activities completed
- [ ] Required labels applied (component, work-type, priority)
- [ ] No unanswered questions remain
- [ ] No unresolved blocking dependencies
- [ ] Issue follows repository standards

**Transition command:**

```bash
gh issue edit N --add-label "state:grooming" --remove-label "state:new-feature"
# After grooming complete:
gh issue edit N --add-label "state:refinement" --remove-label "state:grooming"
```

### P0 Expedited Grooming

For P0 critical issues, perform abbreviated grooming:

1. Apply P0 priority label immediately
2. Verify no duplicate exists
3. Check for blocking dependencies
4. Skip standards alignment and follow-up review
5. Document "Expedited grooming: P0 critical" in comment
6. Transition to refinement immediately
