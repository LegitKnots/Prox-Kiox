# Prox-Kiox

## About

### This Project was idealized by a member of the Harvey's Virtual Environment Discord community and brought together by myself.  All credit for the idea goes the HSVE Community. 
### Prox-Kiox is simply an install script that will essentially turn any Proxmox intall into a kiosk setup, allowing for full UI managemnt of Proxmox from its main display out. 
### It will install a window manager as well as Firefox in order to achieve this by opening a window automatically and placing it in full screen mode after navigating to the correct location, being http://127.0.0.1:8006.

### You can find more about Harvey's Virtual Environment at the following
### https://discord.gg/WGUdajWzxz
### https://hsve.org/



## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Donate](#donate)
- [License](#license)



## Installation

### Automatic install

``sh <(curl -sS https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh)``

### WGET Download

Download the install script using wget

``wget https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh && chmod +x install.sh``

From here you can look at the usage section below to determine if its necessary to modify the sleep times.
After they have been changed or not you can simply run the script using the following

``./install.sh``



### Manual Install

First, Update the running server with

``apt-get update && apt-get upgrade -y``

Next, we need to install the following dependencies

``apt-get install -y openbox firefox-esr xinit``

Before we start the process and run the window manager and FireFox, we want to create a script that will automatically run the start script upon login.
We can first create the file with the following command and then nano into it.

``touch /etc/profile.d/prox-kiox.sh && nano /etc/profile.d/prox-kiox.sh``

The following code should be place in the file

```
#!/bin/bash

profile_dir=$(find ~/.mozilla/firefox/ -name '*.default-esr' -type d)
if [ -z "$profile_dir" ]; then
    echo "Firefox profile directory not found."
    exit 1
fi
prefsfile="$profile_dir/sessionstore-backups"

rm -rf "$prefsfile"/*

nohup startx &
sleep 3         # Adjust this as needed if the display refuses to connect
export DISPLAY=:0
openbox &
sleep 2         # Adjust this as needed if the display refuses to connect
firefox-esr --kiosk "https://127.0.0.1:8006" &
```

Now that we have it all set up, we can go ahead and run our commands to get it up and running, the commands need to be run as one whole so that it is times and executes properly

Note that as like above, you can modify the sleeps to suite your case, if the display refuses to connect, just modify the sleep by 1 second more and run again, try to match these with above.

``nohup startx & sleep 3 export DISPLAY=:0 openbox & sleep 2 firefox-esr --kiosk "https://127.0.0.1:8006" &``

Now you should be able to see FireFox runing and you can use it however you want.



## Usage

Essentially this is a one-click install per se but theres a few things that you need to keep in mind and can modify in the script, at least for v1 (current)
If you dont want it to always be full screen you can remove the '--kiosk' from the firefox-esr commands which will let in fun like a normal browser

### Options

`-k`

Adding a -k enables kiosk mode, this is almost fullscreen mode but more locked down, you won't have access to the tool bar for firefox.  Simply don't add this if you want the tool bar.



## Uninstall

At any time, you may run the uninstaller script ant it will clean the system of all packages that were installed and remove the autorun file so theres no issues after the fact.  You can do so with the following

``sh <(curl -sS https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/uninstall.sh)``

Or you may use the wget method as like above but using uninstall.sh instead, like this

Download the install script using wget

``wget https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/uninstall.sh && chmod +x uninstall.sh``

From here you can look at the usage section below to determine if its necessary to modify the sleep times.
After they have been changed or not you can simply run the script using the following

``./uninstall.sh``

Please not that these scripts do not delete themselves, so you will need to run

``rm /path/to/script/uninstall.sh``


## Known Issues

Something is going on with the shell and its crashing whe  you open it in the webui.  It was working for a solid 5 minutes until I changed something unrelated, then it broke :\  Dont click on shell for now untill its fixed.

Sometimes you may get an error message saying that the display refused to connect or timed out or something along those lines.  Theres not much of a fix for it right now until I can get a listener going for when thing are open and ready, but best chance is to modify the sleep times as listed above.

## Donate

If you found this project helpful, please consider donating to the project throu PayPal, always appreciated.

https://www.paypal.me/kn0t5



## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.



## Disclaimer

This project is experimental and not official.  Any use of this project may put your resources at a higher risk of failure.  The publisher nor the contributers shall have any liability for any damages casued by the user or the project.  Use at your own risk.

