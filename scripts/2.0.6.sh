#!/usr/bin/env bash

# Add drift file for chrony
sudo sed -i '$a\driftfile /var/lib/chrony/drift' /etc/chrony.conf

# Xrdp
sudo sed -i 's|#    Option "AutoAddDevices" "off"|    Option "AutoAddDevices" "off"|g' /etc/X11/xrdp/xorg.conf
sudo sed -i 's|    Option "DPMS"|    Option "DPMS" "false"|g' /etc/X11/xrdp/xorg.conf
sudo sed -i 's|bitmap_compression=true|bitmap_compression=false|g' /etc/xrdp/xrdp.ini
sudo sed -i 's|bulk_compression=true|bulk_compression=false|g' /etc/xrdp/xrdp.ini
sudo cp /home/astronaut/.astroarch/configs/99-sysctl.conf /etc/sysctl.d
