#!/bin/bash
# Reapply all GNOME Shell customizations after a GNOME/extension reinstall or update.
# Idempotent: safe to run repeatedly. Only asks for sudo if Clipboard Indicator needs patching.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions"
BACKUP_DIR="$HOME/.gnome-ext-backups"
mkdir -p "$BACKUP_DIR"

# Target values (see src/*/REAPPLY.md)
APPINDICATOR_PADDING=14
PANEL_ICON_SPACING=8

# --- 1. AppIndicator fork with adjustable padding (user-local) ---
APPIND_UUID='appindicatorsupport@rgcjonas.gmail.com'
bash "$REPO/src/appindicator-spacing/install.sh" >/dev/null
gnome-extensions enable "$APPIND_UUID" 2>/dev/null || true
gsettings --schemadir "$EXT_HOME/$APPIND_UUID/schemas" \
    set org.gnome.shell.extensions.appindicator compact-mode-enabled true
gsettings --schemadir "$EXT_HOME/$APPIND_UUID/schemas" \
    set org.gnome.shell.extensions.appindicator indicator-padding "$APPINDICATOR_PADDING"
echo "AppIndicator: compact mode, ${APPINDICATOR_PADDING}px padding"

# --- 2. Panel Spacing Tweak (GNOME Quick Settings icon spacing) ---
PANEL_UUID='panel-spacing@personal-patch'
(cd "$REPO/src/panel-spacing-extension" && bash install.sh >/dev/null)
gsettings --schemadir "$EXT_HOME/$PANEL_UUID/schemas" \
    set org.gnome.shell.extensions.panel-spacing icon-spacing "$PANEL_ICON_SPACING"
echo "Panel Spacing: ${PANEL_ICON_SPACING}px"

# --- 3 & 4. Clipboard Indicator + Rectangle source patches ---
# patch <mode> <file> <out>: writes patched copy of <file> to <out>
patch() {
    python3 - "$@" <<'EOF'
import re, sys
mode, src, out = sys.argv[1:4]
s = open(src).read()
Q = r"""['"]"""

def after(pattern, line, s, count=1):
    """Insert `line` (same indent) after each match of `pattern`, unless already there."""
    ms = list(re.finditer(r'^(\s*)(' + pattern + r')\n', s, re.M))
    if len(ms) != count:
        sys.exit(f'{mode}: expected {count} match(es) for {pattern!r}, found {len(ms)}')
    for m, ln in reversed(list(zip(ms, line if isinstance(line, list) else [line]))):
        nxt = s[m.end():].split('\n', 1)[0].strip()
        if nxt.startswith(ln.split('(', 1)[0]):  # same call already follows: replace it
            end = m.end() + len(s[m.end():].split('\n', 1)[0]) + 1
            s = s[:m.end()] + m.group(1) + ln + '\n' + s[end:]
        else:
            s = s[:m.end()] + m.group(1) + ln + '\n' + s[m.end():]
    return s

if mode == 'clip-js':
    s = after(r'super\._init\(0\.0, ' + Q + r'ClipboardIndicator' + Q + r'\);',
              'this.set_style("-natural-hpadding: 6px;");', s)
    s = after(r'this\._blinkAnimationTimeout = null;',
              'this.set_style("-natural-hpadding: 4px;");', s)
    # an untouched upstream blink reset leaves `this.set_style(null);` right after our line
    s = re.sub(r'(this\.set_style\("-natural-hpadding: 4px;"\);\n)\s*this\.set_style\(null\);\n', r'\1', s)
elif mode == 'clip-css':
    s, n = re.subn(r'(\.clipboard-indicator-hbox \.clipboard-indicator-icon \{)[^}]*\}',
                   r'\1\n    transition: color 150ms ease-in-out;\n    margin: 4px;\n    padding: 4px;\n}', s)
    if n != 1:
        sys.exit('clip-css: icon rule not found')
elif mode == 'rect-js':
    s = after(r'this\.menu = new PanelMenu\.Button\(0, ' + Q + r'Rectangle' + Q + r', false\);',
              ['this.menu.set_style("-natural-hpadding: 6px;");',
               'this.menu.set_style("-natural-hpadding: 4px;");'], s, count=2)
    s = after(r'const icon = this\.#menuIcon\(' + Q + r'rectangle' + Q + r'\);',
              'icon.set_style("margin: 0; padding: 8px;");', s)
open(out, 'w').write(s)
EOF
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Clipboard Indicator (system-installed)
CLIP_DIR=/usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
if [ -d "$CLIP_DIR" ]; then
    patch clip-js "$CLIP_DIR/extension.js" "$TMP/clip.js"
    patch clip-css "$CLIP_DIR/stylesheet.css" "$TMP/clip.css"
    if cmp -s "$TMP/clip.js" "$CLIP_DIR/extension.js" && cmp -s "$TMP/clip.css" "$CLIP_DIR/stylesheet.css"; then
        echo "Clipboard Indicator: already patched"
    else
        cp "$CLIP_DIR/extension.js" "$BACKUP_DIR/clipboard-indicator-extension.js.$(date +%Y%m%d%H%M%S)"
        cp "$CLIP_DIR/stylesheet.css" "$BACKUP_DIR/clipboard-indicator-stylesheet.css.$(date +%Y%m%d%H%M%S)"
        sudo install -m 644 "$TMP/clip.js" "$CLIP_DIR/extension.js"
        sudo install -m 644 "$TMP/clip.css" "$CLIP_DIR/stylesheet.css"
        echo "Clipboard Indicator: patched"
    fi
else
    echo "Clipboard Indicator: not installed, skipped"
fi

# Rectangle (user-installed)
RECT_JS="$EXT_HOME/rectangle@acristoffers.me/extension.js"
if [ -f "$RECT_JS" ]; then
    patch rect-js "$RECT_JS" "$TMP/rect.js"
    if cmp -s "$TMP/rect.js" "$RECT_JS"; then
        echo "Rectangle: already patched"
    else
        cp "$RECT_JS" "$BACKUP_DIR/rectangle-extension.js.$(date +%Y%m%d%H%M%S)"
        cp "$TMP/rect.js" "$RECT_JS"
        echo "Rectangle: patched"
    fi
else
    echo "Rectangle: not installed, skipped"
fi

echo "Done. Log out and back in to reload GNOME Shell."
