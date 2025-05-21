#!/usr/bin/env zsh

WALLPAPER_DIR="$HOME/wallpapers/"

# for builtin 2k monitor
CURRENT_WALL=$(hyprpaper listloaded)
# Get a random wallpaper that is not the current one
WALLPAPER1=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)
# Apply the selected wallpaper
hyprpaper reload eDP-1,"$WALLPAPER1"

# for extenal 4k monitor
CURRENT_WALL=$(hyprpaper listloaded)
# Get a random wallpaper that is not the current one
WALLPAPER2=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)
# Apply the selected wallpaper
hyprpaper reload DP-1,"$WALLPAPER2"
