#!/bin/bash
# Install OneDark theme for KDE Plasma

echo "🎨 Installing OneDark theme for KDE Plasma..."
echo ""

# OneDark color values
echo "📝 OneDark color scheme:"
echo "   Background: #282c34 / #21252b"
echo "   Foreground: #abb2bf"
echo "   Accent: #61afef (blue)"
echo "   Red: #e06c75"
echo "   Green: #98c379"
echo "   Yellow: #e5c07b"
echo "   Purple: #c678dd"
echo "   Cyan: #56b6c2"
echo ""

# Check for existing OneDark themes
echo "🔍 Searching for OneDark themes in KDE Store..."
echo ""
echo "📦 Installation options:"
echo ""
echo "Option 1: Install from KDE Store (Recommended)"
echo "   1. Open System Settings → Appearance → Colors"
echo "   2. Click 'Get New Color Schemes...'"
echo "   3. Search for 'OneDark' or 'One Dark'"
echo "   4. Install a theme (popular ones: 'OneDark', 'Atom One Dark')"
echo "   5. Apply the theme"
echo ""
echo "Option 2: Install via command line"
echo "   Search available themes:"
echo "   kpackagetool5 --type Plasma/LookAndFeel --list"
echo ""
echo "Option 3: Manual installation"
echo "   Download .colors file from KDE Store and place in:"
echo "   ~/.local/share/color-schemes/"
echo ""

# Offer to set Breeze Dark as a temporary alternative
echo "🌙 Alternative: Use Breeze Dark (pre-installed)"
read -p "Would you like to set Breeze Dark now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Setting Breeze Dark..."
    lookandfeeltool -a org.kde.breezedark.desktop
    echo "✅ Breeze Dark applied!"
    echo "You can switch to OneDark later from System Settings"
fi

echo ""
echo "📝 Additional theming:"
echo ""
echo "Plasma Theme (window decorations, panel):"
echo "   System Settings → Appearance → Plasma Style"
echo "   Search for OneDark themes or use Breeze Dark"
echo ""
echo "Window Decorations:"
echo "   System Settings → Appearance → Window Decorations"
echo "   Recommended: Breeze (with minimal borders)"
echo ""
echo "GTK Theme (for GTK apps):"
echo "   System Settings → Appearance → Application Style → Configure GNOME/GTK..."
echo "   Try 'Adwaita-dark' or search for OneDark GTK themes"
echo ""
echo "Kvantum (advanced Qt theming - optional):"
echo "   sudo apt install kvantum"
echo "   Search for OneDark Kvantum themes"
echo ""
echo "✅ Theme installation guide complete!"

