#!/bin/bash

# Congih & clean
CONFIG_FILE="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
WALLPAPER="$HOME/Pictures/wallpapers/astroarch-kiosk.png"
export DESKTOP_SESSION=plasma
export XDG_MENU_PREFIX=plasma-
export XDG_DATA_DIRS=$HOME/.local/share:/usr/local/share:/usr/share
export XDG_CONFIG_HOME=$HOME/.config
rm -f $HOME/.cache/menus/*
rm -f $HOME/.cache/ksycoca6*

DESKTOP_DIR="$HOME/Desktop"
mkdir -p "$DESKTOP_DIR"

# List of applications to check (Source -> Name on desktop)
declare -A APPS
#APPS["/usr/share/applications/org.kde.kstars.desktop"]="Kstars"
#APPS["/usr/share/applications/phd2.desktop"]="PHD2"
#APPS["/usr/share/applications/astrodmx_capture.desktop"]="AstroDMx Capture"
#APPS["/usr/share/applications/xgps.desktop"]="xgps"

for APP_PATH in "${!APPS[@]}"; do
    DEST="$DESKTOP_DIR/${APPS[$APP_PATH]}"

    # If the link does not exist, it is created
    if [ ! -L "$DEST" ] && [ ! -f "$DEST" ]; then
        ln -snf "$APP_PATH" "$DEST"
    fi
done

kbuildsycoca6 > /dev/null 2>&1

# Set preference for X
xset s off -dpms s noblank

# Start KDE plasma minimal X window Manager + plasmashell
kwin_x11 &
KWIN_PID=$!
plasmashell &
SHELL_PID=$!

qdbus6 org.kde.PlasmaShell /PlasmaShell makeConfigurationStatic

sleep 2

# Wait for plasma-org.kde.plasma.desktop-appletsrc
while [ ! -f "$CONFIG_FILE" ] ; do
    sleep 10
done

CHANGED=0
# Customize plasmashell
if grep -q "immutability=1" "$CONFIG_FILE"; then
    sed -i 's/immutability=1/immutability=0/g' "$CONFIG_FILE"
    CHANGED=1
fi

if grep -q "wallpaperplugin=org.kde.slideshow" "$CONFIG_FILE"; then
    sed -i 's/wallpaperplugin=org.kde.slideshow/wallpaperplugin=org.kde.image/g' "$CONFIG_FILE"
    CHANGED=1
fi

if [ "$CHANGED" -eq 1 ]; then
    kquitapp6 plasmashell > /dev/null 2>&1
    sleep 5
    killall -9 plasmashell > /dev/null 2>&1
    sleep 5
    rm -rf $HOME/.cache/plasmashell*
    rm -R -f $HOME/.local/share/kactivitymanagerd
    rm -f $HOME/.config/kactivitymanagerd-statsrc
    nohup plasmashell --replace > /dev/null 2>&1 &
    sleep 5
fi

dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
// Apply wallpaers
var allDesktops = desktops();
for (var i in allDesktops) {
    allDesktops[i].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    allDesktops[i].writeConfig('Image', 'file://${WALLPAPER}');
    allDesktops[i].writeConfig('FillMode', '0');
}

// Clean
var panels = panels();
for (var i in panels) {
    var widgets = panels[i].widgets();
    for (var j in widgets) {
        // Clean apps
        if (widgets[j].type === 'org.kde.plasma.kickoff') {
            widgets[j].currentConfigGroup = ['Configuration', 'General'];
            widgets[j].writeConfig('favorites', ['applications:org.kde.kstars.desktop', 'applications:phd2.desktop', 'applications:astrodmx_capture.desktop'], 'applications:xgps.desktop');
            widgets[j].writeConfig('systemFavorites', false);
            widgets[j].reloadConfig();
        }
        // Clean task bar
        if (widgets[j].type === 'org.kde.plasma.icontasks') {
            widgets[j].currentConfigGroup = ['Configuration', 'General'];
            widgets[j].writeConfig('launchers', '');
            widgets[j].reloadConfig();
        }
    }
}"

plasmashell --replace &

chmod -R 775 "$HOME"


# App monitoring
watch_apps() {
    while true; do
#pgrep -x kstars > /dev/null || kstars &
#pgrep -x "phd2.bin" > /dev/null || phd2 &
#pgrep -x xgps > /dev/null || xgps &
#pgrep -f AstroDMx-Capture  > /dev/null || /opt/AstroDMx-Capture/bin/AstroDMx-Capture &
       sleep 5
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
