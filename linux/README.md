# Linux desktop setup

The root `bootstrap.sh` installs shared CLI tools and links development configs on
Fedora, Mint/Ubuntu and WSL. The scripts in this directory add desktop applications.
Run commands from the repository root; exactly one of `-work` or `-home` is required.

```bash
# WSL or CLI-only Linux setup
bash bootstrap.sh -work

# Full native desktop setup (includes the shared bootstrap)
bash linux/go-fedora.sh -home
bash linux/go-mint.sh -home

# Optional gaming applications and desktop settings
bash linux/go-fedora.sh -home --gaming --desktop=gnome
bash linux/go-mint.sh -home --gaming --desktop=cinnamon

# Link shared and desktop configs without installing applications
bash linux/go-fedora.sh -work --symlinks-only
```

`go.sh` forwards to `go-mint.sh` for compatibility and also requires a profile.
The desktop scripts reject WSL. Install desktop applications on Windows when using WSL.
The work/home profile selects Git identity. Codex is installed only with `-home`.
Development SDKs and Spotify are installed with both profiles. `-work` does not remove an existing Codex.

## Shared CLI setup

Git, GitHub CLI, htop, ripgrep, fd, fzf, zoxide, Bash completion,
Neovim, lazygit, Yazi, Starship, Node.js/npm, Python, Rust, tree-sitter CLI,
.NET SDK 10, and Codex for the home profile. Package dependencies are installed before standalone downloads.
Node.js uses the distro repository. A missing .NET 10 SDK is installed in `~/.dotnet`.
Existing compatible standalone tools are skipped by default. `--update` refreshes
standalone CLI tools, runs `rustup update`, refreshes tree-sitter CLI and the .NET
10 SDK, and updates standalone Codex only with `-home`. Desktop scripts also
update packaged WezTerm. No full distro/Flatpak upgrade is performed.
Neovim must provide `vim.pack`; older versions are replaced even in normal setup.
Existing `/opt/nvim-linux-<arch>` trees are backed up rather than merged.
See [the bootstrap review](BOOTSTRAP-REVIEW.md) for findings and test limits.
On Mint/Debian, bootstrap links `~/.local/bin/fd` to the installed `fdfind` when
`fd` is missing. Bash's fzf integration also accepts `fdfind` with config-only setup.
See [the backlog](../BACKLOG.md) for verification on an actual Mint machine.

Bash, Git, Neovim, Yazi, lazygit, Starship and shared AI instructions are linked.
Existing non-symlink configs are backed up beside the original before linking.
The scripts resolve the checkout location rather than requiring `~/dotfiles`.
Standalone CLI downloads support x86_64 and arm64.

## Desktop setup

- WezTerm, with config links
- JetBrains Mono Nerd Font (used by the WezTerm config)
- Native VS Code and Google Chrome (Chrome only on x86_64)
- Spotify via Flathub when no native or Flatpak installation exists
- playerctl, brightnessctl and wl-clipboard for Wayland; fastfetch on Fedora
- VS Code, Rofi and fastfetch configuration links

Fedora uses WezTerm's documented `wezfurlong/wezterm-nightly` Copr repository;
Mint uses WezTerm's stable APT repository. See the [official WezTerm installation guide](https://wezterm.org/install/linux.html).
Flatpak apps are installed for the current user unless already installed system-wide.
Kitty, screen, tmux, GIMP and DBeaver are not installed by these setup scripts.
Historical config files remain in the repository; existing applications are not uninstalled.

## Optional setup

`--gaming` installs Steam, Discord and the MangoHud Flatpak extension, and links the
MangoHud config. For Steam games, add `MANGOHUD=1 %command%` to launch options.
The script chooses MangoHud's extension branch to match Steam's Flatpak runtime.

`--desktop=cinnamon` and `--desktop=gnome` restore the saved dconf settings.
`--desktop=awesome` links the saved Awesome configuration (install Awesome and its
dependencies separately). `--desktop=kde` runs the existing interactive KDE setup.
Choose the desktop you are actually running. With `--symlinks-only`, restoration is skipped.

Service disabling and zram changes are no longer part of application installation.
Existing backup, update and desktop-specific scripts remain available separately;
`update.sh` is an older apt-based maintenance script, not a Fedora updater.

## After installation

Open a new terminal and run `gh auth login`. With the home profile, start `codex` to sign in.
Keep authentication files and tokens outside Git.

```bash
# Explicit standalone Codex update
bash scripts/install-codex.sh --update
```
