#!/bin/bash

export DESKTOP_SESSION=plasma
export XDG_MENU_PREFIX=plasma-

rm -f $HOME/.cache/menus/*
rm -f $HOME/.cache/ksycoca6*

# Set preference for X
xset s off -dpms s noblank

# Start KDE plasma minimal X window Manager + plasmashell
kwin_x11 &
KWIN_PID=$!
plasmashell &
SHELL_PID=$!

/home/astronaut-kiosk/.local/bin/00-init-layout.sh &

# App monitoring
watch_apps() {
    while true; do
#pgrep -x kstars > /dev/null || kstars &
#pgrep -x "phd2.bin" > /dev/null || phd2 &
#pgrep -x xgps > /dev/null || xgps &
#pgrep -f AstroDMx-Capture  > /dev/null || /opt/AstroDMx-Capture/bin/AstroDMx-Capture &
       sleep 10
    done
}

# Launch and/or restart the apps
#kstars &
#phd2 &
#/opt/AstroDMx-Capture/bin/AstroDMx-Capture &
#xgps &

watch_apps &

wait $KWIN_PID
kill $WATCH_PID
kill $SHELL_PID
exit 0
