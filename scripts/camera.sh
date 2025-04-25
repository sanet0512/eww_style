#!/bin/bash

# Script para controlar el estado de la cámara web
# Utiliza v4l2-ctl para detectar cámaras y rfkill para controlar su estado

get_camera_info() {
    # Verificar si hay dispositivos de cámara
    # Contar dispositivos de video disponibles, pero no fallar si no hay ninguno
    devices=$(ls /dev/video* 2>/dev/null | wc -l || echo "0")
    
    # Verificar si la cámara está bloqueada (mediante rfkill)
    if rfkill list video &>/dev/null; then
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
            # No hay dispositivos de cámara
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
    if rfkill list video &>/dev/null; then
        rfkill unblock video 2>/dev/null
        echo "Cámara activada"
    else
        echo "No se puede activar la cámara: no hay control rfkill para video"
    fi
}

# Función para desactivar la cámara
disable_camera() {
    if rfkill list video &>/dev/null; then
        rfkill block video 2>/dev/null
        echo "Cámara desactivada"
    else
        echo "No se puede desactivar la cámara: no hay control rfkill para video"
    fi
}

# Manejar comandos
case "$1" in
    toggle)
        if rfkill list video &>/dev/null; then
            if rfkill list video | grep -q "Soft blocked: yes"; then
                enable_camera
            else
                disable_camera
            fi
            # Retornar estado actual después del toggle
            sleep 0.5
        else
            echo "No hay control rfkill para cámara en este sistema"
        fi
        get_camera_info
        ;;
    status)
        get_camera_info
        ;;
    enable)
        enable_camera
        sleep 0.5
        get_camera_info
        ;;
    disable)
        disable_camera
        sleep 0.5
        get_camera_info
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