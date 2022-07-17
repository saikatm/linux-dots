#!/bin/bash
cd ..;
## clone the repos
git clone https://github.com/saikatm/wallpaperx; 
git clone https://github.com/saikatm/fonts; 
git clone https://github.com/saikatm/linux-dots;
## installing the fonts
cd fonts; cp -r .fonts ~/; cd ..;
## installing the wallpapers
cd wallpaperx; cp -r .wallpapers ~/; cd ..;
## install the config files
cd linux-dots; cd .config;
mkdir -p ~/.config/fish; cp -r fish ~/.config;
mkdir -p ~/.config/fish; cp -r rofi ~/.config;
mkdir -p ~/.config/fish; cp -r kitty ~/.config;
mkdir -p ~/.local/share/plank; cp -r plank/themes/ ~/.local/share/plank/;
## clear font cache
fc-cache -fv;
