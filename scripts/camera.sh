#!/bin/bash

# Script para controlar el estado de la cámara web
# Utiliza v4l2-ctl para activar/desactivar la cámara

get_camera_info() {
    # Verificar si hay dispositivos de cámara
    devices=$(ls /dev/video* 2>/dev/null | wc -l)
    
    # Verificar si la cámara está bloqueada (mediante rfkill)
    if [ -n "$(rfkill list video 2>/dev/null)" ]; then
        if rfkill list video | grep -q "Soft blocked: yes"; then
            status="disabled"
            icon="󰷞"
            powered=false
        else
            status="enabled"
            icon="󰄀"
            powered=true
        fi
    else
        # Si no hay rfkill para video, verificar basado en dispositivos
        if [ "$devices" -gt 0 ]; then
            status="enabled"
            icon="󰄀"
            powered=true
        else
            status="no-device"
            icon="󰹑"
            powered=false
        fi
    fi
    
    # Devolver información como JSON
    echo "{\"icon\": \"$icon\", \"status\": \"$status\", \"powered\": $powered, \"devices\": $devices}"
}

# Función para activar la cámara
enable_camera() {
    if [ -n "$(rfkill list video 2>/dev/null)" ]; then
        rfkill unblock video
    fi
    echo "Cámara activada"
}

# Función para desactivar la cámara
disable_camera() {
    if [ -n "$(rfkill list video 2>/dev/null)" ]; then
        rfkill block video
    fi
    echo "Cámara desactivada"
}

# Manejar comandos
case "$1" in
    toggle)
        if rfkill list video 2>/dev/null | grep -q "Soft blocked: yes"; then
            enable_camera
        else
            disable_camera
        fi
        # Retornar estado actual después del toggle
        sleep 0.5
        get_camera_info
        ;;
    status)
        get_camera_info
        ;;
    enable)
        enable_camera
        ;;
    disable)
        disable_camera
        ;;
    *)
        # Modo daemon: actualizar cada 5 segundos
        get_camera_info
        while true; do
            sleep 5
            get_camera_info
        done
        ;;
esac