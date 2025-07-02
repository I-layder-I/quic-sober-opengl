#!/bin/bash
set -euo pipefail

DESKTOP_DIR="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications"
DESKTOP_FILE="${DESKTOP_DIR}/org.vinegarhq.Sober.desktop"
CONFIG_FILE="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

read -p "Create separate .desktop for Sober? [y/N] " -n 1 -r
echo
case "$REPLY" in
    [Yy])
        DESKTOP_DIR="${HOME}/.local/share/applications"
        echo -e "\nPath to Separate :\n$DESKTOP_DIR"
        read -p "Correct? [Y/n] " -n 1 -r
        echo
        case "$REPLY" in
            [Nn])
                read -p "Enter Path to Separate: " DESKTOP_DIR
                ;;
            [Yy]|"")
                mkdir -p "$DESKTOP_DIR"
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
Exec=Exec=${DESKTOP_DIR}/Sober-Wrapper.sh
X-Flatpak=org.vinegarhq.Sober"
EOF
                     DESKTOP_FILE="${DESKTOP_DIR}/org.vinegarhq.Sober.desktop"
                     ;;
            *)
                echo -e "\nInvalid choice, exiting..."
                exit 1
                ;;
        esac
        ;;
    [Nn]|"")
            echo -e "\nPath to Sober.desktop :\n$DESKTOP_FILE\nInstall dir :\n$DESKTOP_DIR"
            read -p "Correct? [Y/n] " -n 1 -r
            echo
            case "$REPLY" in
                [Nn])
                    read -p $'\nEnter Path to Sober.desktop: ' DESKTOP_FILE
                    DESKTOP_DIR=$(dirname "$DESKTOP_FILE")
                    echo -e "Install dir :\n$DESKTOP_DIR"
                    ;;
                [Yy]|"")
                    echo "\nContinuing with default paths..."
                    ;;
                *)
                    echo -e "\nInvalid choice, exiting..."
                    exit 1
                    ;;
            esac
            ;;
    *)
         echo -e "\nInvalid choice, exiting..."
         exit 1
         ;;
esac

echo -e "\nDownloading Script..."
sudo curl -SLo "${DESKTOP_DIR}/Sober-Wrapper.sh" \
     "https://raw.githubusercontent.com/I-layder-I/quick-sober-opengl/main/Sober-Wrapper.sh"
echo "Done"

echo -e "Path to Sober config :\n$CONFIG_FILE"
read -p "Correct? [Y/n] " -n 1 -r
echo
case "$REPLY" in
    [Yy]|"")
        echo -e "\nContinuing with default path..."
        ;;
    [Nn])
        read -p "Enter Path to Sober.desktop: " CONFIG_FILE
        echo -e "\nConfiguring Sober-Wrapper.sh"
        sudo sed -i "s|^CONFIG_FILE=.*|CONFIG_FILE=${CONFIG_FILE}|" "${DESKTOP_DIR}/Sober-Wrapper.sh"
        echo "Done"
        ;;
    *)
        echo -e "\nInvalid choice, exiting..."
        exit 1
        ;;
esac

echo -e "\nAdding chmod +x to Script..."
sudo chmod +x "${DESKTOP_DIR}/Sober-Wrapper.sh"
echo "Done"

echo -e "\nConfiguring $(basename "$DESKTOP_FILE")"
sudo sed -i "s|^Name=.*|Name=Sober Wrapper|" "$DESKTOP_FILE"
sudo sed -i "s|^Exec=.*|Exec=${DESKTOP_DIR}/Sober-Wrapper.sh|" "$DESKTOP_FILE"
echo -e "\nInstallation Complete!"
