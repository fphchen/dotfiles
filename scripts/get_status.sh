#!/bin/bash
# The name of polybar bar which houses the main spotify module and the control modules.
PARENT_BAR="now-playing"phaalan
PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | cut -d" " -f1)

# Set the source audio player here.
# Players supporting the MPRIS spec are supported.
# Examples: spotify, vlc, chrome, mpv and others.
# Use `playerctld` to always detect the latest player.
# See more here: https://github.com/altdesktop/playerctl/#selecting-players-to-control
PLAYER="playerctld"

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
FORMAT="{{ title }} - {{ artist }} - {{duration(mpris:length)}} "

PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
EXIT_CODE=$?

CHK_CHAR (){
	if (( $1 >= 45 )) ; then
		echo "$STATUS1"
	else
		printf '%-45s' "$STATUS1"
	fi
}

if [ $EXIT_CODE -eq 0 ]; then
	STATUS=$PLAYERCTL_STATUS
else
    	STATUS="Welcome ${USER^}!"
fi


if [ "$1" == "--status" ]; then
	printf '%-45s' "$STATUS"
else
	if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
		STATUS1=$(playerctl --player=$PLAYER metadata --format "$FORMAT")
		CHARNUM1=${#STATUS1}
		CHK_CHAR $CHARNUM1
	else
		printf '%-45s' "$STATUS"
	fi
fi
