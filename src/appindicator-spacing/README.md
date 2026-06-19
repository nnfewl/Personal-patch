# AppIndicator adjustable spacing

User-local customization of **AppIndicator and KStatusNotifierItem Support** for
GNOME Shell 50. It adds a live **Horizontal Padding** control to Compact Mode.

- Compact Mode disabled: use the active GNOME Shell theme's spacing.
- Compact Mode enabled: use the configured `0–24px` padding on each side of
  every AppIndicator/KStatusNotifierItem or legacy tray icon.
- Default compact padding: `10px`, matching the original extension behavior.

## Install

```sh
bash install.sh
```

Log out and back in, then enable the extension if necessary:

```sh
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
```

Open the extension preferences and enable **Compact Mode**. The **Horizontal
Padding** control directly below it applies changes immediately.

The system copy in `/usr/share/gnome-shell/extensions/` is not modified.
