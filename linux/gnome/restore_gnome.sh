#!/bin/bash

# Restore GNOME desktop settings from dotfiles

echo "Restoring GNOME desktop settings..."

# Check if settings file exists
if [ ! -f ~/dotfiles/linux/gnome/gnome-settings.dconf ]; then
    echo "Error: gnome-settings.dconf not found!"
    exit 1
fi

# Restore GNOME settings
dconf load /org/gnome/ < ~/dotfiles/linux/gnome/gnome-settings.dconf

echo ""
echo "GNOME settings restored!"
echo ""
echo "Note: You may need to restart GNOME Shell:"
echo "  - Press Alt+F2, type 'r', press Enter (X11 only)"
echo "  - Or log out and log back in"
