# Rationalizations and Responses

Complete table of common excuses for ignoring broken windows and why they're wrong.

## Complete Rationalizations Table

| Excuse                                         | Reality                                                                                                            |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| "It's just a warning, not an error"            | Warnings indicate problems. Ignoring normalizes sloppiness.                                                        |
| "This is normal Windows/environment behaviour" | "Normal" warnings still indicate configuration issues. Fix them.                                                   |
| "No time to fix now"                           | 2-min fix now vs 2-hour debugging later. Fix forward.                                                              |
| "Can fix it later"                             | "Later" rarely happens. Fix unless >2x impact.                                                                     |
| "Warnings don't affect functionality"          | They mask errors and signal low standards.                                                                         |
| "This is normal in this codebase"              | Then fix this instance, document pattern, create cleanup issue.                                                    |
| "Fixing might break things"                    | Apply 2x rule. If quick, fix and test. If risky, investigate first.                                                |
| "That's scope creep"                           | Fixing broken windows is part of the work, not extra.                                                              |
| "Need to balance priorities"                   | 2x rule IS the balance. Objective threshold, not subjective.                                                       |
| "Tech lead/user wants it done now"             | Authority doesn't override 2x rule. Fix or document with approval.                                                 |
| "Already committed too much time"              | Sunk cost fallacy. Fix violations or document why not.                                                             |
| "Broken windows only apply to code"            | Applies to warnings, configs, docs, tests - everything.                                                            |
| "Tests can be added later"                     | Tests are completion criteria, not optional. Work isn't done until tests exist.                                    |
| "User just wants it working"                   | User wants it working AND maintainable. Standards violations create technical debt.                                |
| "This warning is everywhere in the codebase"   | Then it's an epidemic, not an exception. Fix this instance, document pattern, create cleanup issue.                |
| "It's about spirit not ritual"                 | Violating the letter IS violating the spirit. The 2x rule is objective.                                            |
| "This is different because..."                 | Apply the 2x rule. If it's truly different, it will show in the calculation.                                       |
| "I'll set up linting/verification tools later" | Working without verification tools allows broken windows to accumulate undetected. Set up immediately.             |
| "Can work without verification tools for now"  | Every commit without verification is technical debt. If package.json exists, run npm install before starting work. |

## Conventions Documentation

### When Issues Are Fixed

Update `docs/coding-standards.md` with the configuration or pattern:

```markdown
## Configuration Standards

**Line Endings:**

- Configured in .gitattributes
- Policy: LF for all text files
- Reason: Prevents cross-platform issues

**Editor Configuration:**

- Configured in .editorconfig
- Settings: [specific settings applied]
```

### When Issues Are Deferred

Update `docs/known-issues.md` with complete documentation:

```markdown
## Known Issues

### [Issue Description]

- **Detected:** [YYYY-MM-DD]
- **Type:** [Warning | Vulnerability | Standards Violation]
- **Impact:** [Description]
- **Why Not Fixed:** [Fix time estimate] would exceed 2x threshold ([remaining work estimate])
- **Mitigation:** [What's being done to minimize risk]
- **Resolution Plan:** [When/how this will be addressed]
- **Approved By:** [User/Tech Lead]
```

## Greenfield vs Brownfield

### Greenfield Projects

- Establish clean baseline from first commit
- Configure warnings as errors where possible
- Set up pre-commit hooks to catch issues early
- Document standards in coding-standards.md
- No technical debt to manage initially
- Zero tolerance for new broken windows

### Brownfield Projects

- More warnings/issues likely to exist
- **Apply broken-window to NEW warnings only initially**
- Create baseline inventory of existing warnings in docs/known-issues.md
- Establish "no new broken windows" policy
- Gradually reduce existing warnings with cleanup issues
- Don't let perfect be enemy of good (fix new, plan for old)

**Strategy for Brownfield:**

1. **Baseline existing issues:**

   ```bash
   npm audit > docs/baseline-vulnerabilities.txt
   eslint . > docs/baseline-lint-warnings.txt
   git commit -m "docs: baseline existing issues before broken-window policy"
   ```

2. **Document the policy:**

   ```markdown
   # Broken Window Policy

   Effective [DATE]: All NEW warnings/errors must be fixed or documented per 2x rule.

   Existing issues baselined in [files]. Working to reduce over time.
   ```

3. **Track progress:**
   - Create issues for existing problem categories
   - Chip away during regular work
   - Celebrate reduction in baseline counts
