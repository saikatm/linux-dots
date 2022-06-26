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
alias font-refresh "fc-cache -fv"
alias clone "git clone --depth 1"
alias nf "neofetch"
alias fl-u "flatpak update"
alias fl-l "flatpak list"
alias g-st "git status"
alias m "micro"
alias ttc "tty-clock -c -t"

## arch based os specific aliases 
alias update "sudo pacman -Syu"
alias search "pacman -Ss"
alias remove "sudo pacman -Rsc"
alias purge "sudo apt purge"
alias clean "sudo pacman -Sc"

## debian based OS specifiv aliases 
#alias upgrade "sudo apt upgrade"
#alias update "sudo apt update"
#alias remove "sudo apt remove"
#alias purge "sudo apt purge"
#alias clean "sudo apt-get clean"
#alias autoclean "sudo apt-get autoclean"
#alias autoremove "sudo apt-get autoremove"
#alias reconfigure "sudo dpkg-reconfigure


# config recomended for bobthe fish theme
## git 

set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_use_abbreviated_path no
set -g theme_date_format "+%a %H:%M"
set -g theme_date_timezone Asia/Kolkata
set -g theme_avoid_ambiguous_glyphs yes

## theme settings
set -g theme_title_display_user yes
set -g theme_date_format "+%a %H:%M"
set -g theme_display_date yes
set -g theme_nerd_fonts yes
set -g theme_show_exit_status yes
set -g theme_display_jobs_verbose yes
set -g default_user your_normal_user
set -g theme_color_scheme dark #nord, gruvbox, dark, light, dracula solarized-dark


set -g fish_prompt_pwd_dir_length 0
set -g theme_project_dir_length 1
set -g theme_newline_cursor no
set -g theme_newline_prompt '$ '


## enable starship prompt
# starship init fish | source
