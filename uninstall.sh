#!/bin/bash

# Stop running processes
killall -q firefox-esr
killall -q openbox
killall -q xorg

# Remove the auto-run script
rm /etc/profile.d/prox-kiox.sh

# Uninstall dependencies
apt-get remove -y openbox firefox-esr xinit xdotool

# Clean up any residual configuration files
apt-get autoremove -y

echo "Prox-Kiox Successfully Uninstalled. Sorry to see you go :(";