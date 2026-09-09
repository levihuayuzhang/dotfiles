#!/usr/bin/env bash

set -ex

WALLPAPER_DIR="$HOME/wallpapers"

IMG=$(find "$WALLPAPER_DIR" -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
    -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.avif' \
    \) | shuf -n 1)

[ -z "$IMG" ] && exit 1

# pgrep -x awww-daemon >/dev/null || awww-daemon &

awww img "$IMG" \
    --transition-fps 60
# --transition-type grow \
# --transition-duration 1
