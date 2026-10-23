#!/bin/bash
# Give the official Discord client a native window frame so GNOME draws its
# title bar (with the GTK 4 close button from src/gtk-close-button):
#   1. repack core.asar with frame:true windows and CSS that hides Discord's
#      own title bar (needs npx for @electron/asar)
#   2. launcher override that runs Discord through XWayland (--ozone-platform=x11)
# Discord updates into a new app-<version> dir, so rerun after each update.
set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/discord"
DST="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
BACKUP_DIR="$HOME/.gnome-ext-backups"
MARK='X-Personal-Patch=discord-native-frame'
TOP_PADDING=8  # px of empty space left where Discord's title bar was

if pgrep -x Discord >/dev/null; then
    echo "Discord is running. Quit it fully (tray icon > Quit Discord) and rerun." >&2
    exit 1
fi

ASAR=$(ls -d "$CFG"/app-*/modules/discord_desktop_core-*/discord_desktop_core/core.asar 2>/dev/null | sort -V | tail -1)
[ -f "$ASAR" ] || { echo "core.asar not found under $CFG" >&2; exit 1; }
ver=$(echo "$ASAR" | grep -oE 'app-[0-9.]+')

ASAR_TOOL=(npx -y @electron/asar@4.3.1)
BACKUP="$BACKUP_DIR/discord-core-$ver.asar"
if [ ! -f "$BACKUP" ]; then
    if ! grep -qa 'transparent:!1,frame:!1,' "$ASAR"; then
        echo "core.asar ($ver) is already modified and has no backup; reinstall Discord first" >&2
        exit 1
    fi
    mkdir -p "$BACKUP_DIR"
    cp "$ASAR" "$BACKUP"
fi

# Always rebuild from the pristine backup, so reruns give the same result.
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
"${ASAR_TOOL[@]}" extract "$BACKUP" "$WORK/core"

python3 - "$WORK/core/bundle.js" "$ver" "$TOP_PADDING" <<'PY'
import json, sys
path, ver, top_padding = sys.argv[1], sys.argv[2], int(sys.argv[3])
# Hide Discord's own title bar (GNOME draws one now) and shrink the grid row
# it occupied to TOP_PADDING. Matched by structure, not by Discord's hashed class suffixes.
CSS = ('div:has(> [class*="trailing_"] > [class*="winButtons_"])'
       '{display:none !important}'
       '[class*="base__"]:has(> [class*="bar_"] > [class*="trailing_"] > [class*="winButtons_"])'
       '{--custom-app-top-bar-height:%dpx !important}' % top_padding)
PATCHES = [
    # (description, old, new, expected occurrences)
    ('main + popout windows frame:true',
     'transparent:!1,frame:!1,', 'transparent:!1,frame:!0,', 2),
    ('inject CSS hiding Discord title bar on every page load',
     'let loadingDragCssPromises=[];',
     'let loadingDragCssPromises=[];mainWindow.webContents.on("dom-ready",()=>{'
     'mainWindow?.webContents.insertCSS(' + json.dumps(CSS) + ').catch(()=>{})});', 1),
]
d = open(path, encoding='utf-8').read()
for desc, old, new, count in PATCHES:
    n = d.count(old)
    if n != count:
        sys.exit(f'core.asar ({ver}): {desc}: expected {count} match(es), found {n}; Discord changed, not patching')
    d = d.replace(old, new)
    print(f'core.asar ({ver}): {desc}')
open(path, 'w', encoding='utf-8').write(d)
PY

"${ASAR_TOOL[@]}" pack "$WORK/core" "$WORK/core.asar"
if cmp -s "$WORK/core.asar" "$ASAR"; then
    echo "core.asar ($ver): already up to date"
else
    cp "$WORK/core.asar" "$ASAR"
    echo "core.asar ($ver): repacked (backup: $BACKUP)"
fi

mkdir -p "$DST"
if [ -f "$DST/discord.desktop" ] && ! grep -qx "$MARK" "$DST/discord.desktop"; then
    echo "discord.desktop: user override already exists (not ours), skipped"
else
    sed -E 's|^Exec=/usr/bin/discord (--ozone-platform=x11 )?|Exec=/usr/bin/discord --ozone-platform=x11 |' \
        /usr/share/applications/discord.desktop \
        | sed "0,/^\[Desktop Entry\]$/s//[Desktop Entry]\n$MARK/" > "$DST/discord.desktop"
    update-desktop-database "$DST" 2>/dev/null || true
    echo "discord.desktop: XWayland override written"
fi
echo "Done. Start Discord from the app menu."
