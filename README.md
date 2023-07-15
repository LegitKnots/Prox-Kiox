# Prox-Kiox

## About

### This Project was idealized by a member of the Harvey's Virtual Environment Discord community and brought together by myself.  All credit for the idea goes the HSVE Community. 
### Prox-Kiox is simply an install script that will essentially turn any Proxmox intall into a kiosk setup, allowing for full UI managemnt of Proxmox from its main display out. 
### It will install a window manager as well as fire fox in order to achieve this by opening a window automatically and placing it in full screen mode after navigating to the correnct location, being http://127.0.0.1:8006.

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

``wget https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh``

From here you can look at the usage section below to determine if its necessary to modify the sleep times.
After they have been changed or not you can simply run the script using the following

``./install.sh``



### Manual Install

First, Update the running server with

``apt-get update && apt-get upgrade -y``

Next, we need to install the following dependencies

``apt-get install -y openbox firefox-esr xinit xdotool``

Before we start the process and run the window manager and FireFox, we want to create a script that will automatically run the start script upon login.
We can first create the file with the following command and then nano into it.

``touch /etc/profile.d/prox-kiox.sh && nano /etc/profile.d/prox-kiox.sh``

The following code should be place in the file

```
#!/bin/bash
startx &
sleep 5
export DISPLAY=:0
openbox &
sleep 2
firefox-esr &
sleep 15
xdotool key ctrl+j 2>/dev/null
xdotool key BackSpace 2>/dev/null
xdotool type "http://127.0.0.1:8006" 2>/dev/null
xdotool key F11 2>/dev/null
xdotool key Return 2>/dev/null
```

Now that we have it all set up, we can go ahead and run our commands to get it up and running, the commands need to be run as one whole so that it is times and executes properly

``startx & sleep 5; export DISPLAY=:0; openbox & sleep 2; firefox-esr &``

Now you should be able to see FireFox runing and you can use it however you want.



## Usage

Essentially this is a one-click install per se but theres a few things that you need to keep in mind and can modify in the script, at least for v1 (current)

First off, the various sleeps within the script can be modified and fine tuned depending on how fast or slow your system starts up the applications.  I've found that startx and openbox tend to start quickly while firefox may take up to 15 seconds to start in some cases, so you just need to be patient there.

Another thing, with the above automatic install, it will install with a 15 second delay to actually send the keyboard commands on a reboot and 10 seconds on first install.  This is simply to accomodate slower systems and can be tweaked if you clone into the repo instead.



## Donate

If you found this project helpful, please consider donating to the project throu PayPal, always appreciated.

https://www.paypal.me/kn0t5



## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

