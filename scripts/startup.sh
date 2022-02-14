#!/bin/bash

sleep 1
exec alacritty -e peaclock --config-dir ~/.config/peaclock &
sleep 1
exec alacritty -e unimatrix &
sleep 1
exec alacritty -e htop &
