# DangerJS Enforcement (Recommended)

> Reference material for the [`issue-driven-delivery`](../SKILL.md) skill.


**Strongly recommended**: Configure DangerJS to validate evidence requirements
automatically on PRs. This catches violations before human review.

### Example Dangerfile Rules

```javascript
// dangerfile.js - Evidence validation rules

const { danger, warn, fail } = require("danger");

// Rule 1: All acceptance criteria must be checked
const issueBody = danger.github.issue?.body || "";
const uncheckedAcceptance = (issueBody.match(/- \[ \] (?!~~)/g) || []).length;
const struckItems = (issueBody.match(/- \[ \] ~~/g) || []).length;

if (uncheckedAcceptance > struckItems) {
  fail(
    `${uncheckedAcceptance - struckItems} acceptance criteria not checked. ` +
      `Complete all items or mark as descoped before PR.`,
  );
}

// Rule 2: Checked items must have evidence links
const checkedWithoutEvidence = issueBody.match(/- \[x\] [^(\n]+(?!\()/g) || [];
if (checkedWithoutEvidence.length > 0) {
  fail(
    `${checkedWithoutEvidence.length} checked items missing evidence links. ` +
      `Format: - [x] Item ([evidence](link))`,
  );
}

// Rule 3: Descoped items must have approval links
const descopedWithoutApproval =
  issueBody.match(/- \[ \] ~~[^(]+(?!\(descoped:)/g) || [];
if (descopedWithoutApproval.length > 0) {
  fail(
    `Descoped items missing approval links. ` +
      `Format: - [ ] ~~Item~~ (descoped: [approval](link))`,
  );
}

// Rule 4: Plan must be archived (check for plan file in archive)
const planArchived = danger.git.created_files.some((f) =>
  f.includes("docs/plans/archive/"),
);
const planInProgress = danger.git.modified_files.some(
  (f) => f.includes("docs/plans/") && !f.includes("archive"),
);

if (planInProgress && !planArchived) {
  warn("Plan file modified but not archived. Archive plan before merge.");
}

// Rule 5: PR test plan should not be pre-checked by author
const prBody = danger.github.pr.body || "";
const preCheckedTestPlan = (
  prBody.match(/## Test [Pp]lan[\s\S]*?- \[x\]/g) || []
).length;
if (preCheckedTestPlan > 0) {
  warn("PR test plan items should be checked by reviewer, not author.");
}
```

### DangerJS Setup

1. Install: `npm install --save-dev danger`
2. Create `dangerfile.js` with rules above
3. Add to CI pipeline (example below)

**GitHub Actions example:**

```yaml
- name: Danger
  run: npx danger ci
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Validation Without DangerJS

If DangerJS is not available, validate manually before merge:

```bash
# Check for unchecked acceptance criteria (excluding descoped)
gh issue view N --json body --jq '.body' | grep -c '- \[ \] [^~]'
# Should be 0

# Check for checked items without evidence
gh issue view N --json body --jq '.body' | grep -E '- \[x\] [^(]+$'
# Should return nothing

# Check plan archived
ls docs/plans/archive/*N* 2>/dev/null
# Should find archived plan
```
