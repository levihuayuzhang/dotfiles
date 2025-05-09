#!/usr/bin/env bash

wall=$(find ~/wallpapers/ -type f -name "*.jpg" -o -name "*.png" -o -name "*.gif" | shuf -n 1)

swww img $wall --transition-fps 240 --transition-type random

