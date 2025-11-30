#!/bin/bash
# Configure Rofi shortcuts in KDE

echo "🚀 Configuring Rofi shortcuts..."
echo ""

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo "❌ Rofi is not installed!"
    echo "Install with: sudo apt install rofi"
    exit 1
fi

# Get rofi path
ROFI_PATH=$(which rofi)
ROFI_CONFIG="$HOME/dotfiles/linux/rofi/config.rasi"

echo "✅ Rofi found at: $ROFI_PATH"
echo "✅ Config: $ROFI_CONFIG"
echo ""

# Note: KDE doesn't support setting custom shortcuts via kwriteconfig5 easily
# These need to be added manually via System Settings
echo "📝 To add Rofi shortcuts manually:"
echo ""
echo "1. Open System Settings → Shortcuts → Custom Shortcuts"
echo "2. Click 'Edit' → 'New' → 'Global Shortcut' → 'Command/URL'"
echo ""
echo "3. Add these shortcuts:"
echo ""
echo "   ┌─────────────────────────────────────────────────────────"
echo "   │ Name: Rofi Application Launcher"
echo "   │ Trigger: Super+P (or your preferred key)"
echo "   │ Command: rofi -show drun -config $ROFI_CONFIG"
echo "   └─────────────────────────────────────────────────────────"
echo ""
echo "   ┌─────────────────────────────────────────────────────────"
echo "   │ Name: Rofi Window Switcher"
echo "   │ Trigger: Super+Z (or your preferred key)"
echo "   │ Command: rofi -show window -config $ROFI_CONFIG"
echo "   └─────────────────────────────────────────────────────────"
echo ""
echo "   ┌─────────────────────────────────────────────────────────"
echo "   │ Name: Rofi Run Command"
echo "   │ Trigger: Super+R (or your preferred key)"
echo "   │ Command: rofi -show run -config $ROFI_CONFIG"
echo "   └─────────────────────────────────────────────────────────"
echo ""
echo "4. Click 'Apply' to save"
echo ""
echo "💡 Tip: You can also use KRunner (Alt+Space) as a native KDE alternative!"

