#!/bin/bash

# Matar la instancia actual de Eww
echo "Reiniciando EWW..."
eww kill

# Esperar un momento
sleep 1

# Iniciar el daemon de Eww
eww daemon

# Esperar a que el daemon esté listo
sleep 1

# Abrir las ventanas
echo "Abriendo ventanas..."
eww open bar
eww open bottom-bar

echo "Recarga completada." 