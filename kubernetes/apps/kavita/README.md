# Kavita

Reading server (ebooks / comics / manga) with Nextcloud as library source via WebDAV (rclone sidecar).

## Architecture

- **kavita** container : reading server, reads `/media`, config on PVC `/kavita/config`
- **rclone** container : mounts Nextcloud WebDAV (`Kavita/` folder) at `/media` via FUSE
- Volume `media` : `emptyDir` with `Bidirectional`/`HostToContainer` mount propagation

## Usage

- Create a `Kavita/` folder in Nextcloud, drop books/series inside.
- In Kavita UI, add a library pointing to `/media`.
- Reading progress is stored in Kavita config (PVC), synced across web + mobile (OPDS).
