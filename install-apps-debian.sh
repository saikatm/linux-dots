#!/bin/bash

#update first!
sudo apt update -y;

sudo apt install -y papirus-icon-theme gparted rofi kitty ntfs-3g vlc micro clinfo adb nomacs firefox plank fish;
echo "Basic apps are installed!";


## install virt manger
echo "Installing virt manager..";
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;



#fix the permissions 
echo "fixing permissions!";
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl start libvirtd.service;

# reboot the computer
echo "Installation done. please reboot!";

