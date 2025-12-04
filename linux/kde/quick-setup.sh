#!/bin/bash
# Quick setup script - runs all KDE configuration steps in order

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  KDE Plasma Quick Setup - Awesome WM → KDE Migration     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Basic KDE setup
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Step 1/4: Basic KDE Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/setup-kde.sh"
echo ""
read -p "Press Enter to continue..."
echo ""

# Step 2: Configure keyboard shortcuts
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⌨️  Step 2/4: Keyboard Shortcuts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/configure-shortcuts.sh"
echo ""
read -p "Press Enter to continue..."
echo ""

# Step 3: Install autostart
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Step 3/4: Autostart Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
mkdir -p ~/.config/autostart
cp "$SCRIPT_DIR/autostart-settings.desktop" ~/.config/autostart/
echo "✅ Autostart installed"
bash "$SCRIPT_DIR/autostart-settings.sh"
echo ""
read -p "Press Enter to continue..."
echo ""

# Step 4: Install OneDark theme
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎨 Step 4/4: OneDark Theme (manual installation)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/install-onedark-theme.sh"
echo ""

# Summary
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  ✅ Quick Setup Complete!                                 ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "📝 What was configured:"
echo "   ✅ 4 virtual desktops"
echo "   ✅ Keyboard repeat rate (200ms, 35/sec)"
echo "   ✅ CapsLock → Escape remapping"
echo "   ✅ Kitty as default terminal"
echo "   ✅ Basic keyboard shortcuts"
echo "   ✅ Autostart settings"
echo "   ✅ Mouse acceleration (-0.3)"
echo ""
echo "📋 Manual steps remaining:"
echo "   1. Configure OneDark theme (System Settings → Appearance)"
echo "   2. Configure panel (right-click panel → Enter Edit Mode)"
echo "   3. Configure fonts (System Settings → Appearance → Fonts)"
echo "   4. Optional: Use KRunner (Alt+Space) as application launcher"
echo "   5. Optional: Install Bismuth tiling (./install-bismuth.sh)"
echo ""
echo "🔄 Important: Log out and log back in for all changes to take effect!"
echo ""
echo "📚 See PIKAOPAS.md or README.md for detailed instructions: $SCRIPT_DIR/"

