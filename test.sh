#!/usr/bin/env bash
# set -eo pipefail
rm -rf "$HOME/.whine"
export WINEARCH=win32
export WINEPREFIX="$HOME/.whine"
# cd "$WINEPREFIX/drive_c/users/raf/Documents/GTA2"

# env

. ./lib.sh

if [[ ! -e "gta2-installer.exe" ]]; then
    curl -L -O "https://gtamp.com/GTA2/gta2-installer.exe"
fi

wine ./gta2-installer.exe &
clean_last_pid_up_fam

sleep 10

set +e
for (( i = 0; i < 8; i++ )); do
    sleep 1
    echo ">>"
    xdotool getwindowfocus getwindowname || true
    # xdotool getactivewindow || true
done
