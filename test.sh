#!/usr/bin/env bash
set -eo pipefail
rm -rf "$HOME/.whine"
# export WINEARCH=win32
export WINEPREFIX="$HOME/.whine"
# cd "$WINEPREFIX/drive_c/users/raf/Documents/GTA2"


if [[ ! -e "gta2-installer.exe" ]]; then
    curl -L -O "https://gtamp.com/GTA2/gta2-installer.exe"
fi

wine ./gta2-installer.exe &
last=$?

for (( i = 0; i < 8; i++ )); do
    xdotool getwindowfocus getwindowname
    sleep 1
done

kill -9 "$last"
exit 0
