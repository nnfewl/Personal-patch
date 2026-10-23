#!/bin/bash
# Remove the .desktop overrides written by apply.sh (only files carrying our marker).
set -euo pipefail

DST="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
MARK='X-Personal-Patch=qt-xwayland-frames'

for f in "$DST"/*.desktop; do
    [ -f "$f" ] && grep -qx "$MARK" "$f" || continue
    rm "$f"
    echo "$(basename "$f"): override removed"
done

for f in "${XDG_DATA_HOME:-$HOME/.local/share}"/dbus-1/services/*.service; do
    [ -f "$f" ] && grep -qx "# $MARK" "$f" || continue
    rm "$f"
    echo "$(basename "$f"): D-Bus override removed"
done

update-desktop-database "$DST" 2>/dev/null || true
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig 2>/dev/null || true
echo "Done. Quit the apps fully and relaunch them."
