# Simple OpenGL (old graphics) activator for Sober (Roblox for Linux)

I did it because I was too lazy to always get into the configuration of the sober and turn on the open-geel to play Nullscape

## Installation and Description of functions

1. First, download the installer or execute this command, it downloads the installer and runs it:
```
sudo curl -SLo /tmp/install.sh "https://raw.githubusercontent.com/I-layder-I/quick-sober-opengl/main/install.sh" & & sudo chmod +x /tmp/install.sh & & /tmp/install.sh
```
2. Next is the installation:
   ```
   Create separate .desktop for Sober? [y/N]
   ```
   Here the script asks whether to create a separate desktop file (not in the folder with the sober) and throw the Sober-Wrapper itself there (it works with the configuration of the opengl in the sober) so that when updating or deleting, the activator does not merge with the sober. If the answer is positive, it is thrown along the path `"${HOME}/.local/share/applications"` or you can specify your own.
   
4. Works only when running games from a roblox site, otherwise do not enable this:
   ```
   Use auto OpenGL(more on github) [Y/n]
   ```
   Function to automatically enable outdated graphics when a place is found in an array of the form:
   ```
   OPENGL_PLACES=(
    "129279692364812" # Nullscape
    "PlaseId"
    "PlaceID"
    )
   ```
   For now, the sheet can only be changed in the script itself along the way
   ```
   "/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications"
   ```
   Or with a separate desktop
   ```
   "${HOME}/.local/share/applications"
   ```
5. When you turn on the automation:
   ```
   Ask when place isn't found in PlaceID, or disable OpenGL by default [Ask/disable]
   ```
   The question here is whether when starting a game not with a place, it will be turned off or ask in a pop-up window whether to turn it on or not.
   
7. Whether to start the sober after installation:
   ```
   Start Sober? [y/N]
   ```
This way the script will be installed.
