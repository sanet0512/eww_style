#!/bin/bash

# Copiar el archivo CSS
echo "Copiando archivo CSS..."
cp eww.scss eww.css

# Verificar si la copia fue exitosa
if [ $? -eq 0 ]; then
    echo "Archivo CSS copiado exitosamente"
else
    echo "Error al copiar el archivo CSS"
    exit 1
fi