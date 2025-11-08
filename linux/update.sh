#!/bin/bash

echo "🔄 Updating all packages and applications..."
echo "========================================"

# Update APT packages
echo "📦 Updating APT packages..."
sudo apt update && sudo apt upgrade -y

# Update Flatpak apps
if command -v flatpak &> /dev/null; then
    echo ""
    echo "📱 Updating Flatpak applications..."
    flatpak update -y
else
    echo "📱 Flatpak not installed, skipping..."
fi

# Update Snap packages
if command -v snap &> /dev/null; then
    echo ""
    echo "📦 Updating Snap packages..."
    sudo snap refresh
else
    echo "📦 Snap not installed, skipping..."
fi

# Update Node.js packages globally
if command -v npm &> /dev/null; then
    echo ""
    echo "🟢 Updating global npm packages..."
    npm update -g
else
    echo "🟢 npm not installed, skipping..."
fi

# Clean up old packages
echo ""
echo "🧹 Cleaning up old packages..."
sudo apt autoremove -y
sudo apt autoclean

# Optional: Update firmware
echo ""
read -p "Update firmware? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💾 Updating firmware..."
    echo "⚠️  Warning: Do not power off during firmware update!"
    
    # Check if laptop and battery level
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        battery_level=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "unknown")
        echo "🔋 Battery level: ${battery_level}%"
        if [ "$battery_level" != "unknown" ] && [ "$battery_level" -lt 30 ]; then
            echo "⚠️  Low battery! Consider plugging in charger first."
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Skipping firmware update for safety."
                exit 0
            fi
        fi
    fi
    
    sudo fwupdmgr update
fi

echo ""
echo "✅ All updates completed!"
echo ""
echo "📊 System information:"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"