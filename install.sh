#!/bin/bash

# Install dependencies
apt-get install -y openbox firefox-esr xinit xdotool

# Install the auto-run script
echo '#!/bin/bash
startx &
sleep 5
export DISPLAY=:0
openbox &
sleep 2
firefox-esr &' | tee /etc/profile.d/prox-kiox.sh > /dev/null

echo "" >> "/etc/firefox-esr/firefox-esr.js"
echo "// Defines the browser start page url" >> "/etc/firefox-esr/firefox-esr.js"
echo "pref(\"browser.startup.homepage\", https://127.0.0.1:8006);" >> "/etc/firefox-esr/firefox-esr.js"


# Start the X server
startx &

# Wait for X server to start
sleep 5

# Set the display variable
export DISPLAY=:0

# Start Openbox window manager
openbox &

# Wait for Openbox to start
sleep 2

# Run Firefox
firefox-esr &

# Wait for Firefox to start
sleep 10

# Navigate to the specified URL
xdotool key ctrl+j 2>/dev/null
xdotool key BackSpace 2>/dev/null
xdotool type "http://127.0.0.1:8006" 2>/dev/null
xdotool key F11 2>/dev/null
xdotool key Return 2>/dev/null