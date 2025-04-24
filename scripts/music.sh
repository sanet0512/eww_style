#!/bin/bash

get_metadata() {
    playerctl metadata --format '{{title}}' 2>/dev/null || echo "No hay música"
}

get_artist() {
    playerctl metadata --format '{{artist}}' 2>/dev/null || echo "Desconocido"
}

get_status() {
    playerctl status 2>/dev/null || echo "Stopped"
}

get_position() {
    playerctl position 2>/dev/null || echo "0"
}

get_duration() {
    playerctl metadata --format '{{mpris:length}}' 2>/dev/null || echo "0"
}

case $1 in
    "play-pause")
        playerctl play-pause
        ;;
    "next")
        playerctl next
        ;;
    "previous")
        playerctl previous
        ;;
    *)
        echo "{\"title\": \"$(get_metadata)\", \"artist\": \"$(get_artist)\", \"status\": \"$(get_status)\", \"position\": $(get_position), \"duration\": $(get_duration)}"
        ;;
esac
