# CLI Commands Quick Reference

## GitHub (gh CLI)

| Step          | Action                      | Command                                        |
| ------------- | --------------------------- | ---------------------------------------------- |
| Set state     | Add/update label            | `gh issue edit <id> --add-label "state:impl"`  |
| Add component | Add label                   | `gh issue edit <id> --add-label "skill"`       |
| Plan approval | Comment with plan link      | `gh issue comment <id> --body "Plan: <url>"`   |
| Sub-tasks     | Add task list items         | `gh issue edit <id> --body-file tasks.md`      |
| Evidence      | Comment with links and logs | `gh issue comment <id> --body "Evidence: ..."` |
| Next steps    | Create work item            | `gh issue create --title "..." --body "..."`   |
| PR            | Open PR                     | `gh pr create --title "..." --body "..."`      |
| PR feedback   | Track PR comments           | `gh pr view <id> --comments`                   |

## Azure DevOps (ado CLI)

| Step          | Action                     | Command                                                  |
| ------------- | -------------------------- | -------------------------------------------------------- |
| Set state     | Update state field         | `ado workitems update --id <id> --state "Active"`        |
| Add component | Add tag                    | `ado workitems update --id <id> --tags "skill"`          |
| Plan approval | Add comment with plan link | `ado workitems comment <id> "Plan: <url>"`               |
| Sub-tasks     | Create child work items    | `ado workitems create --type Task --parent <id>`         |
| Evidence      | Add comment with links     | `ado workitems comment <id> "Evidence: ..."`             |
| Next steps    | Create work item           | `ado workitems create --type "User Story" --title "..."` |
| PR            | Open PR                    | `ado repos pr create --title "..." --description "..."`  |
| PR feedback   | Track PR comments          | `ado repos pr show --id <id> --comments`                 |

## Jira (jira CLI)

| Step          | Action                     | Command                                            |
| ------------- | -------------------------- | -------------------------------------------------- |
| Set state     | Transition issue           | `jira issue move <id> "In Progress"`               |
| Add component | Add component or label     | `jira issue edit <id> --component "Skills"`        |
| Plan approval | Add comment with plan link | `jira issue comment <id> "Plan: <url>"`            |
| Sub-tasks     | Create sub-tasks           | `jira issue create --type Subtask --parent <id>`   |
| Evidence      | Add comment with links     | `jira issue comment <id> "Evidence: ..."`          |
| Next steps    | Create issue               | `jira issue create --type Story --summary "..."`   |
| PR            | Open PR                    | (Depends on code hosting: GitHub, Bitbucket, etc.) |
| PR feedback   | Track PR                   | (Use code hosting CLI)                             |
