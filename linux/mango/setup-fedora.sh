#!/usr/bin/env bash
set -euo pipefail

profile=''
links_only=false
for arg in "$@"; do
    case "$arg" in
        -home|-work)
            [[ -z "$profile" ]] || { echo 'Anna täsmälleen yksi profiili: -home tai -work.' >&2; exit 2; }
            profile=$arg ;;
        --symlinks-only) links_only=true ;;
        *) echo "Tuntematon argumentti: $arg" >&2; exit 2 ;;
    esac
done
[[ -n "$profile" ]] || { echo 'Käyttö: bash linux/mango/setup-fedora.sh -home|-work [--symlinks-only]' >&2; exit 2; }
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if ! "$links_only"; then
    . /etc/os-release
    [[ "$ID" == fedora ]] || { echo 'Tämä asennus on Fedoralle.' >&2; exit 1; }
    # Repository bootstrap command from the upstream Fedora installation guide.
    if ! rpm -q terra-release >/dev/null 2>&1; then
        sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
    fi
    sudo dnf install -y mangowm waybar fuzzel mako swaybg swaylock swayidle \
        mate-polkit xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
        wl-clipboard brightnessctl playerctl grim slurp
    command -v wezterm >/dev/null || { echo 'Asenna WezTerm ennen asetusten käyttöönottoa.' >&2; exit 1; }
    [[ -x /usr/libexec/polkit-mate-authentication-agent-1 ]] || {
        echo 'Polkit-agentin polku poikkeaa odotetusta; tarkista rpm -ql mate-polkit.' >&2; exit 1;
    }
    mango -c "$source_dir/config.conf" -p
fi

config_root=${XDG_CONFIG_HOME:-$HOME/.config}
backup_suffix="backup-$(date +%Y%m%d-%H%M%S)-$$"
link_config() {
    local src=$1 dest=$2
    mkdir -p -- "$(dirname -- "$dest")"
    if [[ -L "$dest" && "$(readlink -- "$dest")" == "$src" ]]; then
        return
    fi
    if [[ -e "$dest" || -L "$dest" ]]; then
        mv -- "$dest" "$dest.$backup_suffix"
    fi
    ln -s -- "$src" "$dest"
}
for file in config.conf waybar.jsonc waybar.css window-title.py focus-terminal.py; do
    link_config "$source_dir/$file" "$config_root/mango/$file"
done
link_config "$source_dir/mango-portals.conf" "$config_root/xdg-desktop-portal/mango-portals.conf"
echo 'Asetukset linkitetty. Mango-istuntoa voi käyttää vasta pakettiasennuksen jälkeen.'
if ! "$links_only"; then
    rpm -q mangowm waybar fuzzel mako swaylock swayidle
    if ! find /usr/share/wayland-sessions -maxdepth 1 -iname '*mango*.desktop' -print | rg .; then
        echo 'Mango-istuntotiedosto puuttuu; älä kirjaudu ulos ennen sen korjaamista.' >&2
        exit 1
    fi
    echo 'Asennus valmis. Kirjaudu ulos ja valitse kirjautumisruudun rattaasta Mango.'
fi
