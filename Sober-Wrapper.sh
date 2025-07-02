#!/bin/bash

CONFIG_FILE="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

zenity --question --title="Sober" --text="Use OpenGL?" --width=300

if [ $? -eq 0 ]; then
	sed -i 's/"use_opengl": false/"use_opengl": true/g' "$CONFIG_FILE"
        /usr/bin/flatpak run org.vinegarhq.Sober

else sed -i 's/"use_opengl": true/"use_opengl": false/g' "$CONFIG_FILE"
        /usr/bin/flatpak run org.vinegarhq.Sober
fi
