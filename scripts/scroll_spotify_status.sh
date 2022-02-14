#!/bin/bash

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding "  " \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --match-command "`dirname $0`/get_spotify_status.sh --status" \
        --update-check true "`dirname $0`/get_spotify_status.sh" &
wait

