#!/bin/bash

# Generate exit_code check for error output
# and redirect outputs (STDOUT & STDERR) to /dev/null
xdotool getactivewindow > /dev/null 2>&1
exit_code=$?

if [ ! $exit_code -eq 0 ]; then
	echo "Desktop"	
else
	# Get WM_CLASS & WM_NAME variables from active window
	wm_class=$(xprop -id $(xdotool getactivewindow) WM_CLASS | awk 'NF {print $NF}' | sed 's/"/ /g')
	wm_name=$(xprop -id $(xdotool getactivewindow) WM_NAME | cut -d '=' -f 2 | awk -F\" '{ print $2 }')
	
	if [ $wm_class == "Brave-browser" ]; then
		echo "Brave"
	
	elif [ $wm_class == "firefox" ]; then
		echo "$wm_name"
	
	elif [ $wm_class == "feh" ]; then
		echo "${wm_name^}"
	else
		echo "${wm_class^}"
	fi
fi

