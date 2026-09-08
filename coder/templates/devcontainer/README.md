# Devcontainer

Kubernetes workspace using [Envbuilder](https://github.com/coder/envbuilder) to build and run a repository's `.devcontainer/devcontainer.json`.

## Parameters

| Name | Description |
|---|---|
| `repo_url` | HTTPS URL of the Git repository to clone |
| `github_token` | GitHub PAT with `repo` scope — injected as `GITHUB_TOKEN` in the workspace |

## Deploy

```bash
coder templates push devcontainer --directory coder/templates/devcontainer/
```
