## configure dnf

`sudo nano /etc/dnf/dnf.conf`  
fastestmirror=True  
max_paralleldownloads=10  
defaultyes=True  
keepcache=True  

## enable rpm fusion

https://rpmfusion.org/Configuration

`sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`  
`sudo dnf groupupdate core`

## enable flathub repo

`flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`

## enable media codecs

`sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin`  
`sudo dnf groupupdate sound-and-video`

## enable preload
`sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y; systemctl start preload; systemctl enable preload;`

## install development tools

`sudo dnf install kernel-headers kernel-devel`  
`sudo dnf group install "C Development Tools and Libraries"`
