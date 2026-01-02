#!/bin/sh

if [ ! $(which xdotool) ]; then
  echo "xdotool not found, install it before running"
  exit 1
fi

WID=$(xdotool search --onlyvisible --class "Atari800" | head -n 1)
echo "WID: $WID"

if [ -z "$WID" ]; then
  echo "Atari800 not found"
  exit 1
fi

xdotool windowactivate $WID
xdotool key --delay 100 shift+ctrl+r
sleep 1
xdotool type --delay 100 D:AUTO.ACT
xdotool key --delay 100 Return
sleep 1
xdotool key --delay 100 shift+ctrl+m
sleep 1
xdotool type --delay 100 COMPILE
xdotool key --delay 100 Return
sleep 1
xdotool type --delay 100 RUN
xdotool key --delay 100 Return
