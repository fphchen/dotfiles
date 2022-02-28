#!/bin/bash
# The name of polybar bar which houses the main spotify module and the control modules.
parent_bar="now-playing"phaalan
parent_bar_pid=$(pgrep -a "polybar" | grep "$parent_bar" | cut -d" " -f1)

# Set the source audio player here.
# Players supporting the MPRIS spec are supported.
# Examples: spotify, vlc, chrome, mpv and others.
# Use `playerctld` to always detect the latest player.
# See more here: https://github.com/altdesktop/playerctl/#selecting-players-to-control
player="playerctld"

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
format="{{ title }} - {{ artist }} - {{duration(mpris:length)}} "

playerctl_status=$(playerctl --player=$player status 2>/dev/null)
exit_code=$?

chk_char (){
	if (( $1 >= 40 )) ; then
		echo "$status1"
	else
		printf '%-40s' "$status1"
	fi
}

if [ $exit_code -eq 0 ]; then
	status=$playerctl_status
else
   	status="Welcome ${USER^}!"
fi


if [ "$1" == "--status" ]; then
	printf '%-40s' "$status"
else
	if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
		status1=$(playerctl --player=$player metadata --format "$format")
		charnum=${#status1}
		chk_char $charnum
	else
		printf '%-40s' "$status"
	fi
fi
