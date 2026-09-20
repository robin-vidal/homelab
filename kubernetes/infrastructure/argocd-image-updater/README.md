# argocd-image-updater

Auto-updates container image tags for selected apps and commits the change back to this repo (git write-back), so Argo CD stays the source of truth even with `selfHeal: true`.

## What it tracks

Configured via annotations on the `apps-auto-image` ApplicationSet (`kubernetes/clusters/vps/apps.yaml`):

| App           | Image                               | Tag      | Strategy |
| ------------- | ----------------------------------- | -------- | -------- |
| neetrack      | `ghcr.io/robin-vidal/neetrack`      | `latest` | `digest` |
| personal-site | `ghcr.io/robin-vidal/personal-site` | `latest` | `digest` |
| job-track     | `ghcr.io/robin-vidal/job-track`     | `edge`   | `digest` |

> All three deploy a mutable rolling tag, so the `digest` strategy pins the tag's digest in each `kustomization.yaml` and bumps it whenever the tag moves. `allow-tags` restricts each to its single tag. Write-back uses the kustomize method, adding an `images:` override to each app's `kustomization.yaml`.

## One-time setup: SSH deploy key

Git write-back pushes commits to `robin-vidal/homelab`, which needs a write credential. Uses a repo-scoped SSH **deploy key** (not a PAT).

1. Generate the key, build the SOPS-encrypted secret, print the public key:

   ```sh
   ssh-keygen -t ed25519 -C "argocd-image-updater" -f /tmp/iu_key -N ""
   kubectl create secret generic argocd-image-updater-ssh -n argocd \
     --from-file=sshPrivateKey=/tmp/iu_key --dry-run=client -o yaml \
     > kubernetes/infrastructure/argocd-image-updater/secrets/ssh.enc.yaml
   sops -e -i kubernetes/infrastructure/argocd-image-updater/secrets/ssh.enc.yaml
   cat /tmp/iu_key.pub    # add this on GitHub
   rm /tmp/iu_key /tmp/iu_key.pub
   ```

2. GitHub repo → **Settings → Deploy keys → Add deploy key** → paste the public key → **check "Allow write access"**.

3. Commit `secrets/ssh.enc.yaml`, then merge.

Registry reads are anonymous (public GHCR), so no pull secret is required. Host-key verification uses `argocd-ssh-known-hosts-cm` (from the argo-cd chart), mounted into image-updater automatically.
