#!/bin/bash

# Randomly select directories in ~/wallpapers
# Randomly select file in above selcted directory
initdir=~/Documents/git/fphchen/wallpapers
randdir=$initdir/$(exec ls $initdir | shuf -n 1)
randfile=$(exec ls $randdir | shuf -n 1)
wall=$randdir/$randfile

swww img ${wall} --transition-fps 60 --transition-type simple --transition-duration 2
