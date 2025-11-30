

#!/bin/bash

set -e  # Exit on error

echo "Starting dotfiles setup..."

# Ask about gaming setup first
read -p "Initialize gaming setup? (y/n): " -n 1 -r
echo
INSTALL_GAMING=$REPLY

# Ask about work or home setup
echo ""
read -p "Work or Home setup? (w/h): " -n 1 -r
echo
SETUP_TYPE=$REPLY

# Update package list once
sudo apt update

# github cli, 
# https://github.com/cli/cli/releases
# linux 386 deb lataa -> suorita
# gh auth login 



sudo apt install -y git htop neofetch unzip screen tmux

# Media control and brightness tools for laptops
sudo apt install -y playerctl brightnessctl pulseaudio-utils

# Install latest Kitty terminal (via official installer)
if [ ! -d ~/.local/kitty.app ]; then
    echo "Installing latest Kitty terminal..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "Kitty already installed at ~/.local/kitty.app"
fi

# Install Neovim (latest version from GitHub)
if [ ! -d /opt/nvim-linux-x86_64 ]; then
    echo "Installing latest Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
else
    echo "Neovim already installed at /opt/nvim-linux-x86_64"
fi

# Install Nerd Fonts (FiraCode)
if [ ! -d ~/.local/share/fonts/NerdFonts ]; then
    echo "Installing FiraCode Nerd Font..."
    mkdir -p ~/.local/share/fonts/NerdFonts
    cd ~/.local/share/fonts/NerdFonts
    curl -fLo "FiraCode Nerd Font.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -o "FiraCode Nerd Font.zip"
    rm "FiraCode Nerd Font.zip"
    fc-cache -fv
    cd -
else
    echo "Nerd Fonts already installed"
fi

# Install Brave Browser (Flatpak)
if ! flatpak list | grep -q brave; then
    echo "Installing Brave Browser (Flatpak)..."
    flatpak install -y flathub com.brave.Browser
else
    echo "Brave Browser already installed"
fi

# Install DBeaver (Flatpak)
if ! flatpak list | grep -q dbeaver; then
    echo "Installing DBeaver Community Edition (Flatpak)..."
    flatpak install -y flathub io.dbeaver.DBeaverCommunity
else
    echo "DBeaver already installed"
fi

# Install VS Code
if ! command -v code &> /dev/null; then
    echo "Installing VS Code..."
    # Remove any existing VS Code repository configuration
    sudo rm -f /etc/apt/sources.list.d/vscode.list
    
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
else
    echo "VS Code already installed"
fi

# Install Spotify
if ! command -v spotify &> /dev/null; then
    echo "Installing Spotify..."
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client
else
    echo "Spotify already installed"
fi

sudo apt install -y make gcc ripgrep fd-find

# Creative tools
sudo apt install -y gimp

# Developer tools
sudo apt install -y fzf silversearcher-ag python3 python3-pip python3-venv bash-completion

# Install zram for compressed swap in RAM
sudo apt install -y zram-config

# Install Node.js (LTS version via NodeSource)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js LTS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed: $(node --version)"
fi

# Install .NET SDK
if ! command -v dotnet &> /dev/null; then
    echo "Installing .NET SDK..."
    # Detect Ubuntu version (Linux Mint is based on Ubuntu)
    UBUNTU_VERSION=$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2)
    
    # Map common versions
    case $UBUNTU_VERSION in
        "jammy") UBUNTU_NUM="22.04" ;;
        "focal") UBUNTU_NUM="20.04" ;;
        "noble") UBUNTU_NUM="24.04" ;;
        *) UBUNTU_NUM="22.04" ;;  # Default to 22.04 if unknown
    esac
    
    wget https://packages.microsoft.com/config/ubuntu/${UBUNTU_NUM}/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
    sudo apt install -y dotnet-sdk-9.0
else
    echo ".NET SDK already installed"
fi

# Install lazygit
if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    echo "lazygit already installed"
fi

# zoxide - smarter cd command
sudo apt install -y zoxide

# Install Starship prompt
if ! command -v starship &> /dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed"
fi

# Create symlinks for bash configuration
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/bash/.bash_aliases ~/.bash_aliases

# Create symlinks for git configuration based on work/home choice
if [[ $SETUP_TYPE =~ ^[Ww]$ ]]; then
    echo "Setting up work git config..."
    ln -sf ~/dotfiles/git/.gitconfig_work_linux ~/.gitconfig
else
    echo "Setting up personal git config..."
    ln -sf ~/dotfiles/git/.gitconfig_personal_linux ~/.gitconfig
fi

# Create symlink for vim configuration
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc

