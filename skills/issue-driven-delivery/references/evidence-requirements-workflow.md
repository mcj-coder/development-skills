# Evidence Requirements

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


**Critical**: All commits must be pushed to remote before posting links. Evidence
must be posted as clickable links in work item comments AND in checkbox updates.

**Key requirements**:

- Each sub-task comment includes links to exact commits and files
- Role reviews are separate work item comments using
  superpowers:receiving-code-review (team roles defined in repository's `docs/roles/`)
- Plan separates Original Scope Evidence from Additional Work
- Keep only latest verification evidence in plan
- **All checkboxes updated with evidence links before PR creation**

See [Evidence Requirements](references/evidence-requirements.md) for complete
requirements and evidence checklist.

### Checkbox Evidence Format

**Every checked checkbox MUST include an evidence link.** This applies to:

- Issue acceptance criteria
- PR test plan items
- Plan task items
- Sub-task checklists

**Standard format:**

```markdown
- [x] Acceptance item ([evidence](https://github.com/org/repo/commit/abc123))
- [x] Multiple evidence sources ([commit](link1), [test output](link2))
- [x] File change ([diff](https://github.com/org/repo/pull/1/files#diff-abc123))
```

**Scope change format:**

```markdown
- [x] Added during implementation (added: [approval](comment-link), [evidence](link))
- [ ] ~~Removed from scope~~ (descoped: [approval](comment-link))
```

**Evidence link types:**

| Change Type | Evidence Format                                     |
| ----------- | --------------------------------------------------- |
| Code        | Commit SHA URL: `repo/commit/abc123`                |
| File        | Permalink with line: `repo/blob/sha/path#L10-L20`   |
| PR          | PR URL or files tab: `repo/pull/1/files`            |
| Test        | CI run URL or test output in comment                |
| Config      | Before/after screenshot or diff link                |
| Approval    | Issue comment URL: `repo/issues/1#issuecomment-123` |

### Pre-PR Evidence Requirements

**Before creating a PR, the implementer MUST:**

1. **Update all acceptance criteria checkboxes** in issue body:
   - Check each completed item: `- [ ]` → `- [x]`
   - Add evidence link to each checked item
   - Strike through descoped items with approval link

2. **Update all plan task checkboxes**:
   - Check each completed task with evidence
   - Update plan status to "Implementation Complete"
   - Ensure plan is ready for archive

3. **Prepare PR test plan**:
   - All items should be checkable by reviewer
   - Implementer does NOT check PR test plan items
   - Reviewer checks items after verification

**Evidence separation (Critical):**

- **Implementer**: Gathers and links ALL evidence before PR
- **Reviewer**: Verifies evidence is valid and sufficient
- **Reviewer does NOT gather evidence for implementer**

If reviewer finds missing evidence, PR is sent back to implementer to add it.

### Scope Change Tracking

All scope changes during implementation MUST be tracked in acceptance criteria:

**Adding scope:**

1. Post scope change comment (use template below)
2. Get approval in issue comment thread
3. Add new checkbox with approval link
4. Complete work and add evidence

**Removing scope (descoping):**

1. Post scope change comment (use template below)
2. Get approval in issue comment thread
3. Strike through item and add approval link
4. Item remains unchecked but struck through

**Scope change without approval is a violation.** All added or removed work
requires explicit approval captured in issue comments.

#### Scope Change Comment Template

When scope changes, post a comment using this format:

```markdown
## Scope Change

**Type:** Addition / Removal / Modification
**Reason:** [Why the change is needed]
**Impact:** [What this affects - timeline, dependencies, etc.]

**Changes:**

- ~~Removed: [item being removed]~~
- Added: [new item being added]
- Modified: [item changed] → [new version]

**Awaiting approval to proceed with scope change.**
```

After approval, update the issue body:

Format for added scope:

```markdown
- [ ] New requirement (added: [approval](#issuecomment-123))
- [x] New requirement (added: [approval](#issuecomment-123), [evidence](commit-link))
```

Format for descoped items:

```markdown
- [ ] ~~Original requirement~~ (descoped: [approval](#issuecomment-123))
```

**Exemplar:** [Issue #167](https://github.com/mcj-coder/development-skills/issues/167) demonstrates
partial scope change compliance with documented scope reduction.

### Plan Lifecycle Evidence

Plans must be updated throughout implementation:

**During implementation:**

- Update task checkboxes as work completes
- Add evidence links to each task
- Note any scope changes with approval links

**Before PR creation:**

- All tasks checked with evidence
- Status updated: "Implementation Complete"
- Scope changes documented

**Before PR merge:**

- Status updated: "Verification Complete" (if verification phase used)
- Archive plan: `git mv docs/plans/plan.md docs/plans/archive/`
- Commit archive with issue reference

**Plan archive validation:**

```bash
# Verify plan archived before merge
test -f docs/plans/archive/*issue-N*.md && echo "PASS" || echo "FAIL: Plan not archived"
```
