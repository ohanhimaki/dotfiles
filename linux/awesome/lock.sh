#!/bin/bash
# Screen locker script for AwesomeWM with i3lock
# This script configures DPMS to turn off the screen after a timeout when locked

# DPMS timeout in seconds (default: 300 seconds = 5 minutes)
# Change this value to adjust how long the screen stays on after locking
DPMS_TIMEOUT=120

# Save current DPMS settings
DPMS_STANDBY=$(xset q | grep "Standby" | awk '{print $2}')
DPMS_SUSPEND=$(xset q | grep "Suspend" | awk '{print $4}')
DPMS_OFF=$(xset q | grep "Off" | awk '{print $6}')

# Enable DPMS and set timeout for locked screen
xset +dpms
xset dpms $DPMS_TIMEOUT $DPMS_TIMEOUT $DPMS_TIMEOUT

# Lock the screen with i3lock
# -c = background color (hex without #)
# -d = don't fork, allow DPMS to work
# -e = ignore empty password
# Add more options from: man i3lock
i3lock -c 000000 -d -e

# After unlock, restore previous DPMS settings
# (AwesomeWM has DPMS disabled by default in rc.lua)
xset -dpms
xset s off

