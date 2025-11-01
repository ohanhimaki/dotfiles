#!/bin/bash

# Backup script for Linux Mint dotfiles
# Run this before committing changes to update your dotfiles with current system settings

echo "Backing up Linux Mint configuration files..."

# Gnome Terminal settings
echo "Backing up Gnome Terminal settings..."
dconf dump /org/gnome/terminal/ > ~/dotfiles/linux/gnome-terminal-settings.dconf

# Cinnamon desktop settings (panels, applets, themes, keyboard shortcuts, etc.)
echo "Backing up Cinnamon desktop settings..."
dconf dump /org/cinnamon/ > ~/dotfiles/linux/cinnamon-settings.dconf

echo ""
echo "Backup complete! Files updated:"
echo "  - linux/gnome-terminal-settings.dconf"
echo "  - linux/cinnamon-settings.dconf"
echo ""
echo "Don't forget to commit and push your changes!"
