#!/bin/bash
## install the config files
cd .config &&
echo "moving fish files" &&
mkdir -p ~/.config/fish; cp -r fish/ ~/.config &&
echo "moving rofi files" &&
mkdir -p ~/.config/rofi; cp -r rofi/ ~/.config &&
echo "moving kitty files" &&
mkdir -p ~/.config/kitty; cp -r kitty/ ~/.config &&
echo "moving plank files" &&
mkdir -p ~/.local/share/plank && cp -r plank/themes/ ~/.local/share/plank/ &&
echo "Everyting is installed!";
