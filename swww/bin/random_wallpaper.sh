#!/usr/bin/env bash

set -ex

WALLPAPER_DIR="$HOME/wallpapers"

IMG=$(find "$WALLPAPER_DIR" -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
    -o -iname '*.webp' -o -iname '*.avif' \
\) | shuf -n 1)

[ -z "$IMG" ] && exit 1

# pgrep -x swww-daemon >/dev/null || swww-daemon &

swww img "$IMG"
  # --transition-type grow \
  # --transition-fps 60 \
  # --transition-duration 1

