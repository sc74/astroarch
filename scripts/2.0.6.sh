#!/usr/bin/env bash

# Add drift file for chrony
sudo sed -i '$a\driftfile /var/lib/chrony/drift' /etc/chrony.conf

# Xrdp & network
sudo sed -i 's|#    Option "AutoAddDevices" "off"|    Option "AutoAddDevices" "off"|g' /etc/X11/xrdp/xorg.conf
sudo cp /home/astronaut/.astroarch/configs/99-sysctl.conf /etc/sysctl.d
