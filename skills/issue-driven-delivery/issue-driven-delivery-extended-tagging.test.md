# Extended Tagging BDD Tests

This file contains behaviour-driven development tests for the extended tagging system (priority, work type, blocked status).

## RED Scenario 1: Missing Priority Tag

**Context:** Agent closes work item without priority tag

**Without extended tagging skill:**

```text
Agent closes issue #123
Issue has: component:skill, work-type:enhancement
Issue missing: priority tag
Result: Issue closed successfully (no enforcement)
```

**Expected with extended tagging (should fail initially):**

- [ ] Agent checks for priority tag before closing
- [ ] Agent stops with error: "Missing mandatory priority tag"
- [ ] Agent suggests appropriate priority based on issue content

## RED Scenario 2: Missing Work Type Tag

**Context:** Agent closes work item without work type tag

**Without extended tagging skill:**

```text
Agent closes issue #124
Issue has: component:api, priority:p2
Issue missing: work type tag
Result: Issue closed successfully (no enforcement)
```

**Expected with extended tagging:**

- [ ] Agent checks for work type tag before closing
- [ ] Agent stops with error: "Missing mandatory work type tag"
- [ ] Agent suggests work type based on issue title/content

## RED Scenario 3: Blocked Tag Without Comment

**Context:** Agent adds blocked tag but no comment explaining blocker

**Without extended tagging skill:**

```text
Agent adds label: blocked
Agent does NOT post comment explaining what's blocking
Result: Blocked tag applied with no explanation
```

**Expected with extended tagging:**

- [ ] Agent detects blocked tag exists
- [ ] Agent checks for blocking comment
- [ ] Agent stops with error: "Blocked tag requires comment explaining blocker"

## RED Scenario 4: Blocked Work Item Unassigned

**Context:** Agent tries to unassign blocked work item

**Without extended tagging skill:**

```text
Work item has blocked tag
Agent unassigns work item
Result: Blocked work unassigned (accountability lost)
```

**Expected with extended tagging:**

- [ ] Agent detects work item is blocked
- [ ] Agent prevents unassignment
- [ ] Agent stops with error: "Cannot unassign blocked work item"
- [ ] Agent suggests either removing blocked tag or reassigning

## RED Scenario 5: Missing Auto-Assignment

**Context:** New issue created without tags

**Without extended tagging skill:**

```text
User creates issue: "Add dark mode to settings"
No tags auto-applied
Result: Issue created with no organizational tags
```

**Expected with extended tagging:**

- [ ] Agent analyses issue title/body
- [ ] Agent suggests/applies component tag based on content
- [ ] Agent suggests/applies work type based on keywords ("Add" → new-feature)
- [ ] Agent suggests/applies priority based on urgency indicators

## GREEN Scenario 1: Priority Tag Enforcement

**With extended tagging skill:**

**Agent behaviour when closing issue without priority:**

```text
Agent checks issue #123 tags before closing
Finds: component:skill, work-type:enhancement
Missing: priority tag
Agent stops with error message
Agent suggests: priority:p2 based on "enhancement" keyword
User adds priority:p2
Agent proceeds with closing
```

**Evidence:**

- ✅ Agent checks for priority tag before closing
- ✅ Agent stops with error if missing
- ✅ Agent suggests priority based on issue content
- ✅ Priority taxonomy documented (P0-P4)

## GREEN Scenario 2: Work Type Tag Enforcement

**With extended tagging skill:**

**Agent behaviour when closing issue without work type:**

```text
Agent checks issue #124 tags before closing
Finds: component:api, priority:p2
Missing: work-type tag
Agent stops with error message
Agent suggests: work-type:enhancement or work-type:new-feature based on title
User adds work-type:enhancement
Agent proceeds with closing
```

**Evidence:**

- ✅ Agent checks for work type tag before closing
- ✅ Agent stops with error if missing
- ✅ Agent suggests work type based on issue title/body
- ✅ Work type taxonomy documented (8+ types)

## GREEN Scenario 3: Blocked Status Workflow

**With extended tagging skill:**

**Agent behaviour when adding blocked tag:**

```text
Agent identifies work is blocked
Agent adds blocked label
Agent IMMEDIATELY posts comment:
  "Blocked by: Waiting for API design from #125
   Blocker ID: #125
   What's needed: API specification document
   Who can help: @architect"
Work item remains assigned
```

**Evidence:**

- ✅ Blocked tag requires mandatory comment
- ✅ Comment includes: blocker description, ID, what's needed, who can help
- ✅ Work item stays assigned (cannot unassign)
- ✅ Blocked status workflow documented

## GREEN Scenario 4: Blocked Work Item Assignment Constraint

**With extended tagging skill:**

**Agent behaviour when trying to unassign blocked work:**

```text
Work item #126 has blocked tag
Agent attempts to unassign
Agent detects blocked status
Agent stops with error:
  "Cannot unassign blocked work item.
   Blocked work must remain assigned for accountability.
   To proceed: (1) remove blocked tag, or (2) reassign to another person."
```

**Evidence:**

- ✅ Agent prevents unassignment of blocked work
- ✅ Agent provides clear error message
- ✅ Agent suggests alternatives (remove tag or reassign)
- ✅ Blocked assignment constraint documented

## GREEN Scenario 5: Auto-Assignment on Issue Creation

**With extended tagging skill:**

**Agent behaviour when creating new issue:**

```text
User creates issue: "Add dark mode to settings"
Agent analyses:
  - Title keyword "Add" → work-type:new-feature (high confidence)
  - Content mentions "settings" → component:ui (medium confidence)
  - No urgency indicators → priority:p2 (default)
Agent auto-applies tags
Agent posts comment:
  "🏷️ **Auto-applied tags:**
   - work-type:new-feature (keyword: Add)
   - component:ui (mentions settings)
   - priority:p2 (default for new features)

   Please verify these are appropriate."
```

**Evidence:**

- ✅ Agent analyses issue content on creation
- ✅ Agent auto-applies high-confidence tags
- ✅ Agent posts comment explaining auto-assignment
- ✅ Auto-assignment strategy documented

## Verification Checklist

After implementing extended tagging system, verify:

- [ ] All RED scenarios fail without the extended tagging documentation
- [ ] All GREEN scenarios pass with the extended tagging documentation
- [x] Priority taxonomy (P0-P4) is documented in component-tagging.md
- [x] Work type taxonomy (8+ types) is documented in component-tagging.md
- [x] Blocked status workflow is documented in component-tagging.md
- [x] Enforcement rules cover all tag types
- [x] Auto-assignment strategy is documented
- [x] Repository documentation template created
- [x] Work-type-specific issue templates created
- [x] Main SKILL.md references extended tagging system
