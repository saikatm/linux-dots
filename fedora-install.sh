#!/bin/bash

#update first!
echo "checking for update..";
sudo dnf update;
# install the apps
echo "installing all the apps..";
xargs sudo dnf -y install < pkgs-fedora.txt 

# echo "Installing kvm & virt manager..";
# # install the pkgs
# sudo dnf install @virtualization -y
# # fix the permissions
# echo "fixing permissions & starting the services..";
# sudo usermod -G kvm -a $USER;
# sudo usermod -G libvirt -a $USER;
# sudo systemctl enable libvirtd;
# sudo systemctl start libvirtd;

# reboot the computer
echo "Installation done. please reboot!"
