#!/bin/bash
set -euo pipefail

check_dir() {
    if [ ! -d "$1" ]; then
        echo "Error: Directory $1 does not exist" >&2
        return 1
    fi
    return 0
}

check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File $1 does not exist" >&2
        return 1
    fi
    return 0
}

DESKTOP_DIR="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications"
DESKTOP_FILE="${DESKTOP_DIR}/org.vinegarhq.Sober.desktop"
CONFIG_FILE="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

read -p "Install or Uninstall? [I/u] " -n 1 -r reply
echo
case "$reply" in
    [Uu])
        read -p "You have separate .desktop in non-default path? [y/N] " -n 1 -r reply
        echo
        case "$reply" in
            [Nn]|"")
                    ;;
            [Yy])
                 while true; do
                     read -p "Enter Path to Separate: " DESKTOP_FILE
                     check_file "$DESKTOP_FILE" && break
                     DESKTOP_DIR=$(dirname "$DESKTOP_FILE")
                     check_dir "$DESKTOP_DIR" && break
                 done
                 sudo rm -rf "$DESKTOP_DIR/org.vinegarhq.Sober.desktop"
                 sudo rm -rf "$DESKTOP_DIR/Sober-Wrapper.sh"
                 ;;
            *)
              echo -e "\nInvalid choice, exiting..."
              exit 1
              ;;
        esac
        sudo rm -rf "$DESKTOP_DIR/org.vinegarhq.Sober.desktop"
        sudo rm -rf "$DESKTOP_DIR/Sober-Wrapper.sh"
        rm -rf "$HOME/.local/share/applications/org.vinegarhq.Sober.desktop"
        rm -rf "$HOME/.local/share/applications/Sober-Wrapper.sh"
        sudo cat > "/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications/org.vinegarhq.Sober.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Sober
GenericName=Roblox Player
Comment=Play, chat & explore on Roblox
Icon=org.vinegarhq.Sober
Keywords=roblox;vinegar;game;gaming;social;experience;launcher;
MimeType=x-scheme-handler/roblox;x-scheme-handler/roblox-player;
Categories=GNOME;GTK;Game;
Terminal=false
PrefersNonDefaultGPU=true
SingleMainWindow=true
Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=sober --file-forwarding org.vinegarhq.Sober -- @@u %u @    @
Actions=open-settings;
X-Flatpak=org.vinegarhq.Sober

[Desktop Action open-settings]
Name=Settings
Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=sober org.vinegarhq.Sober config
EOF

        echo "Uninstall Complete!"
        exit 0
        ;;
    [Ii]|"")    
read -p "Create separate .desktop for Sober? [y/N] " -n 1 -r reply
echo
case "$reply" in
    [Yy])
        DESKTOP_DIR="${HOME}/.local/share/applications"
        echo -e "\nPath to Separate :\n$DESKTOP_DIR"
        read -p "Correct? [Y/n] " -n 1 -r
        echo
        case "$REPLY" in
            [Nn])
                while true; do
                    read -p "Enter Path to Separate: " DESKTOP_DIR
                    check_dir "$DESKTOP_DIR" && break
                done
                ;;
            [Yy]|"")
                echo -e "\nContinuing with default paths..."
                check_dir "$DESKTOP_DIR" || {
                    echo "Directory is not exist. May You not install Sober, Exiting..."
                    exit 1
                }
                ;;
        esac
        cat > "${DESKTOP_DIR}/org.vinegarhq.Sober.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Sober Wrapper
GenericName=Roblox Player
Comment=Play, chat & explore on Roblox
Icon=org.vinegarhq.Sober
Keywords=roblox;vinegar;game;gaming;social;experience;launcher;
MimeType=x-scheme-handler/roblox;x-scheme-handler/roblox-player;
Categories=GNOME;GTK;Game;
Terminal=false
PrefersNonDefaultGPU=true
SingleMainWindow=true
Exec=${DESKTOP_DIR%/}/Sober-Wrapper.sh %u
X-Flatpak=org.vinegarhq.Sober

[Desktop Action open-settings]
Name=Settings
Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=sober org.vinegarhq.Sober config
EOF
;;
    [Nn]|"")
            echo -e "\nPath to Sober.desktop :\n$DESKTOP_FILE\nInstall dir :\n$DESKTOP_DIR"
            if ! check_file "$DESKTOP_FILE"; then
                while true; do
                    read -p "File not found. Enter custom path to .desktop: " DESKTOP_FILE
                    check_file "$DESKTOP_FILE" && break
                done
            DESKTOP_DIR=$(dirname "$DESKTOP_FILE")
            fi
            echo -e "\nFind, Continuing..."
            ;;
    *)
       echo -e "\nInvalid choice, exiting..."
       exit 1
       ;;
esac

echo -e "\nDownloading Script..."
if ! sudo curl -SLo "${DESKTOP_DIR}/Sober-Wrapper.sh" \
     "https://raw.githubusercontent.com/I-layder-I/quick-sober-opengl/main/Sober-Wrapper.sh"; then
    echo "Failed to download script" >&2
    exit 1
fi
read -p "Use auto OpenGL(more on github) [Y/n] " -n 1 -r
echo
case "$REPLY" in
    [Yy]|"")
        read -p "Ask when place isn't found in PlaceID, or disable OpenGL by default [ask/Disable] " -n 1 -r
        echo
        case "$REPLY" in
            [Aa])
                ;;
            [Dd]|"")
                echo -e "\nConfiguring Sober-Wrapper.sh: Disabling OpenGL by default"
                  sudo sed -i $'29,34c\\\nsed -i \\\'s|"use_opengl":.*|"use_opengl": false|\\\' "$CONFIG_FILE"' \
                "${DESKTOP_DIR}/Sober-Wrapper.sh"
                ;;
            *)
                echo -e "\nInvalid choice, exiting..."
                exit 1
                ;;
        esac
        ;;
    [Nn])
         sudo sed -i -e '6,28d' -e '35d' "${DESKTOP_DIR}/Sober-Wrapper.sh"
         ;;
    *)
        echo -e "\nInvalid choice, exiting..."
        exit 1
        ;;
esac
echo "Done"

echo -e "Path to Sober config :\n$CONFIG_FILE"
if ! check_file "$CONFIG_FILE"; then
    while true; do
    read -p "Config file not found. Enter custom path: " CONFIG_FILE
    check_file "$CONFIG_FILE" && break
    done
    echo -e "\nConfiguring Sober-Wrapper.sh"
    sudo sed -i "s|^CONFIG_FILE=.*|CONFIG_FILE=\"${CONFIG_FILE}\"|" "${DESKTOP_DIR}/Sober-Wrapper.sh"
    echo "Done"
fi
echo -e "\nFind, Continuing..."

echo -e "\nAdding chmod +x to Script..."
sudo chmod +x "${DESKTOP_DIR}/Sober-Wrapper.sh"
echo "Done"

if [[ $reply =~ ^[Nn]$|"" ]]; then
    echo -e "\nConfiguring $(basename "$DESKTOP_FILE")"
    sudo sed -i "s|^Name=.*|Name=Sober Wrapper|" "$DESKTOP_FILE"
    sudo sed -i "s|^Exec=.*|Exec=${DESKTOP_DIR%/}/Sober-Wrapper.sh %u|" "$DESKTOP_FILE"
fi

read -p $'\nInstallation Complete!\nStart Sober? [y/N] ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "${DESKTOP_DIR}/Sober-Wrapper.sh" >/dev/null 2>&1 &
fi
       ;;
    *)
      echo -e "\nInvalid choice, exiting..."
      exit 1
      ;;
esac
