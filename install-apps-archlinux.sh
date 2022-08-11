#!/bin/bash

#update first!
echo "checking for update..";
sudo pacman -Syu;

# install the apps
echo "installing all the apps..";

pacman -S --needed base-devel git neofetch ntfs-3g git man-db man-pages gst-libav nano rofi kitty gparted papirus-icon-theme vlc micro clinfo android-tools nomacs firefox -y;

# #install KVM and virt manager.
# echo "Installatiing KVM and Virt Manager.."
# 
# sudo pacman -S virt-manager qemu vde2 ebtazbles dnsmasq bridge-utils openbsd-netcat libguestfs iptables ebtables -y;
# 
# ##fix the permissions
# sudo usermod -G kvm -a $USER;
# sudo usermod -G libvirt -a $USER;
# sudo systemctl enable libvirtd;
# sudo systemctl start libvirtd.service;


# install the aur helper
echo "installing aur helper.."
cd ..;
git clone https://aur.archlinux.org/pikaur.git; 
cd pikaur; makepkg -fsri -y;
cd ..;

# reboot the computer
echo "Installation done. please reboot!"
