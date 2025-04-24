#!/bin/bash

# Script mejorado para WiFi

# Definir variables
connected=true
ssid="Mi_Red_WiFi"
strength=85  # de 0 a 100

# Seleccionar icono según el estado y la fuerza de la señal
if [ "$connected" = true ]; then
    if [ $strength -ge 80 ]; then
        icon="󰤨"
    elif [ $strength -ge 60 ]; then
        icon="󰤥"
    elif [ $strength -ge 40 ]; then
        icon="󰤢"
    elif [ $strength -ge 20 ]; then
        icon="󰤟"
    else
        icon="󰤯"
    fi
else
    icon="󰤮"
fi

# Construir respuesta JSON
echo "{\"connected\": $connected, \"ssid\": \"$ssid\", \"strength\": $strength, \"icon\": \"$icon\"}"
