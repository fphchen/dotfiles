# ~/.bashrc
export EDITOR=vim
export OPENER=xdg-open

# Source 
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Enable AutoCorrect
shopt -s cdspell

# Terminal Shortcut Alias
alias clr='clear'
alias h='history'
alias ka='killall'
alias pk='pkill'
alias now='date +%Y%m%d%H%M'

# Terminal Directory Alias
alias ls='ls --color=auto'
alias lsla='ls -lah'
alias lsh='ls -lh'
alias lsa='ls -A'
alias lsm='ls -m'
alias lsr='ls -R'
alias lsg='ls -l --group-directories-first'
alias ~='cd ~'
alias r='cd /'
alias ..='cd ..; pwd'
alias ...='cd ..; cd ..; pwd'
alias ....='cd ..; cd ..; cd ..; pwd'
alias rmrf='rm -rf'

# Pacman Alias
alias pcm='sudo pacman'
alias parucr='paru -Sccd'

# VIM Alias
alias rswap='rm -rf ~/.cache/vim/swap/*.*'
alias v='vim'
alias s.brc='source ~/.bashrc'
alias s.zrc='source ~/.zshrc'
alias v.brc='vim ~/.bashrc'
alias v.zrc='vim ~/.zshrc'
alias v.vrc='vim ~/.vimrc'

# Git Alias
alias gcl='git clone'
alias gi='git init'
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'
alias gitdir='cd ~/Documents/git'
alias dotfiles='cd ~/Documents/git/fphchen/dotfiles'
alias wallpapers='cd ~/Documents/git/fphchen/wallpapers'
alias installers='cd ~/Documents/git/fphchen/installers'

# 2026 Calendar Alias
alias jan='cal -m 01 2026'
alias feb='cal -m 02 2026'
alias mar='cal -m 03 2026'
alias apr='cal -m 04 2026'
alias may='cal -m 05 2026'
alias jun='cal -m 06 2026'
alias jul='cal -m 07 2026'
alias aug='cal -m 08 2026'
alias sep='cal -m 09 2026'
alias oct='cal -m 10 2026'
alias nov='cal -m 11 2026'
alias dec='cal -m 12 2026'

# Function Alias
mkcd (){
	mkdir -p -- "$1" && cd -P -- "$1"
}

# App alias
alias peaclock='peaclock --config-dir ~/.config/peaclock'

# Startup Message
echo -e "\n"
neofetch
echo -e "\nWelcome ${USER^}, AVDENTES FORTVNA IVVAT!\n"

# Enable VIM commands in terminal
set -o vi
