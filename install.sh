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

# Update the repos and upgrade them

apt-get update && apt-get upgrade -y

apt-get autoremove -y

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

# Function to check if a process is running
is_process_running() {
  pgrep "$1" > /dev/null
}

# Start X server if not running
if ! is_process_running "X"; then
  nohup startx &
fi

export DISPLAY=:0

# Start Openbox if not running
if ! is_process_running "openbox"; then
  nohup openbox &
fi
' | tee /etc/profile.d/prox-kiox.sh > /dev/null; then
  echo "Failed to create auto-run script."
  exit 1
fi

if [[ $kiosk = true ]]; then
  if ! echo '
            if ! is_process_running "firefox-esr"; then
              firefox-esr --kiosk "https://127.0.0.1:8006" &
            fi
          ' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo "Failed to add kiosk command to auto-run script."
    exit 1
  fi
else
  if ! echo '
            if ! is_process_running "firefox-esr"; then
              firefox-esr "https://127.0.0.1:8006" &
            fi
          ' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo "Failed to add regular command to auto-run script."
    exit 1
  fi
fi

# Function to check if a process is running
is_process_running() {
  pgrep "$1" > /dev/null
}

# Start X server if not running
if ! is_process_running "X"; then
  nohup startx &
fi

export DISPLAY=:0

# Start Openbox if not running
if ! is_process_running "openbox"; then
  nohup openbox &
fi

# Start Firefox if not running
if [[ $kiosk = true ]]; then
  if ! is_process_running "firefox-esr"; then
    firefox-esr --kiosk "https://127.0.0.1:8006" &
  fi
else
  if ! is_process_running "firefox-esr"; then
    firefox-esr "https://127.0.0.1:8006" &
  fi
fi

