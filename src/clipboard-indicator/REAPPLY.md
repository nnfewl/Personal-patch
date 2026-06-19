# Clipboard Indicator post-update edits

Use this runbook after an update replaces the installed Clipboard Indicator
files. It reproduces the current customization exactly; it does not normalize
the intentionally different startup and blink-reset padding values.

## Current target values

| Property | Value |
|---|---:|
| Panel button padding at startup | `6px` per side |
| Panel button padding after a blink | `4px` per side |
| Top-bar icon margin | `4px` on all sides |
| Top-bar icon padding | `4px` on all sides |

## 1. Edit `extension.js`

Open the installed file:

```sh
sudoedit /usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/extension.js
```

In `ClipboardIndicator._init()`, find:

```js
super._init(0.0, "ClipboardIndicator");
```

Ensure it is followed by:

```js
this.set_style("-natural-hpadding: 6px;");
```

The result should be:

```js
super._init(0.0, "ClipboardIndicator");
this.set_style("-natural-hpadding: 6px;");
```

In `_blinkIcon()`, find the timeout that restores the normal appearance.
Ensure these three lines are present:

```js
this._blinkAnimationTimeout = null;
this.set_style("-natural-hpadding: 4px;");
this.icon.set_style(null);
```

If the update restored `this.set_style(null);`, replace that line with the
`4px` `set_style()` call above.

## 2. Edit `stylesheet.css`

Open:

```sh
sudoedit /usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/stylesheet.css
```

Find `.clipboard-indicator-hbox .clipboard-indicator-icon` and make its block:

```css
.clipboard-indicator-hbox .clipboard-indicator-icon {
    transition: color 150ms ease-in-out;
    margin: 4px;
    padding: 4px;
}
```

## 3. Verify

```sh
rg -n 'natural-hpadding|margin: 4px|padding: 4px' \
  /usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/extension.js \
  /usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/stylesheet.css
```

Expected customization occurrences:

- `extension.js`: startup `6px` and blink-reset `4px`.
- `stylesheet.css`: icon margin `4px` and icon padding `4px`.

Log out and back in to reload GNOME Shell on Wayland.
