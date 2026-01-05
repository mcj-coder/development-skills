# Platform Resolution

Infer platform from the taskboard URL (from README.md Work Items section):

| Platform     | Domain patterns                     | CLI    |
| ------------ | ----------------------------------- | ------ |
| GitHub       | `github.com`                        | `gh`   |
| Azure DevOps | `dev.azure.com`, `visualstudio.com` | `ado`  |
| Jira         | `atlassian.net`, `jira.`            | `jira` |

If the URL is not recognised, stop and ask the user to confirm the platform.
