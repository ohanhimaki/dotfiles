#!/bin/bash

# Backup script for Linux Mint dotfiles
# Run this before committing changes to update your dotfiles with current system settings

echo "Backing up Linux configuration files..."

# Gnome Terminal settings
echo "Backing up Gnome Terminal settings..."
dconf dump /org/gnome/terminal/ > ~/dotfiles/linux/gnome-terminal-settings.dconf

# Detect current desktop environment
if [ "$XDG_CURRENT_DESKTOP" = "X-Cinnamon" ]; then
    echo "Backing up Cinnamon desktop settings..."
    dconf dump /org/cinnamon/ > ~/dotfiles/linux/cinnamon/cinnamon-settings.dconf
    echo "  - linux/cinnamon/cinnamon-settings.dconf"
elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    echo "Backing up GNOME desktop settings..."
    dconf dump /org/gnome/ > ~/dotfiles/linux/gnome/gnome-settings.dconf
    echo "  - linux/gnome/gnome-settings.dconf"
else
    echo "Unknown desktop environment: $XDG_CURRENT_DESKTOP"
    echo "Skipping DE-specific backup..."
fi

echo ""
echo "Backup complete! Files updated:"
echo "  - linux/gnome-terminal-settings.dconf"
echo ""
echo "Don't forget to commit and push your changes!"
