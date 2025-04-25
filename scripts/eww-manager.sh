#!/bin/bash

# Script unificado para gestionar EWW
# Uso: ./eww-manager.sh {start|stop|reload|check|side-panel}

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

    # Verificar estado de los scripts de micrófono y cámara
    print_msg "Verificando scripts específicos..." "${YELLOW}"
    
    # Comprobar script de micrófono
    if ~/.config/eww/scripts/microphone.sh status 2>/dev/null | grep -q "muted"; then
        print_msg "✅ Script de micrófono funciona correctamente" "${GREEN}"
    else
        print_msg "❌ Script de micrófono no funciona correctamente" "${RED}"
    fi

    # Comprobar script de cámara
    if ~/.config/eww/scripts/camera.sh status 2>/dev/null | grep -q "icon"; then
        print_msg "✅ Script de cámara funciona correctamente" "${GREEN}"
    else
        print_msg "❌ Script de cámara no funciona correctamente" "${RED}"
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

# Función para gestionar panel lateral
manage_side_panel() {
    case "$1" in
        open)
            print_msg "Abriendo panel lateral..." "${YELLOW}"
            eww open side-panel
            ;;
        close)
            print_msg "Cerrando panel lateral..." "${YELLOW}"
            eww close side-panel
            ;;
        toggle)
            print_msg "Alternando panel lateral..." "${YELLOW}"
            eww open --toggle side-panel
            ;;
        *)
            print_msg "Estado actual del panel lateral:" "${YELLOW}"
            if eww active-windows | grep -q "side-panel"; then
                print_msg "Panel lateral: ABIERTO" "${GREEN}"
            else
                print_msg "Panel lateral: CERRADO" "${RED}"
            fi
            ;;
    esac
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
    side-panel)
        manage_side_panel "$2"
        ;;
    *)
        print_msg "Uso: $0 {start|stop|reload|check|side-panel}" "${YELLOW}"
        print_msg "  start      - Iniciar EWW" "${YELLOW}"
        print_msg "  stop       - Detener EWW" "${YELLOW}"
        print_msg "  reload     - Recargar EWW" "${YELLOW}"
        print_msg "  check      - Verificar configuración" "${YELLOW}"
        print_msg "  side-panel - Gestionar panel lateral [open|close|toggle]" "${YELLOW}"
        exit 1
        ;;
esac 