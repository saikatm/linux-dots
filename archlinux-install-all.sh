#!/bin/bash

#update first!
echo "checking for update..";
sudo pacman -Sy;

# install the apps
echo "installing all the apps..";

sudo pacman -S --noconfirm - < packages-arch.txt

# install the aur helper
# echo "installing aur helper.."
# cd ..;
# git clone https://aur.archlinux.org/pikaur.git;
# cd pikaur; makepkg --noconfirm -fsri;
# cd ..;
# 
# # reboot the computer
# echo "Installation done. please reboot!"
# 


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

