#!/bin/bash

# Obtener la lista de espacios de trabajo de Hyprland
workspaces=$(hyprctl workspaces -j)

# Si hyprctl falla o devuelve un formato incorrecto, usar datos por defecto
if [ $? -ne 0 ] || [ -z "$workspaces" ]; then
    echo '[]'
else
    echo "$workspaces"
fi
