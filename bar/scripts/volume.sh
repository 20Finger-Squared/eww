#!/bin/bash

get_volume_status() {
    local output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$output" | grep -q "\[MUTED\]"; then
        echo "MUTED"
    else
        echo "$output" | awk '{print int($2 * 100)}'
    fi
}

# get initial value
get_volume_status

pactl subscribe | stdbuf -oL grep "sink" | while read -r line; do
    get_volume_status
done
