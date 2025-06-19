#!/bin/sh
# Wait for X to settle
sleep 1

# Find the touchpad device name (case-insensitive)
TOUCHPAD_NAME=$(xinput list --name-only | grep -i "touchpad")

if [ -z "$TOUCHPAD_NAME" ]; then
    echo "Touchpad not found."
    exit 1
fi

# Extract device ID from the device name line
DEVICE_ID=$(xinput list | grep "$TOUCHPAD_NAME" | grep -o "id=[0-9]*" | cut -d= -f2)

if [ -z "$DEVICE_ID" ]; then
    echo "Device ID not found for touchpad."
    exit 1
fi

# Function to check if a property exists
property_exists() {
    xinput list-props "$DEVICE_ID" | grep -q "$1"
}

# Enable tapping if the property exists
if property_exists "libinput Tapping Enabled"; then
    xinput set-prop "$DEVICE_ID" "libinput Tapping Enabled" 1
fi

# Enable natural scrolling if the property exists
if property_exists "libinput Natural Scrolling Enabled"; then
    xinput set-prop "$DEVICE_ID" "libinput Natural Scrolling Enabled" 1
fi
