#!/bin/bash

#update first!
sudo apt update -y

sudo apt install -y papirus-icon-theme gparted rofi kitty ntfs-3g vlc micro clinfo adb nomacs firefox flatpak;


## install virt manger
echo "Installation done. please reboot."

sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;

## check for hardware support
LC_ALL=C lscpu | grep Virtualization


#fix the permissions 
echo "fixing permissions!"
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl start libvirtd.service;

# reboot the computer
echo "Installation done. please reboot!"

