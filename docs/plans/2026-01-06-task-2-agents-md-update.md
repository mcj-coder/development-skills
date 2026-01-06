# Task 2: Update AGENTS.md with TDD/BDD Requirements - BDD Verification

## RED: Failing Checklist (Before Implementation)

- [ ] AGENTS.md contains expanded applied-skill evidence section
- [ ] Distinguishes concrete changes (require applied evidence) from process-only (analytical verification)
- [ ] References `docs/references/bdd-checklist-templates.md`
- [ ] Includes example of concrete verification with commit SHAs
- [ ] Includes example of process-only analytical verification
- [ ] States "TDD enforcement" section (line 20-21) applies to all changes including documentation

**Failure Notes:**
- Current AGENTS.md line 12-15 has basic applied-skill evidence requirement
- Lacks clarity on concrete vs process-only distinction
- No reference to BDD checklist templates
- No examples provided
- TDD enforcement section doesn't reference BDD checklists

## GREEN: Passing Checklist (After Implementation)

- [x] AGENTS.md contains expanded applied-skill evidence section (lines 12-22)
- [x] Distinguishes concrete changes (require applied evidence) from process-only (analytical verification)
- [x] References `docs/references/bdd-checklist-templates.md` (line 21)
- [x] Includes example of concrete verification with commit SHAs (line 15-16)
- [x] Includes example of process-only analytical verification (line 19-20)
- [x] States "TDD enforcement" section (lines 27-34) applies to all changes including documentation

**Applied Evidence:**
- Updated AGENTS.md applied-skill evidence section (lines 12-22)
  - Concrete changes require applied evidence with commit SHAs and file links
  - Process-only allows analytical verification with issue comment links
  - Includes examples for both types
- Updated TDD enforcement section (lines 27-34)
  - Explicitly states TDD applies to ALL changes (code, configuration, documentation)
  - Documents RED/GREEN phases for BDD checklists
  - References BDD checklist templates
  - States "no verify after changes allowed"
