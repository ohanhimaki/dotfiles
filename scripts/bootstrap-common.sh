#!/usr/bin/env bash
# Shared argument parsing and safe config linking; sourced by setup scripts.

parse_setup_args() {
    PROFILE=
    SYMLINKS_ONLY=false
    GAMING=false
    DESKTOP=
    for arg in "$@"; do
        case "$arg" in
            -work|-home)
                if [[ -n "$PROFILE" ]]; then
                    echo "Choose exactly one profile: -work or -home." >&2
                    return 1
                fi
                PROFILE=${arg#-}
                ;;
            --symlinks-only) SYMLINKS_ONLY=true ;;
            --gaming)
                [[ "${ALLOW_DESKTOP_ARGS:-false}" == true ]] || { echo "--gaming belongs to a desktop setup script." >&2; return 1; }
                GAMING=true
                ;;
            --desktop=*)
                [[ "${ALLOW_DESKTOP_ARGS:-false}" == true ]] || { echo "--desktop belongs to a desktop setup script." >&2; return 1; }
                DESKTOP=${arg#*=}
                case "$DESKTOP" in
                    cinnamon|gnome|awesome|kde) ;;
                    *) echo "Unknown desktop: $DESKTOP" >&2; return 1 ;;
                esac
                ;;
            -h|--help)
                echo "Usage: bash $0 (-work | -home) [--symlinks-only]"
                if [[ "${ALLOW_DESKTOP_ARGS:-false}" == true ]]; then
                    echo "Desktop options: --gaming --desktop=cinnamon|gnome|awesome|kde"
                fi
                exit 0
                ;;
            *) echo "Unknown argument: $arg" >&2; return 1 ;;
        esac
    done
    [[ -n "$PROFILE" ]] || { echo "Required profile missing. Usage: bash $0 (-work | -home) [--symlinks-only]" >&2; return 1; }
}

link_config() {
    local source=$1 target=$2 backup
    [[ -e "$source" ]] || { echo "Config source missing: $source" >&2; return 1; }
    mkdir -p "$(dirname "$target")"
    if [[ -e "$target" && ! -L "$target" ]]; then
        backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
        while [[ -e "$backup" || -L "$backup" ]]; do backup="${backup}.bak"; done
        echo "Backing up $target to $backup"
        mv -- "$target" "$backup"
    fi
    ln -sfnT -- "$source" "$target"
}

is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ $(uname -r) == *[Mm]icrosoft* ]]
}
