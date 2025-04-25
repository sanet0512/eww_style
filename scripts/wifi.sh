#!/bin/bash

# Script para WiFi con funcionalidad real

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
    # Reportar el nuevo estado después del toggle
    if rfkill list wifi | grep -q "Soft blocked: no"; then
        echo "{\"icon\": \"󰤨\", \"ssid\": \"Activando...\", \"signal\": \"0\", \"connected\": false}"
    else
        echo "{\"icon\": \"󰤮\", \"ssid\": \"WiFi apagado\", \"signal\": \"0\", \"connected\": false}"
    fi
    exit 0
fi

# Función para obtener y mostrar la información del WiFi
get_wifi_info() {
    # Verificar si el WiFi está habilitado
    if rfkill list wifi 2>/dev/null | grep -q "Soft blocked: no"; then
        # Obtener SSID de la red conectada utilizando NetworkManager
        if command -v nmcli &> /dev/null; then
            # Usar nmcli si está disponible (más preciso)
            connection_info=$(nmcli -t -f DEVICE,STATE,CONNECTION device | grep -E '^wlan[0-9]:connected:')
            if [ -n "$connection_info" ]; then
                connected=true
                ssid=$(echo "$connection_info" | cut -d: -f3)
                
                # Obtener calidad de señal en porcentaje con nmcli
                signal=$(nmcli -t -f IN-USE,SIGNAL device wifi | grep "^\*" | cut -d: -f2)
                if [ -z "$signal" ]; then
                    signal=0
                fi
            else
                connected=false
                ssid="Sin conexión"
                signal=0
            fi
        else
            # Alternativa usando iwconfig si nmcli no está disponible
            ssid=$(iwconfig 2>/dev/null | grep -oP 'ESSID:"\K[^"]*' | head -1)
            signal_strength=$(iwconfig 2>/dev/null | grep -oP 'Signal level=\K[-0-9]*' | head -1)
            
            if [ -z "$ssid" ]; then
                connected=false
                ssid="Sin conexión"
                signal=0
            else
                connected=true
                
                # Convertir la señal a porcentaje (de dBm)
                if [ -n "$signal_strength" ]; then
                    signal=$(( (100 + $signal_strength) * 2 ))
                    # Asegurar que esté en el rango 0-100
                    if [ $signal -gt 100 ]; then
                        signal=100
                    elif [ $signal -lt 0 ]; then
                        signal=0
                    fi
                else
                    signal=100
                fi
            fi
        fi
    else
        connected=false
        ssid="WiFi apagado"
        signal=0
    fi

    # Determinar el icono según el estado y la intensidad de la señal
    if [ "$connected" = true ]; then
        if [ $signal -ge 80 ]; then
            icon="󰤨"  # Señal excelente
        elif [ $signal -ge 60 ]; then
            icon="󰤥"  # Señal buena
        elif [ $signal -ge 40 ]; then
            icon="󰤢"  # Señal media
        elif [ $signal -ge 20 ]; then
            icon="󰤟"  # Señal baja
        else
            icon="󰤯"  # Señal muy baja
        fi
    else
        icon="󰤮"  # WiFi apagado o desconectado
    fi

    # Devolver información como JSON
    echo "{\"icon\": \"$icon\", \"ssid\": \"$ssid\", \"signal\": \"$signal\", \"connected\": $connected}"
}

# Mostrar la información inicial
get_wifi_info

# Monitorear cambios y actualizar cada 5 segundos
while true; do
    sleep 5
    get_wifi_info
done
