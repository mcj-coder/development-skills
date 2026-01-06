# finishing-a-development-branch - Test Scenarios

## Test 1: Block PR when skill verification missing

**Given** a developer has completed implementation of a new skill on feat/issue-123-add-skill
**And** all tests pass
**And** changes are committed and pushed
**When** developer invokes finishing-a-development-branch skill
**And** git diff shows skill files modified (skills/new-skill/SKILL.md)
**And** work item #123 has NO "Skill Author Review" comment
**Then** skill displays verification checkpoint warning
**And** shows checklist with "Skill Author review" unchecked
**And** blocks Option 2 (Create PR)
**And** provides guidance on completing Skill Author review
**And** exits without presenting PR option

## Test 2: Block PR when documentation verification missing

**Given** a developer has updated README.md and docs/architecture.md
**And** all tests pass
**And** changes are committed and pushed
**When** developer invokes finishing-a-development-branch skill
**And** git diff shows documentation files modified
**And** work item has NO "Documentation Expert Review" comment
**Then** skill displays verification checkpoint warning
**And** shows checklist with "Documentation Expert review" unchecked
**And** blocks Option 2 (Create PR)
**And** provides guidance on completing Documentation Expert review
**And** exits without presenting PR option

## Test 3: Block PR when QA verification missing

**Given** a developer has implemented a feature with acceptance criteria
**And** tests pass but QA verification not performed
**And** changes are committed and pushed
**When** developer invokes finishing-a-development-branch skill
**And** work item has NO "QA Verification" comment
**Then** skill displays verification checkpoint warning
**And** shows checklist with "QA verification" unchecked
**And** blocks Option 2 (Create PR)
**And** provides guidance on completing QA verification
**And** exits without presenting PR option

## Test 4: Allow PR when all verifications complete

**Given** a developer has completed skill implementation
**And** all tests pass
**And** Skill Author has posted review comment in work item
**And** QA has posted verification comment in work item
**And** all critical issues addressed
**And** evidence summary posted to work item
**When** developer invokes finishing-a-development-branch skill
**And** verification checkpoint detects all required comments present
**Then** skill displays "Verification checkpoint passed ✅"
**And** presents Option 1 (Direct Merge), Option 2 (Create PR), Option 3 (Abandon)
**And** Option 2 includes PR template with evidence links
**And** developer can proceed with PR creation

## Test 5: Multiple review types required

**Given** a developer has modified both skills and documentation
**And** git diff shows changes to skills/existing-skill/SKILL.md AND docs/guide.md
**When** developer invokes finishing-a-development-branch skill
**And** only Skill Author review comment exists (no Documentation Expert)
**Then** skill displays verification checkpoint warning
**And** shows checklist with "Documentation Expert review" unchecked
**And** blocks Option 2 (Create PR)
**And** provides guidance on completing remaining reviews

## Test 6: Direct merge option (verification complete)

**Given** verification and reviews are complete
**And** developer prefers direct merge over PR
**When** developer invokes finishing-a-development-branch skill
**And** chooses Option 1 (Direct Merge)
**Then** skill guides through fast-forward merge commands
**And** includes cleanup commands (delete branch)
**And** reminds to update work item and post final evidence

## Test 7: Abandon branch option

**Given** a developer has a feature branch that is no longer needed
**When** developer invokes finishing-a-development-branch skill
**And** chooses Option 3 (Abandon)
**Then** skill provides cleanup commands
**And** warns about permanent deletion
**And** includes both local and remote branch deletion

## Test 8: Verification checkpoint with custom role requirements

**Given** a work item specifies custom reviewer requirements (e.g., "Security review required")
**And** developer has completed implementation
**When** developer invokes finishing-a-development-branch skill
**And** only standard QA verification exists (no Security review comment)
**Then** skill displays verification checkpoint warning
**And** includes custom requirement in checklist
**And** blocks Option 2 (Create PR)
**And** provides guidance on completing custom reviews

## Test 9: Re-verification after addressing critical issues

**Given** initial Skill Author review found critical issues
**And** developer fixed issues and committed changes
**And** Skill Author posted updated review comment ("re-verified, issues resolved")
**When** developer invokes finishing-a-development-branch skill
**Then** skill detects updated verification comments
**And** passes verification checkpoint ✅
**And** allows PR creation

## Test 10: Evidence posting reminder

**Given** all role-based reviews complete
**And** individual verification comments exist in work item
**But** NO evidence summary comment posted
**When** developer invokes finishing-a-development-branch skill
**Then** skill displays verification checkpoint warning
**And** shows "Evidence posted to work item" unchecked
**And** reminds developer to post evidence summary linking all reviews
**And** blocks Option 2 (Create PR) until evidence posted

## Test 11: Tests passing but acceptance criteria not met

