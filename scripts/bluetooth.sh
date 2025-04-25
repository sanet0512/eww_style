#!/bin/bash

# Script para Bluetooth con funcionalidad real

# Verificar si se pasa un argumento para realizar una acción
if [[ $1 = "toggle" ]]; then
    if bluetoothctl show | grep -q "Powered: yes"; then
        # Desactivar Bluetooth
        bluetoothctl power off
    else
        # Activar Bluetooth
        bluetoothctl power on
    fi
    sleep 1  # Esperar a que se aplique el cambio
    # Reportar el nuevo estado después del toggle
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "{\"icon\": \"󰂯\", \"devices\": 0, \"powered\": true}"
    else
        echo "{\"icon\": \"󰂲\", \"devices\": 0, \"powered\": false}"
    fi
    exit 0
fi

# Función para obtener y mostrar la información del Bluetooth
get_bluetooth_info() {
    # Verificar si el servicio bluetooth está activo
    if ! systemctl is-active --quiet bluetooth; then
        echo "{\"icon\": \"󰂲\", \"devices\": 0, \"powered\": false, \"status\": \"Servicio inactivo\"}"
        return
    fi
    
    # Verificar si el bluetooth está encendido
    if bluetoothctl show | grep -q "Powered: yes"; then
        powered=true
        
        # Contar dispositivos conectados
        connected_devices=$(bluetoothctl devices Connected | wc -l)
        
        # Nombres de dispositivos conectados (limitar a 2 para la visualización)
        if [ $connected_devices -gt 0 ]; then
            device_names=""
            count=0
            while IFS= read -r line && [ $count -lt 2 ]; do
                # Extraer el nombre del dispositivo
                device_name=$(echo "$line" | sed 's/^Device [^ ]* //g')
                if [ -n "$device_names" ]; then
                    device_names="$device_names, "
                fi
                device_names="$device_names$device_name"
                count=$((count + 1))
            done < <(bluetoothctl devices Connected | sed 's/^Device [^ ]* //g')
            
            # Agregar indicación si hay más dispositivos
            if [ $connected_devices -gt 2 ]; then
                device_names="$device_names y $(($connected_devices - 2)) más"
            fi
            
            status="$device_names"
        else
            status="Sin dispositivos"
        fi
    else
        powered=false
        connected_devices=0
        status="Apagado"
    fi

    # Determinar el icono según el estado
    if [ "$powered" = true ]; then
        if [ $connected_devices -gt 0 ]; then
            icon="󰂱"  # Bluetooth conectado a dispositivos
        else
            icon="󰂯"  # Bluetooth encendido pero sin conexiones
        fi
    else
        icon="󰂲"  # Bluetooth apagado
    fi

    # Devolver información como JSON
    echo "{\"icon\": \"$icon\", \"devices\": $connected_devices, \"powered\": $powered, \"status\": \"$status\"}"
}

# Mostrar la información inicial
get_bluetooth_info

# Monitorear cambios y actualizar cada 5 segundos
while true; do
    sleep 5
    get_bluetooth_info
done
