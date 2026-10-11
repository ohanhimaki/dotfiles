#!/usr/bin/env bash
# Offline behavior checks; all installs use a temporary HOME and mocked commands.
set -euo pipefail
REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TEST_TMP=$(mktemp -d)
trap 'rm -rf -- "$TEST_TMP"' EXIT
export HOME="$TEST_TMP/home" TEST_LOG="$TEST_TMP/log" NVIM_LOG_FILE="$TEST_TMP/nvim.log" REPO
mkdir -p "$HOME"
source "$REPO/scripts/bootstrap-common.sh"

parse_setup_args -home --update
[[ "$PROFILE" == home && "$UPDATE" == true ]]
for args in '' '-home -work' '-home -home' '--symlinks-only' '-home --update --symlinks-only'; do
    if (parse_setup_args $args) >/dev/null 2>&1; then
        echo "Unexpected valid arguments: $args" >&2; exit 1
    fi
done

mkdir -p "$TEST_TMP/source/bin" "$TEST_TMP/target"
printf '#!/bin/sh\nexit 0\n' > "$TEST_TMP/source/bin/nvim"
chmod +x "$TEST_TMP/source/bin/nvim"
echo old > "$TEST_TMP/target/stale"
sudo() { "$@"; }
install_nvim_tree "$TEST_TMP/source" "$TEST_TMP/target"
[[ -x "$TEST_TMP/target/bin/nvim" && ! -e "$TEST_TMP/target/stale" ]]
compgen -G "$TEST_TMP/target.backup.*/stale" >/dev/null
sudo() {
    if [[ "$1" == cp ]]; then mkdir -p "${@: -1}"; return 1; fi
    "$@"
}
if install_nvim_tree "$TEST_TMP/source" "$TEST_TMP/target"; then exit 1; fi
[[ -x "$TEST_TMP/target/bin/nvim" ]]
compgen -G "$TEST_TMP/target.failed.*" >/dev/null
printf '#!/bin/sh\nexit 1\n' > "$TEST_TMP/source/bin/nvim"
if install_nvim_tree "$TEST_TMP/source" "$TEST_TMP/target"; then exit 1; fi
[[ -x "$TEST_TMP/target/bin/nvim" ]]

# Config-only runs must back up existing files and stay idempotent.
echo original > "$HOME/.bashrc"
bash "$REPO/bootstrap.sh" -work --symlinks-only >/dev/null
bash "$REPO/bootstrap.sh" -work --symlinks-only >/dev/null
[[ -L "$HOME/.bashrc" && -L "$HOME/.config/nvim" ]]
[[ $(cat "$HOME"/.bashrc.backup.*) == original ]]

