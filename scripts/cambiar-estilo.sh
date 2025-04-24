#!/bin/bash

# Script para cambiar entre estilos de Eww

estilo=$1

if [ "$estilo" == "minimalista" ] || [ "$estilo" == "transparente" ]; then
    echo "Cambiando a estilo minimalista/transparente..."
    git checkout master
    eww reload
    echo "¡Listo! Estilo minimalista aplicado."
elif [ "$estilo" == "original" ] || [ "$estilo" == "estandar" ]; then
    echo "Cambiando a estilo original/estándar..."
    git checkout version-original
    eww reload
    echo "¡Listo! Estilo original aplicado."
else
    echo "Uso: $0 [minimalista|original]"
    echo ""
    echo "Estilos disponibles:"
    echo "  - minimalista (o transparente): Barras transparentes con efecto minimalista"
    echo "  - original (o estandar): Barras estándar originales"
fi 