set -e # Exit on error

SYMLINKS_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --symlinks-only) SYMLINKS_ONLY=true ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# Get the absolute path of the dotfiles directory (where this script is located)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Starting dotfiles setup..."
echo "Dotfiles directory: $DOTFILES_DIR"
# Create symlinks for bash configuration
ln -sf "$DOTFILES_DIR/bash/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/bash/.bash_aliases" ~/.bash_aliases

mkdir -p ~/.config

ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim-v2" ~/.config/nvim-v2
ln -sf "$DOTFILES_DIR/yazi/config" ~/.config/yazi
ln -sf "$DOTFILES_DIR/ai-hommat/.agents" ~/.agents
ln -sf "$DOTFILES_DIR/ai-hommat/.agents" ~/.agents
ln -sf "$DOTFILES_DIR/ai-hommat/shared-instructions.md" ~/.copilot/copilot-instructions.md

mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml

if [ "$SYMLINKS_ONLY" = true ]; then
    echo "Symlinks created. Skipping tool installation."
    exit 0
fi

sudo apt update

sudo apt install -y git htop neofetch unzip screen zoxide

sudo apt install -y make gcc ripgrep fd-find
sudo apt install -y fzf silversearcher-ag python3 python3-pip python3-venv bash-completion

cd ~

if [ ! -d /opt/nvim-linux-x86_64 ]; then
    echo "Installing latest Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
else
    echo "Neovim already installed at /opt/nvim-linux-x86_64"
fi

# Install lazygit
if ! command -v lazygit &>/dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    echo "lazygit already installed"
fi

# Install Starship prompt
if ! command -v starship &>/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed"
fi

# Install Node.js (LTS version via NodeSource)
if ! command -v node &>/dev/null; then
    echo "Installing Node.js LTS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed: $(node --version)"
fi

# Install Rust via rustup
if ! command -v rustup &>/dev/null; then
    echo "Installing Rust (rustup)..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y

    # Lataa cargo env heti käyttöön tässä skriptissä
    source "$HOME/.cargo/env"
else
    echo "rustup already installed"
    source "$HOME/.cargo/env"
fi

# Update Rust to latest
rustup update

# Install tree-sitter CLI (uusin versio)
if ! command -v tree-sitter &>/dev/null; then
    echo "Installing tree-sitter-cli..."
    cargo install tree-sitter-cli
else
    echo "tree-sitter already installed"
fi

# install yazi from github latest release from https://github.com/sxyazi/yazi/releases
if ! command -v yazi &>/dev/null; then
    echo "Installing yazi..."
    curl -Lo yazi.zip "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
    unzip yazi.zip
    sudo install yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin
    sudo install yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin
    rm -rf yazi-x86_64-unknown-linux-gnu yazi.zip
else
    echo "yazi already installed"
fi


cd "$DOTFILES_DIR"
