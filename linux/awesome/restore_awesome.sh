#!/bin/bash

echo "Setting up Awesome WM configuration..."

# Install Awesome WM and dependencies
echo "Installing Awesome WM and dependencies..."
sudo apt install -y awesome arandr rofi pavucontrol playerctl i3lock-fancy imagemagick scrot

# Create configuration directories
echo "Creating configuration directories..."
mkdir -p ~/.config/awesome
mkdir -p ~/.config/awesome/themes

# Create symlink for entire Awesome WM configuration directory
echo "Creating symlink for Awesome WM configuration..."
# Remove existing config if it exists
rm -rf ~/.config/awesome
# Create symlink to entire awesome directory
ln -sf ~/dotfiles/linux/awesome ~/.config/awesome


# Set up 144Hz monitor configuration if arandr config exists
if [ -f ~/.screenlayout/default.sh ]; then
    echo "Found existing monitor configuration"
else
    echo "Creating default monitor configuration for 144Hz..."
    mkdir -p ~/.screenlayout
    cat > ~/.screenlayout/default.sh << 'EOF'
#!/bin/sh
# Monitor configuration: HDMI-0 (60Hz left) + DP-4 (144Hz primary right)
xrandr --output DP-4 --mode 1920x1080 --rate 143.61 --primary --pos 1920x0 --output HDMI-0 --mode 1920x1080 --rate 60.00 --pos 0x0
EOF
    chmod +x ~/.screenlayout/default.sh
fi

# Add autostart entry for monitor configuration
echo "Setting up autostart..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/monitor-setup.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Monitor Setup
Exec=/home/$USER/.screenlayout/default.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

echo "Awesome WM setup complete!"
echo ""
echo "To use Awesome WM:"
echo "1. Log out of your current session"
echo "2. At the login screen, click the gear icon and select 'Awesome'"
echo "3. Log in"
echo ""
echo "Key shortcuts:"
echo "- Alt+Q/W/E/R: Switch between workspaces"
echo "- Super+Esc: Switch between monitors"
echo "- Alt+Tab: Window switcher (rofi)"
echo "- Super+Enter: Terminal"
echo "- Super+Q: Power menu"
