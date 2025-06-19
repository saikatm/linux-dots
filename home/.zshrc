# ~/.zshrc - Clean Zsh Configuration

# ============================================================================
# Oh My Zsh
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# ============================================================================
# Essential ZSH Options
# ============================================================================

# History
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Navigation & Completion
setopt AUTO_CD
setopt AUTO_MENU
setopt NO_BEEP
setopt PROMPT_SUBST

# ============================================================================
# Environment & Path
# ============================================================================

export QT_QPA_PLATFORM=xcb
export PATH="$HOME/.local/bin:$PATH"

# ============================================================================
# Completion
# ============================================================================

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ============================================================================
# Git Aliases
# ============================================================================

alias g-push="git push -u origin main"
alias g-a="git add"
alias g-b="git branch"
alias g-m="git commit -m"
alias g-co="git checkout"
alias g-s="git status"
alias clone="git clone --depth 1"
alias pull="git pull"

# ============================================================================
# System Aliases
# ============================================================================

alias ls="ls --group-directories-first --color=auto"
alias lsl="ls -la --group-directories-first -lh --color=auto"
alias m="micro"
alias lsd="lsd -la"
alias b="btm -b"
alias nf="neofetch"

# Debian/Nala
alias nlu="sudo nala update"
alias nlug="sudo nala upgrade"
alias nls="nala search"

# Flatpak
alias flu="flatpak update"
alias fll="flatpak list"

# System
alias cpu="sudo auto-cpufreq --stats"
alias font-refresh="fc-cache -fv"

# ============================================================================
# Functions
# ============================================================================

mkcd() { mkdir -p "$1" && cd "$1" }
