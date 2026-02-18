#!/usr/bin/env bash

## Add the kiosk session ##
USERNAME="astronaut-kiosk"
if ! id "$USERNAME" &>/dev/null; then
# Add user astronaut-kiosk
sudo useradd -G wheel -m astronaut-kiosk
echo "astronaut-kiosk:astro" | sudo chpasswd
sudo usermod -aG uucp,sys,network,power,audio,input,lp,storage,video,users,astronaut astronaut-kiosk
sudo usermod -aG astronaut-kiosk astronaut
sudo chmod -R 770 /home/astronaut-kiosk
sudo -u astronaut-kiosk  LC_ALL=C.UTF-8 xdg-user-dirs-update --force
mkdir -p /home/astronaut-kiosk/.local/{bin,share,state}

# New Xrdp launcher for astronaut and astronaut-kiosk sessions
sudo cp /home/astronaut/.astroarch/configs/kiosk/45-allow-shutdown-xrdp.rules /etc/polkit-1/rules.d/
sudo cp /home/astronaut/.astroarch/configs/startwm.sh /home/astronaut-kiosk/
sudo cp /home/astronaut/.astroarch/configs/kiosk/.xinitrc /home/astronaut-kiosk/

# Copy wallpapers
sudo -u astronaut-kiosk mkdir -p /home/astronaut-kiosk/Pictures/wallpapers
sudo cp /home/astronaut/.astroarch/configs/kiosk/astroarch-kiosk.png /home/astronaut-kiosk/Pictures/wallpapers/

# Config plasma
sudo cp /home/astronaut/.astroarch/configs/kiosk/00-init-layout.sh /home/astronaut-kiosk/.local/bin/
sudo chmod +x /home/astronaut-kiosk/.local/bin/00-init-layout.sh
sudo chown astronaut-kiosk:astronaut-kiosk /home/astronaut-kiosk/.local/bin/00-init-layout.sh
sudo -u astronaut cp /home/astronaut/.astroarch/configs/kscreenlockerrc /home/astronaut/.config/kscreenlockerrc

# Add menu
sudo cp -r /home/astronaut/.astroarch/configs/kiosk/menus /home/astronaut-kiosk/.config/

# Minimal desktop
sudo -u astronaut-kiosk ln -snf /home/astronaut/.astroarch/desktop/astroarch-config-kiosk.desktop /home/astronaut-kiosk/Desktop/Astroarch-config-Kiosk

# Adjustment of user rights
sudo chmod -R 770 /home/astronaut-kiosk
sudo chown -R astronaut-kiosk:astronaut-kiosk /home/astronaut-kiosk

fi
