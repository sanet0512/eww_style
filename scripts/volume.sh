#!/bin/bash

# Script mejorado para volumen

# Definir volumen y estado
volume=70
muted=false

# Seleccionar icono según volumen
if [ "$muted" = true ]; then
    icon="󰝟"
elif [ $volume -eq 0 ]; then
    icon="󰕿"
elif [ $volume -lt 30 ]; then
    icon="󰖀"
elif [ $volume -lt 70 ]; then
    icon="󰕾"
else
    icon="󰕾"
fi

# Construir respuesta JSON
echo "{\"volume\": $volume, \"muted\": $muted, \"icon\": \"$icon\"}"