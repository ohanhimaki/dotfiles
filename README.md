# Dotfiles

Cross-platform dotfiles configuration for Windows and Linux development environments.

## Quick Start

### Prerequisites

#### Windows

```powershell
winget install --id Git.Git
```

#### Linux

```bash
# Mint / Ubuntu / WSL Ubuntu
sudo apt-get update
sudo apt-get install -y git

# Fedora
sudo dnf install -y git
```

### Installation

1. Clone this repository:

```bash
# Public repo - no authentication needed!
git clone https://github.com/ohanhimaki/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the bootstrap script:

#### Windows (PowerShell)

```powershell
.\install.ps1
.\makesymlinks.ps1
```

Windows tools and desktop applications (including WezTerm) are installed on Windows.
The existing Windows scripts do not accept work/home profile arguments.

#### Linux / WSL

Run from the repository root. Exactly one of `-work` or `-home` is required,
including when using `--symlinks-only`. The profile selects your Linux Git configuration. Codex is installed only with `-home`;
development SDKs are installed with both profiles.

```bash
# Shared CLI tools and configs: Fedora, Mint or WSL
bash bootstrap.sh -work
bash bootstrap.sh -home

# Refresh standalone CLI tools and development SDKs
bash bootstrap.sh -home --update
# Include the packaged WezTerm update on Mint
bash linux/go-mint.sh -home --update

# Only link configs; skip all downloads and package installation
bash bootstrap.sh -work --symlinks-only

# Fedora desktop: shared bootstrap + desktop applications and fonts
bash linux/go-fedora.sh -home

# Mint desktop: shared bootstrap + desktop applications and fonts
bash linux/go-mint.sh -home

# Optional gaming applications and desktop settings restoration
bash linux/go-fedora.sh -home --gaming --desktop=gnome
```

The desktop scripts call the shared bootstrap automatically and reject WSL.
Use Windows WezTerm to open WSL; install Linux CLI tools inside WSL for Linux projects.
Existing config files/directories are backed up before linking. Existing symlinks are replaced.
See [Linux setup](linux/README.md) for desktop application details.

### Codex CLI

With `-home`, the shared bootstrap installs Codex using the standalone installer if
Linux `codex` is missing. `-work` skips Codex installation and leaves existing installations in place.
It prepends `~/.local/bin` to PATH and leaves existing installations in place.
Sign in separately on each machine by starting `codex`. Credentials do not belong in this repository.

```bash
# Install only Codex (requires curl and tar)
bash scripts/install-codex.sh

# Explicitly update a standalone installation in ~/.local/bin
bash scripts/install-codex.sh --update
```

For npm/system-managed Codex, use the existing package manager to update it.
Normal bootstrap installs missing tools. `--update` refreshes Neovim, LazyGit,
Starship, Yazi/ya, Rust toolchains, tree-sitter CLI and the .NET 10 SDK;
with `-home` it also updates standalone Codex. It cannot be combined with
`--symlinks-only`. Desktop scripts forward the flag and update packaged WezTerm.
This is not a full distro or Flatpak update.

For LazyGit, Starship and Yazi, explicit update installs a preferred user-local
copy even if an older copy exists under `/usr/local/bin` or `/usr/bin`.
Those older copies are retained. Codex requires its existing installer when it
is npm/system-managed; the update stops with instructions rather than replacing it.
Neovim uses `/opt/nvim-linux-<arch>` and `~/.local/bin/nvim`; existing trees are
retained as timestamped backups, with rollback on copy failure. Normal bootstrap
also replaces Neovim that lacks `vim.pack` (Neovim 0.12+ is required).
Neovim plugins are updated separately with `:PackUpdateFromOnline`.
See [the bootstrap review](linux/BOOTSTRAP-REVIEW.md) for current machine findings
and offline test coverage.
Distro packages use apt/dnf; Node.js comes from the distro repositories.
.NET SDK 10 is installed under `~/.dotnet` when a version 10 SDK is missing.

## What Gets Installed

### Shared Linux CLI Tools (Both Profiles)

- **Desktop terminal**: WezTerm on native Linux desktops or Windows
- **Shell**: PowerShell configuration, Bash configuration
- **Prompt**: Starship
- **Git**: Configuration and LazyGit
- **Editor**: Neovim with full configuration
- **CLI Tools**: ripgrep, fd, fzf, zoxide, bat, eza
- **Window Manager**: GlazeWM (Windows)
- **Utilities**: PowerToys (Windows)

### Profile: Work

Uses `git/.gitconfig_work_linux` on Linux. Installs development SDKs and skips Codex installation.

### Profile: Home

Uses `git/.gitconfig_personal_linux` on Linux. Installs development SDKs and Codex.

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
├── scripts/           # Shared setup helpers and Codex installer
├── install.ps1        # Windows application installation
├── makesymlinks.ps1    # Windows configuration links
└── bootstrap.sh       # Shared Linux / WSL CLI bootstrap
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

## Development backlog

See [BACKLOG.md](BACKLOG.md) for checks to run on a Mint machine and deferred
application choices. [AGENTS.md](AGENTS.md) records repository maintenance conventions.
