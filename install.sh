#!/bin/bash

kiosk=false

# Prompt the user
echo "------------------------------------------------------------------"
echo ""
read -p "Enable kiosk mode? [Y/n]: " input

# Process user input
input=${input:-Y}  # Default to "Y" if no input provided
input=${input,,}  # Convert input to lowercase

if [[ $input == "y" ]]; then
  mode=kiosk
else
  mode=normal
fi
echo ""
echo "Mode: $mode"
echo ""
echo "------------------------------------------------------------------"
echo ""

sleep 1

echo "------------------------------------------------------------------"
echo "Updating the live server"
echo ""
sleep 0.5
apt-get update && apt-get upgrade -y
apt-get autoremove -y
echo ""
echo "------------------------------------------------------------------"
echo ""

echo ""
echo "------------------------------------------------------------------"
echo "Installing dependancies: Openbox"
echo ""
sleep 0.5
apt-get install -y openbox
echo ""
echo "Done!"
echo "------------------------------------------------------------------"
echo ""

echo ""
echo "------------------------------------------------------------------"
echo "Installing dependancies: Firefox-ESR"
echo ""
sleep 0.5
apt-get install -y firefox-esr
echo ""
echo "Done!"
echo "------------------------------------------------------------------"
echo ""

echo ""
echo "------------------------------------------------------------------"
echo "Installing dependancies: Xinit"
echo ""
sleep 0.5
apt-get install -y xinit
echo ""
echo "Done!"
echo "------------------------------------------------------------------"
echo ""


## Work-around for now to ensure that the .mozzila folder is present before continuing
## Had an issue that would literally brick the system and not allow login, fixing with this and the sleep after no .mozzila in auto run below
echo ""
echo "------------------------------------------------------------------"
echo "Initializing Firefox-ESR"
echo ""
sleep 0.5
firefox-esr --headless &
sleep 5
killall firefox-esr
echo ""
echo "Done!"
echo "------------------------------------------------------------------"
echo ""



if [[ $? -ne 0 ]]; then
  echo ""
  echo "------------------------------------------------------------------"
  echo ""
  echo "Failed to install dependencies. Purging rest..."
  sleep 0.5
  echo ""
  apt-get purge -y openbox firefox-esr xinit
  echo ""
  echo "------------------------------------------------------------------"
  echo "Instalation Failed!"
  exit 1
fi


echo ""
echo "------------------------------------------------------------------"
echo "Installing autorun script"
echo ""

# Install the auto-run script
if ! echo '#!/bin/bash
profile_dir=$(find ~/.mozilla/firefox/ -name '*.default-esr' -type d)
if [ -z "$profile_dir" ]; then
    sleep 5
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

sleep 1
export DISPLAY=:0

# Start Openbox if not running
if ! is_process_running "openbox"; then
  nohup openbox &
fi' | tee /etc/profile.d/prox-kiox.sh > /dev/null; then

  echo ""
  echo "------------------------------------------------------------------"
  echo ""
  echo "Failed to create auto-run script.  Purging Dependancies...."
  sleep 0.5
  echo ""
  apt-get purge -y openbox firefox-esr xinit
  echo ""
  echo "------------------------------------------------------------------"
  echo "Instalation Failed!"
  exit 1
fi

if [[ $mode = kiosk ]]; then
  if ! echo 'if ! is_process_running "firefox-esr"; then
  firefox-esr --kiosk "https://127.0.0.1:8006" &
fi' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo ""
    echo "------------------------------------------------------------------"
    echo ""
    echo "Failed to add kiosk mode to auto-run script.  Purging Dependancies...."
    sleep 0.5
    echo ""
    apt-get purge -y openbox firefox-esr xinit
    echo ""
    echo "------------------------------------------------------------------"
    echo "Instalation Failed!"
    exit 1
  fi
else
  if ! echo 'if ! is_process_running "firefox-esr"; then
  firefox-esr "https://127.0.0.1:8006" &
fi' | tee -a /etc/profile.d/prox-kiox.sh > /dev/null; then
    echo ""
    echo "------------------------------------------------------------------"
    echo ""
    echo "Failed to add Firefox run to auto-run script.  Purging Dependancies...."
    sleep 0.5
    echo ""
    apt-get purge -y openbox firefox-esr xinit
    echo ""
    echo "------------------------------------------------------------------"
    echo "Instalation Failed!"
    exit 1
  fi
fi
echo "Done!"


echo ""
echo "------------------------------------------------------------------"
echo "Starting all services.."
echo ""

# Function to check if a process is running
is_process_running() {
  pgrep "$1" > /dev/null
}

# Start X server if not running
if ! is_process_running "X"; then
  nohup startx &
fi

sleep 1
export DISPLAY=:0

# Start Openbox if not running
if ! is_process_running "openbox"; then
  nohup openbox &
fi

# Start Firefox if not running
if [[ $mode = kiosk ]]; then
  if ! is_process_running "firefox-esr"; then
    firefox-esr --kiosk "https://127.0.0.1:8006" &
  fi
else
  if ! is_process_running "firefox-esr"; then
    firefox-esr "https://127.0.0.1:8006" &
  fi
fi

echo ""
echo "------------------------------------------------------------------"
echo "Done!"
echo ""
