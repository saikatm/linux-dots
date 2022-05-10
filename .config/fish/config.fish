if status is-interactive
	rxfetch;
    # Commands to run in interactive sessions can go here
end


## Aliases
alias ls "ls --group-directories-first"
alias lsl "ls -la --group-directories-first -lh"
alias search "apt search"
alias show "apt-cache show"
alias install "sudo apt install --no-install-recommends"
alias upgrade "sudo apt upgrade"
alias update "sudo apt update"
alias remove "sudo apt remove"
alias purge "sudo apt purge"
alias clean "sudo apt-get clean"
alias autoclean "sudo apt-get autoclean"
alias autoremove "sudo apt-get autoremove"
alias reconfigure "sudo dpkg-reconfigure"
alias pkglist "dpkg --get-selections | grep -v deinstall | sed s/\tinstall//g"
alias version "apt-cache policy"
alias font-refresh "fc-cache -fv"
alias clone "git clone --depth 1"
alias nf "neofetch"

