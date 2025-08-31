#!/bin/bash
# get initial value
wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}' | sed 's/./&/g'
pactl subscribe | stdbuf -oL grep "sink" | while read -r line; do
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}' | sed 's/./&/g'
done

