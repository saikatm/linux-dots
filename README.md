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

## SCREENSHOTS

### KITTY TERMINAL THEME
<p align="center">
  <img src="kitty.png" style="border-radius:2%"/>
</p>
