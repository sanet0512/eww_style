#!/bin/bash

# Esperar a que Hyprland esté listo
sleep 3

# Matar instancias anteriores de EWW
pkill eww

# Esperar un momento
sleep 2

# Asegurar que el directorio de caché existe
mkdir -p ~/.cache/eww

# Eliminar archivos CSS anteriores
rm -f ~/.config/eww/eww.css ~/.config/eww/style.css

# Compilar estilos
echo "Compilando estilos..."
sassc ~/.config/eww/eww.scss ~/.cache/eww/eww_compiled.css

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

echo "EWW iniciado correctamente" 