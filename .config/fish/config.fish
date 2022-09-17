if status is-interactive
#	rxfetch;
    # Commands to run in interactive sessions can go here
end
set fish_greeting

#----- Short aliases are for frequent commands and options-------
# check here for more: https://github.com/GitAlias/gitalias
alias code "flatpak run com.visualstudio.code"
alias g-push "git push -u origin main"
alias g-a "git add"
alias g-b "git branch"
alias g-bm "git branch --merged "
alias g-bnm "git branch --no-merged "
alias g-bed "git branch --edit-description"
alias g-bsd "git commit  branch --show-description"
alias g-m "git commit -m"
alias g-co "git checkout"
alias g-ls "git ls-files"
alias g-rv "git revert "
alias g-rvnc "git revert --no-commit"
alias g-sb "git show-branch"
alias g-smui "git submodule update --init"
alias g-s "git status"
alias g-w "git whatchanged"

#--------global Aliases agnostic to any distribution--------
alias ls "ls --group-directories-first"
alias lsl "ls -la --group-directories-first -lh"
alias font-refresh "fc-cache -fv"
alias clone "git clone --depth 1"
alias nf "neofetch"
alias fl-u "flatpak update"
alias fl-l "flatpak list"
alias m "micro"
alias lsd "lsd -la"

#---------arch based os specific aliases---------
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
