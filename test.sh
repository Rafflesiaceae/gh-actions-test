#!/usr/bin/env bash
set -eo pipefail

echo "=== test begin ==="

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

gta2d="${WINEPREFIX}/drive_c/gta2"

while [[ ! -e "${gta2d}/test/don't-delete-this-folder.txt" ]]; do
    sleep 1
done

echo "> Installed!"
key Enter
sleep 0.5

echo "--- installed ---"

cd "$gta2d"

echo "> Importing registry..."

cat <<EOF > /tmp/gta2.reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2]

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Control]
"0"=dword:000000c8
"1"=dword:000000d0
"10"=dword:00000038
"11"=dword:00000036
"2"=dword:000000cb
"3"=dword:000000cd
"4"=dword:0000001d
"5"=dword:0000001c
"6"=dword:00000039
"7"=dword:0000002c
"8"=dword:0000002d
"9"=dword:0000000f

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Debug]
"bob_debug_display"=dword:00000001
"do_blood"=dword:00000001
"do_debug_keys"=dword:00000001
"mapname"=""
"replaynum"=dword:00000009

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Network]
"f_limit"=dword:0000000f
"game_speed"=dword:00000001
"game_time_limit"=dword:00000000
"game_type"=dword:00000001
"map_index"=dword:0000001c
"PlayerName"="ChangeYourNick"
"police"=dword:00000001
"protocol_selected"=dword:00000000
"s_limit"=dword:00002328
"show_player_names"=dword:00000001
"TCPIPAddrStringd"=hex:31,00,32,00,37,00,2e,00,30,00,2e,00,30,00,2e,00,31,00,\
  00,00
"TCPIPAddrStrings"=dword:00000014
"UseConnectiond"=hex:60,f5,18,13,2c,91,d0,11,9d,aa,00,a0,c9,0a,43,cb,04,00,00,\
  00,64,00,00,00,c0,16,d9,07,af,e0,cf,11,9c,4e,00,a0,c9,05,42,5e,10,00,00,00,\
  e0,5e,e9,36,77,85,cf,11,96,0c,00,80,c7,53,4e,82,a0,32,32,e6,bf,9d,d0,11,9c,\
  c1,00,a0,c9,05,42,5e,14,00,00,00,31,00,32,00,37,00,2e,00,30,00,2e,00,30,00,\
  2e,00,31,00,00,00
"UseConnections"=dword:00000064
"UseProtocold"=hex:e0,5e,e9,36,77,85,cf,11,96,0c,00,80,c7,53,4e,82
"UseProtocols"=dword:00000010

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Option]
"Language"="e"
"text_speed"=dword:00000003

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Player]
"plyrslot"=dword:00000000

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Screen]
"curr_dll_id"=dword:00000001
"do_play_movie"=dword:00000000
"exploding_on"=dword:00000000
"full_height"=dword:000002d0
"full_width"=dword:000003c0
"gamma"=dword:0000000a
"lighting"=dword:00000001
"max_frame_rate"=dword:00000001
"min_frame_rate"=dword:00000001
"renderdevice"=dword:00000001
"rendername"="d3ddll.dll"
"special_recognition"=dword:00000001
"start_mode"=dword:00000000
"tripple_buffer"=dword:00000000
"videodevice"=dword:00000001
"videoname"="dmavideo.dll"
"window_height"=dword:000002d0
"window_width"=dword:000003c0

[HKEY_CURRENT_USER\Software\DMA Design Ltd\GTA2\Sound]
"CDVol"=dword:0000007f
"SFXVol"=dword:0000000b
EOF

wine regedit "/tmp/gta2.reg"
echo "> Done"

echo "> Starting up..."

wine "${gta2d}/gta2.exe" &
clean_last_pid_up_fam

# @TODO disable fullscreen - window mode only
# @TODO edit registry

for (( i = 0; i < 10; i++ )); do
    cur_wname
    sleep 1
done

# sleep 10

set +e
exit 0
