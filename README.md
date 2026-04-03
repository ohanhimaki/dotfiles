# Dotfiles

Cross-platform dotfiles configuration for Windows and Linux development environments.

## Quick Start

### Prerequisites

#### Windows

1. **Git**: Download from [git-scm.com](https://git-scm.com/download/win)
2. **PowerShell 7+**: Usually pre-installed, or download from [Microsoft](https://github.com/PowerShell/PowerShell)

#### Linux

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git
```

### Installation

1. Clone this repository:

```bash
# Public repo - no authentication needed!
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the bootstrap script:

#### Windows (PowerShell)

```powershell
# For work setup
.\bootstrap.ps1 -Profile work

# For home setup
.\bootstrap.ps1 -Profile home
```

#### Linux

```bash
# Make script executable
chmod +x bootstrap.sh

# For work setup
./bootstrap.sh -Profile work

# For home setup
./bootstrap.sh -Profile home
```

3. The script will:
   - Create symlinks for all configuration files
   - Install essential tools via winget (Windows) or apt (Linux)
   - Set up your development environment

## What Gets Installed

### Common Tools (Both Profiles)

- **Terminal**: WezTerm, Windows Terminal (Windows)
- **Shell**: PowerShell configuration, Bash configuration
- **Prompt**: Starship
- **Git**: Configuration and LazyGit
- **Editor**: Neovim with full configuration
- **CLI Tools**: ripgrep, fd, fzf, zoxide, bat, eza
- **Window Manager**: GlazeWM (Windows)
- **Utilities**: PowerToys (Windows)

### Profile: Work

Additional work-specific configurations and tools.

### Profile: Home

Additional home-specific configurations and tools.

## Configuration Structure

```
dotfiles/
├── bash/              # Bash configuration
├── fonts/             # Custom fonts (Fira Code, etc.)
├── git/               # Git configuration
├── glazewm/           # GlazeWM window manager config (Windows)
├── idea/              # IntelliJ IDEA vim settings
├── lazygit/           # LazyGit configuration
├── linux/             # Linux-specific configs
├── nushell/           # Nushell configuration
├── nvim/              # Neovim configuration
├── powershell/        # PowerShell profile and aliases
├── powertoys/         # PowerToys configuration
├── rider/             # Rider IDE vim settings
├── starship/          # Starship prompt configuration
├── vscode/            # VS Code settings
├── wallpapers/        # Wallpaper collection
├── wezterm/           # WezTerm terminal config
├── windowsterminal/   # Windows Terminal settings
├── wsl/               # WSL-specific configuration
├── bootstrap.ps1      # Windows bootstrap script
└── bootstrap.sh       # Linux bootstrap script
```

## Manual Configuration

After running the bootstrap, you may want to:

1. **Configure Git with your personal info:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Generate SSH keys if needed:**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

3. **Customize configurations:**
   - Edit `git/.gitconfig` for git aliases and settings
   - Edit `powershell/Microsoft.PowerShell_profile.ps1` for shell customization
   - Edit `nvim/` configs for editor preferences

## Troubleshooting

### Windows

- **"Access Denied" errors**: Run PowerShell as Administrator
- **Execution policy errors**: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Symlink creation fails**: Enable **Developer Mode** to allow symlinks without Administrator rights:
  - Settings > Privacy & security > For developers > **Developer Mode: On**

### Linux

- **Permission errors**: Don't run bootstrap as root (except for package installation parts)
- **Missing packages**: Run `sudo apt-get update` first
- **Command not found after install**: Restart your terminal or run `source ~/.bashrc`

## Tools Overview

### Terminal & Shell
- **WezTerm**: Modern, GPU-accelerated terminal emulator
- **Starship**: Fast, customizable prompt
- **PowerShell**: Modern shell with aliases and functions
- **Bash**: Traditional shell with enhanced configuration

### Development
- **Neovim**: Highly configured with LSP, treesitter, and plugins
- **VS Code**: Synchronized settings and extensions
- **Rider/IntelliJ IDEA**: Vim mode configurations

### CLI Tools
- **ripgrep (rg)**: Fast grep alternative
- **fd**: Fast find alternative
- **fzf**: Fuzzy finder
- **zoxide**: Smart cd command
- **bat**: Better cat with syntax highlighting
- **eza**: Modern ls alternative
- **LazyGit**: Terminal UI for git

### Windows Specific
- **GlazeWM**: Tiling window manager
- **PowerToys**: Windows utilities collection

## Acknowledgments

Inspired by [Christian Rondeau's dotfiles](https://github.com/christianrondeau/dotfiles)

---

**Note**: This is a public repository. No sensitive information (passwords, API keys, tokens) should be committed here.
