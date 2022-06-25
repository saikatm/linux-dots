#!/bin/bash

#update first!
sudo pacman -Syu

# install the apps
pacman -S --needed base-devel git neofetch ntfs-3g git man-db man-pages gst-libav nano rofi kitty gparted papirus-icon-theme vlc micro clinfo android-tools nomacs firefox flatpak -y

# copy the files
cd linux-dots;
cp .config/rofi/ ~/.config/; .config/kitty/ ~/.config/; .config/fish/ ~/.config/; cp .fonts ~/.; fc-cache -fv 


# install the aur helper
cd ..
git clone https://aur.archlinux.org/pikaur.git; 
cd pikaur; makepkg -fsri  --noconfirm

# reboot the computer
echo ~Installation done. please reboot."
