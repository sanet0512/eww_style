#!/bin/bash

# Script para acciones del sistema

case "$1" in
    "lock")
        echo "Bloqueando pantalla..."
        # swaylock -f
        ;;
    "suspend")
        echo "Suspendiendo sistema..."
        # systemctl suspend
        ;;
    "logout")
        echo "Cerrando sesión..."
        # hyprctl dispatch exit
        ;;
    "reboot")
        echo "Reiniciando sistema..."
        # systemctl reboot
        ;;
    "shutdown")
        echo "Apagando sistema..."
        # systemctl poweroff
        ;;
    *)
        echo "Uso: $0 {lock|suspend|logout|reboot|shutdown}"
        exit 1
        ;;
esac
