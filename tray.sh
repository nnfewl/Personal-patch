#!/bin/sh

# Swap some application trays

tela='/usr/share/icons/Tela-grey'
papirus='/usr/share/icons/Papirus-Dark'

## Slack - Papirus-Dark
for i in 16 22 24
do
	sudo cp src/slack-tray/Numix/slack${i}.svg $papirus/${i}x${i}/panel/slack-indicator.svg
	sudo cp src/slack-tray/Numix/slack${i}r.svg $papirus/${i}x${i}/panel/slack-indicator-unread.svg
	sudo rm -f $papirus/${i}x${i}/panel/slack-indicator-highlight.svg
	sudo cp src/slack-tray/Numix/slack${i}h.svg $papirus/${i}x${i}/panel/slack-indicator-highlight.svg
done

## Slack - Tela-grey (Tela-grey-dark panel symlinks here)
for i in 16 22 24
do
	sudo cp src/slack-tray/Numix/slack${i}.svg $tela/${i}/panel/slack-indicator.svg
	sudo cp src/slack-tray/Numix/slack${i}r.svg $tela/${i}/panel/slack-indicator-unread.svg
	sudo rm -f $tela/${i}/panel/slack-indicator-highlight.svg
	sudo cp src/slack-tray/Numix/slack${i}h.svg $tela/${i}/panel/slack-indicator-highlight.svg
done

## Telegram (test4) - Papirus-Dark (old icon names)
for i in 16 22 24
do
	sudo cp src/telegram-tray/test4/${i}.svg $papirus/${i}x${i}/panel/telegram-mute-panel.svg
	sudo cp src/telegram-tray/test4/telegram${i}.svg $papirus/${i}x${i}/panel/telegram-panel.svg
	sudo cp src/telegram-tray/test4/attention${i}.svg $papirus/${i}x${i}/panel/telegram-attention-panel.svg
done

## Telegram (test4) - Tela-grey (old icon names)
for i in 16 22 24
do
	sudo cp src/telegram-tray/test4/${i}.svg $tela/${i}/panel/telegram-mute-panel.svg
	sudo cp src/telegram-tray/test4/telegram${i}.svg $tela/${i}/panel/telegram-panel.svg
	sudo cp src/telegram-tray/test4/attention${i}.svg $tela/${i}/panel/telegram-attention-panel.svg
done

## Telegram (test4) - new symbolic icon names (telegram-desktop 6.x+)
sudo cp src/telegram-tray/test4/telegram22.svg /usr/share/icons/Tela-grey-dark/symbolic/apps/org.telegram.desktop-symbolic.svg
sudo cp src/telegram-tray/test4/22.svg /usr/share/icons/Tela-grey-dark/symbolic/apps/org.telegram.desktop-mute-symbolic.svg
sudo cp src/telegram-tray/test4/attention22.svg /usr/share/icons/Tela-grey-dark/symbolic/apps/org.telegram.desktop-attention-symbolic.svg

sudo cp src/telegram-tray/test4/telegram22.svg /usr/share/icons/hicolor/symbolic/apps/org.telegram.desktop-symbolic.svg
sudo cp src/telegram-tray/test4/22.svg /usr/share/icons/hicolor/symbolic/apps/org.telegram.desktop-mute-symbolic.svg
sudo cp src/telegram-tray/test4/attention22.svg /usr/share/icons/hicolor/symbolic/apps/org.telegram.desktop-attention-symbolic.svg

echo "Done!"
