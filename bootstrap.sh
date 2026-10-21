#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/scripts/bootstrap-common.sh"
parse_setup_args "$@"

if [[ $EUID -eq 0 ]]; then
    echo "Run as your normal user; package installation uses sudo." >&2
    exit 1
fi

# Link shared CLI configuration on Fedora, Mint and WSL alike.
link_config "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_config "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
if [[ "$PROFILE" == work ]]; then
    link_config "$DOTFILES_DIR/git/.gitconfig_work_linux" "$HOME/.gitconfig"
else
    link_config "$DOTFILES_DIR/git/.gitconfig_personal_linux" "$HOME/.gitconfig"
fi
link_config "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_config "$DOTFILES_DIR/nvim-v2" "$HOME/.config/nvim-v2"
link_config "$DOTFILES_DIR/yazi/config" "$HOME/.config/yazi"
link_config "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
link_config "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_config "$DOTFILES_DIR/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_config "$DOTFILES_DIR/ai-hommat/.agents" "$HOME/.agents"
link_config "$DOTFILES_DIR/ai-hommat/shared-instructions.md" "$HOME/.codex/AGENTS.md"
link_config "$DOTFILES_DIR/ai-hommat/shared-instructions.md" "$HOME/.copilot/copilot-instructions.md"
link_config "$DOTFILES_DIR/ai-hommat/shared-instructions.md" "$HOME/.claude/CLAUDE.md"

if [[ "$SYMLINKS_ONLY" == true ]]; then
    echo "Shared configs linked for $PROFILE. Tool installation skipped."
    exit 0
fi

# Dependencies must be installed before downloading standalone tools.
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git curl ca-certificates tar gzip unzip jq htop \
        zoxide gh make gcc gcc-c++ ripgrep fd-find fzf python3 python3-pip \
        bash-completion nodejs npm bubblewrap openssl-libs libicu zlib
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git curl ca-certificates tar gzip unzip jq htop \
        zoxide gh build-essential ripgrep fd-find fzf python3 python3-pip \
        python3-venv bash-completion nodejs bubblewrap libicu-dev libssl-dev zlib1g build-essential
    # NodeSource bundles npm in nodejs and conflicts with Ubuntu's npm package.
    # Distro nodejs may need npm separately, so check after installing Node.
    if ! has_linux_tool npm || ! npm --version >/dev/null 2>&1; then
        sudo apt-get install -y npm
    fi
else
    echo "Supported package managers: apt-get (Mint/Ubuntu/Debian) and dnf (Fedora)." >&2
    exit 1
fi

# Ensure user-installed Linux tools take precedence over inherited Windows PATH.
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.dotnet:$PATH"
mkdir -p "$HOME/.local/bin"
# Debian/Mint names fd's executable fdfind. Expose the common fd name for
# Bash, Neovim and other tools, without replacing an existing fd installation.
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
INSTALL_TMP=$(mktemp -d)
trap 'rm -rf -- "$INSTALL_TMP"' EXIT

case $(uname -m) in
    x86_64) TOOL_ARCH=x86_64; GO_ARCH=x86_64 ;;
    aarch64|arm64) TOOL_ARCH=arm64; GO_ARCH=arm64 ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

# Recover the link for an existing /opt installation, including arm64.
NVIM_DIR="/opt/nvim-linux-${TOOL_ARCH}"
if [[ -x "$NVIM_DIR/bin/nvim" && ! -e "$HOME/.local/bin/nvim" && ! -L "$HOME/.local/bin/nvim" ]]; then
    ln -s "$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"
fi
if [[ "$UPDATE" == true ]] || ! has_linux_tool nvim || ! nvim --headless -u NONE -i NONE '+lua if not vim.pack then vim.cmd("cquit 1") end' +qa; then
    curl -fSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${TOOL_ARCH}.tar.gz" -o "$INSTALL_TMP/nvim.tar.gz"
    tar -xzf "$INSTALL_TMP/nvim.tar.gz" -C "$INSTALL_TMP"
    install_nvim_tree "$INSTALL_TMP/nvim-linux-${TOOL_ARCH}" "$NVIM_DIR"
    ln -sfn "/opt/nvim-linux-${TOOL_ARCH}/bin/nvim" "$HOME/.local/bin/nvim"
fi

if [[ "$UPDATE" == true ]] || ! has_linux_tool lazygit; then
    LAZYGIT_VERSION=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -er '.tag_name | ltrimstr("v")')
    curl -fSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${GO_ARCH}.tar.gz" -o "$INSTALL_TMP/lazygit.tar.gz"
    tar -xzf "$INSTALL_TMP/lazygit.tar.gz" -C "$INSTALL_TMP" lazygit
    install -m 755 "$INSTALL_TMP/lazygit" "$HOME/.local/bin/lazygit"
fi

if [[ "$UPDATE" == true ]] || ! has_linux_tool starship; then
    curl -fsSL https://starship.rs/install.sh -o "$INSTALL_TMP/starship-install.sh"
    sh "$INSTALL_TMP/starship-install.sh" -y -b "$HOME/.local/bin"
fi

if ! has_linux_tool rustup; then
    curl -fsSL https://sh.rustup.rs -o "$INSTALL_TMP/rustup-install.sh"
    sh "$INSTALL_TMP/rustup-install.sh" -y --no-modify-path
fi
if [[ "$UPDATE" == true ]]; then rustup update; fi
if [[ "$UPDATE" == true ]] || ! has_linux_tool tree-sitter; then
    cargo install tree-sitter-cli --locked
fi

if [[ "$UPDATE" == true ]] || ! has_linux_tool yazi || ! has_linux_tool ya; then
    case "$TOOL_ARCH" in
        x86_64) YAZI_ARCH=x86_64 ;;
        arm64) YAZI_ARCH=aarch64 ;;
    esac
    YAZI_ASSET="yazi-${YAZI_ARCH}-unknown-linux-gnu"
    curl -fSL "https://github.com/sxyazi/yazi/releases/latest/download/${YAZI_ASSET}.zip" -o "$INSTALL_TMP/yazi.zip"
    unzip -q "$INSTALL_TMP/yazi.zip" -d "$INSTALL_TMP"
    install -m 755 "$INSTALL_TMP/$YAZI_ASSET/yazi" "$HOME/.local/bin/yazi"
    install -m 755 "$INSTALL_TMP/$YAZI_ASSET/ya" "$HOME/.local/bin/ya"
fi

# A user-local SDK avoids maintaining Microsoft repositories for each distro.
# Install .NET 10 only when that SDK major version is missing; leave other SDKs in place.
if [[ "$UPDATE" == true ]] || ! { has_linux_tool dotnet && dotnet --list-sdks | grep -q '^10\.'; }; then
    curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$INSTALL_TMP/dotnet-install.sh"
    bash "$INSTALL_TMP/dotnet-install.sh" --channel 10.0 --install-dir "$HOME/.dotnet" --no-path
fi

# LikeC4's Neovim plugin needs the CLI for its language server.
# Keep npm's system-wide prefix untouched and reject unsupported Node versions.
if [[ "$UPDATE" == true ]] || ! has_linux_tool likec4; then
    npm install --global --prefix "$HOME/.local" --engine-strict likec4
fi

if [[ "$PROFILE" == home ]]; then
    CODEX_ARGS=()
    if [[ "$UPDATE" == true ]]; then CODEX_ARGS+=(--update); fi
    bash "$DOTFILES_DIR/scripts/install-codex.sh" "${CODEX_ARGS[@]}"
else
    echo "Work profile: Codex installation skipped."
fi
echo "Shared setup complete ($PROFILE). Open a new terminal and sign in to the tools you use."
