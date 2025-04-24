#!/bin/bash

# Obtener el mes y año actuales
current_month=$(date +%m)
current_year=$(date +%Y)

# Función para mostrar el calendario
show_calendar() {
    cal --color=never $1 $2
}

# Asegurar que el script devuelva algo
if [ -z "$1" ]; then
    show_calendar $current_month $current_year
else
    case "$1" in
        "prev")
            if [ $current_month -eq 1 ]; then
                show_calendar 12 $((current_year - 1))
            else
                show_calendar $((current_month - 1)) $current_year
            fi
            ;;
        "next")
            if [ $current_month -eq 12 ]; then
                show_calendar 1 $((current_year + 1))
            else
                show_calendar $((current_month + 1)) $current_year
            fi
            ;;
        *)
            show_calendar $current_month $current_year
            ;;
    esac
fi
