#!/bin/bash
# KDE Plasma Setup Script
# Configures KDE settings to match Awesome WM workflow

echo "🚀 Starting KDE Plasma configuration..."

# Configure 4 virtual desktops
echo "📊 Setting up 4 virtual desktops..."
kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 1

# Configure keyboard repeat rate
echo "⌨️  Configuring keyboard repeat rate (200ms delay, 35 chars/sec)..."
xset r rate 200 35

# Configure CapsLock -> Escape
echo "🔄 Remapping CapsLock to Escape..."
setxkbmap -option caps:escape

# Set Kitty as default terminal
echo "🖥️  Setting Kitty as default terminal..."
kwriteconfig5 --file kdeglobals --group General --key TerminalApplication "/home/$USER/.local/kitty.app/bin/kitty"
kwriteconfig5 --file kdeglobals --group General --key TerminalService "kitty.desktop"

# Configure window focus policy (focus follows mouse, optional)
# Uncomment if you want focus-follows-mouse like in Awesome WM
# kwriteconfig5 --file kwinrc --group Windows --key FocusPolicy FocusFollowsMouse

# Disable compositor for better gaming performance (optional)
# Uncomment if you experience performance issues
# kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

# Apply changes
echo "♻️  Applying KWin configuration..."
qdbus org.kde.KWin /KWin reconfigure

echo "✅ KDE configuration complete!"
echo ""
echo "📝 Next steps:"
echo "1. Log out and log back in for all changes to take effect"
echo "2. Configure keyboard shortcuts manually: System Settings → Shortcuts"
echo "3. Install OneDark theme from KDE Store"
echo "4. Install Bismuth for tiling: sudo apt install kwin-bismuth"
echo "5. Configure panel and widgets manually"

