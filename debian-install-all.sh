#!/bin/bash

#update first!
echo "checking for update..";
sudo apt update -y;

#Install nala pkg manager!
echo "Installing nala pkg manager..";
sudo apt install nala -y;

# install the apps
echo "installing all the apps..";
xargs sudo nala install < pkgs-debian.txt -y;

#enable preload services!
echo "starting preload services";
systemctl enable preload;
systemctl start preload;
echo "all pkgs are installed.. please reboot!";

#---------------------------------------------------
# # install virt manger
# echo "Installing kvm & virt manager..";
# sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;
# # fix the permissions
# echo "fixing permissions & starting the services..";
# sudo usermod -G kvm -a $USER;
# sudo usermod -G libvirt -a $USER;
# sudo systemctl enable libvirtd;
# sudo systemctl start libvirtd;
# # reboot the computer
