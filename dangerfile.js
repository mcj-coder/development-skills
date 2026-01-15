// dangerfile.js - Evidence validation rules for PR enforcement
// Implements automated checks from issue-driven-delivery skill
// Issues: #300, #290, #291, #292

const { danger, warn, fail, message } = require("danger");

// Constants
const MAX_ITEM_PREVIEW_LENGTH = 80;

/**
 * Check if text contains an evidence link (URL in parentheses or markdown link)
 * Handles formats like:
 * - ([link](https://...))
 * - (https://...)
 * - (see [link](https://...))
 * - [link](https://...)
 */
function hasEvidenceLink(text) {
  // Markdown link with URL: [text](https://...)
  if (/\[[^\]]+\]\(https?:\/\/[^)]+\)/.test(text)) {
    return true;
  }
  // URL anywhere in parentheses: (... https://... ...)
  if (/\([^)]*https?:\/\/[^)]+\)/.test(text)) {
    return true;
  }
  // Bare URL at end of line
  if (/https?:\/\/\S+\s*$/.test(text)) {
    return true;
  }
  return false;
}

/**
 * Find checked items missing evidence links in given text
 */
function findCheckedItemsWithoutEvidence(text) {
  const checkedItemsRegex = /- \[x\] (.+)/gi;
  const itemsWithoutEvidence = [];

  for (const match of text.matchAll(checkedItemsRegex)) {
    const itemText = match[1];
    if (!hasEvidenceLink(itemText)) {
      itemsWithoutEvidence.push(itemText.substring(0, MAX_ITEM_PREVIEW_LENGTH));
    }
  }

  return itemsWithoutEvidence;
}

