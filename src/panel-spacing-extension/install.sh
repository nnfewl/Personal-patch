#!/bin/bash
set -e

UUID="panel-spacing@personal-patch"
DEST="$HOME/.local/share/gnome-shell/extensions/$UUID"

mkdir -p "$DEST/schemas"
cp extension.js prefs.js metadata.json "$DEST/"
cp schemas/org.gnome.shell.extensions.panel-spacing.gschema.xml "$DEST/schemas/"
glib-compile-schemas "$DEST/schemas/"

gnome-extensions enable "$UUID" 2>/dev/null || echo "Log out and back in, then run: gnome-extensions enable $UUID"
echo "Installed: $UUID"
