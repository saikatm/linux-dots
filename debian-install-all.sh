#!/bin/bash

#update first!
echo "checking for update..";
sudo apt update -y;
# install the apps
echo "installing all the apps..";
xargs sudo apt install < pkgs-debian.txt -y
echo "Basic apps are installed!";
# install virt manger
echo "Installing kvm & virt manager..";
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;
# fix the permissions
echo "fixing permissions & starting the services..";
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl start libvirtd;
# reboot the computer
echo "Installation done. please reboot!";
