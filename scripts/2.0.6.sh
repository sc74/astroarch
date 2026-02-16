#!/usr/bin/env bash

# Add drift file for chrony
sudo sed -i '$a\driftfile /var/lib/chrony/drift' /etc/chrony.conf

USERNAME="astronaut-kiosk"
if ! id "$USERNAME" &>/dev/null; then
# Add user astronaut-kiosk
sudo useradd -G wheel -m astronaut-kiosk
echo "astronaut-kiosk:astro" | sudo chpasswd
sudo usermod -aG uucp,sys,network,power,audio,input,lp,storage,video,users,astronaut astronaut-kiosk
sudo usermod -aG astronaut-kiosk astronaut
sudo chmod -R 777 /home/astronaut-kiosk
sudo -u astronaut-kiosk  LC_ALL=C.UTF-8 xdg-user-dirs-update --force
mkdir -p /home/astronaut-kiosk/.local/{bin,share,state}

## Add the kiosk session ##
# New Xrdp launcher for astronaut and astronaut-kiosk sessions
sudo cp /home/astronaut/.astroarch/configs/kiosk/45-allow-shutdown-xrdp.rules /etc/polkit-1/rules.d/
sudo cp /home/astronaut/.astroarch/configs/startwm.sh /home/astronaut-kiosk/
sudo cp /home/astronaut/.astroarch/configs/kiosk/.xinitrc /home/astronaut-kiosk/

# Copy wallpapers
sudo -u astronaut-kiosk mkdir -p /home/astronaut-kiosk/Pictures/wallpapers
sudo cp /home/astronaut/.astroarch/configs/kiosk/astroarch-kiosk.png /home/astronaut-kiosk/Pictures/wallpapers/

# Add menu
sudo cp -r /home/astronaut/.astroarch/configs/kiosk/menus /home/astronaut-kiosk/.config/

# Copy kstars folders
sudo cp -R /home/astronaut/.local/share/kstars /home/astronaut-kiosk/.local/share/

cat <<EOF >/home/astronaut-kiosk/.config/plasmanotifyrc
[DoNotDisturb]
WhenFullscreen=false
WhenScreensMirrored=false
EOF

# Copy the screensaver config, by default it is off
sudo cp /home/astronaut/.astroarch/configs/kscreenlockerrc /home/astronaut-kiosk/.config/kscreenlockerrc"

# Adjustment of user rights
sudo chmod -R 777 /home/astronaut-kiosk
sudo chown -R astronaut-kiosk:astronaut-kiosk /home/astronaut-kiosk

# Minimal desktop
sudo -u astronaut-kiosk ln -snf /home/astronaut/.astroarch/desktop/astroarch-config-kiosk.desktop /home/astronaut-kiosk/Desktop/Astroarch-config-Kiosk

# Allows access to the astronaut group
sudo chmod -R 770 /home/astronaut
fi
