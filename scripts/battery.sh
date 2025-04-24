#!/bin/bash

# Script mejorado para batería

# Definir porcentaje y estado
percentage=75
status="Discharging"  # Opciones: "Charging", "Discharging", "Full"

# Seleccionar icono según porcentaje y estado
if [ "$status" = "Charging" ]; then
    icon="󰂄"
else
    if [ $percentage -ge 95 ]; then
        icon="󰁹"
    elif [ $percentage -ge 75 ]; then
        icon="󰂂"
    elif [ $percentage -ge 50 ]; then
        icon="󰂀"
    elif [ $percentage -ge 25 ]; then
        icon="󰁾"
    else
        icon="󰁻"
    fi
fi

# Construir respuesta JSON
echo "{\"percentage\": $percentage, \"status\": \"$status\", \"icon\": \"$icon\"}" 