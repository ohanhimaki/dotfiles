#!/bin/bash
# Restore KDE configuration files from dotfiles repo

echo "♻️  Restoring KDE configuration files..."

# KDE config directory
KDE_CONFIG="$HOME/.config"
DOTFILES_KDE="$HOME/dotfiles/linux/kde"

# Check if configs directory exists
if [ ! -d "$DOTFILES_KDE/configs" ]; then
    echo "❌ Error: configs directory not found at $DOTFILES_KDE/configs/"
    echo "Run ./backup_kde.sh first to create a backup."
    exit 1
fi

# Backup current configs before restoring (just in case)
BACKUP_DIR="$HOME/.kde-config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "📦 Creating safety backup of current configs to: $BACKUP_DIR"

# Restore each config file
for config in "$DOTFILES_KDE/configs"/*; do
    if [ -f "$config" ]; then
        filename=$(basename "$config")

        # Backup current file if it exists
        if [ -f "$KDE_CONFIG/$filename" ]; then
            cp "$KDE_CONFIG/$filename" "$BACKUP_DIR/"
        fi

        # Restore from dotfiles
        cp "$config" "$KDE_CONFIG/"
        echo "✅ Restored: $filename"
    fi
done

echo ""
echo "♻️  Applying configuration changes..."

# Reconfigure KWin
qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || echo "⚠️  KWin reconfigure failed (not running?)"

# Restart Plasma Shell to apply panel/widget changes
# Uncomment if you want automatic restart (will briefly show desktop)
# killall plasmashell && plasmashell &

echo ""
echo "✅ Restore complete!"
echo ""
echo "📝 Next steps:"
echo "1. Log out and log back in for all changes to take effect"
echo "   OR run: plasmashell --replace & (to restart Plasma Shell now)"
echo "2. Your old configs are backed up at: $BACKUP_DIR"

