#
# ~/.bashrc
export PATH=$PATH:/usr/local/bin

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Enable VIM commands in terminal
set -o vi

# Terminal Shortcut Alias
alias clr='clear'
alias h='history'
alias lsa='ls -a'
alias lsl='ls -l'
alias ka='killall'

# Terminal Directory Alias
alias ~='cd ~'
alias r='cd /'
alias ..='cd ..;pwd'
alias ...='cd ..; cd ..;pwd'
alias ....='cd ..; cd ..; cd ..;pwd'
alias rmdir='sudo rm -rf'

# Pacman Alias
alias pcm='sudo pacman'

# 2022 Calendar Alias
alias jan='cal -m 01 2022'
alias feb='cal -m 02 2022'
alias mar='cal -m 03 2022'
alias apr='cal -m 04 2022'
alias may='cal -m 05 2022'
alias jun='cal -m 06 2022'
alias jul='cal -m 07 2022'
alias aug='cal -m 08 2022'
alias sep='cal -m 09 2022'
alias oct='cal -m 10 2022'
alias nov='cal -m 11 2022'
alias dec='cal -m 12 2022'

# VIM Alias
alias v='vim'
alias vrc.lua='vim ~/.config/awesome/rc.lua'
alias vtheme.lua='vim ~/.config/awesome/theme.lua'
alias v.bashrc='vim ~/.bashrc'
alias s.bashrc='source ~/.bashrc'
alias v.vimrc='vim ~/.vimrc'
alias rswap='rm -rf ~/.cache/vim/swap/*.*'

# Git
alias ga.='git add .'
alias gs='git status'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'

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
set -o vi
