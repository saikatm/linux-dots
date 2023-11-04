if status is-interactive
#	rxfetch;
    # Commands to run in interactive sessions can go here
end
set fish_greeting

# check here for more: https://github.com/GitAlias/gitalias

#----- aliases git-------
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
alias clone "git clone --depth 1"


#--------global aliases agnostic to any distribution--------
#alias code "flatpak run com.visualstudio.code"
alias ls "ls --group-directories-first"
alias lsl "ls -la --group-directories-first -lh"
alias font-refresh "fc-cache -fv"
alias nf "neofetch"
alias flu "flatpak update"
alias fll "flatpak list"
alias m "micro"
alias lsd "lsd -la"
alias b "btm -b" #for btm process/system monitor basic view like htop

#---------debian based os specific aliases---------
alias nlu "sudo nala update"
alias nlug "sudo nala upgrade"
alias nls "nala search"

#---------arch based os specific aliases---------
# alias pmu "sudo pacman -Syu"
# alias pms "pacman -Ss"
# alias pmr "sudo pacman -Rsc"
# alias pmc "sudo pacman -Sc"

# alias for auto-cpufreq
alias cpu "sudo auto-cpufreq --stats"

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
