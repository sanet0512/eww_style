# Control de Versiones para Eww

Este repositorio contiene la configuración de Eww (ElKowars Wacky Widgets) con control de versiones usando Git.

## Requisitos

- Git (ya instalado en tu sistema)
- Eww (ya instalado en tu sistema)

## Versiones disponibles

Este repositorio contiene dos versiones principales:

1. **Rama master**: Versión con barras transparentes y estilo minimalista
2. **Rama version-original**: Versión original con barras estándar

## Guía para principiantes

### ¿Qué es Git?

Git es un sistema de control de versiones que te permite guardar diferentes versiones de tus archivos y cambiar entre ellas fácilmente.

### Comandos básicos

#### Para ver el estado actual
```bash
git status
```

#### Para ver las ramas disponibles
```bash
git branch
```

#### Para cambiar entre versiones

Para cambiar a la versión con barras transparentes (minimalista):
```bash
git checkout master
```

Para cambiar a la versión original:
```bash
git checkout version-original
```

Después de cambiar entre versiones, debes reiniciar eww para ver los cambios:
```bash
eww reload
```

### Script para cambiar estilos rápidamente

Para facilitar el cambio entre estilos, puedes usar el script incluido:

```bash
# Cambiar al estilo minimalista/transparente
./scripts/cambiar-estilo.sh minimalista

# Cambiar al estilo original/estándar
./scripts/cambiar-estilo.sh original
```

Este script cambia automáticamente entre las ramas y reinicia eww.

### Para crear nuevas versiones

Si has hecho cambios que deseas guardar como una nueva versión:

1. **Crea una nueva rama para tu versión**:
   ```bash
   git checkout -b mi-nueva-version
   ```

2. **Realiza los cambios deseados** en los archivos:
   - `eww.scss` para cambios de estilos
   - `eww.yuck` para cambios de estructura y comportamiento

3. **Guarda tus cambios**:
   ```bash
   git add eww.scss eww.yuck
   git commit -m "Descripción de mis cambios"
   ```

### Fusionar versiones

Si quieres combinar los cambios de diferentes versiones:

1. **Cambia a la rama donde quieres aplicar los cambios**:
   ```bash
   git checkout rama-destino
   ```

2. **Fusiona los cambios de otra rama**:
   ```bash
   git merge otra-rama
   ```

## Solución de problemas

### Conflictos

Si Git muestra un mensaje de conflicto, significa que has modificado las mismas líneas en ambas versiones. Para resolverlo:

1. Abre los archivos con conflictos y busca secciones marcadas con `<<<<<<<`, `=======` y `>>>>>>>`.
2. Edita los archivos para mantener solo las partes que deseas.
3. Guarda los cambios y continúa la fusión:
   ```bash
   git add .
   git commit -m "Resuelto conflicto de fusión"
   ```

### Descartar cambios no guardados

Si has hecho cambios que no quieres mantener:
```bash
git checkout -- archivo
```

## Recomendaciones

1. **Haz commits frecuentes** con mensajes claros que expliquen los cambios realizados.
2. **Crea nuevas ramas** para cada conjunto de cambios relacionados.
3. **Realiza copias de seguridad** regularmente.
4. **Prueba tus cambios** antes de confirmarlos.

## Recursos adicionales

- [Git - La guía sencilla](https://rogerdudler.github.io/git-guide/index.es.html)
- [Documentación oficial de Git](https://git-scm.com/book/es/v2)
- [Documentación de Eww](https://github.com/elkowar/eww) 