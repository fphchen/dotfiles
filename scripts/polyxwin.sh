#!/bin/bash

DESKTOPID=$(xdotool getwindowfocus)

if [ $DESKTOPID == "4194311" ]; then

	echo "Desktop"

elif [ $DESKTOPID != "1833" ]; then

	WM_CLASS=$(xprop -id $(xdotool getactivewindow) WM_CLASS | awk 'NF {print $NF}' | sed 's/"/ /g')

	if [ $WM_CLASS == "Brave-browser" ]; then
		echo "Brave"
	elif [ $WM_CLASS == "firefox" ]; then
		echo "Firefox"
	else
		echo "$WM_CLASS"
	fi
fi
