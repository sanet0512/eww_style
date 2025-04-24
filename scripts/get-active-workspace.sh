#!/bin/bash
hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ ${line:0:9} == "workspace" ]]; then
        hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
    fi
done
