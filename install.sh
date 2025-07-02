#!/bin/bash
set -euo pipefail

DESKTOP_DIR="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications"
DESKTOP_FILE="${DESKTOP_DIR}/org.vinegarhq.Sober.desktop"

echo "Path to Sober.desktop : 
$DESKTOP_FILE
Install dir :
$DESKTOP_DIR"
read -p "Correct? [Y/n] " -n 1 -r

case "$REPLY" in
    [Nn])
        read -p "Enter Path to Sober.desktop " DESKTOP_FILE
        DESKTOP_DIR="${DESKTOP_FILE##/*}"
        echo "Install dir :
        $DESKTOP_DIR"
        ;;
    [Yy]|"")
        echo "Continuing with default paths..."
        ;;
    *)
        echo "Invalid choice, exiting..."
        exit 1
        ;;
esac

echo "Downloading Script..."
sudo curl -SLo "${DESKTOP_DIR}/Sober-Wrapper.sh" \
     "https://raw.githubusercontent.com/I-layder-I/quick-sober-opengl/main/Sober-Wrapper.sh"
echo "Done"
echo "Adding chmod +x to Script..."
sudo chmod +x "${DESKTOP_DIR}/Sober-Wrapper.sh"
echo "Done"

echo "Configuring $(basename "$DESKTOP_FILE")"
sudo sed -i "s|^Exec=.*|Exec=${DESKTOP_DIR}/Sober-Wrapper.sh|" "$DESKTOP_FILE"
echo "Installation Complete!"
