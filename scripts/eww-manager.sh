#!/bin/bash

# Script unificado para gestionar EWW
# Uso: ./eww-manager.sh {start|stop|reload|check}

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_msg() {
    echo -e "${2}${1}${NC}"
}

# Función para verificar la configuración
check_setup() {
    print_msg "Verificando configuración de EWW..." "${YELLOW}"

    # Verificar eww
    if ! command -v eww &> /dev/null; then
        print_msg "❌ EWW no está instalado" "${RED}"
    else
        print_msg "✅ EWW está instalado ($(eww --version))" "${GREEN}"
    fi

    # Verificar scripts
    print_msg "Verificando scripts..." "${YELLOW}"
    for script in ~/.config/eww/scripts/*.sh; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                print_msg "✅ $script es ejecutable" "${GREEN}"
            else
                print_msg "❌ $script no es ejecutable" "${RED}"
                chmod +x "$script"
                print_msg "  → Permisos corregidos" "${GREEN}"
            fi
        fi
    done

    # Verificar archivos clave
    print_msg "Verificando archivos clave..." "${YELLOW}"
    if [ -f ~/.config/eww/eww.yuck ]; then
        print_msg "✅ eww.yuck encontrado" "${GREEN}"
    else
        print_msg "❌ eww.yuck no encontrado" "${RED}"
    fi

    if [ -f ~/.config/eww/eww.scss ]; then
        print_msg "✅ eww.scss encontrado" "${GREEN}"
    else
        print_msg "❌ eww.scss no encontrado" "${RED}"
    fi

    print_msg "Verificación completada" "${GREEN}"
}

# Función para matar instancias de EWW
kill_eww() {
    print_msg "Deteniendo EWW..." "${YELLOW}"
    eww kill
    sleep 1
}

# Función para iniciar EWW
start_eww() {
    print_msg "Iniciando EWW daemon..." "${YELLOW}"
    eww daemon
    sleep 1.5
    
    print_msg "Abriendo barras..." "${YELLOW}"
    eww open bar
    sleep 0.5
    eww open bottom-bar
    
    print_msg "EWW iniciado correctamente" "${GREEN}"
}

# Función para recargar EWW
reload_eww() {
    print_msg "Recargando EWW..." "${YELLOW}"
    
    # Matar instancia actual
    kill_eww
    
    # Iniciar nuevamente
    start_eww
    
    print_msg "Recarga completada" "${GREEN}"
}

# Procesar argumentos
case "$1" in
    start)
        kill_eww
        start_eww
        ;;
    stop)
        kill_eww
        print_msg "EWW detenido correctamente" "${GREEN}"
        ;;
    reload)
        reload_eww
        ;;
    check)
        check_setup
        ;;
    *)
        print_msg "Uso: $0 {start|stop|reload|check}" "${YELLOW}"
        print_msg "  start  - Iniciar EWW" "${YELLOW}"
        print_msg "  stop   - Detener EWW" "${YELLOW}"
        print_msg "  reload - Recargar EWW" "${YELLOW}"
        print_msg "  check  - Verificar configuración" "${YELLOW}"
        exit 1
        ;;
esac 