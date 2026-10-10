#!/usr/bin/env bash
set -euo pipefail

UPDATE=false
case "${1:-}" in
    '') ;;
    --update) UPDATE=true ;;
    -h|--help) echo "Usage: bash $0 [--update]"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
esac
[[ $# -le 1 ]] || { echo "Too many arguments." >&2; exit 1; }
[[ $EUID -ne 0 ]] || { echo "Install Codex as your normal user." >&2; exit 1; }

export PATH="$HOME/.local/bin:$PATH"
CODEX_PATH=$(command -v codex || true)
# Windows npm launchers can leak into WSL's PATH without an .exe suffix.
case "$CODEX_PATH" in
    /mnt/[a-zA-Z]/*|*.exe|*.cmd|*.ps1)
        echo "Windows Codex found on PATH; installing a Linux copy for WSL."
        CODEX_PATH=
        ;;
esac
if [[ -n "$CODEX_PATH" ]]; then
    if [[ "$UPDATE" == false ]]; then
        echo "Codex already available: $CODEX_PATH. Use --update for an explicit update."
        exit 0
    fi
    # Do not overlay an npm/system installation with the standalone installer.
    if [[ "$CODEX_PATH" != "$HOME/.local/bin/codex" ]]; then
        echo "Update Codex using its existing installer: $CODEX_PATH" >&2
        exit 1
    fi
    case $(readlink -f "$CODEX_PATH") in
        "${CODEX_HOME:-$HOME/.codex}/packages/standalone/"*) ;;
        *) echo "This is not a standalone-managed Codex install. Use its existing installer to update it." >&2; exit 1 ;;
    esac
fi

INSTALL_TMP=$(mktemp -d)
trap 'rm -rf -- "$INSTALL_TMP"' EXIT
curl -fsSL https://chatgpt.com/codex/install.sh -o "$INSTALL_TMP/install-codex.sh"
CODEX_INSTALL_DIR="$HOME/.local/bin" CODEX_NON_INTERACTIVE=1 sh "$INSTALL_TMP/install-codex.sh"
codex --version
