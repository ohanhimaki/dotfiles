#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/scripts/bootstrap-common.sh"
ALLOW_DESKTOP_ARGS=true
parse_setup_args "$@"
if is_wsl; then
    echo "Use bootstrap.sh inside WSL; install desktop apps on Windows." >&2
    exit 1
fi
source /etc/os-release
[[ "$ID" == linuxmint || "$ID" == ubuntu ]] || { echo "This script requires Mint/Ubuntu." >&2; exit 1; }
command -v apt-get >/dev/null 2>&1 || { echo "apt-get is required." >&2; exit 1; }

COMMON_ARGS=("-$PROFILE")
if [[ "$SYMLINKS_ONLY" == true ]]; then COMMON_ARGS+=(--symlinks-only); fi
bash "$DOTFILES_DIR/bootstrap.sh" "${COMMON_ARGS[@]}"
source "$DOTFILES_DIR/linux/desktop-common.sh"
link_desktop_configs
if [[ "$SYMLINKS_ONLY" == true ]]; then
    echo "Desktop configs linked. Installation and desktop restoration skipped."
    exit 0
fi

INSTALL_TMP=$(mktemp -d)
trap 'rm -rf -- "$INSTALL_TMP"' EXIT
sudo apt-get install -y flatpak fontconfig dconf playerctl brightnessctl gpg
if ! command -v wezterm >/dev/null 2>&1; then
    curl -fsSL https://apt.fury.io/wez/gpg.key -o "$INSTALL_TMP/wezterm.key"
    sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg "$INSTALL_TMP/wezterm.key"
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y wezterm
fi
install_desktop_apps
install_desktop_fonts
restore_desktop
printf 'Desktop setup complete (%s). Open a new terminal.\n' "$PROFILE"
