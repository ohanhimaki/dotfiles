# Zebar Custom Widget

This directory contains custom widget configuration for Zebar, a status bar for GlazeWM.

## Structure

```
zebar/
├── settings.json           # Main Zebar configuration
├── custom-bar/            # Custom widget directory
│   ├── index.html        # Widget HTML/CSS/JS
│   └── widget.json       # Widget metadata
└── .marketplace/          # Marketplace packages metadata
```

## Custom Bar Widget

The custom bar includes:
- **Clock** with format: `hh:mm:ss dd.mm.yyyy` (e.g., `14:30:45 22.12.2024`)
- **Workspaces** indicator (1-9)
- **System info** display

### Features

- Semi-transparent background with blur effect
- Blue accent color matching GlazeWM theme (#8dbcff)
- Responsive design
- Updates every second

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

