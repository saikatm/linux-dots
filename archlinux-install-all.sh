#!/bin/bash

#update first!
echo "checking for update..";
sudo pacman -Sy;
# install the apps
echo "installing all the apps..";
sudo pacman -S --noconfirm - < pkgs-arch.txt;
# # install the aur helper
# echo "installing aur helper pikaur.."
# cd ..;
# git clone https://aur.archlinux.org/pikaur.git;
# cd pikaur; makepkg --noconfirm -fsri;
# cd ..;

# # install KVM and virt manager.
# echo "Installing kvm & virt manager..";
# sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs -y;
# # fix the permissions
# echo "fixing permissions & starting the services..";
# sudo usermod -G kvm -a $USER;
# sudo usermod -G libvirt -a $USER;
# sudo systemctl enable libvirtd;
# sudo systemctl start libvirtd;

# reboot the computer
echo "Installation done. please reboot!"
