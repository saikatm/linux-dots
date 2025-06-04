#!/bin/bash

# install autocpufreq
cd ..;
git clone https://github.com/AdnanHodzic/auto-cpufreq.git;
cd auto-cpufreq && sudo ./auto-cpufreq-installer;
sudo auto-cpufreq --install;
systemctl start auto-cpufreq;
systemctl status auto-cpufreq;
systemctl enable auto-cpufreq;

## install touchegg for trackpad
pikaur touchegg;
# install touche for configuring
## copy the preconfugrued xml file to .config dir
flatpak install flathub com.github.joseexposito.touche -y;

# install gnome x11 extension

