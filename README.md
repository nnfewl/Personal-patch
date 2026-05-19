# Personal-patch

Personal icon patcher for Linux icon themes. Replaces app icons, folder icons, tray icons, and mimetypes with custom or alternative-theme SVGs across Papirus, Tela-grey-dark, and other themes.

## Scripts

| Script | Description |
|--------|-------------|
| `app.sh` | Patches Papirus app icons (Slack, Telegram, VirtualBox, Chrome, Firefox, Spotify, etc.) |
| `tela-app.sh` | Same as `app.sh` but targets Tela-grey-dark theme |
| `tray.sh` | Patches system tray icons for Slack, Telegram, Dropbox, KeePassXC |
| `magic.sh` | Replaces Papirus folder/places icons with Qogir equivalents, patches mimetypes |

## Tray icon patching (`tray.sh`)

Patches tray icons across Papirus-Dark, Tela-grey, and Tela-grey-dark themes:

- **Slack** - Custom Numix-style indicators (normal, unread, highlight) at 16/22/24px
- **Telegram** - Custom tray icons for both old panel names and new 6.x+ symbolic names (`org.telegram.desktop-*-symbolic`)
- **Dropbox** - Converts custom Papirus-based SVGs to PNGs, replaces bundled icons in `/opt/dropbox/` and `~/.dropbox-dist/`
- **KeePassXC** - Replaces tray icons with macOS-style design (circle with key/lock)
- **Tailscale** - Custom systray SVGs via patched `tailscale-systray` binary (see below)

```shell
sudo bash tray.sh
```

## Tailscale systray

Custom tailscale-systray build that uses theme-native SVG icons instead of embedded procedurally-generated PNGs. Source modifications in `src/tailscale-custom/` and `src/systray-custom/`.

Icons in `src/tailscale-tray/`:
- `connected.svg` - 3x3 dot grid with T-shape active pattern
- `disconnected.svg` - All dots inactive
- `exit-node-online.svg` - Connected pattern with arrow overlay
- `exit-node-offline.svg` - Connected pattern with red X

## Telegram tray icons

Multiple design variants in `src/telegram-tray/` (test1-test4, origin, old-papirus, backup):

```shell
cd src/telegram-tray/test4
bash apply.sh
```

## Prerequisites

Clone the repo:

```shell
git clone https://github.com/sparkyvxcx/Personal-patch.git
```

For folder/mimetype patching (`magic.sh`), clone Qogir into `themes/`:

```shell
mkdir themes && cd themes
git clone https://github.com/vinceliuice/Qogir-icon-theme.git
```

## Usage

```shell
bash app.sh          # Patch app icons (Papirus)
bash tela-app.sh     # Patch app icons (Tela-grey-dark)
sudo bash tray.sh    # Patch tray icons (all themes)
bash magic.sh        # Patch folders/mimetypes (requires Qogir)
```

## Preview

- OS: Arch Linux
- DE: GNOME
- Themes: Papirus, Tela-grey-dark

#### Dash to Dock

![Dash to Dock before](screenshot/dod-before.png)
![Dash to Dock after](screenshot/dod-after.png)

#### Nautilus

![Nautilus before](screenshot/nautilus-before.png)
![Nautilus after](screenshot/nautilus-after.png)

#### System tray

![system-tray after](screenshot/system-tray.png)

## Acknowledgments

* [Papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
* [Qogir-icon-theme](https://github.com/vinceliuice/Qogir-icon-theme)
* [Tela-icon-theme](https://github.com/vinceliuice/Tela-icon-theme)
