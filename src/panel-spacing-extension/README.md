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

Edit `stylesheet.css` and change the `spacing` value, then reload:

```bash
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell \
  --method org.gnome.Shell.Extensions.DisableExtension panel-spacing@personal-patch
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell \
  --method org.gnome.Shell.Extensions.EnableExtension panel-spacing@personal-patch
```

## Uninstall

```bash
gnome-extensions disable panel-spacing@personal-patch
rm -rf ~/.local/share/gnome-shell/extensions/panel-spacing@personal-patch
```
