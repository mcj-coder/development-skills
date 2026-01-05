# Work-Type-Specific Issue Templates

This document provides issue templates for different work types to ensure consistent structure and required information.

## GitHub Issue Templates

GitHub supports YAML-based issue templates in `.github/ISSUE_TEMPLATE/` directory.

### Bug Report Template

**File:** `.github/ISSUE_TEMPLATE/bug-report.yml`

```yaml
name: Bug Report
description: Report a defect or error
labels: ["work-type:bug", "priority:p2"]
body:
  - type: markdown
    attributes:
      value: |
        ## Bug Report
        Please provide details about the bug you encountered.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: Clear description of the bug
      placeholder: What happened?
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: Step-by-step instructions to reproduce the bug
      placeholder: |
        1. Go to...
        2. Click on...
        3. See error...
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behaviour
      description: What should have happened?
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behaviour
      description: What actually happened?
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P0 - Critical (system down, data loss)
        - P1 - High (major functionality broken)
        - P2 - Medium (important but has workarounds)
        - P3 - Low (minor issue)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```

### Feature Request Template

**File:** `.github/ISSUE_TEMPLATE/feature-request.yml`

```yaml
name: Feature Request
description: Propose new functionality
labels: ["work-type:new-feature", "priority:p3"]
body:
  - type: markdown
    attributes:
      value: |
        ## Feature Request
        Describe the new feature you'd like to see.

  - type: textarea
    id: problem
    attributes:
      label: Problem Statement
      description: What problem does this solve?
      placeholder: As a [user], I need [capability] so that [benefit]
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How should this work?
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: What other approaches did you consider?

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (blocking other work)
        - P2 - Medium (important enhancement)
        - P3 - Low (nice to have)
        - P4 - Nice-to-have (future consideration)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```

### Enhancement Template

**File:** `.github/ISSUE_TEMPLATE/enhancement.yml`

```yaml
name: Enhancement
description: Improve existing functionality
labels: ["work-type:enhancement", "priority:p2"]
body:
  - type: markdown
    attributes:
      value: |
        ## Enhancement
        Describe how you'd like to improve existing functionality.

  - type: textarea
    id: current
    attributes:
      label: Current Behaviour
      description: How does it work now?
    validations:
      required: true

  - type: textarea
    id: proposed
    attributes:
      label: Proposed Improvement
      description: How should it work?
    validations:
      required: true

  - type: textarea
    id: benefit
    attributes:
      label: Benefit
      description: Why is this improvement valuable?
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (significant improvement)
        - P2 - Medium (moderate improvement)
        - P3 - Low (minor improvement)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Documentation
        - Other
    validations:
      required: true
```

### Tech Debt Template

**File:** `.github/ISSUE_TEMPLATE/tech-debt.yml`

```yaml
name: Technical Debt
description: Address technical debt or code quality
labels: ["work-type:tech-debt", "priority:p3"]
body:
  - type: markdown
    attributes:
      value: |
        ## Technical Debt
        Describe the technical debt that needs addressing.

  - type: textarea
    id: issue
    attributes:
      label: Technical Debt Description
      description: What is the technical debt?
      placeholder: Describe the code quality issue, outdated pattern, or architectural concern
    validations:
      required: true

  - type: textarea
    id: impact
    attributes:
      label: Impact
      description: Why does this matter?
      placeholder: How does this affect maintainability, performance, or development?
    validations:
      required: true

  - type: textarea
    id: approach
    attributes:
      label: Proposed Approach
      description: How should this be addressed?

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P1 - High (causing active problems)
        - P2 - Medium (should address soon)
        - P3 - Low (address when convenient)
    validations:
      required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      options:
        - API
        - UI
        - Database
        - Auth
        - Infrastructure
        - Other
    validations:
      required: true
```

## Azure DevOps Work Item Templates

Azure DevOps uses Work Item Type definitions (XML or Process Template).

### Custom Work Item Types

**Bug:**

- Fields: Title, Description, Steps to Reproduce, Expected Result, Actual Result
- Required tags: Component, Priority
- Default priority: P2

**User Story (for new-feature):**

- Fields: Title, Description, Acceptance Criteria
- Required tags: Component, Priority
- Default priority: P3

**Task (for enhancement, chore):**

- Fields: Title, Description
- Required tags: Component, Work Type, Priority
- Default priority: P2

**Technical Debt:**

- Fields: Title, Description, Impact, Proposed Solution
- Required tags: Component, Priority
- Default priority: P3

## Jira Issue Types

Jira uses Issue Type Schemes to define templates.

### Configure Issue Types

**Bug:**

- Fields: Summary, Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour
- Required: Component, Priority
- Default priority: Medium

**Story (for new-feature):**

- Fields: Summary, Description, Acceptance Criteria
- Required: Component, Priority
- Default priority: Low

**Task (for enhancement, chore, infrastructure):**

- Fields: Summary, Description
- Required: Component, Work Type Label, Priority
- Default priority: Medium

**Technical Debt:**

- Fields: Summary, Description, Impact, Remediation Plan
- Required: Component, Priority
- Default priority: Low

## Template Customisation

These templates are **strong recommendations**. Customise based on your needs:

1. Copy relevant template for your platform
2. Adjust component options to match your repository
3. Modify fields based on your workflow
4. Ensure work-type and priority tags/fields are included
5. Document customisations in your repository

## Implementation Steps

**For GitHub:**

1. Create `.github/ISSUE_TEMPLATE/` directory
2. Add `.yml` template files for each work type
3. Configure `config.yml` to customise issue creation experience

**For Azure DevOps:**

1. Access Organisation Settings → Process
2. Create custom process or customise existing
3. Add/modify work item types
4. Configure fields and rules

**For Jira:**

1. Access Project Settings → Issue Types
2. Create custom issue types or use defaults
3. Configure fields for each type
4. Set up issue type schemes
