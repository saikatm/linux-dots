#!/bin/bash

#update first!
echo "checking for update..";
sudo dnf update;
# install the apps
echo "installing all the apps..";
xargs sudo dnf -y install < pkgs-fedora.txt 