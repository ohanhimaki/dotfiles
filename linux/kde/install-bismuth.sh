#!/bin/bash
# Install and configure Bismuth tiling for KDE

echo "🪟 Installing Bismuth tiling extension for KDE..."
echo ""

# Check if already installed
if dpkg -l | grep -q kwin-bismuth; then
    echo "✅ Bismuth is already installed!"
else
    echo "📦 Installing kwin-bismuth..."
    sudo apt install -y kwin-bismuth

    if [ $? -eq 0 ]; then
        echo "✅ Bismuth installed successfully!"
    else
        echo "❌ Failed to install Bismuth"
        echo "Try manually: sudo apt install kwin-bismuth"
        exit 1
    fi
fi

echo ""
echo "♻️  Restarting KWin to load Bismuth..."
kwin_x11 --replace &
sleep 2

echo ""
echo "⚙️  Enabling Bismuth KWin script..."
# Enable Bismuth script
kwriteconfig5 --file kwinrc --group Plugins --key bismuthEnabled true

# Apply changes
qdbus org.kde.KWin /KWin reconfigure

echo ""
echo "✅ Bismuth installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Log out and log back in (or wait a moment for KWin to reload)"
echo "2. Verify Bismuth is running:"
echo "   - System Settings → Window Management → KWin Scripts"
echo "   - 'Bismuth' should be checked"
echo "3. Configure Bismuth shortcuts (optional):"
echo "   - Open Bismuth settings: qdbus org.kde.bismuth /Bismuth org.kde.bismuth.showSettings"
echo ""
echo "🎮 Default Bismuth shortcuts:"
echo "   Meta+\\ - Cycle layouts"
echo "   Meta+J/K - Focus next/previous window"
echo "   Meta+Shift+J/K - Move window down/up"
echo "   Meta+H/L - Shrink/grow master"
echo "   Meta+Shift+Return - Swap with master"
echo "   Meta+T - Toggle tiling for current window"
echo ""
echo "📖 More info: https://github.com/Bismuth-Forge/bismuth"

