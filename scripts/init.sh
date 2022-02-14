#!/usr/bin/env bash
# Start Polybar
# Terminate already running polybar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar using default location ~/.config/polybar/config
polybar phaalan 2>&1 | tee -a /tmp/polybar.log & disown

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
