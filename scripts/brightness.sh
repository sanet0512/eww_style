#!/bin/bash

if [[ "$1" == "set" ]]; then
    # En una implementación real, esto cambiaría el brillo
    echo "Estableciendo brillo a $2%"
    exit 0
fi

# Script simple para brillo
echo '{"brightness": 80}' 