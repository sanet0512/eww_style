#!/bin/bash

# Script ejecutado desde scripts/
# Definir la ruta al directorio principal y al CSS
SCRIPT_DIR="$(dirname "$0")"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CSS_FILE="$ROOT_DIR/eww.css"

# Verificar que eww.css existe
if [ ! -f "$CSS_FILE" ]; then
    echo "Error: No se encontró el archivo de estilos en $CSS_FILE"
    exit 1
fi

# Recargar configuración de EWW
echo "Recargando EWW..."
cd "$ROOT_DIR"
eww reload

# Si hay un error, reiniciar completamente
if [ $? -ne 0 ]; then
    echo "Error al recargar. Reiniciando EWW..."
    eww kill
    sleep 1
    eww daemon
    sleep 2
    eww open bar
    sleep 1
    eww open bottom-bar
    sleep 1
    eww open side-panel
fi

echo "Estilos aplicados correctamente." 