#!/usr/bin/env bash
# Shared Linux desktop tasks, sourced after the common bootstrap.

link_desktop_configs() {
    link_config "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
    link_config "$DOTFILES_DIR/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    link_config "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
    link_config "$DOTFILES_DIR/linux/rofi" "$HOME/.config/rofi"
    link_config "$DOTFILES_DIR/linux/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
    if [[ "$GAMING" == true ]]; then
        link_config "$DOTFILES_DIR/linux/MangoHud/MangoHud.conf" "$HOME/.config/MangoHud/MangoHud.conf"
    fi
}

install_desktop_apps() {
    local app desktop_tmp code_platform chrome_url code_extension steam_runtime mangohud_ref
    # Flatpak applications are installed for the current user on both distros.
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    for app in com.spotify.Client; do
        if ! command -v spotify >/dev/null 2>&1 && ! flatpak info --user "$app" >/dev/null 2>&1 && ! flatpak info --system "$app" >/dev/null 2>&1; then
            flatpak install --user -y flathub "$app"
        fi
    done
    if [[ "$GAMING" == true ]]; then
        for app in com.valvesoftware.Steam com.discordapp.Discord; do
            if ! flatpak info --user "$app" >/dev/null 2>&1 && ! flatpak info --system "$app" >/dev/null 2>&1; then
                flatpak install --user -y flathub "$app"
            fi
        done
        steam_runtime=$(flatpak info --user --show-runtime com.valvesoftware.Steam 2>/dev/null || flatpak info --system --show-runtime com.valvesoftware.Steam)
        mangohud_ref="org.freedesktop.Platform.VulkanLayer.MangoHud//${steam_runtime##*/}"
        if ! flatpak info --user "$mangohud_ref" >/dev/null 2>&1 && ! flatpak info --system "$mangohud_ref" >/dev/null 2>&1; then
            flatpak install --user -y flathub "$mangohud_ref"
        fi
        flatpak override --user --filesystem=xdg-config/MangoHud:ro com.valvesoftware.Steam
    fi

    # Native Code can use local SDKs and shells without Flatpak sandbox boundaries.
    desktop_tmp="$INSTALL_TMP/apps"
    mkdir -p "$desktop_tmp"
    if command -v dnf >/dev/null 2>&1; then
        code_platform=linux-rpm
        chrome_url=https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    else
        code_platform=linux-deb
        chrome_url=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    fi
    case $(uname -m) in
        x86_64) code_platform+=-x64 ;;
        aarch64|arm64) code_platform+=-arm64 ;;
        *) echo "Unsupported desktop architecture." >&2; return 1 ;;
    esac
    if ! command -v code >/dev/null 2>&1; then
        if [[ "$code_platform" == linux-rpm* ]]; then code_extension=rpm; else code_extension=deb; fi
        curl -fSL "https://update.code.visualstudio.com/latest/$code_platform/stable" -o "$desktop_tmp/code.$code_extension"
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y "$desktop_tmp/code.rpm"
        else
            sudo apt-get install -y "$desktop_tmp/code.deb"
        fi
    fi
    if [[ $(uname -m) == x86_64 ]] && ! command -v google-chrome >/dev/null 2>&1; then
        if command -v dnf >/dev/null 2>&1; then
            curl -fSL "$chrome_url" -o "$desktop_tmp/chrome.rpm"
            sudo dnf install -y "$desktop_tmp/chrome.rpm"
        else
            curl -fSL "$chrome_url" -o "$desktop_tmp/chrome.deb"
            sudo apt-get install -y "$desktop_tmp/chrome.deb"
        fi
    fi
    rm -rf -- "$desktop_tmp"
}

install_desktop_fonts() {
    local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerd" font_tmp
    if [[ ! -f "$font_dir/.installed" ]]; then
        font_tmp="$INSTALL_TMP/fonts"
        mkdir -p "$font_tmp"
        curl -fSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$font_tmp/font.zip"
        mkdir -p "$font_dir"
        unzip -qo "$font_tmp/font.zip" -d "$font_dir"
        fc-cache -f
        touch "$font_dir/.installed"
        rm -rf -- "$font_tmp"
    fi
}

restore_desktop() {
    case "$DESKTOP" in
        cinnamon) dconf load /org/cinnamon/ < "$DOTFILES_DIR/linux/cinnamon/cinnamon-settings.dconf" ;;
        gnome) dconf load /org/gnome/ < "$DOTFILES_DIR/linux/gnome/gnome-settings.dconf" ;;
        awesome) link_config "$DOTFILES_DIR/linux/awesome" "$HOME/.config/awesome" ;;
        kde) bash "$DOTFILES_DIR/linux/kde/quick-setup.sh" ;;
        '') ;;
    esac
}
