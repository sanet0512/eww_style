#!/bin/bash

# Función para monitorear los cambios en los espacios de trabajo de Hyprland
function get_workspace_data() {
    # Verificar si hyprctl está disponible
    if ! command -v hyprctl &> /dev/null; then
        # Si hyprctl no está disponible, retornar datos simulados
        echo '[{"id":1,"active":true,"windows":0},{"id":2,"active":false,"windows":0},{"id":3,"active":false,"windows":0},{"id":4,"active":false,"windows":0},{"id":5,"active":false,"windows":0}]'
        return
    fi
    
    # Obtener espacios de trabajo activos
    active_workspace=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)
    
    # Si el comando anterior falla, usar el valor predeterminado
    if [ -z "$active_workspace" ] || [ "$active_workspace" = "null" ]; then
        active_workspace=1
    fi
    
    # Crear un array para los espacios de trabajo del 1 al 5
    workspaces_array='['
    
    # Espacios de trabajo fijos del 1 al 5
    for i in {1..5}; do
        # Verificar si hay ventanas en este espacio de trabajo
        has_windows=$(hyprctl workspaces -j 2>/dev/null | jq -r ".[] | select(.id == $i) | .windows" 2>/dev/null)
        
        # Si es null, no hay ventanas
        if [ "$has_windows" = "null" ] || [ -z "$has_windows" ] || [ "$has_windows" = "0" ]; then
            has_windows=0
        fi
        
        # Marcar si este es el espacio de trabajo activo
        is_active="false"
        if [ "$active_workspace" = "$i" ]; then
            is_active="true"
        fi
        
        # Añadir al array JSON
        workspaces_array+="{ \"id\": $i, \"active\": $is_active, \"windows\": $has_windows }"
        
        # Añadir coma si no es el último elemento
        if [ $i -lt 5 ]; then
            workspaces_array+=", "
        fi
    done
    
    workspaces_array+=']'
    echo "$workspaces_array"
}

# Función principal para monitorear cambios
get_workspace_data

# Verificar si estamos en una sesión Hyprland
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Verificar si socat está disponible
    if command -v socat &> /dev/null; then
        # Ruta del socket
        SOCKET_PATH="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
        
        # Verificar si el socket existe
        if [ -S "$SOCKET_PATH" ]; then
            # Monitorear eventos de cambio de espacio de trabajo y actualizar
            socat -u UNIX-CONNECT:"$SOCKET_PATH" - 2>/dev/null | while read -r line; do
                case "$line" in
                    workspace*|createworkspace*|destroyworkspace*|openwindow*|closewindow*|movewindow*)
                        get_workspace_data
                        ;;
                esac
            done
        else
            # Si el socket no existe, actualizar periódicamente
            while true; do
                get_workspace_data
                sleep 1
            done
        fi
    else
        # Si socat no está disponible, actualizar periódicamente
        while true; do
            get_workspace_data
            sleep 1
        done
    fi
else
    # Si no estamos en Hyprland, salir después de imprimir una vez
    exit 0
fi
