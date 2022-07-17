dot files for a new linux machine.

|       1			  |   	2	              |
| :-----------------: | :-----------------------------: |
|        DISTO        |   ARCH / MANJARO / POP-OS   |
| DESKTOP ENVIRONMENT |              GNOME              |
|        THEME        | [ZORIN OS DESKTOP THEME](https://github.com/ZorinOS/zorin-desktop-themes) |
|        ICONS        | [ZORIN OS ICONS](https://github.com/ZorinOS/zorin-icon-themes) OR PAPIRUS ICONS |
| LAUNCHER | [ROFI](https://github.com/davatorium/rofi) |
| TERMINAL | KITTY |
| DOCK | PLANK DOCK |

---

## install the configs, fonts and wallpapers

- `git clone https://github.com/saikatm/wallpaperx; git clone https://github.com/saikatm/fonts; git clone https://github.com/saikatm/linux-dots;` 
- insall the repo `./install.sh`
- 

- run `cd linux-dots; mkdir -p ~/.fonts; mv .fonts ~/; fc-cache -fv;`
- then `reboot`





nstall the apps with a single command: 

on Arch based OS: `sudo pacman -S kitty rofi papirus-icon-theme gparted neofetch htop fish plank foliate -y`

install AUR helper: https://github.com/actionless/pikaur, `pikaur -S preload`; `pikaur -S appimagelauncher`

---

on Debian based OS: `sudo apt install kitty rofi papirus-icon-theme gparted preload neofetch htop plank fish foliate-y`

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

- fixt virt manager issue network

  `sudo virsh net-autostart default`
