# panel-spacing-extension

GNOME Shell extension that increases spacing between system tray icons (WiFi, volume, battery) in the Quick Settings button.

## Requirements

- GNOME Shell 50+
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension enabled

## Install

```bash
cd src/panel-spacing-extension
bash install.sh
```

If the shell is running on Wayland and can't enable in-session, log out, log back in, then:

```bash
gnome-extensions enable panel-spacing@personal-patch
```

## Tuning

Open **GNOME Extensions** app → Panel Spacing Tweak → Settings. Adjust the **Icon Spacing** spin row (0–48px). Changes apply live without reloading.

Or via CLI:

```bash
gsettings --schemadir ~/.local/share/gnome-shell/extensions/panel-spacing@personal-patch/schemas \
  set org.gnome.shell.extensions.panel-spacing icon-spacing 20
```

## Uninstall

```bash
gnome-extensions disable panel-spacing@personal-patch
rm -rf ~/.local/share/gnome-shell/extensions/panel-spacing@personal-patch
```
