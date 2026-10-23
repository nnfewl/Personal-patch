#!/bin/bash
# Restore Discord's original core.asar from the backup and remove the launcher override.
set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/discord"
DST="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
BACKUP_DIR="$HOME/.gnome-ext-backups"
MARK='X-Personal-Patch=discord-native-frame'

if pgrep -x Discord >/dev/null; then
    echo "Discord is running. Quit it fully (tray icon > Quit Discord) and rerun." >&2
    exit 1
fi

for asar in "$CFG"/app-*/modules/discord_desktop_core-*/discord_desktop_core/core.asar; do
    [ -f "$asar" ] || continue
    ver=$(echo "$asar" | grep -oE 'app-[0-9.]+')
    backup="$BACKUP_DIR/discord-core-$ver.asar"
    if [ -f "$backup" ]; then
        cp "$backup" "$asar"
        echo "core.asar ($ver): restored"
    fi
done

if [ -f "$DST/discord.desktop" ] && grep -qx "$MARK" "$DST/discord.desktop"; then
    rm "$DST/discord.desktop"
    update-desktop-database "$DST" 2>/dev/null || true
    echo "discord.desktop: override removed"
fi
echo "Done."
