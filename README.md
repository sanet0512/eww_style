# EWW Widgets Configuration

## Descripción
Esta configuración de EWW (ElKowar's Wacky Widgets) proporciona una interfaz de usuario personalizada para tu sistema Linux con barras transparentes y estilo minimalista. Incluye widgets para control de audio, micrófono, red, y más.

## Características
- Control de audio y micrófono
- Widgets de red
- Interfaz personalizable con transparencias
- Integración con WirePlumber para control de audio
- Capturas de pantalla en la carpeta `screenshots/`

## Estructura del Proyecto
```
.
├── scripts/           # Scripts de utilidad
├── styles/           # Archivos de estilos CSS
├── widgets/          # Widgets de EWW
├── docs/            # Documentación adicional
└── screenshots/     # Capturas de pantalla de la interfaz
```

## Requisitos
- EWW
- WirePlumber
- Font Awesome (para iconos)

## Instalación
1. Clona este repositorio en `~/.config/eww/`
2. Asegúrate de tener EWW instalado
3. Ejecuta `eww daemon` para iniciar el servidor
4. Ejecuta `eww open bar` para abrir la barra principal

## Uso
Los widgets principales incluyen:
- Control de volumen
- Control de micrófono
- Indicador de red
- Información del sistema

## Capturas de Pantalla
Puedes encontrar capturas de pantalla de la interfaz en la carpeta `screenshots/`. Estas imágenes muestran:
- La barra principal con transparencias
- Widgets individuales
- Estados diferentes de la interfaz

## Contribución
Las contribuciones son bienvenidas. Por favor, sigue las guías de estilo y asegúrate de probar tus cambios.

## Licencia
MIT License 