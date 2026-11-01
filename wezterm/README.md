# WezTerm Configuration

This directory contains WezTerm terminal emulator configuration.

## Features

- **Tokyo Night Color Scheme**: Night variant with the original Gruvbox scheme available
- **Custom Font**: JetBrains Mono / Fira Code / Cascadia Code with fallback to Consolas
- **Opacity**: 95% window background opacity for a modern look
- **Tab Bar**: Visible tab bar with colors matching the selected theme
- **Flexible Shell**: Uses WezTerm's default shell detection (no hardcoded shell path)
- **Error Resilient**: Configuration includes proper error handling and fallbacks

## Keybindings

This config uses a leader key:

- `Ctrl+a`: Leader

### Pane Management
- `Leader, Shift+d`: Split the current pane vertically (side-by-side panes)
- `Leader, d`: Split the current pane horizontally (stacked panes)
- `Leader, h`: Move to the pane on the left
- `Leader, l`: Move to the pane on the right
- `Leader, k`: Move to the pane above
- `Leader, j`: Move to the pane below
- `Leader, r`: Enter pane resize mode, then use `h/j/k/l` or arrow keys
- `Cmd+w`: Close current pane (with confirmation)

### Tabs
- `Leader, 1` ... `Leader, 9`: Jump directly to tab 1 ... 9

### Workspaces
- `Leader, s`: Open workspace switcher
- `Leader, n`: Create or switch to a workspace by name
- `Leader, Shift+r`: Rename the current workspace

### Utility
- `Leader, p`: Open launcher
- `Leader, o`: Toggle window opacity

### Copy/Paste
- `Ctrl+Shift+C`: Copy to clipboard
- `Ctrl+Shift+V`: Paste from clipboard

### Mouse
- **Left Click**: Select text
- **Ctrl+Left Click**: Open link under cursor

## Configuration File Location

The configuration is linked to `~/.config/wezterm/wezterm.lua` on Linux and
`%USERPROFILE%\.config\wezterm\wezterm.lua` on Windows.

## Installation

```bash
# Native Linux desktop, including shared CLI setup
bash linux/go-fedora.sh -home
bash linux/go-mint.sh -home
```

```powershell
# Windows (also when using WezTerm to open WSL)
.\install.ps1
.\makesymlinks.ps1
```

The shared Linux/WSL `bootstrap.sh` installs CLI tools. WezTerm installation and
Linux desktop config linking belong to the desktop scripts.

## Customization

Edit `wezterm/wezterm.lua` and `wezterm/modules/mappings.lua` to customize:
- Font family and size
- Color scheme
- Window opacity
- Keybindings
- Default shell

After making changes, restart WezTerm or reload configuration with `Ctrl+Shift+R`.

## Theme selection

Set `M.theme` in `config.lua` to `"tokyonight_night"` (default) or `"gruvbox"`.
The selection controls terminal colors, tabs, workspace, resize indicator and status.
The bundled `colors/tokyonight_night.toml` comes from
[folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim/blob/main/extras/wezterm/tokyonight_night.toml).
It does not require a Neovim installation at runtime.

## References

- [WezTerm Official Documentation](https://wezfurlong.org/wezterm/)
- [WezTerm Configuration Examples](https://wezfurlong.org/wezterm/config/files.html)

