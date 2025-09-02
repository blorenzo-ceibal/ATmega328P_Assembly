# ⚡ 03 - Configurar Shell para Uso Global

> **⏱️ Tiempo estimado:** 3 minutos
> **🎯 Objetivo:** Configurar el comando `program` para usar desde cualquier directorio
> **📋 Prerequisito:** Haber completado [02-instalacion-basica.md](02-instalacion-basica.md) ✅

## 🌟 **¿Por qué configurar esto?**

Hasta ahora has usado `./program archivo.asm`, pero esto te limita a estar siempre en la carpeta del tutorial.

**Con esta configuración podrás:**
- ✅ Usar `program archivo.asm` desde **cualquier directorio**
- ✅ Crear proyectos en **cualquier carpeta** de tu Mac
- ✅ Workflow más **profesional** y cómodo
- ✅ **Mismo comando** sin importar dónde estés

---

## 🚀 **PASO 1: Configuración Automática del Alias (2 min)**

### 🔧 **Ejecutar script de configuración automática:**

Copia y pega este script completo en tu terminal:

```bash
# ⚡ CONFIGURACIÓN AUTOMÁTICA DEL COMANDO 'program'

configure_program_alias() {
    echo "🔍 Configurando alias global para 'program'..."

    # Opción 1: Usar directorio actual si estamos en el repo
    if [ -x "$(pwd)/program" ] && [[ "$(pwd)" == *"ATmega328P_Assembly"* ]]; then
        REPO_PATH="$(pwd)"
        echo "✅ Usando directorio actual: $REPO_PATH"
    else
        # Opción 2: Buscar automáticamente
        REPO_PATH=$(find "$HOME" -name "ATmega328P_Assembly" -type d 2>/dev/null | head -1)
        if [ -n "$REPO_PATH" ] && [ -x "$REPO_PATH/program" ]; then
            echo "✅ Repositorio encontrado automáticamente: $REPO_PATH"
        else
            echo "❌ No se pudo encontrar el repositorio automáticamente"
            echo "💡 Asegúrate de estar en la carpeta ATmega328P_Assembly y vuelve a ejecutar"
            return 1
        fi
    fi

    # Verificar si el alias ya existe
    if grep -q "alias program=" ~/.zshrc 2>/dev/null; then
        echo "⚠️  El alias 'program' ya existe en ~/.zshrc"
        echo "🔄 Actualizando con nueva ruta..."
        # Remover línea existente
        sed -i.backup '/alias program=/d' ~/.zshrc
    fi

    # Configurar alias
    echo "" >> ~/.zshrc
    echo "# ATmega328P Programming Command - $(date '+%Y-%m-%d')" >> ~/.zshrc
    echo "alias program='$REPO_PATH/program'" >> ~/.zshrc

    echo "🎉 Alias configurado: program -> $REPO_PATH/program"
    echo "⚡ Recargando configuración..."
    source ~/.zshrc

    # Verificar
    if command -v program >/dev/null 2>&1; then
        echo "✅ ¡Configuración exitosa! Ahora puedes usar 'program' desde cualquier directorio"
        program --help 2>/dev/null || echo "📝 Usa 'program nombre_archivo.asm' para programar"
    else
        echo "❌ Algo salió mal. Verifica manualmente con: which program"
    fi
}

# Ejecutar configuración
configure_program_alias
```

### ✅ **Deberías ver algo como esto:**
```
🔍 Configurando alias global para 'program'...
✅ Usando directorio actual: /Users/tuusuario/Desktop/ATmega328P_Assembly
🎉 Alias configurado: program -> /Users/tuusuario/Desktop/ATmega328P_Assembly/program
⚡ Recargando configuración...
✅ ¡Configuración exitosa! Ahora puedes usar 'program' desde cualquier directorio
```

---

## 🧪 **PASO 2: Verificar Configuración (1 min)**

### 🔍 **Test básico:**

```bash
# Verificar que el alias funciona
which program

# Debe mostrar algo como:
# program: aliased to /Users/tuusuario/ruta/ATmega328P_Assembly/program
```

### 🚀 **Test completo desde otro directorio:**

```bash
# Cambiar a otro directorio
cd ~/Desktop

# Probar que funciona desde cualquier lugar
program simple_blink

# Si ves que compila y programa, ¡está funcionando perfectamente!
```

---

## 💡 **Solución Manual (si algo falla)**

Si el script automático no funciona, puedes configurarlo manualmente:

### 🔧 **Método manual:**

```bash
# 1. Ir al directorio donde clonaste el repo
cd /ruta/a/tu/ATmega328P_Assembly

# 2. Agregar alias manualmente
echo "alias program='$(pwd)/program'" >> ~/.zshrc

# 3. Recargar configuración
source ~/.zshrc

# 4. Verificar
which program
```

---

## ✅ **Checkpoint - Comando Global Configurado**

### 🔍 **Verificaciones finales:**

- [ ] **Alias existe:** `which program` muestra la ruta correcta
- [ ] **Funciona globalmente:** `cd ~/Desktop && program simple_blink` compila
- [ ] **Sin errores:** No aparecen mensajes de "command not found"

### 🏆 **¡Tu nuevo superpoder!**

**Antes:**
```bash
cd /ruta/al/tutorial/ATmega328P_Assembly
./program mi_archivo.asm
```

**Ahora:**
```bash
# Desde CUALQUIER directorio:
cd ~/mis_proyectos_atmega/
program mi_archivo.asm

cd ~/Documents/universidad/
program proyecto_final.asm
```

---

## 🚀 **¿Qué significa esto para tu workflow?**

### 🎯 **Ahora puedes:**
- ✅ **Crear proyectos** en cualquier carpeta de tu Mac
- ✅ **Organizar** tus proyectos como quieras
- ✅ **Usar el comando** sin recordar rutas complicadas
- ✅ **Workflow profesional** como cualquier herramienta seria

### 💡 **Estructura recomendada para tus proyectos:**
```
~/Documents/
├── atmega_proyectos/
│   ├── proyecto_led/
│   │   └── led_parpadeo.asm
│   ├── proyecto_sensor/
│   │   └── sensor_temp.asm
│   └── universidad/
│       └── practica_final.asm
```

**¡Y desde cualquiera de esas carpetas, simplemente:** `program archivo.asm`

---

**✅ Configuración completada →** **[04-workflow-diario.md](04-workflow-diario.md)**

**⬅️ Paso anterior:** **[02-instalacion-basica.md](02-instalacion-basica.md)**
**🏠 Índice:** **[README.md](README.md)**
