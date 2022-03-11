#!/usr/bin/env bash

# Start Polybar
#
# Terminate already running polybar instances
killall -q polybar

# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar using default location ~/.config/polybar/config.ini
polybar awesome 2>&1 | tee -a /tmp/polybar.log & disown

sleep 0.5
