# linux-dots

### fonts and dotfiles for my linux machine.

- .config - contains the config files for different apps.
- .fonts - contains some custom fonts.


### install the rofi theme 
- get it from [here](https://github.com/catppuccin/rofi) 
- then replace the config.rasi with my config.rasi

### fix bengali font issue on linux

- copy the repo
- move the .fonts folder to home directory
    - `cd linux-dots; mv .fonts ~/.fonts; fc-cache -fv;`
    - reboot
