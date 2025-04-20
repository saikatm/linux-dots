# Linux System Setup Dotfiles

Configure Fedora or Pop!_OS with optimized settings and essential applications.

## Scripts

**Fedora:**
```bash
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/fedora-setup.sh && chmod +x fedora-setup.sh && sudo ./fedora-setup.sh
```

**Pop!_OS/Ubuntu:**
```bash
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/popos-setup.sh && chmod +x popos-setup.sh && sudo ./popos-setup.sh
```

**Post-Setup:**
```bash
# XFCE (PopOS only)
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/xfce-setup-popos.sh && chmod +x xfce-setup-popos.sh && sudo ./xfce-setup-popos.sh

# Fonts
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/fonts-install.sh -O fonts-install.sh && chmod +x fonts-install.sh && sudo ./fonts-install.sh

# Dotfiles
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/dotfiles-install.sh && chmod +x dotfiles-install.sh && sudo ./dotfiles-install.sh
```

## Applications
- [Notion](https://github.com/saikatm/notion-appimage)
- [Parsify](https://github.com/parsify-dev/desktop)
- [Todoist](https://todoist.com)
- [AppImage Launcher](https://github.com/TheAssassin/AppImageLauncher/wiki)
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq)
- [Timeshift](https://github.com/teejee2008/timeshift)
- [Open Bangla Keyboard](https://github.com/OpenBangla/OpenBangla-Keyboard)

> Reboot after setup for all changes to take effect.