// Helper to extract linked issue number from PR body
function getLinkedIssueNumber() {
  const prBody = danger.github.pr.body || "";
  const issueMatch = prBody.match(/(?:closes|fixes|resolves)\s+#(\d+)/i);
  return issueMatch ? parseInt(issueMatch[1]) : null;
}

// Helper to safely get issue body (linked issue from PR)
async function getLinkedIssueBody() {
  const issueNumber = getLinkedIssueNumber();
  if (!issueNumber) {
    return null;
  }

  try {
    const issue = await danger.github.api.issues.get({
      owner: danger.github.thisPR.owner,
      repo: danger.github.thisPR.repo,
      issue_number: issueNumber,
    });
    return issue.data.body || "";
  } catch (error) {
    // Log error details for debugging (visible in CI logs)
    console.error(
      `Failed to fetch issue #${issueNumber}: ${error.message || error}`,
    );
    if (error.status === 404) {
      console.error(`Issue #${issueNumber} not found or inaccessible`);
    } else if (error.status === 403) {
      console.error(`Rate limited or insufficient permissions`);
    }
    return null;
  }
}

// Helper to get comments on the linked issue
async function getLinkedIssueComments() {
  const issueNumber = getLinkedIssueNumber();
  if (!issueNumber) {
    return null;
  }

  try {
    const comments = await danger.github.api.issues.listComments({
      owner: danger.github.thisPR.owner,
      repo: danger.github.thisPR.repo,
      issue_number: issueNumber,
    });
    return comments.data || [];
  } catch (error) {
    console.error(
      `Failed to fetch comments for issue #${issueNumber}: ${error.message || error}`,
    );
    return null;
  }
}

/**
 * Check if a comment contains a plan (implementation plan for approval)
 * Plan indicators:
 * - Contains "## Plan" or "## Implementation Plan" or "## Refinement"
 * - Links to docs/plans/ directory
 * - Contains "awaiting approval" or "ready for approval"
 */
function isPlanComment(commentBody) {
  if (!commentBody) return false;
  const lowerBody = commentBody.toLowerCase();

  // Check for plan headers
  if (/##\s*(implementation\s+)?plan/i.test(commentBody)) return true;
  if (/##\s*refinement/i.test(commentBody)) return true;

  // Check for plan file links
  if (/docs\/plans\//.test(commentBody)) return true;

  // Check for approval request language
  if (
    lowerBody.includes("awaiting approval") ||
    lowerBody.includes("ready for approval") ||
    lowerBody.includes("plan ready for approval")
  )
    return true;

  return false;
}

/**
 * Check if a comment indicates plan approval
 */
function isApprovalComment(commentBody) {
  if (!commentBody) return false;
  const lowerBody = commentBody.toLowerCase();

  return (
    lowerBody.includes("approval acknowledged") ||
    lowerBody.includes("approved to proceed") ||
    lowerBody.includes("plan approved") ||
    /proceed(ing)?\s+with/.test(lowerBody)
  );
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
  // Count all unchecked items, then subtract descoped ones
  const allUncheckedMatches = issueBody.match(/- \[ \] /g) || [];
  const descopedMatches = issueBody.match(/- \[ \] ~~[^~]+~~/g) || [];
  const uncheckedCount = allUncheckedMatches.length - descopedMatches.length;

  if (uncheckedCount > 0) {
    fail(
      `[Issue] ${uncheckedCount} acceptance criteria not checked. ` +
        `Complete all items or mark as descoped (~~strikethrough~~) before PR.`,
    );
  }

  // Rule 2: Checked items should have evidence links
  const checkedWithoutEvidence = findCheckedItemsWithoutEvidence(issueBody);

  if (checkedWithoutEvidence.length > 0) {
    warn(
      `[Issue] ${checkedWithoutEvidence.length} checked acceptance criteria may be missing evidence links. ` +
        `Recommended format: - [x] Item ([evidence](link))`,
    );
  }

  // Rule 3: Descoped items must have approval links
  const descopedRegex = /- \[ \] ~~([^~]+)~~/g;
  const descopedWithoutApproval = [];

  for (const match of issueBody.matchAll(descopedRegex)) {
    const lineEnd = issueBody.indexOf("\n", match.index);
    const fullLine = issueBody.substring(
      match.index,
      lineEnd > 0 ? lineEnd : issueBody.length,
    );
    // Case-insensitive check for descoped approval
    if (!/\(descoped:/i.test(fullLine) && !hasEvidenceLink(fullLine)) {
      descopedWithoutApproval.push(
        match[1].substring(0, MAX_ITEM_PREVIEW_LENGTH),
      );
    }
  }

  if (descopedWithoutApproval.length > 0) {
    fail(
      `[Issue] ${descopedWithoutApproval.length} descoped items missing approval links. ` +
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

  // Rule 5: PR test plan validation
  const testPlanSection = prBody.match(/## Test [Pp]lan[\s\S]*?(?=##|$)/);
  if (testPlanSection) {
    const testPlanContent = testPlanSection[0];

    // Rule 5a: All test plan items must be checked before merge
    const uncheckedTestPlan = (testPlanContent.match(/- \[ \] /g) || []).length;
    if (uncheckedTestPlan > 0) {
      fail(
        `[PR] ${uncheckedTestPlan} test plan items not verified. ` +
          `All test plan items must be checked before merge.`,
      );
    }

    // Rule 5b: Checked test plan items should have evidence
    const testPlanWithoutEvidence =
      findCheckedItemsWithoutEvidence(testPlanContent);

    if (testPlanWithoutEvidence.length > 0) {
      fail(
        `[PR] ${testPlanWithoutEvidence.length} test plan items missing evidence links. ` +
          `Required format: - [x] Item ([evidence](link))`,
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

  // Rule 8: Review depth - warn on brief/empty approvals
  const reviews = danger.github.reviews || [];
  const approvedReviews = reviews.filter((r) => r.state === "APPROVED");
  const MIN_REVIEW_BODY_LENGTH = 50;

  if (approvedReviews.length > 0) {
    const briefApprovals = approvedReviews.filter(
      (r) => !r.body || r.body.trim().length < MIN_REVIEW_BODY_LENGTH,
    );

    if (briefApprovals.length === approvedReviews.length) {
      warn(
        `[Review] All ${approvedReviews.length} approval(s) have brief or empty review bodies. ` +
          `Substantive reviews should include: files reviewed, potential issues checked, or specific feedback.`,
      );
    }
  }

  // Rule 9: Plan approval enforcement
  // Issues must have a plan comment with approval before implementation
  const issueComments = await getLinkedIssueComments();
  if (issueComments) {
    const hasPlanComment = issueComments.some((c) => isPlanComment(c.body));
    const hasApprovalComment = issueComments.some((c) =>
      isApprovalComment(c.body),
    );

    if (!hasPlanComment) {
      warn(
        `[Issue] No plan comment found on linked issue. ` +
          `Post a plan comment with "## Plan" header or link to docs/plans/ before implementation. ` +
          `See Issue #177 for exemplar.`,
      );
    } else if (!hasApprovalComment) {
      warn(
        `[Issue] Plan found but no approval comment detected. ` +
          `Add approval comment (e.g., "Approval acknowledged" or "Plan approved") before implementation.`,
      );
    }
  }

  // Success message if all critical checks pass
  const failures = danger.fails || [];
  if (failures.length === 0) {
    message("All PR validation checks passed.");
  }
}

// Run validation
validate();
