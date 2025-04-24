#!/bin/bash

# Verificar si la sidebar está abierta
if eww windows | grep "*side-panel" > /dev/null; then
    # Si está abierta, cerrarla
    eww close side-panel
    echo "Sidebar cerrada"
else
    # Si está cerrada, abrirla
    eww open side-panel
    echo "Sidebar abierta"
fi 