**Given** all unit/integration tests pass
**And** developer believes work is complete
**But** QA verification shows acceptance criteria #3 not met
**When** developer tries to invoke finishing-a-development-branch skill
**And** QA verification comment states "Incomplete - criteria #3 not met"
**Then** skill detects incomplete verification
**And** displays checkpoint warning
**And** blocks PR creation
**And** guides developer to complete acceptance criteria first

## Test 12: Draft PR rationalization rejected

**Given** developer argues "draft PR is fine for getting feedback"
**When** developer invokes finishing-a-development-branch skill
**And** verification checkpoint detects missing reviews
**Then** skill explicitly rejects draft PR excuse in warning message
**And** states "PR can be in draft while verification happens" is a RED FLAG
**And** redirects to work item for feedback/reviews
**And** blocks any PR creation (draft or otherwise)

## Test 13: Automatic detection of skill changes

**Given** git diff main...HEAD --name-only shows:
```
skills/test-driven-development/SKILL.md
skills/test-driven-development/tdd.test.md
```
**When** developer invokes finishing-a-development-branch skill
**Then** skill automatically detects skill modifications
**And** adds "Skill Author review required" to verification checklist
**And** checks work item for "Skill Author Review" comment
**And** blocks PR if comment missing

## Test 14: Automatic detection of documentation changes

**Given** git diff main...HEAD --name-only shows:
```
README.md
docs/architecture/system-design.md
CONTRIBUTING.md
```
**When** developer invokes finishing-a-development-branch skill
**Then** skill automatically detects documentation modifications
**And** adds "Documentation Expert review required" to verification checklist
**And** checks work item for "Documentation Expert Review" comment
**And** blocks PR if comment missing

## Test 15: No verification required for trivial changes

**Given** developer only modified .gitignore and package.json (dependency update)
**And** no skill files, docs, or functional code changed
**When** developer invokes finishing-a-development-branch skill
**Then** skill detects no special verification requirements
**And** requires only basic QA verification (tests pass)
**And** allows PR creation after basic verification

## Test 16: End-to-end happy path

**Given** developer completed feature implementation for issue #123
**And** ran `npm test` → all pass ✅
**And** committed all changes
**And** pushed to feat/issue-123-feature
**And** QA Engineer posted "QA Verification: All acceptance criteria met ✅" comment
**And** Skill Author posted "Skill Author Review: Approved, no issues found" comment
**And** developer posted evidence summary linking both reviews
**When** developer invokes finishing-a-development-branch skill
**Then** verification checkpoint passes ✅
**And** skill presents three options (Merge, PR, Abandon)
**And** developer chooses Option 2 (Create PR)
**And** skill provides gh pr create command with evidence links
**And** PR is created with all verification evidence linked
**And** PR approval is simple gate check (evidence already exists)

## Test 17: Integration with issue-driven-delivery workflow

**Given** developer is following issue-driven-delivery workflow
**And** at step 8c: "Set work item state to verification"
**And** step explicitly states "Do not open PR yet"
**When** developer completes verification (steps 9-11)
**And** reaches new step 11.5: "After all verifications complete"
**And** invokes finishing-a-development-branch skill
**Then** skill enforces verification checkpoint
**And** only allows PR creation if verification complete
**And** ensures SHIFT LEFT principles enforced at workflow level

## Test 18: Manual PR creation bypass detection

**Given** developer bypasses finishing-a-development-branch skill
**And** manually creates PR using `gh pr create` directly
**And** PR has NO verification evidence links
**When** PR reviewer examines PR description
**Then** reviewer should see missing evidence
**And** request verification completion before approval
**And** reference finishing-a-development-branch skill requirements
**And** link to work item verification comments

## Expected Failure Scenarios

### Failure 1: Developer creates PR before verification

**Given** developer completes implementation
**And** immediately runs `gh pr create` without verification
**Then** PR is created BUT lacks evidence
**And** PR review detects missing verification
**And** reviewer requests verification completion
**And** demonstrates cost of finding issues during PR vs before

### Failure 2: "Tests pass" excuse accepted

**Given** developer argues "tests pass, that's good enough"
**And** invokes finishing-a-development-branch skill
**And** only automated tests run (no acceptance criteria verification)
**Then** skill should detect missing QA verification
**And** block PR creation
**And** explicitly state "tests passing ≠ acceptance criteria met"

### Failure 3: Verification checkpoint bypassed

**Given** developer modifies skill to skip verification checkpoint
**And** creates PR without reviews
**Then** PR review process catches missing evidence
**And** PR is rejected
**And** demonstrates importance of verification enforcement

## Verification Assertions

Each test above should verify:
- ✅ Verification checkpoint logic works correctly
- ✅ Automatic detection identifies changed file types
- ✅ Work item comments checked for review evidence
- ✅ PR creation blocked when verification incomplete
- ✅ Clear guidance provided when blocked
- ✅ PR allowed only when verification complete
- ✅ Red Flags and Rationalizations prevent excuses
- ✅ Integration with issue-driven-delivery enforces SHIFT LEFT
- ✅ Benefits (cost savings, quality, pressure reduction) are realized
