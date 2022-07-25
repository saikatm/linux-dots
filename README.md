## dotfiles for a new linux machine.

|       1			  |   	2	              |
| :-----------------: | :-----------------------------: |
|        DISTO        |   ARCH / MANJARO / POP-OS   |
| DESKTOP ENVIRONMENT |              GNOME              |
|        THEME        | [ZORIN OS DESKTOP THEME](https://github.com/ZorinOS/zorin-desktop-themes) |
|        ICONS        | [ZORIN OS ICONS](https://github.com/ZorinOS/zorin-icon-themes) OR PAPIRUS ICONS |
| LAUNCHER | [ROFI](https://github.com/davatorium/rofi) |
| TERMINAL | [KITTY TERMINAL](https://sw.kovidgoyal.net/kitty/) |
| DOCK | PLANK DOCK |

---


### Dependencies
- sudo apt install OR sudo pacman -S `kitty fish rofi plank`

### install the dotfiles, fonts and wallpapers

- just `git clone https://github.com/saikatm/linux-dots;`
- then cd `linux dots ` `./install-dotfiles.sh` to install the dotfiles

### install fonts and wallpapers
- run `./install-fonts` for installing fonts
- run `./install-walls.sh` for wallpapers
- Then `reboot`

  ---
###  Install the necessary apps with a single command: 

**on Arch based OS: `sudo pacman -S --needed base-devel git neofetch ntfs-3g git man-db man-pages gst-libav nano rofi kitty gparted papirus-icon-theme vlc micro clinfo android-tools nomacs firefox flatpak fish plank foliate htop gparted -y`**

install AUR helper: https://github.com/actionless/pikaur, `pikaur -S preload`; `pikaur -S appimagelauncher`

---

**on Debian based OS: `sudo apt install kitty rofi papirus-icon-theme gparted preload neofetch htop plank fish foliate-y`**

---

## install all flatpak apps: 

`flatpak install flathub net.agalwood.Motrix -y`
`flatpak install flathub org.telegram.desktop -y;`
`flatpak install flathub com.github.jeromerobert.pdfarranger -y;`
`flatpak install flathub com.mattjakeman.ExtensionManager -y;`
`flatpak install flathub org.gnome.BreakTimer-y;`
`flatpak install flathub org.librehunt.Organizer -y;`
`flatpak install flathub io.typora.Typora -y`

---

| MUST HAVE APPS       | LINKS                                                        |
| -------------------- | ------------------------------------------------------------ |
| Calculator : Parsify | https://github.com/parsify-dev/desktop                       |
| App Image Launcher   | `pikuar appimagelauncher;` https://github.com/TheAssassin/AppImageLauncher/releases |
| Open Bangla Keyboard | https://github.com/OpenBangla/OpenBangla-Keyboard            |

---

### Install KVM, Virt manger 

**check for hardware support (virt manager)**
`LC_ALL=C lscpu | grep Virtualization`

**install the deps**
`sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat libguestfs iptables ebtables -y`

**fix the permissions** 
`sudo usermod -G kvm -a $USER;`
`sudo usermod -G libvirt -a $USER;`
`sudo systemctl enable libvirtd;`
`sudo systemctl enable --now libvirtd;`
`sudo reboot`

**enable the service**
`sudo virsh net-autostart default`
`sudo systemctl enable libvirtd.service;` 
`sudo systemctl start libvirtd.service;`
`reboot;`

## The repo is work in progress❗