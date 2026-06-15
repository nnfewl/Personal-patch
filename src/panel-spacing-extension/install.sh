#!/bin/bash
set -e

UUID="panel-spacing@personal-patch"
DEST="$HOME/.local/share/gnome-shell/extensions/$UUID"

mkdir -p "$DEST"
cp extension.js metadata.json stylesheet.css "$DEST/"

gnome-extensions enable "$UUID" 2>/dev/null || echo "Enable failed — log out and back in, then run: gnome-extensions enable $UUID"
echo "Installed: $UUID"
