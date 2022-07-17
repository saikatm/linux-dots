#!/bin/bash
## clone the repos
git clone https://github.com/saikatm/wallpaperx; 
git clone https://github.com/saikatm/fonts; 
git clone https://github.com/saikatm/linux-dots;
## installing the fonts
cd fonts; cp -r .fonts ~/; cd..;
## installing the wallpapers
cd wallpaperx; cp -r .wallpapers ~/; cd..;
## install the config files
cd linux-dots; cd .config;
cp -r fish ~/.config;
cp -r rofi ~/.config;
cp -r kitty ~/.config;
cp -r plank/themes/ ~/.local/share/plank/;
## clear font cache
fc-cache -fv;
