#!/usr/bin/env bash
# Shared argument parsing and safe config linking; sourced by setup scripts.

parse_setup_args() {
    PROFILE=
    SYMLINKS_ONLY=false
    UPDATE=false
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
            --update) UPDATE=true ;;
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
                echo "Usage: bash $0 (-work | -home) [--symlinks-only | --update]"
                if [[ "${ALLOW_DESKTOP_ARGS:-false}" == true ]]; then
                    echo "Desktop options: --gaming --desktop=cinnamon|gnome|awesome|kde"
                fi
                exit 0
                ;;
            *) echo "Unknown argument: $arg" >&2; return 1 ;;
        esac
    done
    [[ -n "$PROFILE" ]] || { echo "Required profile missing. Usage: bash $0 (-work | -home) [--symlinks-only]" >&2; return 1; }
    [[ "$UPDATE" != true || "$SYMLINKS_ONLY" != true ]] || { echo "--update cannot be combined with --symlinks-only." >&2; return 1; }
}

# Windows launchers on WSL do not satisfy Linux tool dependencies.
has_linux_tool() {
    local tool_path
    tool_path=$(command -v "$1") || return 1
    case "$tool_path" in
        /mnt/[a-zA-Z]/*|*.exe|*.cmd|*.ps1) return 1 ;;
    esac
}

# Move a complete, verified Neovim tree into place; retain the old tree.
install_nvim_tree() {
    local source=$1 target=$2 backup=
    "$source/bin/nvim" --headless -u NONE -i NONE '+lua if not vim.pack then vim.cmd("cquit 1") end' +qa || return 1
    if [[ -e "$target" || -L "$target" ]]; then
        backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
        while [[ -e "$backup" || -L "$backup" ]]; do backup+=.bak; done
        sudo mv -T -- "$target" "$backup" || return 1
        echo "Previous Neovim retained at $backup"
    fi
    if ! sudo cp -aT -- "$source" "$target"; then
        # Keep a failed partial copy too, so rollback never deletes user files.
        if [[ -e "$target" || -L "$target" ]]; then
            sudo mv -T -- "$target" "${target}.failed.$(date +%s%N)" || return 1
        fi
        if [[ -n "$backup" ]]; then sudo mv -T -- "$backup" "$target"; fi
        return 1
    fi
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
