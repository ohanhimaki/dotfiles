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
[[ "$ID" == fedora ]] || { echo "This script requires Fedora." >&2; exit 1; }
command -v dnf >/dev/null 2>&1 || { echo "dnf is required." >&2; exit 1; }

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
sudo dnf install -y flatpak fontconfig dconf playerctl brightnessctl fastfetch
if ! command -v wezterm >/dev/null 2>&1; then
    # WezTerm's documented Fedora repository provides nightly packages.
    sudo dnf copr enable -y wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm
fi
install_desktop_apps
install_desktop_fonts
restore_desktop
printf 'Desktop setup complete (%s). Open a new terminal.\n' "$PROFILE"
