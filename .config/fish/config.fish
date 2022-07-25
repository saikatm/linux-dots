if status is-interactive
#	rxfetch;
    # Commands to run in interactive sessions can go here
end

##--------global Aliases agnostic to any distribution--------##
alias ls "ls --group-directories-first"
alias lsl "ls -la --group-directories-first -lh"
alias font-refresh "fc-cache -fv"
alias clone "git clone --depth 1"
alias nf "neofetch"
alias fl-u "flatpak update"
alias fl-l "flatpak list"
alias m "micro"
alias lsd "lsd -la"

##----- git specific alias----------#
alias g-st "git status"
alias g-cm "git commit -m"
alias push "git push -u origin main"

##---------arch based os specific aliases---------## 
alias update "sudo pacman -Syu"
alias search "pacman -Ss"
alias remove "sudo pacman -Rsc"
alias clean "sudo pacman -Sc"
alias pik "pikaur"


##------ debian based OS specifiv aliases-------## 
#alias upgrade "sudo apt upgrade"
#alias update "sudo apt update"
#alias remove "sudo apt remove"
#alias purge "sudo apt purge"
#alias clean "sudo apt-get clean"
#alias autoclean "sudo apt-get autoclean"
#alias autoremove "sudo apt-get autoremove"
#alias reconfigure "sudo dpkg-reconfigure
#alias search "apt search"
#alias show "apt-cache show"
#alias install "sudo apt install --no-install-recommends"

# other aliases
#alias ttc "tty-clock -c -t"
##-------------
## enable starship prompt
# starship init fish | source
