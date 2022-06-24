### mount drives in linux

identify the drive with `lsblk`

format the drive `mkfs.ext4 /dev/drivename`

create the mount point `sudo mkdir /media/drivename`

set name of the drive nsert a line with the UUID, path, file type, defaults and 0 0. The line should look like this: (note: do not use spaced just hit tab)
`UUID=6fb54c8a-db63-41dc-9d8f-19b3afb3e768   /media/drivename    ext4    defaults 0 0`

get uuid of the drive `blkid`

add a label for the drive `e2label /dev/sdb2 drivename`

### change ownership of drive

make it writeable” `sudo chown username /media/drivename/`

run `blkid`

~~change ownership of drive `chown username /media/Desired-UUID`~~

[How to Auto Mount Drives in Linux on Boot](https://www.youtube.com/watch?v=LkwZZIsY9uE)

### must have apps:

```bash

### arch linux post install apps

pacman -S neofetch ntfs-3g git man-db man-pages gst-libav nano rofi kitty gparted papirus-icon-theme vlc micro clinfo gnome-sushi adb nomacs -y

sudo apt install papirus-icon-theme zathura gparted rofi kitty ntfs-3g vlc micro clinfo gnome-sushi adb nomacs -y;

##install KVM & Virt Manager
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager;

## Commands
sudo usermod -G kvm -a $USER;
sudo usermod -G libvirt -a $USER;
sudo systemctl enable libvirtd;
sudo systemctl enable --now libvirtd;
sudo reboot
```

- [appimage daemon](https://github.com/probonopd/go-appimage/blob/master/src/appimaged/README.md)
- [bottom](https://github.com/ClementTsang/bottom)
- warp-cli
- librecad
- [ventoy](https://www.ventoy.net/en/doc_linux_gui.html)

- **Install KVM and virt-manager**
    
    ### Add your userid to the kvm and libvirt groups.
    
    `sudo usermod -G kvm -a $USER
    sudo usermod -G libvirt -a $USER`
    
    `sudo systemctl enable libvirtd`
    
    `sudo systemctl enable --now libvirtd`
    `sudo reboot`
    
    ---
    
    - Debian based
    
    `sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager`
    
    - clear linux
    `sudo swupd bundle-add kvm-host virt-manager-gui`

[fix broken bengali font in linux](https://www.notion.so/fix-broken-bengali-font-in-linux-5f573dd6bd34474590ac39acf5306d1b)

### rofi launcher

The modi to combine in combi mode.  For syntax to -combi-modi, see -modi.  To
get one merge view, of window,run, and ssh:

`rofi -show combi -combi-modi "window,run,ssh" -modi combi`

[GitHub - catppuccin/rofi: 🦂 Soothing pastel theme for Rofi](https://github.com/catppuccin/rofi)

---

[How to Setup and Configure Rofi (The Best App Launcher)](https://www.youtube.com/watch?v=TutfIwxSE_s)

[config.rasi](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/aded9103-a3b9-4906-a364-5ef960aa76df/config.rasi)

[Rofi with Custom themes](https://www.notion.so/Rofi-with-Custom-themes-99cb94da0f2c417fa64ef572868cb56e)

---

### install gpu drivers

[docs/InstallingDrivers.md at master · lutris/docs](https://github.com/lutris/docs/blob/master/InstallingDrivers.md)

### web apps

Install web apps from chrome.

- [ ]  todoist
- [ ]  Notion
- [ ]  photope
- [ ]  google keep

### flatpak apps

- `flatpak uninstall --unused`
- Google Chrome
- Extension Manager
- Telegram
- VLC
- Master PDF Editor
- OBS Studio
- Foliate
- Discord
- [Motrix](https://github.com/agalwood/Motrix)
- Pitivi video editor
- Break Timer
- Time Cop
- Todoist
- Pdf Arranger
- gnome text editor
- Cozy - audiobook
- ****Font Downloader****
- **Fragments**
- xmind
- organizer
- https://flathub.org/apps/details/io.github.realmazharhussain.GdmSettings

```bash
##optional apps
flatpak install flathub com.google.Chrome -y; 
flatpak install flathub net.codeindustry.MasterPDFEditor -y; 
flatpak install flathub com.obsproject.Studio -y; 
flatpak install flathub org.pitivi.Pitivi -y; 
flatpak install flathub com.github.jeromerobert.pdfarranger -y; 
flatpak install flathub com.github.geigi.cozy -y; 
flatpak install flathub de.haeckerfelix.Fragments -y; 
flatpak install flathub org.gustavoperedo.FontDownloader -y; 
flatpak install flathub net.xmind.XMind -y
flatpak install flathub com.todoist.Todoist -y; 
flatpak install flathub com.github.johnfactotum.Foliate -y; 

#must needed apps 
flatpak uninstall --unused

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

### gnome extensions:

- workspace bar
- vitals
- screenshot tool
- pop shell - for tiling wm
- gnome-
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7d8c8100-931e-4b4f-87fe-390f4d38b657/Untitled.png)
    

### fix broken bengali font in linux

- copy fonts folder in the .fonts dir
- run `fc-cache -fv`

~~Home Directory তে গিয়ে টার্মিনালে ওপেন করেন। তারপর এই কমান্ড রান করেনঃ mkdir -p .config/fontconfig/conf.d/ তারপর লিংকে দেয়া ফাইলটি ওখানে(conf.d এর মধ্যে) কপি করেন। তারপর লগ-আউট করে পুনরায় লগ-ইন করুন।~~

~~❯ mkdir -p .config/fontconfig/conf.d/
❯ cp ~/Downloads/90-bengali.conf ~/.config/fontconfig/conf.d/~~

### install open bangla keyboard

- download .deb
- sudo dpkg -i “package”

[Installing OpenBangla Keyboard · OpenBangla/OpenBangla-Keyboard Wiki](https://github.com/OpenBangla/OpenBangla-Keyboard/wiki/Installing-OpenBangla-Keyboard)

### Bengali font in libreoffice

- Copy the .fonts dir then clear fc cache
- Change libreoffice settings: language add bengali india.
- Remove asian fonts Chinese

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f52461a0-7c1e-4a26-b522-a112bf5bd0ea/Untitled.png)

### eye candy for linux

[dot files](https://www.notion.so/dot-files-57ed5f074a3e4e14b989c0a122e1561f)

### [yaru theme for gnome](https://blog.devget.net/linux/how-to-install-ubuntu-yaru-theme-in-pop_os-20-04/)

`sudo apt install yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound`

---

[GitHub - vinceliuice/WhiteSur-cursors: WhiteSur cursors theme for linux desktops](https://github.com/vinceliuice/WhiteSur-cursors)

---

[GitHub - zayronxio/Deepin-icons-2022: Deepin icons 2022](https://github.com/zayronxio/Deepin-icons-2022)

---

[GitHub - vinceliuice/Tela-circle-icon-theme: Tela-circle-icon-theme](https://github.com/vinceliuice/Tela-circle-icon-theme)

### The rofi launcher

- [x]  Launch apps with rofi
- [ ]  Minimal theme for rofi two tone
- [ ]  Rofi: Find Files
- [x]  Rofi: Emoji
- [x]  Rofi: powermenu
- [ ]  Rofi: Calculator

---

- [rofi-emoji](https://github.com/Mange/rofi-emoji)  : `rofi -show emoji -modi emoji -theme Paper.rasi`
- [rofi-power](https://github.com/jluttine/rofi-power-menu) : `rofi -show power-menu -modi power-menu:/home/saikat/.local/bin/./rofi-power-menu`
    - fix gnome blocked by application `gsettings set org.gnome.desktop.lockdown disable-lock-screen 'false’`
