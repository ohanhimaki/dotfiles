

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

# Install Brave Browser
if ! command -v brave-browser &> /dev/null; then
    echo "Installing Brave Browser..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
else
    echo "Brave Browser already installed"
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
    sudo apt install -y dotnet-sdk-8.0
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

# Clone Neovim configuration
if [ ! -d ~/.config/nvim ]; then
    echo "Cloning Neovim configuration..."
    gh clone https://github.com/ohanhimaki/nvim ~/.config/nvim
else
    echo "Neovim config already exists at ~/.config/nvim"
fi

# Create symlinks for VS Code configuration
mkdir -p ~/.config/Code/User
ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json

# Create symlink for GIMP configuration (Photoshop-friendly settings)
mkdir -p ~/.config/GIMP/2.10
ln -sf ~/dotfiles/linux/gimp/gimprc ~/.config/GIMP/2.10/gimprc

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


# Ask about Cinnamon desktop restoration
echo ""
read -p "Restore Cinnamon desktop settings? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f ~/dotfiles/linux/restore_cinnamon.sh ]; then
        bash ~/dotfiles/linux/restore_cinnamon.sh
    else
        echo "restore_cinnamon.sh not found, skipping..."
    fi
fi


echo ""
echo "Setup complete! Don't forget to:"
echo "1. Source your bashrc: source ~/.bashrc"
echo "2. Edit ~/.gitconfig to remove Windows credential helper if needed"


