# KDE Plasma Configuration

This directory contains KDE Plasma configuration files and setup scripts for migrating from Awesome WM.

## 📁 Files

- **migration-plan.md** - Comprehensive migration guide from Awesome WM to KDE Plasma
- **setup-kde.sh** - Initial KDE setup script (run once)
- **autostart-settings.sh** - Autostart script for keyboard/mouse settings
- **configure-shortcuts.sh** - Configure keyboard shortcuts
- **backup_kde.sh** - Backup current KDE configuration
- **restore_kde.sh** - Restore KDE configuration from dotfiles
- **configs/** - Directory containing backed up KDE config files

## 🚀 Quick Start

### Option 1: Automatic Setup (Recommended)

Run the quick setup script that does everything for you:

```bash
cd ~/dotfiles/linux/kde
./quick-setup.sh
```

This interactive script will:
- Configure 4 virtual desktops
- Set keyboard repeat rate and CapsLock remapping
- Set Kitty as default terminal
- Configure basic keyboard shortcuts
- Install autostart settings
- Offer to install Bismuth tiling
- Show instructions for Rofi and OneDark theme

After the script finishes, **log out and log back in** for all changes to take effect.

### Option 2: Manual Step-by-Step Setup

If you prefer to configure manually:

1. **Run the basic setup:**
   ```bash
   cd ~/dotfiles/linux/kde
   ./setup-kde.sh
   ```

2. **Configure keyboard shortcuts:**
   ```bash
   ./configure-shortcuts.sh
   ```

3. **Install autostart settings:**
   ```bash
   mkdir -p ~/.config/autostart
   cp autostart-settings.desktop ~/.config/autostart/
   ```

4. **Install Bismuth (optional):**
   ```bash
   ./install-bismuth.sh
   ```

5. **Configure Rofi shortcuts:**
   ```bash
   ./configure-rofi-shortcuts.sh
   ```

6. **Install OneDark theme:**
   ```bash
   ./install-onedark-theme.sh
   ```

7. **Log out and log back in** for all changes to take effect

### Manual Configuration Steps

After running the scripts, configure these manually:

1. **Theme (OneDark):**
   - System Settings → Appearance → Colors
   - Search KDE Store for "OneDark" themes

2. **Fonts:**
   - System Settings → Appearance → Fonts
   - Set all to FiraCode Nerd Font (10pt)

3. **Panel:**
   - Right-click panel → Enter Edit Mode
   - Move to top, adjust height (~24-28px)
   - Add widgets: Task Manager, System Tray, Clock, etc.

4. **Tiling (Bismuth):**
   ```bash
   # Install Bismuth
   sudo apt install kwin-bismuth
   # Or download from KDE Store
   ```
   - Enable in System Settings → Window Management → KWin Scripts
   - Configure shortcuts for tiling

5. **Virtual Desktops:**
   - System Settings → Workspace Behavior → Virtual Desktops
   - Verify 4 desktops are configured (should be set by setup script)

6. **Additional Shortcuts:**
   - System Settings → Shortcuts → Custom Shortcuts
   - Add custom commands (Rofi, etc.)

## 🔄 Backup & Restore

### Backup Current Configuration

After you've configured KDE to your liking:

```bash
cd ~/dotfiles/linux/kde
./backup_kde.sh
```

This backs up:
- kdeglobals (global KDE settings)
- kwinrc (window manager settings)
- kglobalshortcutsrc (keyboard shortcuts)
- plasma-org.kde.plasma.desktop-appletsrc (panel/widgets)
- And other important config files

**Commit the backed up configs to git:**
```bash
cd ~/dotfiles
git add linux/kde/configs/
git commit -m "Update KDE configuration"
git push
```

### Restore Configuration

On a new system or after reinstalling:

```bash
cd ~/dotfiles/linux/kde
./restore_kde.sh
```

Then log out and log back in.

## ⚙️ Configuration Details

### Keyboard Settings

- **Repeat rate:** 200ms delay, 35 chars/sec (gaming optimized)
- **CapsLock:** Remapped to Escape (Vim-friendly)
- Configured via `autostart-settings.sh`

### Mouse Settings

- **Logitech mouse:** Acceleration speed -0.3
- Configured via `autostart-settings.sh`
- Device detected automatically by name

### Virtual Desktops

- **Count:** 4 desktops
- **Layout:** 1 row × 4 columns
- **Shortcuts:** Super+1/2/3/4 to switch

## 🎨 Theme (OneDark)

### Colors
- Background: `#282c34` / `#21252b`
- Foreground: `#abb2bf`
- Accent: `#61afef` (blue)
- Red: `#e06c75`
- Green: `#98c379`
- Yellow: `#e5c07b`
- Purple: `#c678dd`
- Cyan: `#56b6c2`

### Font
- **Family:** FiraCode Nerd Font Mono
- **Size:** 10pt (9pt for small text)

## 🪟 Window Management

### Tiling

**Recommended:** Bismuth KWin script
- Dynamic tiling like Awesome WM
- Multiple layouts: tile, monocle, etc.
- Keyboard-driven

**Alternative:** KDE native tiling (Plasma 5.27+)
- System Settings → Window Management → Window Behavior → Window Tiling

### Keyboard Shortcuts (After Configuration)

| Shortcut | Action |
|----------|--------|
| `Super + Q` | Close window |
| `Super + M` | Maximize window |
| `Super + F` | Fullscreen |
| `Super + Return` | Launch Kitty terminal |
| `Super + 1/2/3/4` | Switch to desktop 1/2/3/4 |
| `Super + A / Left` | Previous desktop |
| `Super + D / Right` | Next desktop |
| `Super + Shift + 1/2/3/4` | Move window to desktop |
| `Super + J/K` | Focus next/previous window (Bismuth) |
| `Super + H/L` | Shrink/grow master (Bismuth) |
| `Alt + Tab` | Window switcher |

## 📦 Required Packages

```bash
# KDE Plasma (already installed on Linux Mint KDE edition)
sudo apt install kde-plasma-desktop

# Tiling (optional but recommended)
sudo apt install kwin-bismuth

# Already installed from Awesome WM setup
# - rofi
# - kitty
# - playerctl
# - brightnessctl
```

## 🎮 Gaming (RTX 4060)

- **Compositor:** Automatically suspends during fullscreen games
- **NVIDIA drivers:** Installed via Linux Mint Driver Manager
- **Verify:** `nvidia-smi`
- **Settings:** System Settings → Display and Monitor → Compositor
  - Backend: OpenGL 3.1+
  - VSync: Automatic

## 🔗 Useful Commands

```bash
# Restart KWin (window manager)
kwin_x11 --replace &

# Restart Plasma Shell (panel/widgets)
plasmashell --replace &

# Reconfigure KWin
qdbus org.kde.KWin /KWin reconfigure

# List installed KWin scripts
kpackagetool5 --type KWin/Script --list

# Install KWin script
kpackagetool5 --type KWin/Script -i <script.kwinscript>

# Read config value
kreadconfig5 --file kdeglobals --group General --key ColorScheme

# Write config value
kwriteconfig5 --file kwinrc --group Windows --key FocusPolicy FocusFollowsMouse
```

## 📚 Resources

- [Migration Plan](./migration-plan.md) - Detailed migration guide
- [KDE Plasma Docs](https://userbase.kde.org/Plasma)
- [Bismuth GitHub](https://github.com/Bismuth-Forge/bismuth)
- [KDE Store](https://store.kde.org/) - Themes, widgets, scripts

## ✅ Success Checklist

- [x] KDE Plasma installed
- [ ] 4 virtual desktops configured
- [ ] Keyboard shortcuts working
- [ ] OneDark theme applied
- [ ] Kitty set as default terminal
- [ ] Fonts configured (FiraCode)
- [ ] Panel configured with widgets
- [ ] Tiling working (Bismuth or native)
- [ ] Autostart settings working
- [ ] Configuration backed up

---

**Last updated:** 2025-11-30

