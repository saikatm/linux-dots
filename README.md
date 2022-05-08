# linux-dots



## Install the Apps 
### FOR DEBIAN BASED DISTROS
- `sudo apt install kitty rofi`

### FOR ARCH BASED DISTROS
- `sudo pacman -S kitty rofi`


## fonts and dotfiles for my linux machine.

- .config - contains the config files for different apps.
- .fonts - contains some custom fonts.


## install the rofi theme 
- get it from [here](https://github.com/catppuccin/rofi) 
- then replace the config.rasi with my config.rasi

## fix bengali font issue on linux

- copy the repo
- move the .fonts folder to home directory
    - `cd linux-dots; mv .fonts ~/.fonts; fc-cache -fv;`
    - then `reboot`


### INSTALL FLATPAK 
on arch based: `sudo pacman -S flatpak; reboot;`
on pop_os: `sudo apt install flatpak; flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;`
for more check : https://flatpak.org/setup/

## MUST HAVE FLATPAK APPS

#must needed apps 
flatpak install flathub net.agalwood.Motrix -y; 
flatpak install flathub io.gitlab.librewolf-community -y;
flatpak install flathub org.videolan.VLC -y; 
flatpak install flathub org.telegram.desktop -y; 
flatpak install flathub com.mattjakeman.ExtensionManager -y; 
flatpak install flathub org.gnome.TextEditor -y; 
flatpak install flathub org.librehunt.Organizer -y;
flatpak install flathub org.gnome.BreakTimer-y; 
flatpak install flathub com.github.jeromerobert.pdfarranger -y; 

## REMOVE UNUSED SPACE ON FLATPAK
flatpak uninstall --unused


## SCREENSHOTS

### KITTY TERMINAL THEME
<p align="center">
  <img src="kitty.png" style="border-radius:2%"/>
</p>


