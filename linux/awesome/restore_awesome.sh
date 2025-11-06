#!/bin/bash

echo "Restoring Awesome WM configuration..."

# Create config directory if it doesn't exist
mkdir -p ~/.config/awesome

# Create symlink for rc.lua
ln -sf ~/dotfiles/linux/awesome/rc.lua ~/.config/awesome/rc.lua

echo "Awesome WM configuration restored!"
echo "Note: You may need to restart Awesome WM (Mod4+Ctrl+R) or log out and back in."
