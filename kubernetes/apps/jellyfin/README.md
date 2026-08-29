# Jellyfin

Media server with Nextcloud as media source via WebDAV (rclone sidecar).

## Architecture

- **jellyfin** container : media server, reads `/media`
- **rclone** container : mounts Nextcloud WebDAV at `/media` via FUSE
- Volume `media` : `emptyDir` with `Bidirectional`/`HostToContainer` mount propagation