# Create symlink for Neovim configuration
mkdir -p ~/.config
# Backup existing nvim config if it exists
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    echo "Backing up existing Neovim config to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Create symlinks for VS Code configuration
mkdir -p ~/.config/Code/User
ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json

# Create symlink for GIMP configuration (Photoshop-friendly settings)
mkdir -p ~/.config/GIMP/2.10
ln -sf ~/dotfiles/linux/gimp/gimprc ~/.config/GIMP/2.10/gimprc

# Create symlink for Rofi configuration
mkdir -p ~/.config/rofi
ln -sf ~/dotfiles/linux/rofi/config.rasi ~/.config/rofi/config.rasi
ln -sf ~/dotfiles/linux/rofi/gruvbox-dark.rasi ~/.config/rofi/gruvbox-dark.rasi
ln -sf ~/dotfiles/linux/rofi/onedark.rasi ~/.config/rofi/onedark.rasi


# Create symlink for Kitty terminal configuration
mkdir -p ~/.config/kitty
ln -sf ~/dotfiles/linux/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Create symlink for lazygit configuration
mkdir -p ~/.config/lazygit
ln -sf ~/dotfiles/lazygit/config.yml ~/.config/lazygit/config.yml

# Create symlink for fastfetch configuration
mkdir -p ~/.config/fastfetch
ln -sf ~/dotfiles/linux/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc

# Create symlink for Starship prompt configuration
mkdir -p ~/.config
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# Restore Gnome Terminal settings
if [ -f ~/dotfiles/linux/gnome-terminal-settings.dconf ]; then
    echo "Restoring Gnome Terminal settings..."
    dconf load /org/gnome/terminal/ < ~/dotfiles/linux/gnome-terminal-settings.dconf
else
    echo "Gnome Terminal settings file not found, skipping..."
fi

# Gaming setup
if [[ $INSTALL_GAMING =~ ^[Yy]$ ]]
then
    echo "Installing gaming tools..."
    sudo apt install -y steam discord mangohud
    
    # Create symlink for MangoHud config
    mkdir -p ~/.config/MangoHud
    ln -sf ~/dotfiles/linux/MangoHud/MangoHud.conf ~/.config/MangoHud/MangoHud.conf
fi


# Ask which Desktop Environment to restore
echo ""
echo "Which desktop environment do you want to restore?"
echo "1) Cinnamon"
echo "2) GNOME"
echo "3) Awesome WM"
echo "4) KDE Plasma"
echo "5) Skip DE restoration"
read -p "Choose (1/2/3/4/5): " -n 1 -r
echo

case $REPLY in
    1)
        if [ -f ~/dotfiles/linux/cinnamon/restore_cinnamon.sh ]; then
            bash ~/dotfiles/linux/cinnamon/restore_cinnamon.sh
        else
            echo "Cinnamon restore script not found, skipping..."
        fi
        ;;
    2)
        if [ -f ~/dotfiles/linux/gnome/restore_gnome.sh ]; then
            bash ~/dotfiles/linux/gnome/restore_gnome.sh
        else
            echo "GNOME restore script not found, skipping..."
        fi
        ;;
    3)
        if [ -f ~/dotfiles/linux/awesome/restore_awesome.sh ]; then
            bash ~/dotfiles/linux/awesome/restore_awesome.sh
        else
            echo "Awesome WM restore script not found, skipping..."
        fi
        ;;
    4)
        if [ -f ~/dotfiles/linux/kde/quick-setup.sh ]; then
            echo "Running KDE Plasma configuration..."
            bash ~/dotfiles/linux/kde/quick-setup.sh
        else
            echo "KDE setup script not found, skipping..."
        fi
        ;;
    *)
        echo "Skipping desktop environment restoration"
        ;;
esac

# Boot optimization
echo ""
read -p "Optimize boot time by disabling unused services? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Analyzing boot performance..."
    systemd-analyze blame | head -10
    echo ""
    
    # Disable printing services
    read -p "Disable printing services (cups)? Skip if you have a printer (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Disabling printing services..."
        sudo systemctl disable cups cups-browsed 2>/dev/null || true
    fi
    
    # Disable avahi (network discovery)
    read -p "Disable network discovery (avahi)? Usually safe to disable (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Disabling network discovery..."
        sudo systemctl disable avahi-daemon 2>/dev/null || true
    fi
    
    # Disable remote desktop
    read -p "Disable remote desktop? Skip if you use VNC/RDP (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Disabling remote desktop..."
        sudo systemctl disable gnome-remote-desktop 2>/dev/null || true
    fi
    
    echo "Boot optimization complete! Reboot to see faster startup times."
fi

echo ""
echo "Setup complete! Don't forget to:"
echo "1. Source your bashrc: source ~/.bashrc"
echo "2. Edit ~/.gitconfig to remove Windows credential helper if needed"


