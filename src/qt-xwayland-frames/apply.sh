#!/bin/bash
# Launch selected Qt apps through XWayland so GNOME (mutter-x11-frames, GTK 4)
# draws their title bar and they pick up ~/.config/gtk-4.0/gtk.css
# (see src/gtk-close-button). Writes user-level .desktop overrides only.
set -euo pipefail

APPS=(
    org.wireshark.Wireshark.desktop
    org.telegram.desktop.desktop
    virtualbox.desktop
)
SRC=/usr/share/applications
DST="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
MARK='X-Personal-Patch=qt-xwayland-frames'
mkdir -p "$DST"

for app in "${APPS[@]}"; do
    if [ ! -f "$SRC/$app" ]; then
        echo "$app: not installed, skipped"
        continue
    fi
    if [ -f "$DST/$app" ] && ! grep -qx "$MARK" "$DST/$app"; then
        echo "$app: user override already exists (not ours), skipped"
        continue
    fi
    sed -E 's/^Exec=(env QT_QPA_PLATFORM=xcb )?/Exec=env QT_QPA_PLATFORM=xcb /' "$SRC/$app" \
        | sed "0,/^\[Desktop Entry\]$/s//[Desktop Entry]\n$MARK/" > "$DST/$app"
    echo "$app: override written"
done

update-desktop-database "$DST" 2>/dev/null || true
echo "Done. Quit the apps fully and relaunch them."
