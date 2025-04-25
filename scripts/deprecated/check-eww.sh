#!/bin/bash

echo "Verificando configuración de EWW..."

# Verificar eww
if ! command -v eww &> /dev/null; then
    echo "❌ EWW no está instalado"
else
    echo "✅ EWW está instalado ($(eww --version))"
fi

# Verificar sassc
if ! command -v sassc &> /dev/null; then
    echo "❌ sassc no está instalado (necesario para compilar SCSS)"
else
    echo "✅ sassc está instalado"
fi

# Verificar scripts
echo "Verificando scripts..."
for script in ~/.config/eww/scripts/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo "✅ $script es ejecutable"
        else
            echo "❌ $script no es ejecutable"
            chmod +x "$script"
            echo "  → Permisos corregidos"
        fi
    fi
done

# Verificar archivos clave
echo "Verificando archivos clave..."
if [ -f ~/.config/eww/eww.yuck ]; then
    echo "✅ eww.yuck encontrado"
else
    echo "❌ eww.yuck no encontrado"
fi

if [ -f ~/.config/eww/eww.scss ]; then
    echo "✅ eww.scss encontrado"
else
    echo "❌ eww.scss no encontrado"
fi

# Verificar archivos potencialmente problemáticos
if [ -f ~/.config/eww/eww.css ]; then
    echo "⚠️ eww.css encontrado (podría causar conflictos)"
    echo "  → Recomendado: rm ~/.config/eww/eww.css"
fi

if [ -f ~/.config/eww/style.scss ]; then
    echo "⚠️ style.scss encontrado (podría causar conflictos)"
    echo "  → Recomendado: rm ~/.config/eww/style.scss"
fi

echo "Verificación completada" 