#!/bin/bash

if x=0 then
    hyprctl keyword device 'device:elan1201:00-04f3:3098-touchpad:enabled' true
else
    hyprctl keyword device 'device:elan1201:00-04f3:3098-touchpad:enabled' false
fi
