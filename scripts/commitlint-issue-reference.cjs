/**
 * Commitlint plugin for issue reference validation
 *
 * Ensures commit messages reference a GitHub issue for traceability.
 *
 * Valid patterns:
 *   - Refs: #123
 *   - Refs: #123, #456
 *   - Fixes: #123
 *   - (#123) in subject line
 *
 * Exceptions (no reference required):
 *   - Merge commits (subject starts with "Merge")
 *   - Revert commits (subject starts with "Revert")
 *   - Initial commits (subject is "Initial commit")
 *   - Release commits (subject contains "release" or "version")
 *
 * @see docs/playbooks/standards-compliance.md
 */

/** @type {import('@commitlint/types').Rule} */
const issueReferenceRule = (parsed) => {
  const { subject, body, footer, raw } = parsed;

  // Exception patterns - these commits don't require issue references
  const exemptPatterns = [
    /^Merge\s/i, // Merge commits
    /^Revert\s/i, // Revert commits
    /^Initial commit$/i, // Initial commit
    /release|version/i, // Release/version commits
  ];

  // Check if subject matches any exempt pattern
  if (subject && exemptPatterns.some((pattern) => pattern.test(subject))) {
    return [true, "Exempt commit type - issue reference not required"];
  }

  // Issue reference patterns
  const referencePatterns = [
    /\(#\d+\)/, // (#123) in subject
    /refs?:\s*#\d+/i, // Refs: #123 or Ref: #123
    /fix(?:es)?:\s*#\d+/i, // Fixes: #123 or Fix: #123
    /closes?:\s*#\d+/i, // Closes: #123 or Close: #123
    /resolves?:\s*#\d+/i, // Resolves: #123 or Resolve: #123
    /#\d+/, // Any #123 reference (fallback)
  ];

  // Check subject, body, and footer for references
  const fullMessage = [subject, body, footer].filter(Boolean).join("\n");

  const hasReference = referencePatterns.some((pattern) =>
    pattern.test(fullMessage),
  );

  if (hasReference) {
    return [true, "Valid issue reference found"];
  }

  return [
    false,
    "Commit message must reference an issue (e.g., Refs: #123, Fixes: #456, or (#123) in subject)",
  ];
};

module.exports = {
  rules: {
    "issue-reference": issueReferenceRule,
  },
};
