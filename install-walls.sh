#!/bin/bash
echo "going to previous dir" &&
cd .. &&
echo "cloning the wallpaper repo" &&
git clone --depth 1 https://github.com/saikatm/wallpaperx.git && 
echo "moving wallpapers" &&
cd  wallpaperx && cp -r .wallpapers ~/ && 
echo "All Wallpapers are copied!";
