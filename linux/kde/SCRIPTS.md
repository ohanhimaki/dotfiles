# KDE Configuration Scripts

This document lists all available scripts and their purposes.

## 🚀 Main Scripts

### quick-setup.sh
**Purpose:** Interactive setup that runs all configuration steps in order
**Usage:** `./quick-setup.sh`
**Description:** The easiest way to configure KDE. Walks you through all setup steps with prompts.

### setup-kde.sh
**Purpose:** Initial KDE configuration (virtual desktops, keyboard, terminal)
**Usage:** `./setup-kde.sh`
**Description:** Sets up 4 virtual desktops, keyboard repeat rate, CapsLock→Escape, and sets Kitty as default terminal.

### configure-shortcuts.sh
**Purpose:** Configure basic keyboard shortcuts
**Usage:** `./configure-shortcuts.sh`
**Description:** Sets up window management and virtual desktop shortcuts to match Awesome WM.

### autostart-settings.sh
**Purpose:** Apply custom settings at startup
**Usage:** Runs automatically at KDE startup (or run manually: `./autostart-settings.sh`)
**Description:** Applies keyboard rate, CapsLock remapping, mouse acceleration, and disables DPMS.

## 🪟 Tiling & Window Management

### install-bismuth.sh
**Purpose:** Install and enable Bismuth tiling extension
**Usage:** `./install-bismuth.sh`
**Description:** Installs Bismuth from apt and enables the KWin script for dynamic tiling.

## 🚀 Application Launchers

### configure-rofi-shortcuts.sh
**Purpose:** Display instructions for adding Rofi shortcuts
**Usage:** `./configure-rofi-shortcuts.sh`
**Description:** Shows how to add Rofi shortcuts manually in KDE System Settings.

## 🎨 Theming

### install-onedark-theme.sh
**Purpose:** Instructions for installing OneDark theme
**Usage:** `./install-onedark-theme.sh`
**Description:** Shows various methods to install OneDark color scheme and related themes.

## 💾 Backup & Restore

### backup_kde.sh
**Purpose:** Backup current KDE configuration to dotfiles
**Usage:** `./backup_kde.sh`
**Description:** Copies important KDE config files from ~/.config/ to ./configs/ directory.

### restore_kde.sh
**Purpose:** Restore KDE configuration from dotfiles
**Usage:** `./restore_kde.sh`
**Description:** Restores KDE configs from ./configs/ directory to ~/.config/.

## 📋 Configuration Files

### autostart-settings.desktop
**Purpose:** KDE autostart entry
**Location:** Copy to `~/.config/autostart/`
**Description:** Makes autostart-settings.sh run at KDE startup.

## 📚 Documentation

### README.md
Complete setup guide with detailed instructions for all configuration aspects.

### migration-plan.md
Comprehensive migration plan from Awesome WM to KDE Plasma with checklists and references.

### SCRIPTS.md (this file)
Quick reference for all available scripts.

## 🔄 Typical Workflow

### First Time Setup
```bash
cd ~/dotfiles/linux/kde
./quick-setup.sh  # Interactive setup
# Log out and log back in
```

### After Making Changes
```bash
./backup_kde.sh  # Backup your configuration
cd ~/dotfiles
git add linux/kde/configs/
git commit -m "Update KDE configuration"
git push
```

### On New System
```bash
cd ~/dotfiles/linux/kde
./quick-setup.sh  # Initial setup
./restore_kde.sh  # Restore your backed up configs
# Log out and log back in
```

## ⚡ Quick Commands

| What I want to do | Command |
|-------------------|---------|
| Setup everything quickly | `./quick-setup.sh` |
| Just the basic setup | `./setup-kde.sh` |
| Configure shortcuts | `./configure-shortcuts.sh` |
| Install tiling | `./install-bismuth.sh` |
| Backup my settings | `./backup_kde.sh` |
| Restore my settings | `./restore_kde.sh` |
| Apply autostart settings now | `./autostart-settings.sh` |
| Get Rofi instructions | `./configure-rofi-shortcuts.sh` |
| Get theme instructions | `./install-onedark-theme.sh` |

## 🛠️ Troubleshooting

### Changes not taking effect?
```bash
# Reconfigure KWin
qdbus org.kde.KWin /KWin reconfigure

# Or restart KWin
kwin_x11 --replace &

# Or log out and log back in (most reliable)
```

### Autostart not working?
```bash
# Check if desktop file exists
ls -la ~/.config/autostart/autostart-settings.desktop

# Check if script is executable
ls -la ~/dotfiles/linux/kde/autostart-settings.sh

# Test manually
bash ~/dotfiles/linux/kde/autostart-settings.sh
```

### Bismuth not working?
```bash
# Check if installed
dpkg -l | grep bismuth

# Check if enabled
kreadconfig5 --file kwinrc --group Plugins --key bismuthEnabled

# Enable manually
kwriteconfig5 --file kwinrc --group Plugins --key bismuthEnabled true
qdbus org.kde.KWin /KWin reconfigure
```

---

**Last updated:** 2025-11-30

