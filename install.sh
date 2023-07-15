#!/bin/bash

kiosk=false

# Parse cli options
while getopts "k" opt; do
  case $opt in
    k)
      kiosk=true
      ;;
    \?)
      ;;
  esac
done

# Install dependencies
apt-get install -y openbox firefox-esr xinit

# Check if installation succeeded
if [[ $? -ne 0 ]]; then
  echo "Failed to install dependencies. Purging remaining packages..."
  apt-get purge -y openbox firefox-esr xinit
  exit 1
fi

# Install the auto-run script
if ! echo '#!/bin/bash

profile_dir=$(find ~/.mozilla/firefox/ -name '*.default-esr' -type d)
if [ -z "$profile_dir" ]; then
    echo "Firefox profile directory not found."
    exit 1
fi
prefsfile="$profile_dir/sessionstore-backups"

rm -rf "$prefsfile"/*

nohup startx &
sleep 2
export DISPLAY=:0
nohup openbox &
sleep 2' | tee /etc/profile.d/prox-kiox.sh > /dev/null; then
  echo "Failed to create auto-run script."
  exit 1
fi

if [[ $kiosk = true ]]; then
  if ! echo 'firefox-esr --kiosk "https://127.0.0.1:8006" &' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo "Failed to add kiosk command to auto-run script."
    exit 1
  fi
else
  if ! echo 'firefox-esr "https://127.0.0.1:8006" &' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo "Failed to add regular command to auto-run script."
    exit 1
  fi
fi

# Start X server
nohup startx &

sleep 2

export DISPLAY=:0

# Start Openbox
nohup openbox &

sleep 2

# Start Firefox
if [[ $kiosk = true ]]; then
  firefox-esr --kiosk "https://127.0.0.1:8006" &
else
  firefox-esr "https://127.0.0.1:8006" &
fi
