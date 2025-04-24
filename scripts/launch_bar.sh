#!/bin/bash

# Función para matar instancias de EWW
kill_eww() {
    echo "Cerrando instancias previas de EWW..."
    killall eww || echo "No hay instancias de EWW ejecutándose"
    sleep 1
}

# Función para iniciar EWW
start_eww() {
    echo "Iniciando EWW daemon..."
    eww daemon
    sleep 2
    
    echo "Abriendo barras..."
    eww open bar
    sleep 1
    eww open bottom-bar
}

# Función para detener las barras
stop_bars() {
    echo "Cerrando barras..."
    eww kill
}

# Función para recargar la configuración
reload_config() {
    echo "Recargando configuración..."
    eww reload
    sleep 1
    eww close-all
    sleep 1
    eww open bar
    sleep 1
    eww open bottom-bar
}

# Procesar argumentos
case "$1" in
    start)
        kill_eww
        start_eww
        ;;
    stop)
        stop_bars
        ;;
    reload)
        reload_config
        ;;
    restart)
        stop_bars
        sleep 1
        kill_eww
        sleep 1
        start_eww
        ;;
    *)
        echo "Uso: $0 {start|stop|reload|restart}"
        exit 1
        ;;
esac
