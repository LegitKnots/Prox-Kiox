#!/bin/bash

# Install dependencies
apt-get install -y openbox firefox-esr xinit

# Install the auto-run script
echo '#!/bin/bash

profile_dir=$(find ~/.mozilla/firefox/ -name '*.default-esr' -type d)
if [ -z "$profile_dir" ]; then
    echo "Firefox profile directory not found."
    exit 1
fi
prefsfile="$profile_dir/sessionstore-backups"

rm -rf "$prefsfile"/*

startx &
sleep 1
export DISPLAY=:0
openbox &
sleep 1
firefox-esr --kiosk "https://127.0.0.1:8006" &' | tee /etc/profile.d/prox-kiox.sh > /dev/null


nohup startx &

sleep 2

export DISPLAY=:0

openbox &

sleep 2

firefox-esr --kiosk "https://127.0.0.1:8006" &
