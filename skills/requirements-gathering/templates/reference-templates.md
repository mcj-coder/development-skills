# Reference Templates

> Reference material for the [`requirements-gathering`](../SKILL.md) skill.


GitHub issue templates and automation scripts for quick repository setup:

| Template                                                                    | Purpose                              |
| --------------------------------------------------------------------------- | ------------------------------------ |
| [github-feature-issue.md](templates/github-feature-issue.md.template)       | Feature request with structured form |
| [github-bug-issue.md](templates/github-bug-issue.md.template)               | Bug report with reproduction steps   |
| [github-epic-issue.md](templates/github-epic-issue.md.template)             | Epic with child ticket tracking      |
| [validate-issue.sh](templates/validate-issue.sh.template)                   | Validate issue has required sections |
| [install-issue-templates.sh](templates/install-issue-templates.sh.template) | Install templates in repository      |

### Quick Setup

```bash
# Install issue templates in your repository
./install-issue-templates.sh /path/to/repo

# Validate an issue has required sections
./validate-issue.sh 123
```

### Template Sections

All issue templates follow the structured format:

- **Goal**: One sentence describing the outcome
- **Requirements/Steps**: Numbered list of deliverables or reproduction steps
- **Acceptance Criteria**: Testable checkboxes
- **Context**: Background and constraints
