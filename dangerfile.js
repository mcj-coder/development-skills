// dangerfile.js - Evidence validation rules for PR enforcement
// Implements automated checks from issue-driven-delivery skill
// Issue: #300

const { danger, warn, fail, message } = require("danger");

// Helper to safely get issue body (linked issue from PR)
async function getLinkedIssueBody() {
  const prBody = danger.github.pr.body || "";

  // Extract issue number from "Closes #N" or "Fixes #N" patterns
  const issueMatch = prBody.match(/(?:closes|fixes|resolves)\s+#(\d+)/i);
  if (!issueMatch) {
    return null;
  }

  const issueNumber = issueMatch[1];
  try {
    const issue = await danger.github.api.issues.get({
      owner: danger.github.thisPR.owner,
      repo: danger.github.thisPR.repo,
      issue_number: parseInt(issueNumber),
    });
    return issue.data.body || "";
  } catch {
    return null;
  }
}

// Main validation logic
async function validate() {
  const prBody = danger.github.pr.body || "";

  // Rule 0: PR must reference an issue
  const hasIssueReference = /(?:closes|fixes|resolves)\s+#\d+/i.test(prBody);
  if (!hasIssueReference) {
    fail("PR must reference an issue. Add 'Closes #N' to the PR description.");
    return; // Can't validate further without issue reference
  }

  const issueBody = await getLinkedIssueBody();
  if (!issueBody) {
    warn("Could not fetch linked issue body. Manual verification required.");
    return;
  }

  // Rule 1: All acceptance criteria must be checked
  // Count unchecked items that are NOT struck through (descoped)
  const uncheckedRegex = /- \[ \] (?!~~)/g;
  const uncheckedMatches = issueBody.match(uncheckedRegex) || [];
  const uncheckedCount = uncheckedMatches.length;

  if (uncheckedCount > 0) {
    fail(
      `${uncheckedCount} acceptance criteria not checked. ` +
        `Complete all items or mark as descoped (~~strikethrough~~) before PR.`,
    );
  }

  // Rule 2: Checked items should have evidence links
  // Look for checked items without parentheses containing links
  const checkedItemsRegex = /- \[x\] (.+)/g;
  let match;
  const checkedWithoutEvidence = [];

  while ((match = checkedItemsRegex.exec(issueBody)) !== null) {
    const itemText = match[1];
    // Check if item has a link in parentheses or markdown link
    if (
      !/\([^)]*https?:\/\/[^)]+\)/.test(itemText) &&
      !/\[[^\]]+\]\([^)]+\)/.test(itemText)
    ) {
      checkedWithoutEvidence.push(itemText.substring(0, 50));
    }
  }

  if (checkedWithoutEvidence.length > 0) {
    warn(
      `${checkedWithoutEvidence.length} checked items may be missing evidence links. ` +
        `Recommended format: - [x] Item ([evidence](link))`,
    );
  }

  // Rule 3: Descoped items must have approval links
  const descopedRegex = /- \[ \] ~~([^~]+)~~/g;
  const descopedWithoutApproval = [];

  while ((match = descopedRegex.exec(issueBody)) !== null) {
    const fullLine = issueBody.substring(
      match.index,
      issueBody.indexOf("\n", match.index),
    );
    if (
      !/\(descoped:/.test(fullLine) &&
      !/\[[^\]]+\]\([^)]+\)/.test(fullLine)
    ) {
      descopedWithoutApproval.push(match[1].substring(0, 50));
    }
  }

  if (descopedWithoutApproval.length > 0) {
    fail(
      `${descopedWithoutApproval.length} descoped items missing approval links. ` +
        `Format: - [ ] ~~Item~~ (descoped: [approval](link))`,
    );
  }

  // Rule 4: Plan must be archived (check for plan file in archive)
  const createdFiles = danger.git.created_files || [];
  const modifiedFiles = danger.git.modified_files || [];

  const planArchived = createdFiles.some((f) =>
    f.includes("docs/plans/archive/"),
  );
  const planInProgress = modifiedFiles.some(
    (f) => f.includes("docs/plans/") && !f.includes("archive"),
  );

  if (planInProgress && !planArchived) {
    warn("Plan file modified but not archived. Archive plan before merge.");
  }

  // Rule 5: PR test plan should not be pre-checked by author
  const testPlanSection = prBody.match(/## Test [Pp]lan[\s\S]*?(?=##|$)/);
  if (testPlanSection) {
    const preCheckedInTestPlan = (testPlanSection[0].match(/- \[x\]/g) || [])
      .length;
    if (preCheckedInTestPlan > 0) {
      warn(
        "PR test plan items should be checked by reviewer, not author. " +
          `Found ${preCheckedInTestPlan} pre-checked items.`,
      );
    }
  }

  // Rule 6: PR must have a summary section
  if (!/## Summary/i.test(prBody)) {
    warn("PR should include a '## Summary' section describing the changes.");
  }

  // Rule 7: PR must have a test plan section
  if (!/## Test [Pp]lan/i.test(prBody)) {
    warn("PR should include a '## Test plan' section.");
  }

  // Success message if all critical checks pass
  const failures = danger.fails || [];
  if (failures.length === 0) {
    message("All PR validation checks passed.");
  }
}

// Run validation
validate();
