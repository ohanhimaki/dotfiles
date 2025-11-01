# Linux Mint Dotfiles Setup

This folder contains configuration files and setup scripts for Linux Mint.

## Quick Start

### Prerequisites: Get files to the correct folder

1. **Install git:**
   ```bash
   sudo apt update
   sudo apt install git -y
   ```

2. **Install GitHub CLI:**
   ```bash
   (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
   	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
   	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
   	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
   	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
   	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
   	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
   	&& sudo apt update \
   	&& sudo apt install gh -y
   ```

3. **Authenticate with GitHub:**
   ```bash
   gh auth login
   ```

4. **Clone this dotfiles repository:**
   ```bash
   cd ~
   gh repo clone ohanhimaki/dotfiles
   ```

### Run the setup script

Run the setup script to install tools and create symlinks:

```bash
cd ~/dotfiles/linux
bash go.sh
```

## What gets installed

### Core Tools
- git, htop, neovim, neofetch, unzip, screen, tmux
- make, gcc, ripgrep, fd-find
- zoxide (smarter cd command)

### Applications
- **Brave Browser** - Privacy-focused web browser
- **VS Code** - Code editor

### Optional: Gaming Setup
The script will prompt you to install gaming tools:
- Steam
- Discord
- MangoHud (performance overlay)

## Configuration Files

### Bash
- `.bashrc` - Main bash configuration
- `.bash_aliases` - Custom aliases and shortcuts

### MangoHud
- `MangoHud/MangoHud.conf` - Gaming performance overlay configuration

## Manual Steps

After running the setup script:

1. **Source your bashrc**: 
   ```bash
   source ~/.bashrc
   ```

2. **Configure VS Code**: Symlink VS Code settings (if needed)

## Customization

Edit the `DOTFILES_DIR` variable at the top of `go.sh` if your dotfiles are located elsewhere (e.g., `~/.dotfiles`).
