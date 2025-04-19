## Linux System Setup Dotfiles

**Quickly configure Fedora or Pop!_OS systems with optimized settings and essential applications.**  
*"My OS journey: Windows 🪟 → macOS (Hackintosh) 🍎 → Linux 🐧 - ends here!"*

## ⚙️ Script Features
| Component               | Fedora                     | Pop!_OS                   |
|-------------------------|----------------------------|---------------------------|
| Package Manager         | DNF5 optimized            | APT configured            |
| Media Codecs            | RPM Fusion + GStreamer     | Ubuntu Restricted Extras  |
| Desktop Environment     | GNOME optimized            | GNOME customized          |
| AppImages               | Todoist, Parsify, Notion   | Todoist, Parsify, Notion  |
| Performance             | Preload service            | Preload service           |
| Development Tools       | C Development Tools        | Build Essential           |
| Cloud Storage           | MEGA, Dropbox              | MEGA, Dropbox             |


### 1. System Setup Scripts

**For Fedora Systems:**
```bash
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/fedora-setup.sh && chmod +x fedora-setup.sh && sudo ./fedora-setup.sh
```

**For Pop!_OS/Ubuntu Systems:**
```bash
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/popos-setup.sh && chmod +x popos-setup.sh && sudo ./popos-setup.sh
```

*Both scripts will:*

✔ Configure optimized package manager settings  
✔ Enable essential software repositories  
✔ Install development tools and utilities  
✔ Remove unnecessary default applications  
✔ Set up performance optimizations  
✔ Install productivity applications  

### 2. Post-Setup Configuration

```bash
# Install recommended fonts
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/fonts-install.sh -O fonts-install.sh && chmod +x fonts-install.sh && sudo ./fonts-install.sh

# Apply system dotfiles
wget https://raw.githubusercontent.com/saikatm/linux-dots/main/dotfiles-install.sh && chmod +x dotfiles-install.sh && sudo ./dotfiles-install.sh
```

## 🌟 Essential Applications

### Productivity
- [Notion AppImage](https://github.com/saikatm/notion-appimage) - All-in-one workspace
- [Parsify Calculator](https://github.com/parsify-dev/desktop) - Smart calculator
- [Todoist](https://todoist.com) - Task management

### System Utilities
- [AppImage Launcher](https://github.com/TheAssassin/AppImageLauncher/wiki) - Manage AppImages
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) - Laptop power optimization
- [Timeshift](https://github.com/teejee2008/timeshift) - System backups

### Localization
- [Open Bangla Keyboard](https://github.com/OpenBangla/OpenBangla-Keyboard) - Bengali input method

## 🎨 Customization

### GNOME Extensions
- [Vitals](https://extensions.gnome.org/extension/1460/vitals/) - System monitoring
- [Space Bar](https://extensions.gnome.org/extension/5090/space-bar/) - Workspace manager
- [Session Manager](https://extensions.gnome.org/extension/4709/another-window-session-manager/) - Window management

### Themes
- [Chepeus Conky Theme](https://github.com/closebox73/Chepeus) - Desktop widgets
- [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) - Icon pack



> 💡 Tip  : After setup, reboot your system for all changes to take effect.

