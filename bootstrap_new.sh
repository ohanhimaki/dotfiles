#!/bin/bash

set -e # Exit on error

echo "Starting dotfiles setup..."

# Create symlinks for bash configuration
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/bash/.bash_aliases ~/.bash_aliases

mkdir -p ~/.config

ln -sf ~/dotfiles/nvim ~/.config/nvim

mkdir -p ~/.config
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml

sudo apt update

sudo apt install -y git htop neofetch unzip screen

sudo apt install -y make gcc ripgrep fd-find
sudo apt install -y fzf silversearcher-ag python3 python3-pip python3-venv bash-completion

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
