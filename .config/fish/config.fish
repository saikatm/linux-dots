# Fish shell configuration file
# ----------------------------

# Interactive session configurations
if status is-interactive
    # Commands to run in interactive sessions can go here
    # Uncomment to use rxfetch on startup
    # rxfetch
end

# Remove default Fish greeting
set fish_greeting

# ==============================
# Git Aliases
# ==============================
alias g-push "git push -u origin main"
alias g-a "git add"
alias g-b "git branch"
alias g-bm "git branch --merged"
alias g-bnm "git branch --no-merged"
alias g-bed "git branch --edit-description"
alias g-bsd "git branch --show-description"  # Fixed: removed erroneous 'commit'
alias g-m "git commit -m"
alias g-co "git checkout"
alias g-ls "git ls-files"
alias g-rv "git revert"
alias g-rvnc "git revert --no-commit"
alias g-sb "git show-branch"
alias g-smui "git submodule update --init"
alias g-s "git status"
alias g-w "git whatchanged"
alias clone "git clone --depth 1"
alias pull "git pull"

# ==============================
# Directory & File Management
# ==============================
alias ls "ls --color=auto --group-directories-first"
alias lsl "ls -la --group-directories-first -lh"
alias lx "lsd -la"
alias m "micro"

# ==============================
# System Information
# ==============================
alias nf "neofetch"
alias b "btm -b"  # Bottom process monitor in basic view

# ==============================
# Package Management
# ==============================
# --- Flatpak ---
alias flu "flatpak update"
alias fll "flatpak list"

# --- Debian/Ubuntu Based (using Nala) ---
alias nlu "sudo nala update"
alias nlug "sudo nala upgrade"
alias nls "nala search"

# Fedora DNF Package Management
# ==============================

# Basic system maintenance
# alias update "sudo dnf check-update"
# alias upgrade "sudo dnf upgrade"
# alias install "sudo dnf install"
# alias remove "sudo dnf remove"
# alias autoremove "sudo dnf autoremove"
# alias clean "sudo dnf clean all"

# --- Arch Based (Uncomment if using Arch) ---
# alias pmu "sudo pacman -Syu"
# alias pms "pacman -Ss"
# alias pmr "sudo pacman -Rsc"
# alias pmc "sudo pacman -Sc"

# --- Alternative apt commands (Uncomment if needed) ---
# alias upgrade "sudo apt upgrade"
# alias update "sudo apt update"
# alias remove "sudo apt remove"
# alias purge "sudo apt purge"
# alias clean "sudo apt-get clean"
# alias autoclean "sudo apt-get autoclean"
# alias autoremove "sudo apt-get autoremove"
# alias reconfigure "sudo dpkg-reconfigure"
# alias search "apt search"
# alias show "apt-cache show"
# alias install "sudo apt install --no-install-recommends"

# ==============================
# Other Commands
# ==============================
# alias ttc "tty-clock -c -t"
# alias code "flatpak run com.visualstudio.code"

# ==============================
# Fish Prompt Configuration
# ==============================
# Enable Starship prompt (uncomment to use)
# starship init fish | source