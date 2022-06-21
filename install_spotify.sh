#!/bin/bash

# Install KDocker
sudo apt install kdocker

# Install Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client

# Create minimized spotify
SPOTIFY_ICON=$(find /usr/share -name "spotify-client.png" | grep 64)

# Create spotify.desktop
cat <<EOF > $HOME/.local/share/applications/spotify.desktop
[Desktop Entry]
Type=Application
Name=Spotify
GenericName=Music Player
Icon=spotify-client
TryExec=spotify
Exec=kdocker -q -o -l -i ${SPOTIFY_ICON} -n Spotify spotify %U
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=spotify
EOF

referenced from: https://www.maketecheasier.com/minimize-spotify-to-system-tray-linux/
