#!/bin/bash

PLAYER="playerctld"

PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    STATUS=$PLAYERCTL_STATUS
    else
        STATUS="No player is running"
fi

if [ "$1" == "--status" ]; then
    echo "$STATUS"
    else
	if [ "$STATUS" = "Playing"  ]; then
	    	echo ""
	else
	    	echo "契"
	fi
fi
