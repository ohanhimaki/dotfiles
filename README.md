# Olli's Dotfiles

Cross-platform dotfiles configuration for Windows and Linux development environments.

## Quick Start

### Prerequisites

Install these tools first:

#### Windows
1. **Git**: Download from [git-scm.com](https://git-scm.com/download/win)
2. **.NET SDK 10+**: Download from [dotnet.microsoft.com](https://dotnet.microsoft.com/download)

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git dotnet-sdk-10.0

# Arch
sudo pacman -S git dotnet-sdk
```

### Installation

1. Clone this repository:
```bash
git clone --recursive https://github.com/olli/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the bootstrap script:
```bash
# Windows (PowerShell)
dotnet run bootstrap.cs

# Linux
dotnet run bootstrap.cs
# Or make it executable and run directly
chmod +x bootstrap.cs
./bootstrap.cs
```

3. Follow the interactive prompts to select your profile:
   - **Minimal**: Essential configurations only
   - **Basic**: Standard development setup (recommended)
   - **Full**: Everything including additional tools

## What Gets Installed

### Minimal Profile
- PowerShell configuration & aliases
- Git configuration
- WezTerm terminal
- GlazeWM window manager (Windows)
- PowerToys (Windows)
- Windows Terminal settings
- Basic Vim/Bash setup (Linux)

### Basic Profile
Everything in Minimal, plus:
- Modern CLI tools (ripgrep, fd, bat, eza, fzf, zoxide)
- Starship prompt
- Lazygit
- Neovim configuration
- VS Code settings
- 7zip, Process Explorer, Fira Code font (Windows)
- Zsh with plugins (Linux)

### Full Profile
Everything in Basic, plus:
- Rider/IntelliJ IDEA vim config
- GitExtensions, Spotify, VLC, Discord (Windows)
- Additional development tools

## Manual Configuration

After running the bootstrap, you may want to:
- Configure Git with your name and email: `git config --global user.name "Your Name"`
- Generate SSH keys if needed: `ssh-keygen -t ed25519 -C "your_email@example.com"`
- Customize `.gitconfig`, PowerShell profiles, or other configs as needed

## Troubleshooting

### Windows
- **"Access Denied" errors**: Run PowerShell as Administrator
- **Execution policy errors**: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Chocolatey not found**: Restart your terminal after bootstrap installs it

### Linux  
- **Permission errors**: Ensure you don't run as root (except for apt-get)
- **Missing packages**: Run `sudo apt-get update` first

## Structure

- `powershell/` - PowerShell profile and aliases
- `nvim/` - Neovim configuration
- `wezterm/` - WezTerm terminal config
- `glazewm/` - GlazeWM window manager config
- `git/` - Git configuration
- `vscode/` - VS Code settings
- `lazygit/` - Lazygit config
- `bootstrap.cs` - Main installation script

## Ideas & Future Plans

- Unify Rider IDE settings with Vim/Nvim configurations
- Better organization of shared aliases across platforms
- Bash history improvements
- Mangohud alt + x toggle

## Acknowledgments

Inspired by [Christian Rondeau's dotfiles](https://github.com/christianrondeau/dotfiles)