# Zebar Configuration

This directory contains Zebar configuration, a customizable status bar for GlazeWM.

## Structure

```
zebar/
├── settings.json                  # Main Zebar configuration
├── glzr-io.starter@0.0.0/        # Official starter pack (currently active)
│   ├── with-glazewm.html         # Widget with GlazeWM integration
│   ├── onedark-glazewm.html      # OneDark themed GlazeWM widget
│   ├── styles.css                # Original widget styles
│   ├── onedark-styles.css        # OneDark theme styles
│   └── zpack.json                # Pack metadata
└── my-widget-pack/                # Custom widget pack
    └── zpack.json                 # Pack metadata
```

## Current Setup

Currently using the **starter** pack with the **onedark-glazewm** widget, featuring OneDark color theme:

### Features

- **OneDark Theme**: Matches OneDark color scheme used in popular editors
  - Background: `#282c34`
  - Foreground: `#abb2bf`
  - Accent colors: Blue (`#61afef`), Cyan (`#56b6c2`), Green (`#98c379`), etc.
- **Workspaces** indicator with focus/display states
- **Date/Time** display in cyan
- **System info**: Network (green), CPU (cyan), Memory (magenta), Battery (yellow)
- **Tiling direction** toggle
- **Binding modes** and pause state indicators
- Full GlazeWM integration
- Real-time system metrics
- Interactive workspace switching

## Switching Themes

To switch between the OneDark theme and the original starter theme, edit `settings.json`:

### Use OneDark Theme (Current)
```json
{
  "pack": "starter",
  "widget": "onedark-glazewm",
  "preset": "default"
}
```

### Use Original Starter Theme
```json
{
  "pack": "starter",
  "widget": "with-glazewm",
  "preset": "default"
}
```

After changing the theme, restart Zebar or reload GlazeWM for changes to take effect.

## Usage

After running `bootstrap.ps1`, Zebar will automatically:
1. Start with GlazeWM (configured in `glazewm/config.yaml`)
2. Load the custom widget from `custom-bar/index.html`
3. Display at the top of your screen

## Customization

To modify the widget:

1. Edit `custom-bar/index.html` for appearance and functionality
2. Reload GlazeWM with `Alt+Shift+R` to see changes

### Clock Format

The clock format is defined in the `updateClock()` function:

```javascript
const hh = String(now.getHours()).padStart(2, '0');
const mm = String(now.getMinutes()).padStart(2, '0');
const ss = String(now.getSeconds()).padStart(2, '0');
const dd = String(now.getDate()).padStart(2, '0');
const MM = String(now.getMonth() + 1).padStart(2, '0');
const yyyy = now.getFullYear();
```

### Colors

- Primary accent: `#8dbcff` (blue)
- Secondary text: `#a1a1a1` (gray)
- Background: `rgba(0, 0, 0, 0.8)` (semi-transparent black)

## Troubleshooting

If the widget doesn't appear:
1. Ensure Zebar is installed: `winget install glzr-io.zebar`
2. Run `bootstrap.ps1` to symlink configuration files
3. Restart GlazeWM with `Alt+Shift+E` (exit) and relaunch
4. Check Zebar logs in `%USERPROFILE%\.glzr\zebar\logs\`

## References

- [Zebar Documentation](https://github.com/glzr-io/zebar)
- [GlazeWM Documentation](https://github.com/glzr-io/glazewm)

