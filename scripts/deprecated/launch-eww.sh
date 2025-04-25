#!/bin/bash

# Matar instancias anteriores de EWW
pkill eww

# Esperar un momento
sleep 0.5

# Iniciar el daemon de EWW
eww daemon

# Esperar a que el daemon esté listo
sleep 1

# Abrir las barras
eww open bar
eww open bottom-bar

echo "EWW iniciado correctamente" 