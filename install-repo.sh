#!/bin/bash
cd .. && echo "going to the previous dir" &&
## clone the repos
echo "cloning the repos" &&
git clone https://github.com/saikatm/wallpaperx && 
git clone https://github.com/saikatm/fonts && 
## installing the fonts
echo "moving font files" &&
cd fonts && cp -r .fonts ~/ && cd .. &&
## installing the wallpapers
echo "copying the wallpapers" &&
cd wallpaperx && cp -r .wallpapers/ ~/ && cd .. &&
## install the config files
echo "moving the config files" &&
cd linux-dots && cd .config &&
echo "moving fish files" &&
mkdir -p ~/.config/fish && cp -r fish/ ~/.config &&
echo "moving rofi files" &&
mkdir -p ~/.config/rofi && cp -r rofi/ ~/.config &&
echo "moving kitty files" &&
mkdir -p ~/.config/kitty && cp -r kitty/ ~/.config &&
echo "moving plank files" &&
mkdir -p ~/.local/share/plank && cp -r plank/themes/ ~/.local/share/plank/ &&
## clear font cache
echo "clear font cache" &&
fc-cache -fv &&
echo "Please Reboot Now.";
