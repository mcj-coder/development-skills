# AutoFix Reference

This document describes the detailed AutoFix behaviour for each verification check.

## AutoFix: Superpowers Not Available

**Trigger:** Superpowers is not installed or not bootstrapped.

**Steps:**

1. Read prerequisite repositories section from AGENTS.md
2. Locate Superpowers repository URL from prerequisite list
3. Fetch installation instructions from Superpowers repository
4. Detect current agent type (claude, codex, or other)
5. Install Superpowers using agent's default installation mechanism
6. Run bootstrap command using agent's default mechanism
7. Verify Superpowers skills are now available
8. If verification still fails, halt and provide manual installation instructions

**Example output:**

```text
❌ Verification failed: Superpowers not available
🔧 AutoFix: Installing Superpowers
   → Reading prerequisite repos from AGENTS.md
   → Found Superpowers: https://github.com/obra/superpowers
   → Reading installation instructions from repository
   → Detected agent type: claude
   → Installing per agent's default mechanism
   → Running bootstrap
   ✅ Superpowers installed and bootstrapped

✅ Verification passed: Superpowers available
```

## AutoFix: using-superpowers Not Loaded

**Trigger:** `superpowers:using-superpowers` skill is not loaded.

**Steps:**

1. Load `superpowers:using-superpowers` skill
2. Verify skill loaded successfully
3. If load fails, halt and provide instructions to load manually

**Example output:**

```text
❌ Verification failed: using-superpowers not loaded
🔧 AutoFix: Loading required skill
   → Loading superpowers:using-superpowers
   ✅ Skill loaded successfully

✅ Verification passed: using-superpowers loaded
```

## AutoFix: AGENTS.md Missing (Brownfield)

**Trigger:** Repository does not have AGENTS.md file.

**Steps:**

1. Detect brownfield scenario (existing repo without AGENTS.md)
2. Create feature branch: `feat/add-skills-first-workflow`
3. Create AGENTS.md using template from references/AGENTS-TEMPLATE.md
4. Replace `[org]` placeholder with actual organization/user:
   - Extract org from remote URL: `git remote get-url origin`
   - Parse GitHub URL format: `https://github.com/[org]/[repo]`
   - Replace all `[org]` instances in template with extracted value
5. Commit AGENTS.md with evidence message
6. Verify AGENTS.md now exists and contains required sections

**Example output:**

```text
❌ Verification failed: AGENTS.md not found
🔧 AutoFix: Creating AGENTS.md (brownfield migration)
   → Creating feature branch: feat/add-skills-first-workflow
   → Creating AGENTS.md with skills-first directives
   → Adding prerequisite repo URLs
   → Committing changes
   ✅ AGENTS.md created

✅ Verification passed: AGENTS.md exists
```

## AutoFix: AGENTS.md Incomplete

**Trigger:** AGENTS.md exists but missing skills-first-workflow reference or
prerequisite repository URLs.

**Steps:**

1. Create feature branch for update
2. Add missing sections to AGENTS.md
3. Add skills-first-workflow reference if missing
4. Add prerequisite repository URLs if missing
5. Commit updates with evidence
6. Verify AGENTS.md now complete

**Example output:**

```text
❌ Verification failed: AGENTS.md missing prerequisite repos
🔧 AutoFix: Updating AGENTS.md
   → Creating feature branch: feat/update-agents-md
   → Adding prerequisite repository URLs
   → Committing changes
   ✅ AGENTS.md updated

✅ Verification passed: AGENTS.md complete
```

## AutoFix: AGENTS.md Missing (Greenfield)

**Trigger:** Creating new repository and AGENTS.md doesn't exist.

**Steps:**

1. Detect greenfield scenario (new repo creation)
2. Create AGENTS.md using template from references/AGENTS-TEMPLATE.md
3. Replace `[org]` placeholder with actual organization/user:
   - Extract org from remote URL: `git remote get-url origin`
   - Parse GitHub URL format: `https://github.com/[org]/[repo]`
   - Replace all `[org]` instances in template with extracted value
4. Create README.md with Work Items section if it doesn't exist
5. Commit both files as part of initialization
6. Verify initialization complete

**Example output:**

```text
❌ Verification failed: AGENTS.md not found (new repo)
🔧 AutoFix: Initializing repository with skills-first workflow
   → Creating AGENTS.md with skills-first directives
   → Creating README.md with Work Items section
   → Committing initialization files
   ✅ Repository initialized

✅ Verification passed: Repository configured for skills-first workflow
```

## AutoFix: Task-Relevant Skills Not Loaded

**Trigger:** Process skills required for current task are not loaded.

**Required skills by task type:**

- **Unclear requirements or new features:** `superpowers:brainstorming`
- **Multi-step tasks:** `superpowers:writing-plans`
- **Code changes:** `superpowers:test-driven-development`
- **All tasks:** `superpowers:verification-before-completion`

**Steps:**

1. Analyze current task to determine required skills
2. Check which required skills are not loaded
3. Load each missing skill
4. Verify all required skills now loaded
5. If load fails for any skill, halt and provide instructions

**Example output:**

```text
❌ Verification failed: Required skills not loaded
   Missing: brainstorming, test-driven-development
🔧 AutoFix: Loading required skills
   → Loading superpowers:brainstorming
   → Loading superpowers:test-driven-development
   ✅ Required skills loaded

✅ Verification passed: All task-relevant skills loaded
```

## No AutoFix: Manual Intervention Required

**When AutoFix halts:**

- Superpowers installation fails after automated attempt
- Skill loading fails after automated attempt
- AGENTS.md creation fails (permissions, conflicts)
- Network issues prevent fetching installation instructions

**Manual instructions provided include:**

- Exact commands to run
- Links to installation guides
- Troubleshooting steps
- Contact information for help
