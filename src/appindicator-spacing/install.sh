#!/usr/bin/env bash

set -euo pipefail

UUID='appindicatorsupport@rgcjonas.gmail.com'
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DEST="$DATA_HOME/gnome-shell/extensions/$UUID"

mkdir -p "$DEST"
cp -a "$SOURCE_DIR/." "$DEST/"
glib-compile-schemas "$DEST/schemas"

echo "Installed the customized AppIndicator extension in:"
echo "  $DEST"
echo
echo "Log out and back in so GNOME Shell loads the user-local copy."
echo "Then enable it with: gnome-extensions enable $UUID"
