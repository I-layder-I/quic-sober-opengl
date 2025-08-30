#!/bin/bash

CONFIG_FILE="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"
PLACEID_LIST="$HOME/.config/sober-opengl-placeids.txt"

# Array of Place IDs where OpenGL should be ENABLED
OPENGL_PLACES=(
    "129279692364812" # Nullscape
    # Array of Place IDs where OpenGL should be ENABLED
)

PLACE_ID=$(echo "$1" | sed 's/%3D/=/g' | grep -oE 'placeId=[0-9]+' | sed 's/.*=//' || true)

if [[ -n "$PLACE_ID" ]]; then   
    found=0
    for place in "${OPENGL_PLACES[@]}"; do
        if [[ "$place" == "$PLACE_ID" ]]; then
            found=1
            break
        fi
    done

    if [[ $found -eq 1 ]]; then
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
