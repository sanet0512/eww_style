#!/bin/bash

# Script mejorado para Bluetooth con funcionalidad real

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
fi

# Verificar si el servicio bluetooth está activo y encendido
if systemctl is-active --quiet bluetooth && bluetoothctl show | grep -q "Powered: yes"; then
    powered=true
    
    # Obtener dispositivos conectados
    connected_devices=$(bluetoothctl devices Connected | wc -l)
else
    powered=false
    connected_devices=0
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

# Construir respuesta JSON
echo "{\"icon\": \"$icon\", \"devices\": $connected_devices, \"powered\": $powered}"

# Si no se pasó un argumento, seguir monitoreando cambios para actualizaciones en tiempo real
if [[ $1 != "toggle" ]]; then
    while true; do
        sleep 5
        
        # Repetir el proceso de verificación
        if systemctl is-active --quiet bluetooth && bluetoothctl show | grep -q "Powered: yes"; then
            powered=true
            connected_devices=$(bluetoothctl devices Connected | wc -l)
        else
            powered=false
            connected_devices=0
        fi
        
        if [ "$powered" = true ]; then
            if [ $connected_devices -gt 0 ]; then
                icon="󰂱"  # Bluetooth conectado a dispositivos
            else
                icon="󰂯"  # Bluetooth encendido pero sin conexiones
            fi
        else
            icon="󰂲"  # Bluetooth apagado
        fi
        
        echo "{\"icon\": \"$icon\", \"devices\": $connected_devices, \"powered\": $powered}"
    done
fi
