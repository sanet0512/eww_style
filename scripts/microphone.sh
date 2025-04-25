#!/bin/bash

# Script para controlar el micrófono
# Utiliza wireplumber (wpctl) para obtener y controlar el estado del micrófono

get_microphone_info() {
    # Comprobar si el micrófono está silenciado
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
        muted=true
    else
        muted=false
    fi

    # Devolver información como JSON
    echo "{\"muted\": $muted}"
}

# Manejar comandos
case "$1" in
    toggle)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        sleep 0.5
        get_microphone_info
        ;;
    status)
        get_microphone_info
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
        sleep 0.5
        get_microphone_info
        ;;
    unmute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
        sleep 0.5
        get_microphone_info
        ;;
    *)
        # Modo daemon: actualizar cada 2 segundos
        get_microphone_info
        while true; do
            sleep 2
            get_microphone_info
        done
        ;;
esac