#!/bin/sh

# Install razercontrol tray icon (symbolic) across themes

src='src/razer-tray/com.github.encomjp.razercontrol-symbolic.svg'
icon='com.github.encomjp.razercontrol-symbolic.svg'

[ -f "$src" ] || { echo "missing source: $src"; exit 1; }

for theme in /usr/share/icons/Papirus-Dark /usr/share/icons/Tela-grey /usr/share/icons/Tela-grey-dark /usr/share/icons/hicolor
do
	dir="$theme/symbolic/apps"
	[ -d "$dir" ] || continue
	sudo rm -f "$dir/$icon"
	sudo cp "$src" "$dir/$icon"
	sudo chmod 644 "$dir/$icon"
done

sudo gtk-update-icon-cache -f /usr/share/icons/Papirus-Dark 2>/dev/null
sudo gtk-update-icon-cache -f /usr/share/icons/Tela-grey 2>/dev/null
sudo gtk-update-icon-cache -f /usr/share/icons/Tela-grey-dark 2>/dev/null
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null

echo "Done!"
