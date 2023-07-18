#!/bin/bash

echo ""
echo "-----------------------------------------------------------------------------------------------------------------------"
echo ""
echo ""
echo "      ___           ___           ___           ___           ___                       ___           ___     "
echo "     /\\  \\         /\\  \\         /\\  \\         |\\__\\         /\\__\\          ___        /\\  \\         |\\__\\    "
echo "    /::\\  \\       /::\\  \\       /::\\  \\        |:|  |       /:/  /         /\\  \\      /::\\  \\        |:|  |   "
echo "   /:/\\:\\  \\     /:/\\:\\  \\     /:/\\:\\  \\       |:|  |      /:/__/          \\:\\  \\    /:/\\:\\  \\       |:|  |   "
echo "  /::\\~\\:\\  \\   /::\\~\\:\\  \\   /:/  \\:\\  \\      |:|__|__   /::\\__\\____      /::\\__\\  /:/  \\:\\  \\      |:|__|__ "
echo " /:/\\:\\ \\:\\__\\ /:/\\:\\ \\:\\__\\ /:/__/ \\:\\__\\ ____/::::\\__\\ /:/\\:::::\\__\\  __/:/\\/__/ /:/__/ \\:\\__\\ ____/::::\\__\\"
echo " \\/__\\:\\/:/  / \\/_|::\\/:/  / \\:\\  \\ /:/  / \\::::/~~/~    \\/_|:|~~|~    /\\/:/  /    \\:\\  \\ /:/  / \\::::/~~/~   "
echo "      \\::/  /     |:|::/  /   \\:\\  /:/  /   ~~|:|~~|        |:|  |     \\::/__/      \\:\\  /:/  /   ~~|:|~~|    "
echo "       \\/__/      |:|\\/__/     \\:\\/:/  /      |:|  |        |:|  |      \\:\\__\\       \\:\\/:/  /      |:|  |    "
echo "                  |:|  |        \\::/  /       |:|  |        |:|  |       \\/__/        \\::/  /       |:|  |    "
echo "                   \\|__|         \\/__/         \\|__|         \\|__|                     \\/__/         \\|__|    "
echo ""
echo ""
echo ""
echo "Version 1.4.0"
echo "--------Created by--------------"
echo ""
echo " _______   _____ ______ _______ "
echo "|   _   |_|     |   __ \\    |  |"
echo "|       |       |    __/       |"
echo "|___|___|_______|___|  |__|____|"
echo ""
echo ""
echo "-------In Part By---------------"
echo ""
echo " _  _ _____   _____ "
echo "| || / __\ \\ / / __|"
echo "| __ \\__ \\\ V /| _|"
echo "|_||_|___/ \\_/ |___|"
echo ""
echo "--------------------------------"
echo ""
echo ""
echo ""

echo "------------------------------------------------------------------"
echo "Updating the live server"
echo "------------------------------------------------------------------"
sleep 0.5
apt-get update > /dev/null && apt-get upgrade -y > /dev/null
apt-get autoremove -y > /dev/null
echo "------------------------------------------------------------------"
echo "Done"
echo "------------------------------------------------------------------"
echo ""
echo ""
echo "------------------------------------------------------------------"
echo "Installing dependencies: Firefox-ESR"
echo "------------------------------------------------------------------"
sleep 0.5
apt-get install -y firefox-esr > /dev/null
echo "------------------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------------------"
echo ""
echo ""
echo "------------------------------------------------------------------"
echo "Installing dependencies: Xinit"
echo "------------------------------------------------------------------"
sleep 0.5
apt-get install -y xinit > /dev/null
echo "------------------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------------------"
echo ""
echo ""
echo "------------------------------------------------------------------"
echo "Installing dependencies: X11 Utils"
echo "------------------------------------------------------------------"
sleep 0.5
apt-get install -y x11-utils > /dev/null
echo "------------------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------------------"
echo ""


## Workaround for now to ensure that the .mozilla folder is present before continuing
## Had an issue that would literally brick the system and not allow login, fixing with this and the sleep after no .mozilla in auto run below
echo ""
echo "------------------------------------------------------------------"
echo "Initializing Firefox-ESR"
echo "------------------------------------------------------------------"
sleep 0.5
firefox-esr --headless > /dev/null 2>&1 &
sleep 5
killall firefox-esr > /dev/null
echo "------------------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------------------"
echo ""


if [[ $? -ne 0 ]]; then
  echo ""
  echo "------------------------------------------------------------------"
  echo "Failed to install dependencies. Purging the rest..."
  echo "------------------------------------------------------------------"
  sleep 0.5
  apt-get purge -y firefox-esr xinit x11-utils > /dev/null
  echo "------------------------------------------------------------------"
  echo "Installation Failed!"
  echo "------------------------------------------------------------------"
  exit 1
fi


echo ""
echo "------------------------------------------------------------------"
echo "Installing bash command script"
echo "------------------------------------------------------------------"



# Install the bash command script

if ! echo '#!/bin/bash
if pgrep -x "firefox-esr" >/dev/null; then
    clear
    echo "Priox-Kiox already running"
    return 0
fi

profile_dir=$(find "$HOME/.mozilla/firefox/" -name "*.default-esr" -type d)
if [ -z "$profile_dir" ]; then
    echo ""
    echo "Firefox profile directory not found."
    return 1
fi
prefsfile="$profile_dir/sessionstore-backups"

rm -rf "$prefsfile"/*

mode=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --kiosk)
      mode="kiosk"
      shift
      ;;
    *)
      echo "Invalid option: $1" >&2
      exit 1
      ;;
  esac
  shift
done
nohup startx &
export DISPLAY=:0
while true; do
    result=$(xdpyinfo 2>&1)
    if [[ $result == *"unable to open display"* ]]; then
        echo "Error: Unable to open display"
        sleep 0.25
    else
        echo "X server is running and display is available."
        break
    fi
done

if [[ $mode = kiosk ]]; then
  nohup firefox-esr --kiosk https://127.0.0.1:8006 &
else

  nohup firefox-esr https://127.0.0.1:8006 &
fi
exit $retval' | tee /usr/bin/prox-kiox > /dev/null; then




  echo ""
  echo "------------------------------------------------------------------"
  echo "Failed to install! Removing dependencies...."
  echo "------------------------------------------------------------------"
  sleep 0.5
  apt-get remove -y firefox-esr xinit x11-utils > /dev/null
  apt-get purge -y firefox-esr xinit x11-utils > /dev/null
  apt-get autoremove -y
  echo "------------------------------------------------------------------"
  echo "Installation Failed!"
  echo "------------------------------------------------------------------"
  echo ""
  exit 1
else
  chmod +x /usr/bin/prox-kiox
fi
echo "------------------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------------------"

echo ""
echo ""
echo "------------------------------------------------------------------"
echo "Installed!"
echo "------------------------------------------------------------------"
echo ""
echo "You can run Prox-Kiox at any time by running the command 'prox-kiox'"
echo ""


