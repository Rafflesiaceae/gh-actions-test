#!/usr/bin/env bash
set -eo pipefail

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




clip_in() { xclip -i -sel clip >/dev/null; }
clip_out() { xclip -o -sel clip </dev/null; }
clip_restore() { xclip -i -sel clip < /tmp/xclip_store >/dev/null; rm /tmp/xclip_store; }
clip_store() { xclip -o -sel clip > /tmp/xclip_store </dev/null; }

key() {
    xdotool key "$1"
    sleep 0.05
}
ckey() {
    xdotool keydown ctrl
    sleep 0.05
    xdotool key "$1"
    sleep 0.05
    xdotool keyup ctrl
}

#     # xdotool getactivewindow || true
cur_wname() { xdotool getwindowfocus getwindowname || true; }

echo "> Waiting for Installer to start..."

while [[ "$(cur_wname)" != "GTA2 11.44 Setup " ]]; do
    # printf "cur_window>%s<\n" "$(cur_wname)"
    sleep 1
done

echo "> Configuring installer..."

echo 'C:\gta2' | clip_in
# xdotool type 'C:/gta2'
ckey v
key Tab
key Tab
key Enter

echo "> Installing..."

while [[ ! -e "$WINEPREFIX/drive_c/gta2/test/don't-delete-this-folder.txt" ]]; do
    sleep 1
done

echo "> Installed!"

exit 0
