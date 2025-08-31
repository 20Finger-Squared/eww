#!/bin/bash

print_workspaces() {
    current=$(swaymsg -t get_workspaces)
    # Base workspaces 1–5
    base=(1 2 3 4 5)
    # Get names of existing workspaces
    existing_names=$(echo "$current" | jq -r '.[].name')
    # Merge base and existing workspaces, avoid duplicates
    combined=("${base[@]}")
    for w in $existing_names; do
        [[ " ${combined[*]} " == *" $w "* ]] || combined+=("$w")
    done
    # Build JSON
    output="["
    first=true
    for w in "${combined[@]}"; do
        # If workspace exists, get its focused value
         focused=$(echo "$current" | jq -r --arg w "$w" '.[] | select(.name==$w) | .focused // empty')
        # If it doesn't exist, default to false
        [[ -z "$focused" ]] && focused=false
        [[ $first == true ]] && first=false || output+=","
        output+="{\"name\":\"$w\",\"focused\":$focused}"
    done
    output+="]"
    echo "$output"
}

# Initial print
print_workspaces

# Subscribe to workspace events
while true; do
    swaymsg -t subscribe '["workspace"]' | while read -r _; do
        print_workspaces
    done
done
