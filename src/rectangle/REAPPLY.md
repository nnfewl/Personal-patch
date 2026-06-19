# Rectangle post-update edits

Use this runbook after a Rectangle update replaces its user-local
`extension.js`. It reproduces the current customization exactly; it does not
normalize the intentionally different initial and recreated button padding.

## Current target values

| Property | Value |
|---|---:|
| Panel button padding at initial enable | `6px` per side |
| Panel button padding after hiding/showing the icon | `4px` per side |
| Top-bar icon margin | `0px` on all sides |
| Top-bar icon padding | `8px` on all sides |

## 1. Open `extension.js`

```sh
${EDITOR:-nano} ~/.local/share/gnome-shell/extensions/rectangle@acristoffers.me/extension.js
```

## 2. Set initial button padding

In `enable()`, find the first Rectangle button construction and ensure the
padding call immediately follows it:

```js
this.menu = new PanelMenu.Button(0, "Rectangle", false);
this.menu.set_style("-natural-hpadding: 6px;");
this.setupMenu();
```

## 3. Set recreated button padding

In `settingsChanged()`, find the button construction inside:

```js
if (showIcon && !menuVisible) {
```

Ensure that block contains:

```js
this.menu = new PanelMenu.Button(0, "Rectangle", false);
this.menu.set_style("-natural-hpadding: 4px;");
this.setupMenu();
```

## 4. Set top-bar icon margin and padding

In `setupMenu()`, find:

```js
const icon = this.#menuIcon("rectangle");
const hbox = new St.BoxLayout({});
```

Add the style call between those lines:

```js
const icon = this.#menuIcon("rectangle");
icon.set_style("margin: 0; padding: 8px;");
const hbox = new St.BoxLayout({});
```

This changes only the Rectangle icon used in the top bar. It does not change
the tile icons inside the popup menu.

## 5. Verify

```sh
rg -n 'natural-hpadding|margin: 0; padding: 8px' \
  ~/.local/share/gnome-shell/extensions/rectangle@acristoffers.me/extension.js
```

Expected customization occurrences:

- Initial button construction: `6px`.
- Recreated button construction: `4px`.
- Top-bar icon: margin `0` and padding `8px`.

Log out and back in to reload GNOME Shell on Wayland.
