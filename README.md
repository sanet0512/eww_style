# EWW Widgets Configuration

## Descripción
Esta configuración de EWW (ElKowar's Wacky Widgets) proporciona una interfaz de usuario personalizada para tu sistema Linux con barras transparentes y estilo minimalista. Incluye widgets para control de audio, micrófono, red, y más.

> **Nota**: EWW es un proyecto creado por [ElKowar](https://github.com/elkowar). Este repositorio contiene una configuración personalizada basada en su trabajo.

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
- [EWW](https://github.com/elkowar/eww) (ElKowar's Wacky Widgets)
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

## Créditos
- [EWW](https://github.com/elkowar/eww) por [ElKowar](https://github.com/elkowar)
- Esta configuración está basada en el trabajo original de ElKowar

## Contribución
Las contribuciones son bienvenidas. Por favor, sigue las guías de estilo y asegúrate de probar tus cambios.

## Licencia
Este proyecto está bajo la licencia GPL-3.0, al igual que EWW. Esto significa que:
- Cualquiera puede usar, modificar y distribuir este código
- Cualquier trabajo derivado debe mantener la misma licencia
- Se debe dar crédito al autor original
- Se debe incluir una copia de la licencia con cualquier distribución

Para más detalles, consulta el archivo [LICENSE](LICENSE). 