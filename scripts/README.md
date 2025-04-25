# Scripts para la gestión de EWW

Este directorio contiene scripts para gestionar y extender la funcionalidad de EWW.

## Script principal: eww-manager.sh

`eww-manager.sh` es un script unificado para gestionar la barra de EWW, con los siguientes comandos:

```bash
./eww-manager.sh {start|stop|reload|check}
```

### Comandos disponibles:

- **start**: Inicia EWW (detiene instancias anteriores si existen)
- **stop**: Detiene cualquier instancia en ejecución de EWW
- **reload**: Reinicia EWW para aplicar cambios en la configuración
- **check**: Verifica la configuración y asegura que todos los scripts tengan permisos de ejecución

### Ejemplos de uso:

```bash
# Iniciar la barra
./eww-manager.sh start

# Recargar después de cambios
./eww-manager.sh reload

# Verificar la configuración
./eww-manager.sh check

# Detener EWW
./eww-manager.sh stop
```

## Scripts de módulos

La barra utiliza varios scripts para mostrar información:

- **wifi.sh**: Muestra información de la conexión WiFi y permite activar/desactivar
- **bluetooth.sh**: Muestra información sobre Bluetooth y dispositivos conectados
- **volume.sh**: Controla y muestra el volumen del sistema
- **brightness.sh**: Controla y muestra el brillo de la pantalla
- **battery.sh**: Muestra el estado de la batería
- **get-workspaces.sh**: Obtiene información sobre los espacios de trabajo

## Uso de la barra

Los módulos de la barra tienen las siguientes funcionalidades:

### WiFi
- Muestra el nombre de la red conectada y la intensidad de la señal
- El icono cambia según la fuerza de la señal
- Clic para activar/desactivar WiFi
- Se actualiza cada 5 segundos

### Bluetooth
- Muestra el estado del Bluetooth y dispositivos conectados
- Clic para activar/desactivar Bluetooth
- Se actualiza cada 5 segundos

### Control de volumen
- Muestra el nivel de volumen actual
- Pasa el cursor por encima para mostrar el deslizador
- Clic para silenciar/activar el audio