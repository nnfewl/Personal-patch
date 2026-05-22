#!/bin/bash
set -euo pipefail

DRY_RUN=0
VERBOSE=0
FILTER=""
INSTALLED=0
SKIPPED=0
ERRORS=0

while getopts "nvf:" opt; do
    case $opt in
        n) DRY_RUN=1; VERBOSE=1 ;;
        v) VERBOSE=1 ;;
        f) FILTER="$OPTARG" ;;
        *) echo "Usage: $0 [-n] [-v] [-f app]" >&2; exit 1 ;;
    esac
done

log()  { [ "$VERBOSE" -eq 1 ] && echo "  $*" || true; }
info() { echo ":: $*"; }

should_run() { [ -z "$FILTER" ] || [ "$FILTER" = "$1" ]; }

theme_size_dir() {
    local theme="$1" size="$2" category="$3"
    if [ "$size" = "symbolic" ]; then
        echo "$theme/symbolic/$category"
    elif [[ "$theme" == *Papirus* ]]; then
        echo "$theme/${size}x${size}/$category"
    else
        echo "$theme/${size}/$category"
    fi
}

install_icon() {
    local src="$1" dst="$2"
    if [ ! -f "$src" ]; then
        echo "WARNING: source missing: $src" >&2
        ERRORS=$((ERRORS + 1))
        return 1
    fi
    log "$src -> $dst"
    if [ "$DRY_RUN" -eq 0 ]; then
        sudo rm -f "$dst"
        sudo cp "$src" "$dst"
        sudo chmod 644 "$dst"
    fi
    INSTALLED=$((INSTALLED + 1))
}

install_icons() {
    local themes="$1" sizes="$2" category="$3" mappings="$4"
    local theme size dir src_pattern target src
    for theme in $themes; do
        for size in $sizes; do
            dir=$(theme_size_dir "$theme" "$size" "$category")
            if [ ! -d "$dir" ]; then
                log "skip (missing): $dir"
                SKIPPED=$((SKIPPED + 1))
                continue
            fi
            while IFS='|' read -r src_pattern target; do
                [ -z "$src_pattern" ] && continue
                src="${src_pattern//\{size\}/$size}"
                install_icon "$src" "$dir/$target" || true
            done <<< "$mappings"
        done
    done
}

PAPIRUS_DARK="/usr/share/icons/Papirus-Dark"
PAPIRUS="/usr/share/icons/Papirus"
PAPIRUS_LIGHT="/usr/share/icons/Papirus-Light"
TELA_GREY="/usr/share/icons/Tela-grey"
TELA_GREY_DARK="/usr/share/icons/Tela-grey-dark"
HICOLOR="/usr/share/icons/hicolor"

if should_run slack; then
    info "Slack"
    install_icons "$PAPIRUS_DARK $TELA_GREY" "16 22 24" "panel" \
"src/slack-tray/Numix/slack{size}.svg|slack-indicator.svg
src/slack-tray/Numix/slack{size}r.svg|slack-indicator-unread.svg
src/slack-tray/Numix/slack{size}h.svg|slack-indicator-highlight.svg"
fi

if should_run telegram; then
    info "Telegram (old names)"
    install_icons "$PAPIRUS_DARK $TELA_GREY" "16 22 24" "panel" \
"src/telegram-tray/test4/{size}.svg|telegram-mute-panel.svg
src/telegram-tray/test4/telegram{size}.svg|telegram-panel.svg
src/telegram-tray/test4/attention{size}.svg|telegram-attention-panel.svg"

    info "Telegram (symbolic)"
    install_icons "$TELA_GREY_DARK $HICOLOR" "symbolic" "apps" \
"src/telegram-tray/test4/telegram22.svg|org.telegram.desktop-symbolic.svg
src/telegram-tray/test4/22.svg|org.telegram.desktop-mute-symbolic.svg
src/telegram-tray/test4/attention22.svg|org.telegram.desktop-attention-symbolic.svg"
fi

if should_run dropbox; then
    info "Dropbox"
    userhome=$(eval echo ~"${SUDO_USER:-$USER}")
    for dropbox_dir in \
        /opt/dropbox/images/hicolor/16x16/status \
        "$userhome"/.dropbox-dist/dropbox-lnx.*/images/hicolor/16x16/status
    do
        [ -d "$dropbox_dir" ] || { SKIPPED=$((SKIPPED + 1)); continue; }
        for icon in blank busy busy2 idle logo x; do
            src="src/dropbox-tray/Custom/dropboxstatus-${icon}.svg"
            dst="$dropbox_dir/dropboxstatus-${icon}.png"
            if [ ! -f "$src" ]; then
                echo "WARNING: source missing: $src" >&2
                ERRORS=$((ERRORS + 1))
                continue
            fi
            log "convert $src -> $dst"
            if [ "$DRY_RUN" -eq 0 ]; then
                if rsvg-convert -w 20 -h 20 "$src" -o "/tmp/dropboxstatus-${icon}.png" 2>/dev/null; then
                    sudo cp "/tmp/dropboxstatus-${icon}.png" "$dst"
                    rm -f "/tmp/dropboxstatus-${icon}.png"
                    INSTALLED=$((INSTALLED + 1))
                else
                    echo "WARNING: rsvg-convert failed for $icon" >&2
                    ERRORS=$((ERRORS + 1))
                fi
            else
                INSTALLED=$((INSTALLED + 1))
            fi
        done
    done
fi

if should_run keepassxc; then
    info "KeePassXC"
    install_icons "$PAPIRUS $PAPIRUS_LIGHT $TELA_GREY $TELA_GREY_DARK" \
        "16 22 24" "panel" \
"src/keepassxc-tray/keepassxc-monochrome-light.svg|keepassxc-monochrome-light.svg
src/keepassxc-tray/keepassxc-monochrome-light-locked.svg|keepassxc-monochrome-light-locked.svg"
fi

if should_run tailscale; then
    info "Tailscale"
    install_icons "$PAPIRUS_DARK $TELA_GREY $TELA_GREY_DARK" \
        "16 22 24" "panel" \
"src/tailscale-tray/connected.svg|tailscale-connected.svg
src/tailscale-tray/disconnected.svg|tailscale-disconnected.svg
src/tailscale-tray/exit-node-online.svg|tailscale-exit-node-online.svg
src/tailscale-tray/exit-node-offline.svg|tailscale-exit-node-offline.svg"
fi

if should_run mega; then
    info "MEGASync"
    install_icons "$TELA_GREY $TELA_GREY_DARK" "16 22 24" "panel" \
"src/mega-tray/Papirus/megaalert.svg|megaalert.svg
src/mega-tray/Papirus/megalogging.svg|megalogging.svg
src/mega-tray/Papirus/megapaused.svg|megapaused.svg
src/mega-tray/Papirus/megasynching.svg|megasynching.svg
src/mega-tray/Papirus/megauptodate.svg|megauptodate.svg
src/mega-tray/Papirus/megawarning.svg|megawarning.svg"
fi

if [ "$ERRORS" -gt 0 ]; then
    info "Done with errors: $INSTALLED installed, $SKIPPED skipped, $ERRORS errors"
    exit 1
else
    info "Done: $INSTALLED installed, $SKIPPED skipped"
fi
