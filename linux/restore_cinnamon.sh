#!/bin/bash

# Restore Cinnamon desktop settings from dotfiles

echo "Restoring Cinnamon desktop settings..."

# Check if settings file exists
if [ ! -f ~/dotfiles/linux/cinnamon-settings.dconf ]; then
    echo "Error: cinnamon-settings.dconf not found!"
    exit 1
fi

# Restore Cinnamon settings
dconf load /org/cinnamon/ < ~/dotfiles/linux/cinnamon-settings.dconf

echo ""
echo "Cinnamon settings restored!"
echo ""
echo "Note: You may need to restart Cinnamon for all changes to take effect:"
echo "  - Press Ctrl+Alt+Esc to restart Cinnamon"
echo "  - Or log out and log back in"
