#!/bin/bash
# Launch selected Qt apps through XWayland so GNOME (mutter-x11-frames, GTK 4)
# draws their title bar and they pick up ~/.config/gtk-4.0/gtk.css
# (see src/gtk-close-button). Writes user-level .desktop overrides only.
set -euo pipefail

APPS=(
    org.wireshark.Wireshark.desktop
    org.telegram.desktop.desktop
    virtualbox.desktop
    org.keepassxc.KeePassXC.desktop
)
SRC=/usr/share/applications
DST="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
DBUS_SRC=/usr/share/dbus-1/services
DBUS_DST="${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"
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
    # DBusActivatable apps (Telegram) are started via their D-Bus service, which
    # ignores Exec=, so turn that off to make GNOME use our Exec line.
    sed -E -e 's/^Exec=(env QT_QPA_PLATFORM=xcb )?/Exec=env QT_QPA_PLATFORM=xcb /' \
        -e 's/^DBusActivatable=true$/DBusActivatable=false/' "$SRC/$app" \
        | sed "0,/^\[Desktop Entry\]$/s//[Desktop Entry]\n$MARK/" > "$DST/$app"
    echo "$app: override written"

    # Anything can still start a DBusActivatable app through its D-Bus service
    # (Telegram is woken this way), so override the service's Exec too.
    svc="${app%.desktop}.service"
    if [ -f "$DBUS_SRC/$svc" ]; then
        mkdir -p "$DBUS_DST"
        { echo "# $MARK"
          sed -E 's|^Exec=(/usr/bin/env QT_QPA_PLATFORM=xcb )?|Exec=/usr/bin/env QT_QPA_PLATFORM=xcb |' "$DBUS_SRC/$svc"
        } > "$DBUS_DST/$svc"
        echo "$svc: D-Bus override written"
    fi
done

update-desktop-database "$DST" 2>/dev/null || true
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig 2>/dev/null || true
echo "Done. Quit the apps fully and relaunch them."
