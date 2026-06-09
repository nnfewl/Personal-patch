#!/bin/sh

# Patch razer-settings app icon — copy Papirus razercommander into Tela

src='/usr/share/icons/Papirus/'
tela='/usr/share/icons/Tela-grey-dark/'
tela_grey='/usr/share/icons/Tela-grey/'
icon='com.github.encomjp.razercontrol.svg'

[ -d $tela ] || exit 1

# Tela only has apps/ at 16 (symlinks to Tela-grey/16/apps) and scalable
sudo cp ${src}16x16/apps/razercommander.svg ${tela}16/apps/$icon

# scalable symlinks to Tela-grey/scalable — use Papirus 64x64 as source
sudo cp ${src}64x64/apps/razercommander.svg ${tela_grey}scalable/apps/$icon

sudo gtk-update-icon-cache -f $tela

echo "Done!"
