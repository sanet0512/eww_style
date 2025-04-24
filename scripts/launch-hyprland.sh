#!/bin/bash

# Esperar a que Hyprland esté listo
sleep 3

# Matar instancias anteriores de EWW
pkill eww

# Esperar un momento
sleep 2

# Asegurar que el directorio de caché existe
mkdir -p ~/.cache/eww

# Compilar estilos
echo "Compilando estilos..."
sassc ~/.config/eww/style.scss ~/.cache/eww/eww.css
cp ~/.cache/eww/eww.css ~/.config/eww/

# Iniciar el daemon de EWW
echo "Iniciando EWW daemon..."
eww daemon

# Esperar a que el daemon esté listo
sleep 3

# Abrir las ventanas
echo "Abriendo ventanas..."
eww open bar
sleep 1
eww open bottom-bar
sleep 1
eww open side-panel

echo "EWW iniciado correctamente" 