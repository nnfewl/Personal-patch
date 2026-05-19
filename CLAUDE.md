# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal icon patcher for Linux icon themes (primarily Papirus). Replaces specific app icons, folder icons, tray icons, and mimetypes with custom or alternative-theme SVGs. All scripts copy SVG files into system icon directories under `/usr/share/icons/` using `sudo`.

## Scripts

- **`app.sh`** — Patches Papirus app icons (Slack, Telegram, VirtualBox, Chrome, Firefox, Spotify, Foliate, Simplenote, VMware, Emacs, etc.) by copying sized SVGs (16-64px) into `/usr/share/icons/Papirus/{size}x{size}/apps/`
- **`tela-app.sh`** — Same concept but targets the Tela-grey-dark icon theme instead of Papirus
- **`tray.sh`** — Patches system tray panel icons for Slack across Papirus-Dark, Tela-grey-dark, and Tela-grey themes (indicator, unread, highlight variants at 16/22/24px)
- **`magic.sh`** — Replaces Papirus folder/places icons with Qogir-icon-theme equivalents, patches mimetypes, and replaces symbolic icons. Requires cloning Qogir-icon-theme into a `themes/` directory first
- **`tray-padding.sh`** — Reduces `-natural-hpadding` on GNOME Shell panel buttons for Clipboard Indicator and Rectangle extensions. Uses Python for safe patching of `extension.js`. Backs up originals to `~/.gnome-ext-backups/`

## Telegram tray icons

`src/telegram-tray/` contains multiple design variants (test1-test4, origin, old-paprius, backup). Each variant folder has its own `apply.sh` and some have `revert.sh`. Run from within the variant directory:

```shell
cd src/telegram-tray/test4
bash apply.sh    # apply
bash revert.sh   # revert (if available)
```

## Source icon structure

`src/` contains per-app directories (e.g., `src/Chrome/`, `src/Slack/`) with sized SVG files following the naming convention `{appname}{size}.svg` (e.g., `chrome16.svg`, `chrome64.svg`). Tray icons in `src/slack-tray/` are organized by style variant (Numix, Paprius, backup) with state suffixes (`h` = highlight, `r` = unread).

## Key conventions

- All scripts require `sudo` — they write to system icon directories
- Standard icon sizes: 16, 22, 24, 32, 48, 64 (panel/tray icons use only 16, 22, 24)
- Scripts check target directory existence with `[ -d $dir ] || exit 1` before proceeding
- SVG files are the only icon format used
