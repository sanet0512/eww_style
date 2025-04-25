#!/bin/bash

# Script mejorado para WiFi con funcionalidad real

# Verificar si se pasa un argumento para realizar una acción
if [[ $1 = "toggle" ]]; then
    # Verificar el estado actual
    if rfkill list wifi | grep -q "Soft blocked: yes"; then
        # Activar WiFi
        rfkill unblock wifi
    else
        # Desactivar WiFi
        rfkill block wifi
    fi
    sleep 1  # Esperar a que se aplique el cambio
fi

# Obtener información del WiFi
# Verificar si el WiFi está habilitado
if rfkill list wifi 2>/dev/null | grep -q "Soft blocked: no"; then
    # Obtener SSID de la red conectada
    ssid=$(iwconfig 2>/dev/null | grep -oP 'ESSID:"\K[^"]*' | head -1)
    
    # Obtener la fuerza de la señal
    signal_strength=$(iwconfig 2>/dev/null | grep -oP 'Signal level=\K[-0-9]*' | head -1)
    
    # Si no hay SSID pero el wifi está encendido
    if [ -z "$ssid" ]; then
        connected=false
        ssid="Sin conexión"
        signal=0
    else
        connected=true
        
        # Convertir la señal a porcentaje (normalmente están en dBm, de -100 a 0)
        if [ -n "$signal_strength" ]; then
            # Convertir de dBm a porcentaje (aproximado)
            signal=$(( (100 + $signal_strength) * 2 ))
            # Asegurar que esté en el rango 0-100
            if [ $signal -gt 100 ]; then
                signal=100
            elif [ $signal -lt 0 ]; then
                signal=0
            fi
        else
            signal=100  # Valor por defecto si no podemos obtener la señal
        fi
    fi
else
    connected=false
    ssid="WiFi apagado"
    signal=0
fi

# Determinar el icono según el estado
if [ "$connected" = true ]; then
    if [ $signal -ge 80 ]; then
        icon="󰤨"
    elif [ $signal -ge 60 ]; then
        icon="󰤥"
    elif [ $signal -ge 40 ]; then
        icon="󰤢"
    elif [ $signal -ge 20 ]; then
        icon="󰤟"
    else
        icon="󰤯"
    fi
else
    icon="󰤮"
fi

# Construir respuesta JSON
echo "{\"icon\": \"$icon\", \"ssid\": \"$ssid\", \"signal\": \"$signal\", \"connected\": $connected}"

# Si no se pasó un argumento, seguir monitoreando cambios para actualizaciones en tiempo real
if [[ $1 != "toggle" ]]; then
    while true; do
        sleep 5
        
        # Repetir el proceso de verificación
        if rfkill list wifi 2>/dev/null | grep -q "Soft blocked: no"; then
            ssid=$(iwconfig 2>/dev/null | grep -oP 'ESSID:"\K[^"]*' | head -1)
            signal_strength=$(iwconfig 2>/dev/null | grep -oP 'Signal level=\K[-0-9]*' | head -1)
            
            if [ -z "$ssid" ]; then
                connected=false
                ssid="Sin conexión"
                signal=0
            else
                connected=true
                
                if [ -n "$signal_strength" ]; then
                    signal=$(( (100 + $signal_strength) * 2 ))
                    if [ $signal -gt 100 ]; then
                        signal=100
                    elif [ $signal -lt 0 ]; then
                        signal=0
                    fi
                else
                    signal=100
                fi
            fi
        else
            connected=false
            ssid="WiFi apagado"
            signal=0
        fi
        
        if [ "$connected" = true ]; then
            if [ $signal -ge 80 ]; then
                icon="󰤨"
            elif [ $signal -ge 60 ]; then
                icon="󰤥"
            elif [ $signal -ge 40 ]; then
                icon="󰤢"
            elif [ $signal -ge 20 ]; then
                icon="󰤟"
            else
                icon="󰤯"
            fi
        else
            icon="󰤮"
        fi
        
        echo "{\"icon\": \"$icon\", \"ssid\": \"$ssid\", \"signal\": \"$signal\", \"connected\": $connected}"
    done
fi
