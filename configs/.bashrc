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
alias ls='ls --color=auto'
alias lsla='ls -lah'
alias ka='killall'
alias pk='pkill'
alias now='date +%Y%m%d%H%M'

# Terminal Directory Alias
alias ~='cd ~'
alias r='cd /'
alias ..='cd ..; pwd'
alias ...='cd ..; cd ..; pwd'
alias ....='cd ..; cd ..; cd ..; pwd'
alias rmd='rm -rf'

# Pacman Alias
alias pcm='sudo pacman'
alias parucr='paru -Sccd'

# 202333 Calendar Alias
alias jan='cal -m 01 2023'
alias feb='cal -m 02 2023'
alias mar='cal -m 03 2023'
alias apr='cal -m 04 2023'
alias may='cal -m 05 2023'
alias jun='cal -m 06 2023'
alias jul='cal -m 07 2023'
alias aug='cal -m 08 2023'
alias sep='cal -m 09 2023'
alias oct='cal -m 10 2023'
alias nov='cal -m 11 2023'
alias dec='cal -m 12 2023'

# VIM Alias
alias rswap='rm -rf ~/.cache/vim/swap/*.*'
alias v='vim'
alias s.brc='source ~/.bashrc'
alias v.brc='vim ~/.bashrc'
alias v.vrc='vim ~/.vimrc'

# Git
alias gi='git init'
alias ga.='git add .'
alias gs='git status'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'
alias gitdir='cd ~/Documents/git'
alias dotfiles='cd ~/Documents/git/fphchen/dotfiles'
alias wallpapers='cd ~/Documents/git/fphchen/wallpapers'

# Function Alias
mkcd (){
	mkdir -p -- "$1" && cd -P -- "$1"
}

# App alias
alias peaclock='peaclock --config-dir ~/.config/peaclock'

# Startup
echo -e "\n"
neofetch
echo -e "\nWelcome ${USER^}, AVDENTES FORTVNA IVVAT!\n"

# Enable VIM commands in terminal
set -o vi
