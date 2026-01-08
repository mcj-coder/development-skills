const issueReferencePlugin = require("./scripts/commitlint-issue-reference.cjs");

module.exports = {
  extends: ["@commitlint/config-conventional"],
  plugins: [issueReferencePlugin],
  rules: {
    // Require issue reference in commit messages
    // Level 2 = error, "always" = must have reference
    "issue-reference": [2, "always"],
  },
};
