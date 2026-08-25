# argocd-sops

Patches argocd-repo-server to add ksops as a Config Management Plugin sidecar. Enables SOPS-encrypted secrets (age) to be decrypted at sync time.

The age private key must be pre-loaded manually (out-of-band, never in Git):

```bash
kubectl create secret generic argocd-age-key \
  --from-file=keys.txt=$HOME/.config/sops/age/keys.txt \
  -n argocd
```
