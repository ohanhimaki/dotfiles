#!/bin/bash

# GNOME Desktop Setup Script
# Installs essential tools and tweaks for a better GNOME experience

set -e

echo "=== GNOME Desktop Setup ==="
echo ""

# Install GNOME Tweaks and Extension Manager
echo "Installing GNOME Tweaks and Extension Manager..."
sudo apt install -y gnome-tweaks gnome-shell-extension-manager

# Install useful GNOME Shell Extensions from apt
echo "Installing some GNOME extensions..."
sudo apt install -y gnome-shell-extension-appindicator gnome-shell-extension-desktop-icons-ng

# Apply performance and usability tweaks
echo ""
echo "Applying GNOME tweaks..."

# Enable fractional scaling for better HiDPI support
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
echo "✓ Enabled fractional scaling"

# Add minimize and maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
echo "✓ Added minimize/maximize buttons"

# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true
echo "✓ Enabled battery percentage"

# Enable middle-click paste
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true
echo "✓ Enabled middle-click paste"

# Hot corner (top-left) for Activities
gsettings set org.gnome.desktop.interface enable-hot-corners true
echo "✓ Enabled hot corners"

# Set favorite apps in dash (customize as needed)
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'code.desktop', 'org.gnome.Terminal.desktop', 'spotify.desktop']"
echo "✓ Set favorite apps"

# Better font rendering
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'
echo "✓ Improved font rendering"

# Disable screen blank (useful for gaming/streaming)
gsettings set org.gnome.desktop.session idle-delay 0
echo "✓ Disabled screen blanking"

# Workspaces on all monitors
gsettings set org.gnome.mutter workspaces-only-on-primary false
echo "✓ Workspaces on all monitors"

# Center new windows
gsettings set org.gnome.mutter center-new-windows true
echo "✓ Center new windows"

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "📦 Next steps:"
echo "1. Open 'Extension Manager' to install more extensions:"
echo "   - Dash to Panel (Windows-like taskbar)"
echo "   - Blur My Shell (pretty blur effects)"
echo "   - Vitals (system monitor in top bar)"
echo "   - Just Perfection (customize UI)"
echo ""
echo "2. Open 'Tweaks' to customize:"
echo "   - Appearance (themes, icons)"
echo "   - Fonts"
echo "   - Top Bar"
echo "   - Window Titlebars"
echo ""
echo "3. Restart GNOME Shell:"
echo "   - Log out and log back in"
echo "   - Or press Alt+F2, type 'r', press Enter (X11 only)"
echo ""
echo "4. Run './linux/backup.sh' to save your GNOME settings!"
