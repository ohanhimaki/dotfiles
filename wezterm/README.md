# WezTerm Configuration

This directory contains WezTerm terminal emulator configuration.

## Features

- **OneDark Color Scheme**: Custom OneDark color palette defined explicitly for maximum compatibility
- **Custom Font**: JetBrains Mono / Fira Code / Cascadia Code with fallback to Consolas
- **Opacity**: 95% window background opacity for a modern look
- **Tab Bar**: Visible tab bar with OneDark themed colors
- **Flexible Shell**: Uses WezTerm's default shell detection (no hardcoded shell path)
- **Error Resilient**: Configuration includes proper error handling and fallbacks

## Keybindings

### Pane Management
- `Ctrl+Shift+-`: Split pane vertically
- `Ctrl+Shift+|`: Split pane horizontally
- `Ctrl+Shift+H`: Navigate to left pane
- `Ctrl+Shift+L`: Navigate to right pane
- `Ctrl+Shift+K`: Navigate to upper pane
- `Ctrl+Shift+J`: Navigate to lower pane
- `Ctrl+Shift+W`: Close current pane (with confirmation)

### Copy/Paste
- `Ctrl+Shift+C`: Copy to clipboard
- `Ctrl+Shift+V`: Paste from clipboard

### Mouse
- **Left Click**: Select text
- **Ctrl+Left Click**: Open link under cursor

## Configuration File Location

After running `bootstrap.ps1`, the configuration will be symlinked to:
- `%USERPROFILE%\.config\wezterm\wezterm.lua`

## Installation

Run the bootstrap script with at least "Minimal" profile:
```powershell
.\bootstrap.ps1 -Profile Minimal
```

This will:
1. Install WezTerm via winget
2. Symlink the configuration file to the correct location

## Customization

Edit `wezterm/wezterm.lua` to customize:
- Font family and size
- Color scheme
- Window opacity
- Keybindings
- Default shell

After making changes, restart WezTerm or reload configuration with `Ctrl+Shift+R`.

## OneDark Theme Colors

The OneDark color scheme matches other applications in this dotfiles setup:
- Background: `#282c34`
- Foreground: `#abb2bf`
- Active Tab: `#61afef` (blue)
- Inactive Tab: `#3e4451` (dark gray)

## References

- [WezTerm Official Documentation](https://wezfurlong.org/wezterm/)
- [WezTerm Configuration Examples](https://wezfurlong.org/wezterm/config/files.html)

