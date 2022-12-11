#!/usr/bin/env bash
set +e

echo "=== start begin ==="

. ./lib.sh

export DISPLAY=:58

Xvfb "$DISPLAY" -screen 0 640x480x16 -nolisten tcp &
clean_last_pid_up_fam

openbox-session &
clean_last_pid_up_fam

sleep 5

./test.sh
