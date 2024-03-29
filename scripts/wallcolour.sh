#!/bin/bash

# Clear Pywall cache
wal -c

# Randomly select directories in ~/Wallpapers
# Randomly select file in above selcted directory
initdir=~/Documents/git/fphchen/wallpapers
randdir=$initdir/$(exec ls $initdir | shuf -n 1)
randfile=$(exec ls $randdir | shuf -n 1)
wall=$randdir/$randfile

# Pass full path of the randomly selected wallpaper to Feh & Pywall
feh --bg-fill $wall
sleep 0.5
wal -n -q -i $wall
sleep 0.5

# Apply Pywal colour scheme to Alacritty
source $HOME/.script/alacolour.sh

# Source the current wal colour scheme
source $HOME/.cache/wal/colors.sh

# Assign the variables in the wal scheme in vis' format
cat > $HOME/.config/vis/colors/wal << EOF
$color1
$color2
$color3
$color4
$color5
$color6
$color7
$color8
$color9
$color10
$color11
$color12
$color13
$color14
$color15
$color16
EOF
