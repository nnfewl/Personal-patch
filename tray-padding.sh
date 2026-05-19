#!/bin/bash
set -e

PADDING='-natural-hpadding: 6px;'
BACKUP_DIR="$HOME/.gnome-ext-backups"
mkdir -p "$BACKUP_DIR"

# --- Clipboard Indicator (system-installed, needs sudo) ---
CLIP_EXT="/usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/extension.js"
CLIP_CSS="/usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/stylesheet.css"

sudo cp "$CLIP_EXT" "$BACKUP_DIR/clipboard-indicator-extension.js.bak"
sudo cp "$CLIP_CSS" "$BACKUP_DIR/clipboard-indicator-stylesheet.css.bak"
echo "Backed up: Clipboard Indicator"

# Revert stylesheet.css (remove any added padding lines)
sudo sed -i '/^    padding: 0 [0-9]*px;$/d' "$CLIP_CSS"

# Patch extension.js using Python for safe multi-line insertion
sudo python3 -c "
import sys
path = sys.argv[1]
padding = sys.argv[2]

with open(path, 'r') as f:
    content = f.read()

# Add set_style after super._init (if not already patched)
old = 'super._init(0.0, \"ClipboardIndicator\");'
new = old + '\n        this.set_style(\"' + padding + '\");'
if 'set_style(\"' + padding not in content:
    content = content.replace(old, new)

# Fix blink reset: restore custom style instead of null
content = content.replace('this.set_style(null);', 'this.set_style(\"' + padding + '\");')

with open(path, 'w') as f:
    f.write(content)
" "$CLIP_EXT" "$PADDING"

echo "Patched: Clipboard Indicator"

# --- Rectangle (user-installed, no sudo) ---
RECT_EXT="$HOME/.local/share/gnome-shell/extensions/rectangle@acristoffers.me/extension.js"

cp "$RECT_EXT" "$BACKUP_DIR/rectangle-extension.js.bak"
echo "Backed up: Rectangle"

python3 -c "
import sys
path = sys.argv[1]
padding = sys.argv[2]

with open(path, 'r') as f:
    content = f.read()

old = 'this.menu = new PanelMenu.Button(0, \"Rectangle\", false);'
new = old + '\n            this.menu.set_style(\"' + padding + '\");'

# Only patch if not already patched
if 'menu.set_style(\"' + padding not in content:
    content = content.replace(old, new)

with open(path, 'w') as f:
    f.write(content)
" "$RECT_EXT" "$PADDING"

echo "Patched: Rectangle"
echo "Done. Log out and back in to apply."
