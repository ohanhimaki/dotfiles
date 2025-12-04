#!/bin/bash
# Backup KDE configuration files to dotfiles repo

echo "💾 Backing up KDE configuration files..."

# KDE config directory
KDE_CONFIG="$HOME/.config"
DOTFILES_KDE="$HOME/dotfiles/linux/kde"

# Create configs directory if it doesn't exist
mkdir -p "$DOTFILES_KDE/configs"

# List of important KDE config files to backup
CONFIG_FILES=(
    "kdeglobals"              # Global KDE settings
    "kwinrc"                  # KWin window manager settings
    "kglobalshortcutsrc"      # Global keyboard shortcuts
    "khotkeysrc"              # Custom hotkeys
    "plasma-org.kde.plasma.desktop-appletsrc"  # Panel and widgets
    "plasmarc"                # Plasma shell settings
    "plasmashellrc"           # Plasma shell configuration
    "kscreenlockerrc"         # Screen locker settings
    "powermanagementprofilesrc"  # Power management
    "ksmserverrc"             # Session management
    "kcminputrc"              # Input devices (keyboard, mouse)
    "kxkbrc"                  # Keyboard layouts
)

# Backup each config file
for config in "${CONFIG_FILES[@]}"; do
    if [ -f "$KDE_CONFIG/$config" ]; then
        cp "$KDE_CONFIG/$config" "$DOTFILES_KDE/configs/"
        echo "✅ Backed up: $config"
    else
        echo "⚠️  Not found: $config"
    fi
done

# Backup Bismuth settings if they exist
if [ -f "$KDE_CONFIG/kwinrc" ]; then
    echo "✅ KWin config (including Bismuth settings if any) backed up"
fi

echo ""
echo "✅ Backup complete!"
echo "📁 Configs saved to: $DOTFILES_KDE/configs/"
echo ""
echo "📝 To restore these settings, run: ./restore_kde.sh"

