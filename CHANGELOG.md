# Changelog

## 2026-05-18

### KeePassXC
- Add macOS-style tray icons (circle with key/lock design)
- Patch Papirus, Papirus-Light, Tela-grey, and Tela-grey-dark themes

### Tailscale
- Add original tailscale tray SVGs (extracted from binary)
- Custom tailscale-systray build using theme-native SVG icons via `SetIconName` D-Bus property
- Patched `fyne.io/systray` to support `SetIconName` with proper startup timing
- Icons: connected, disconnected, exit-node-online, exit-node-offline

### Dropbox
- Add custom tray icons (lighter `#ffffff` color, larger viewBox) in `src/dropbox-tray/Custom/`
- Convert Papirus SVGs to PNGs and replace bundled Dropbox icons
- Support both `/opt/dropbox/` and `~/.dropbox-dist/` paths
- Fix `$HOME` resolution under `sudo` using `$SUDO_USER`

### Telegram
- Fix tray patching for telegram-desktop 6.x+ symbolic icon names
- Support new `org.telegram.desktop-symbolic`, `-mute-symbolic`, `-attention-symbolic` names
- Install to both Tela-grey-dark and hicolor `symbolic/apps/`

### Slack
- Fix symlink overwrite bug for `slack-indicator-highlight.svg`
- Add Tela-grey theme support (Tela-grey-dark panel symlinks here)
