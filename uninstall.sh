#!/bin/bash

# Stop running processes
killall -q firefox-esr
killall -q openbox
killall -q xorg

# Remove the auto-run script
rm /etc/profile.d/prox-kiox.sh
rm -rf /root/.mozilla
rm -rf /etc/firefox-esr


# Uninstall dependencies
apt-get remove -y openbox firefox-esr xinit

# Clean up any residual configuration files
apt-get autoremove -y

echo "Prox-Kiox Successfully Uninstalled. Sorry to see you go :(";