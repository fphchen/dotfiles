#!/usr/bin/env bash

# Start picom with experimental features
exec picom --experimental-backends &

## Function for checking program that needs to be single instance
function run {
	if ! pgrep -f $1 ;
	then
		$@&
	fi
}

## Run single instance programs via Function run
run blueman-applet
run nm-applet
