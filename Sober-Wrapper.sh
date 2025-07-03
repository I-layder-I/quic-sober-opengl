#!/bin/bash

CONFIG_FILE="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

# Array of Place IDs where OpenGL should be ENABLED
OPENGL_PLACES=(
    "129279692364812" # Nullscape-ALPHA-0-2
    # Add more IDs as needed
)

URL="$@"

PLACE_ID=$(echo "$URL" | grep -oE 'games/[0-9]+' | cut -d'/' -f2)

if [[ -n "$PLACE_ID" ]]; then
    if [[ "${OPENGL_PLACES[*]}" =~ "$PLACE_ID" ]]; then
        sed -i 's|"use_opengl":.*|"use_opengl": true|' "$CONFIG_FILE"
    else
        sed -i 's|"use_opengl":.*|"use_opengl": false|' "$CONFIG_FILE"
    fi
else
    zenity --question --title="Sober" --text="Use OpenGL?" --width=300
    if [ $? -eq 0 ]; then
        sed -i 's|"use_opengl":.*|"use_opengl": true|' "$CONFIG_FILE"
    else
        sed -i 's|"use_opengl":.*|"use_opengl": false|' "$CONFIG_FILE"
    fi
fi

/usr/bin/flatpak run org.vinegarhq.Sober "$@"
