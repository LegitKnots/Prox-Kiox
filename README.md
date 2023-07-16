# Prox-Kiox (version 1.3.3)

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

This may not work or may be instable

~sh <(curl -sS https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh)~



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
if ! is_process_running "firefox-esr"; then
  firefox-esr --kiosk "https://127.0.0.1:8006" &
fi
```

Now that we have it all set up, we can go ahead and run our commands to get it up and running, the commands need to be run as one whole so that it is times and executes properly

Note that as like above, you can modify the sleeps to suite your case, if the display refuses to connect, just modify the sleep by 1 second more and run again, try to match these with above.

``nohup startx & sleep 1 export DISPLAY=:0 openbox & firefox-esr --kiosk "https://127.0.0.1:8006" &``

Now you should be able to see FireFox runing and the PVE webui screen.



## Usage

You can use either of the three methods to install but the most stable is going to be with wget.

For the manual install, above defaults to kiosk mode but since the backbone of this is a basic Firefox application, you can remove the --kiost from both commands in the auto run and post install and you'll be able to use it like a normal browser
If you dont want it to always be full screen you can remove the '--kiosk' from the firefox-esr commands which will let in fun like a normal browser



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

On some systems, the auto run script will fail to run properly after logon, will require the install script to be run again.

## Donate

If you found this project helpful, please consider donating to the project throu PayPal, always appreciated.

https://www.paypal.me/kn0t5



## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.



## Disclaimer

This project is experimental and not official.  Any use of this project may put your resources at a higher risk of failure.  The publisher nor the contributers shall have any liability for any damages casued by the user or the project.  Use at your own risk.

