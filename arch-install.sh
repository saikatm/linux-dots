> git clone [http://github.com/saikatm/linux-dots](http://github.com/saikatm/linux-dots)
> 

### for arch based distro

```bash
./arch-install.sh

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
cd pikaur; makepkg -fsri -y

# reboot the computer
echo ~Installation done. please reboot."

## check for hardware support (virt manager)
LC_ALL=C lscpu | grep Virtualization

#install the deps
sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat libguestfs iptables ebtables -y

##fix the permissions 
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl enable --now libvirtd;
sudo reboot

## enable the service
sudo systemctl enable libvirtd.service; 
sudo systemctl start libvirtd.service;
```

### for debian based distro

```bash
./debian-install.sh

sudo apt install -y papirus-icon-theme zathura gparted rofi kitty ntfs-3g vlc micro clinfo adb nomacs firefox flatpak;

## for pop os 
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## install virt manger
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;

## check for hardware support
LC_ALL=C lscpu | grep Virtualization

##fix the permissions 
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl enable --now libvirtd;
sudo reboot

## enable the service
sudo systemctl enable libvirtd.service; 
sudo systemctl start libvirtd.service;
```

### install flatpak apps

```bash
flatpak install flathub com.github.jeromerobert.pdfarranger -y; 
flatpak install flathub net.agalwood.Motrix -y; 
flatpak install flathub io.gitlab.librewolf-community -y;
flatpak install flathub org.videolan.VLC -y; 
flatpak install flathub org.telegram.desktop -y; 
flatpak install flathub com.mattjakeman.ExtensionManager -y; 
flatpak install flathub org.gnome.TextEditor -y; 
flatpak install flathub org.librehunt.Organizer -y;
flatpak install flathub org.gnome.BreakTimer-y; 
```

### cool linux apps

```bash
foliate 
gnome-sushi
```
