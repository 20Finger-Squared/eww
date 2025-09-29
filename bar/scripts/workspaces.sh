#!/bin/bash

# Initial run to make sure eww logs are quiet
swaymsg -t get_workspaces -r | jq -c

# Subscribe to workspace events
while true; do
    swaymsg -t subscribe '["workspace"]' | while read -r _; do
        swaymsg -t get_workspaces -r | jq -c
    done
done
