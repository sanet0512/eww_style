# Informe: Solución de problemas con EWW para Hyprland

## 1. Introducción

Este informe documenta el proceso de depuración y solución de problemas para una configuración de EWW (ElKowars Wacky Widgets) en un entorno Hyprland. El objetivo principal era resolver problemas relacionados con la carga de estilos y el lanzamiento correcto de las diferentes ventanas de widgets.

## 2. Problemas Detectados

### 2.1 Problema Principal

El usuario tenía una configuración casi completa de EWW pero enfrentaba dos problemas principales:

1. **Problemas de Estilo**: Los estilos no se aplicaban correctamente. A pesar de tener un archivo SCSS bien estructurado, la interfaz se mostraba con un color blanco pálido por defecto.
2. **Problemas de Lanzamiento**: Las ventanas definidas en la configuración no se abrían correctamente.

### 2.2 Mensajes de Error

Los logs mostraron errores específicos:

```
failed to open window `bar`
Caused by:
    No window named 'bar' exists in config.
    This may also be caused by your config failing to load properly, please check for any other errors in that case.
```

Otro error importante fue:
```
Encountered both an SCSS and CSS file. Only one of these may exist at a time
```

Y problemas con variables:
```
error: Failed to turn `` into a value of type f64
```

## 3. Análisis de Causas

### 3.1 Causas Principales

Tras el análisis, identificamos varias causas raíz:

1. **Conflicto de archivos de estilo**: Existían múltiples archivos CSS y SCSS que causaban conflictos.
2. **Problema con las variables**: Había una definición incorrecta en el archivo `variables.yuck` usando un comando no existente `defdocument`.
3. **Errores en scripts**: Algunos scripts no devolvían datos en el formato esperado o tenían permisos incorrectos.
4. **Problemas de formato JSON**: Los espacios de trabajo y otras variables no se definían con formato JSON válido.
5. **Problemas con el calendario**: El valor del año del calendario no se estaba pasando correctamente.

### 3.2 Confusiones durante el proceso

Durante el proceso de depuración, surgieron varias confusiones:

1. **Ubicación de los archivos**: Inicialmente no estaba claro dónde debían ubicarse los archivos CSS/SCSS para que EWW los reconociera correctamente.
2. **Carga de estilos**: Hubo confusión sobre cómo EWW carga los estilos (SCSS vs CSS compilado).
3. **Gestión de transparencias**: La implementación de transparencias en Wayland/Hyprland requería un enfoque diferente al esperado.
4. **Comunicación entre scripts**: No estaba claro cómo algunos scripts debían comunicarse con EWW.

## 4. Proceso de Solución

### 4.1 Diagnóstico Inicial

Comenzamos examinando la estructura de archivos y los logs de error:

```bash
eww logs
```

Esto reveló que había problemas con la carga de la configuración y con variables indefinidas.

### 4.2 Corrección de Archivos de Configuración

#### 4.2.1 Archivo variables.yuck

El primer problema se encontró en `variables.yuck`, que contenía comandos incorrectos:

```lisp
;; Definir el documento sin estilos predeterminados
(defdocument *none* :stylesheet "")
```

Esta sintaxis era incorrecta, ya que `defdocument` no es un comando válido en EWW. Se corrigió para usar solo variables válidas:

```lisp
;; Rutas para archivos SCSS externos
(defvar eww_scss_file "~/.config/eww/eww.scss")
```

#### 4.2.2 Sistemas de archivos CSS/SCSS

Se identificó que había múltiples archivos de estilo (`style.scss` y generación automática de `eww.css`), lo que causaba conflictos. La solución fue:

1. Eliminar archivos redundantes
2. Crear un único archivo `eww.scss`
3. Modificar el script de lanzamiento para manejar correctamente la compilación

#### 4.2.3 Corrección de Scripts

Varios scripts necesitaban correcciones:

1. **get-workspaces.sh**: Se corrigió para generar JSON válido
2. **calendar.sh**: Se modificó para garantizar que siempre devuelva datos válidos
3. **system-info.sh**: Se actualizó para manejar correctamente valores nulos o vacíos

