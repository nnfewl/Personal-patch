# Personal-patch

Personal icon patcher for Linux icon themes. Replaces app icons, folder icons, tray icons, and mimetypes with custom or alternative-theme SVGs across Papirus, Tela-grey-dark, and other themes.

## Scripts

| Script | Description |
|--------|-------------|
| `app.sh` | Patches Papirus app icons (Slack, Telegram, VirtualBox, Chrome, Firefox, Spotify, etc.) |
| `tela-app.sh` | Same as `app.sh` but targets Tela-grey-dark theme |
| `tray.sh` | Patches system tray icons for Slack, Telegram, Dropbox, KeePassXC, Tailscale, MEGASync |
| `magic.sh` | Replaces Papirus folder/places icons with Qogir equivalents, patches mimetypes |
| `tray-padding.sh` | Reduces horizontal padding on GNOME Shell tray icons (Clipboard Indicator, Rectangle) |

## Tray icon patching (`tray.sh`)

Patches tray icons across Papirus-Dark, Tela-grey, and Tela-grey-dark themes:

- **Slack** - Custom Numix-style indicators (normal, unread, highlight) at 16/22/24px
- **Telegram** - Custom tray icons for both old panel names and new 6.x+ symbolic names (`org.telegram.desktop-*-symbolic`)
- **Dropbox** - Converts custom Papirus-based SVGs to PNGs, replaces bundled icons in `/opt/dropbox/` and `~/.dropbox-dist/`
- **KeePassXC** - Replaces tray icons with macOS-style design (circle with key/lock)
- **Tailscale** - Custom systray SVGs via patched `tailscale-systray` binary (see below)
- **MEGASync** - Papirus-style tray icons for Tela-grey/Tela-grey-dark

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

## Tray icon padding (`tray-padding.sh`)

Reduces the horizontal padding (`-natural-hpadding`) on GNOME Shell panel buttons for extensions that have oversized tray icons. Patches `extension.js` directly via Python for safe multi-line insertion.

Targets:
- **Clipboard Indicator** (`clipboard-indicator@tudmotu.com`) — system-installed, requires sudo
- **Rectangle** (`rectangle@acristoffers.me`) — user-installed

Backups are saved to `~/.gnome-ext-backups/` before patching. Edit the `PADDING` variable at the top to adjust (default: `6px`, GNOME default: `12px`).

```shell
bash tray-padding.sh    # requires sudo for Clipboard Indicator
```

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

GNOME Shell top panel with patched monochrome tray icons on a dark background. The indicator system trays from left to right are: Telegram (paper plane), Megasync (circled M), Portmaster (shield with green status dot), Dropbox (open box), Tailscale (3x3 dot grid), Clipboard Indicator (grid of squares), and Rectangle (overlapping windows). All icons follow a consistent monochrome style matching the Papirus/Tela-grey-dark themes, with reduced horizontal padding via `tray-padding.sh`.

![system-tray new](screenshot/system-tray-new.png)

## Acknowledgments

* [Papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
* [Qogir-icon-theme](https://github.com/vinceliuice/Qogir-icon-theme)
* [Tela-icon-theme](https://github.com/vinceliuice/Tela-icon-theme)
