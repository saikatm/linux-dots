#!/bin/bash
echo "going to previous dir" &&
cd .. &&
echo "cloning the font repo" &&
git clone --depth 1 https://github.com/saikatm/fonts.git && 
cd fonts &&
echo "moving font files" &&
cd fonts && cp -r .fonts ~/ && 
## clear font cache
echo "clear font cache" &&
fc-cache -fv &&
echo "Please Reboot Now.";