### 4.3 Mejoras de Estilo

Se creó un archivo SCSS simplificado con colores más contrastantes:

```scss
$bg-color: #1e1e2e;
$surface-color: #313244;
$text-color: #ffffff;
$text-dimmed: #e0e0e0;
// Más variables de color...

.bar, .bottom-bar {
  background-color: $bg-color;
  color: $text-color;
  font-size: 14px;
  border-radius: $radius;
  margin: 8px;
  padding: 4px;
}

// Más estilos...
```

### 4.4 Adaptación para Hyprland

Se creó un script específico para Hyprland que maneja correctamente el ciclo de vida de EWW:

```bash
#!/bin/bash

# Esperar a que Hyprland esté listo
sleep 3

# Matar instancias anteriores de EWW
pkill eww

# Resto del script...
```

### 4.5 Herramientas de Diagnóstico

Se desarrolló un script de verificación `check-eww.sh` para diagnosticar problemas comunes:

```bash
#!/bin/bash

echo "Verificando configuración de EWW..."

# Verificar eww
if ! command -v eww &> /dev/null; then
    echo "❌ EWW no está instalado"
else
    echo "✅ EWW está instalado ($(eww --version))"
fi

# Más verificaciones...
```

## 5. Solución Final

La solución final consistió en:

1. **Estructura de archivos optimizada**:
   - Un único archivo SCSS (`eww.scss`)
   - Archivos de script corregidos con permisos adecuados
   - Eliminación de archivos redundantes o conflictivos

2. **Correcciones de configuración**:
   - Definiciones de ventanas correctas con clases CSS asignadas
   - Variables JSON bien formateadas
   - Inclusión apropiada de archivos externos

3. **Scripts de lanzamiento mejorados**:
   - Script específico para Hyprland
   - Mejor manejo de errores y tiempos de espera
   - Compilación SCSS adecuada

4. **Herramientas de diagnóstico**:
   - Script `check-eww.sh` para verificar la configuración
   - Mejor documentación de componentes

## 6. Lecciones Aprendidas

### 6.1 Consideraciones técnicas

1. **Gestión de estilos en EWW**: EWW puede usar SCSS pero debe manejarse cuidadosamente la compilación y evitar conflictos entre archivos.

2. **Formato JSON en EWW**: Las variables que utilizan JSON deben ser cuidadosamente formateadas y escapadas.

3. **Integración con Hyprland**: Para una integración adecuada, es necesario esperar a que el compositor esté listo antes de lanzar EWW.

4. **Debugging en EWW**: El comando `eww logs` es crucial para identificar problemas, pero los mensajes de error pueden ser crípticos.

### 6.2 Mejores prácticas identificadas

1. **Separación de configuración**: Mantener variables, widgets y estilos en archivos separados pero bien integrados.

2. **Scripts de lanzamiento robustos**: Incluir verificaciones, pausas y manejo de errores en los scripts de lanzamiento.

3. **Verificación sistemática**: Desarrollar herramientas para verificar configuraciones y dependencias.

4. **Permisos adecuados**: Asegurar que todos los scripts tengan permisos de ejecución.

## 7. Configuración para Auto-inicio

Para asegurar que EWW se inicie automáticamente con Hyprland, se añadió la siguiente línea al archivo de configuración de Hyprland:

```
exec-once = ~/.config/eww/scripts/launch-eww-hyprland.sh
```

## 8. Conclusión

La configuración de EWW con Hyprland requiere atención a varios detalles técnicos, especialmente en la gestión de estilos y la integración con el sistema de composición de ventanas. Mediante un enfoque sistemático de diagnóstico y corrección, logramos resolver los problemas de estilo y lanzamiento, creando una configuración robusta y visualmente coherente.

La clave para mantener un sistema EWW funcional es la limpieza de la configuración, la correcta definición de variables y clases CSS, y el uso de scripts de lanzamiento que manejen adecuadamente el ciclo de vida de la aplicación. 