#!/bin/bash
# Configure KDE keyboard shortcuts to match Awesome WM
# Note: Some shortcuts need to be configured manually via System Settings

echo "⌨️  Configuring KDE keyboard shortcuts..."
echo ""
echo "⚠️  Note: This script sets some basic shortcuts, but many need manual configuration"
echo "    Go to: System Settings → Shortcuts → Global Shortcuts → KWin"
echo ""

# Window Management Shortcuts
echo "🪟 Configuring window management shortcuts..."

# Close window: Super+Q
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Close" "Meta+Q,Alt+F4,Close Window"

# Maximize window: Super+M
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+M,Meta+PgUp,Maximize Window"

# Fullscreen: Super+F
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Fullscreen" "Meta+F,,Make Window Fullscreen"

# Launch Kitty terminal: Super+Return
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Kitty" "Meta+Return,none,Launch Kitty"

# Virtual Desktop Shortcuts
echo "🖥️  Configuring virtual desktop shortcuts..."

# Switch to desktop 1-4: Super+1/2/3/4
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop 1" "Meta+1,none,Switch to Desktop 1"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop 2" "Meta+2,none,Switch to Desktop 2"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop 3" "Meta+3,none,Switch to Desktop 3"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop 4" "Meta+4,none,Switch to Desktop 4"

# Switch to next/previous desktop
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Next Desktop" "Meta+D,Meta+Right,none,Switch to Next Desktop"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Previous Desktop" "Meta+A,Meta+Left,none,Switch to Previous Desktop"

# Move window to desktop 1-4: Super+Shift+1/2/3/4
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window to Desktop 1" "Meta+Shift+1,none,Window to Desktop 1"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window to Desktop 2" "Meta+Shift+2,none,Window to Desktop 2"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window to Desktop 3" "Meta+Shift+3,none,Window to Desktop 3"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window to Desktop 4" "Meta+Shift+4,none,Window to Desktop 4"

# Apply changes
echo "♻️  Applying changes..."
qdbus org.kde.KWin /KWin reconfigure

echo ""
echo "✅ Basic shortcuts configured!"
echo ""
echo "📝 Manual configuration needed for:"
echo "   - Window tiling shortcuts (Super+J/K/H/L) - Configure after installing Bismuth"
echo "   - Application launchers (Super+P for Rofi, etc.)"
echo "   - Custom commands (System Settings → Shortcuts → Custom Shortcuts)"
echo ""
echo "Go to: System Settings → Shortcuts to verify and add more shortcuts"

