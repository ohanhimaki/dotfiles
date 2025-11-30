#!/bin/bash
# KDE Autostart Settings
# This script runs at KDE startup to ensure keyboard and mouse settings persist

# Keyboard repeat rate (200ms delay, 35 chars/sec - gaming optimized)
xset r rate 200 35

# CapsLock -> Escape remapping
setxkbmap -option caps:escape

# Mouse settings (Logitech mouse acceleration)
# Note: Device ID may vary, this sets it by name pattern
# Find your mouse with: xinput list
MOUSE_ID=$(xinput list | grep -i "logitech" | grep -i "pointer" | grep -o 'id=[0-9]*' | grep -o '[0-9]*' | head -n1)
if [ -n "$MOUSE_ID" ]; then
    xinput --set-prop "$MOUSE_ID" 'libinput Accel Speed' -0.3
    echo "Mouse acceleration set for device ID: $MOUSE_ID"
fi

