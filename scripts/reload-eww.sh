#!/bin/bash

# Asegurarse de que el directorio de caché existe
mkdir -p ~/.cache/eww

# Compilar SCSS a CSS
echo "Compilando estilos..."
sassc ~/.config/eww/style.scss ~/.cache/eww/eww.css

# Copiar el CSS compilado al directorio de configuración
cp ~/.cache/eww/eww.css ~/.config/eww/

# Matar la instancia actual de Eww
echo "Reiniciando EWW..."
eww kill

# Esperar un momento
sleep 2

# Iniciar el daemon de Eww
eww daemon

# Esperar a que el daemon esté listo
sleep 2

# Abrir las ventanas
echo "Abriendo ventanas..."
eww open bar
eww open bottom-bar
eww open side-panel

echo "Recarga completada." 