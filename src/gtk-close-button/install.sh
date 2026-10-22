#!/bin/bash
# Install the red close-button CSS as the user GTK 3/4 stylesheets.
# Backs up any existing gtk.css that differs.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$HOME/.gnome-ext-backups"
for v in 3 4; do
    dst="$CFG/gtk-$v.0/gtk.css"
    mkdir -p "$CFG/gtk-$v.0"
    if [ -f "$dst" ] && ! cmp -s "$DIR/gtk$v.css" "$dst"; then
        mkdir -p "$BACKUP_DIR"
        cp "$dst" "$BACKUP_DIR/gtk-$v.0-gtk.css.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$DIR/gtk$v.css" "$dst"
done