# Mock downloads, package managers and privileged writes for full CLI branches.
sudo() {
    echo "sudo $*" >> "$TEST_LOG"
    # Model NodeSource's conflict with a separately requested npm package.
    if [[ "$1" == apt-get && " $* " == *' nodejs '* && " $* " == *' npm '* ]]; then return 1; fi
}
curl() {
    echo "curl $*" >> "$TEST_LOG"
    local out= arg
    while [[ $# -gt 0 ]]; do
        arg=$1; shift
        if [[ "$arg" == -o ]]; then out=$1; shift; fi
    done
    if [[ -n "$out" ]]; then
        printf '#!/bin/sh\nexit 0\n' > "$out"
    else
        echo '{"tag_name":"v1.0.0"}'
    fi
}
tar() {
    local dest= arg
    while [[ $# -gt 0 ]]; do
        arg=$1; shift
        if [[ "$arg" == -C ]]; then dest=$1; shift; fi
    done
    mkdir -p "$dest/nvim-linux-${MOCK_ARCH}/bin"
    printf '#!/bin/sh\nexit 0\n' > "$dest/nvim-linux-${MOCK_ARCH}/bin/nvim"
    chmod +x "$dest/nvim-linux-${MOCK_ARCH}/bin/nvim"
}
jq() { echo 1.0.0; }
unzip() { :; }
install() { echo "install $*" >> "$TEST_LOG"; }
rustup() { echo "rustup $*" >> "$TEST_LOG"; }
cargo() { echo "cargo $*" >> "$TEST_LOG"; }
nvim() { [[ "${MOCK_OLD_NVIM:-false}" == false ]]; }
dotnet() { echo '10.0.101 [mock/sdk]'; }
lazygit() { :; }
starship() { :; }
tree-sitter() { :; }
yazi() { :; }
ya() { :; }
dnf() { :; }
npm() { [[ "${MOCK_NPM_MISSING:-false}" == false ]]; }
uname() { if [[ "$1" == -m ]]; then echo "$MOCK_ARCH"; else echo Linux; fi; }
export -f sudo curl tar jq unzip install rustup cargo nvim dotnet lazygit starship tree-sitter yazi ya dnf uname npm
export MOCK_ARCH=x86_64
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -work >/dev/null
! rg -q 'curl|cargo|rustup' "$TEST_LOG"
for arch in x86_64 arm64; do
    export MOCK_ARCH=$arch
    : > "$TEST_LOG"
    bash "$REPO/bootstrap.sh" -work --update >/dev/null
    rg -q "nvim-linux-$arch.tar.gz" "$TEST_LOG"
    rg -q "Linux_$arch.tar.gz" "$TEST_LOG"
    rg -q 'rustup update' "$TEST_LOG"
    rg -q 'cargo install tree-sitter-cli --locked' "$TEST_LOG"
    rg -q 'dotnet-install.sh' "$TEST_LOG"
    ! rg -q 'codex/install.sh' "$TEST_LOG"
done
unset -f dnf
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -work --update >/dev/null
rg -q 'sudo apt-get update' "$TEST_LOG"
rg -q 'sudo apt-get install' "$TEST_LOG"
! rg -q '^sudo apt-get install .*\bnpm\b' "$TEST_LOG"
export MOCK_NPM_MISSING=true
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -work >/dev/null
rg -q '^sudo apt-get install -y npm$' "$TEST_LOG"
export MOCK_NPM_MISSING=false
export MOCK_OLD_NVIM=true MOCK_ARCH=x86_64
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -work >/dev/null
rg -q 'nvim-linux-x86_64.tar.gz' "$TEST_LOG"
export MOCK_OLD_NVIM=false
unset -f ya
command() { if [[ "$*" == '-v ya' ]]; then return 1; else builtin command "$@"; fi; }
export -f command
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -work >/dev/null
rg -q 'yazi-x86_64-unknown-linux-gnu.zip' "$TEST_LOG"
unset -f command

# Codex home update uses the standalone installer, work leaves it alone.
mkdir -p "$HOME/.codex/packages/standalone/test/bin" "$HOME/.local/bin"
printf '#!/bin/sh\necho mock-codex\n' > "$HOME/.codex/packages/standalone/test/bin/codex"
chmod +x "$HOME/.codex/packages/standalone/test/bin/codex"
ln -s "$HOME/.codex/packages/standalone/test/bin/codex" "$HOME/.local/bin/codex"
: > "$TEST_LOG"
bash "$REPO/bootstrap.sh" -home --update >/dev/null
rg -q 'codex/install.sh' "$TEST_LOG"
ln -sfn /usr/bin/true "$HOME/.local/bin/codex"
if bash "$REPO/scripts/install-codex.sh" --update >/dev/null 2>&1; then exit 1; fi

# Exercise Windows launcher rejection without writing under /mnt.
command() { if [[ "$*" == '-v codex' ]]; then echo /mnt/c/npm/codex; else builtin command "$@"; fi; }
if has_linux_tool codex; then exit 1; fi
unset -f command
for script in go-mint.sh go-fedora.sh; do
    if WSL_DISTRO_NAME=Test bash "$REPO/linux/$script" -home --update >/dev/null 2>&1; then exit 1; fi
done
echo 'Bootstrap offline behavior checks passed.'
