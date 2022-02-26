#!/bin/bash

player="playerctld"

playerctl_status=$(playerctl --player=$player status 2>/dev/null)
exit_code=$?

if [ $exit_code -eq 0 ]; then
    status=$playerctl_status
    else
        status="No player is running"
fi

if [ "$1" == "--status" ]; then
    echo "$status"
    else
	if [ "$status" = "Playing"  ]; then
	    	echo ""
	else
	    	echo "契"
	fi
fi
