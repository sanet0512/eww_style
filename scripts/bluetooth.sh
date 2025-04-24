#!/bin/bash

# Script mejorado para Bluetooth

# Definir variables
status="on"  # Opciones: "on", "off", "connecting"
connected_devices=2

# Seleccionar icono según el estado
if [ "$status" = "on" ]; then
    if [ $connected_devices -gt 0 ]; then
        icon="󰂱"  # Bluetooth conectado a dispositivos
    else
        icon="󰂯"  # Bluetooth encendido pero sin conexiones
    fi
elif [ "$status" = "connecting" ]; then
    icon="󰂯"  # Bluetooth en proceso de conexión
else
    icon="󰂲"  # Bluetooth apagado
fi

# Construir respuesta JSON
echo "{\"status\": \"$status\", \"connected_devices\": $connected_devices, \"icon\": \"$icon\"}"
