# 🚀 Script Program - Explicación Línea por Línea

> **🎯 Objetivo:** Entender completamente cómo funciona el script `program`
> **📋 Nivel:** Intermedio - para estudiantes que quieren personalizar o crear scripts similares

## 📜 **Script Completo con Documentación**

```bash
#!/bin/bash
# ↑ Shebang: Le dice al sistema que use bash para ejecutar este script

# ===============================================
# SCRIPT DE PROGRAMACIÓN AUTOMÁTICA ATMEGA328P
# ===============================================
# Propósito: Compilar y programar archivos .asm con un solo comando
# Uso: ./program archivo.asm  O  ./program archivo
# Autor: Tutorial ATmega328P Mac

# ===============================================
# CONFIGURACIÓN PRINCIPAL
# ===============================================

# Tipo de microcontrolador objetivo
MCU="atmega328p"

# Tipo de programador para Xplain Mini
PROGRAMMER="xplainedmini"

# Puerto de comunicación (usb para Xplain Mini)
PORT="usb"

# ===============================================
# CÓDIGOS DE COLOR PARA OUTPUT BONITO
# ===============================================
# Estos códigos hacen que el texto tenga colores en terminal

GREEN='\033[0;32m'      # Verde para éxito ✅
RED='\033[0;31m'        # Rojo para errores ❌
YELLOW='\033[1;33m'     # Amarillo para procesos ⚠️
BLUE='\033[0;34m'       # Azul para información ℹ️
NC='\033[0m'            # No Color - resetea a color normal

# ===============================================
# FUNCIÓN: MOSTRAR AYUDA
# ===============================================
show_help() {
    # echo -e permite usar códigos de color (\033)
    echo -e "${GREEN}🚀 Script de programación automática para ATmega328P${NC}"
    echo -e "${YELLOW}📋 Uso:${NC}"
    echo "  ./program archivo.asm     - Programa archivo.asm"
    echo "  ./program archivo         - Programa archivo.asm (agrega .asm automáticamente)"
    echo "  ./program -h              - Esta ayuda"
    echo ""
    echo -e "${YELLOW}💡 Ejemplos:${NC}"
    echo "  ./program simple_blink    - Compila y programa simple_blink.asm"
    echo "  ./program main.asm        - Compila y programa main.asm"
}

# ===============================================
# FUNCIÓN: SALIR CON ERROR
# ===============================================
error_exit() {
    # $1 es el primer argumento pasado a la función
    echo -e "${RED}❌ Error: $1${NC}" >&2  # >&2 envía a stderr en lugar de stdout
    exit 1  # Salir del script con código de error 1
}

# ===============================================
# FUNCIÓN: PROGRAMAR MICROCONTROLADOR
# ===============================================
program_chip() {
    local hex_file="$1"  # local hace que la variable solo exista en esta función

    echo -e "${YELLOW}🚀 Programando ATmega328P via Xplain Mini...${NC}"
    echo -e "${BLUE}ℹ️  Asegúrate de que la Xplain Mini esté conectada${NC}"

    # Ejecutar avrdude y capturar si falla
    avrdude -c "$PROGRAMMER" -p "$MCU" -P "$PORT" -U flash:w:"$hex_file":i || error_exit "Error programando el chip"

    echo -e "${GREEN}✅ Programación exitosa!${NC}"
}

# ===============================================
# PROGRAMA PRINCIPAL - EMPIEZA AQUÍ
# ===============================================

# -----------------------------------------------
# VERIFICAR ARGUMENTOS DE ENTRADA
# -----------------------------------------------

# $# contiene el número de argumentos pasados al script
if [ $# -eq 0 ]; then
    # No hay argumentos, mostrar error
    echo -e "${RED}❌ Error: Falta el nombre del archivo${NC}"
    echo ""
    show_help
    exit 1
fi

# -----------------------------------------------
# MANEJAR SOLICITUDES DE AYUDA
# -----------------------------------------------

# $1 es el primer argumento
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0  # Salir exitosamente (código 0)
fi

# -----------------------------------------------
# PROCESAR NOMBRE DEL ARCHIVO CON ESTRUCTURA PROFESIONAL
# -----------------------------------------------

# Obtener el archivo especificado
FILE="$1"

# Agregar extensión .asm si no la tiene
# [[ ]] es test avanzado de bash
# != significa "no igual a"
# *.asm es patrón que significa "termina en .asm"
if [[ "$FILE" != *.asm ]]; then
    FILE="${FILE}.asm"  # ${variable}.extension agrega la extensión
fi

# -----------------------------------------------
# LÓGICA INTELIGENTE DE BÚSQUEDA DE ARCHIVOS
# -----------------------------------------------
# El script busca el archivo en múltiples ubicaciones:
# 1. Directorio actual (compatibilidad con proyectos antiguos)
# 2. Carpeta src/ (estructura profesional nueva)

SOURCE_FILE=""  # Variable para almacenar ruta encontrada

# Buscar primero en src/ (estructura preferida)
if [ -f "src/$FILE" ]; then
    SOURCE_FILE="src/$FILE"
    echo -e "${BLUE}ℹ️  Archivo encontrado en estructura profesional: src/$FILE${NC}"

# Si no está en src/, buscar en directorio actual (compatibilidad)
elif [ -f "$FILE" ]; then
    SOURCE_FILE="$FILE"
    echo -e "${YELLOW}⚠️  Archivo encontrado en directorio actual: $FILE${NC}"
    echo -e "${BLUE}💡 Sugerencia: Considera mover archivos .asm a carpeta src/${NC}"

# Si no se encuentra en ningún lado, mostrar error informativo
else
    echo -e "${RED}❌ Error: Archivo '$FILE' no encontrado${NC}"
    echo -e "${YELLOW}🔍 Ubicaciones buscadas:${NC}"
    echo -e "   📁 src/$FILE   (estructura profesional)"
    echo -e "   📄 $FILE       (directorio actual)"
    echo ""
    echo -e "${BLUE}💡 Tips:${NC}"
    echo -e "   • Crea carpeta 'src' y mueve archivos .asm ahí"
    echo -e "   • Verifica que el archivo existe y tiene extensión .asm"
    exit 1
fi

# -----------------------------------------------
# CREAR DIRECTORIO build/ PARA ARCHIVOS GENERADOS
# -----------------------------------------------
# Mantener el proyecto limpio separando archivos fuente de generados

BUILD_DIR="build"

# Crear directorio build/ si no existe
# -p hace que no dé error si ya existe
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${BLUE}📁 Creando directorio build/ para archivos generados...${NC}"
    mkdir -p "$BUILD_DIR"
fi

# -----------------------------------------------
# MOSTRAR INFORMACIÓN DEL PROCESO
# -----------------------------------------------

echo -e "${GREEN}🎯 Procesando archivo: $SOURCE_FILE${NC}"

# Obtener nombre base sin extensión para archivos generados
# $(basename file .ext) quita el path y la extensión
BASENAME=$(basename "$SOURCE_FILE" .asm)

echo -e "${YELLOW}📦 Compilando $SOURCE_FILE...${NC}"

# ===============================================
# PROCESO DE COMPILACIÓN PASO A PASO
# ===============================================

# -----------------------------------------------
# PASO 1: COMPILAR ASSEMBLY A OBJETO
# -----------------------------------------------
# avr-gcc compila código Assembly a archivo objeto (.o)

avr-gcc -mmcu="$MCU" \              # Especificar microcontrolador
        -I. \                       # Incluir archivos del directorio actual
        -x assembler-with-cpp \     # Tratar como Assembly con preprocesador
        -g \                        # Incluir información de debug
        -c "$SOURCE_FILE" \         # Compilar archivo fuente encontrado
        -o "$BUILD_DIR/${BASENAME}.o" # Archivo objeto va a build/

# || significa "o" - si el comando anterior falla, ejecutar error_exit
|| error_exit "Error en compilación"

# -----------------------------------------------
# PASO 2: ENLAZAR OBJETO A EJECUTABLE
# -----------------------------------------------
# avr-gcc enlaza archivos objeto para crear ejecutable (.elf)

avr-gcc -mmcu="$MCU" \                  # Especificar microcontrolador
        "$BUILD_DIR/${BASENAME}.o" \    # Archivo objeto de build/
        -o "$BUILD_DIR/${BASENAME}.elf" # Archivo ejecutable a build/

|| error_exit "Error en enlazado"

# -----------------------------------------------
# PASO 3: CREAR ARCHIVO HEX PARA PROGRAMAR
# -----------------------------------------------
# avr-objcopy convierte ELF a formato HEX que entiende avrdude

avr-objcopy -j .text \                  # Incluir sección de código
            -j .data \                  # Incluir sección de datos
            -O ihex \                   # Formato de salida Intel HEX
            "$BUILD_DIR/${BASENAME}.elf" \ # Archivo ELF de build/
            "$BUILD_DIR/${BASENAME}.hex"   # Archivo HEX a build/

|| error_exit "Error creando HEX"

# -----------------------------------------------
# MOSTRAR TAMAÑO DEL PROGRAMA
# -----------------------------------------------

echo -e "${BLUE}📏 Tamaño del programa:${NC}"

# avr-size muestra cuánta memoria usa el programa
avr-size --format=avr \                 # Formato específico para AVR
         --mcu="$MCU" \                 # Especificar microcontrolador
         "$BUILD_DIR/${BASENAME}.elf"   # Archivo ELF de build/

echo -e "${GREEN}✅ Compilación exitosa: build/${BASENAME}.hex${NC}"

# ===============================================
# PROCESO DE PROGRAMACIÓN
# ===============================================

# Llamar a la función program_chip con el archivo HEX del directorio build/
program_chip "$BUILD_DIR/${BASENAME}.hex"

# -----------------------------------------------
# MENSAJES FINALES DE ÉXITO
# -----------------------------------------------

echo -e "${GREEN}🎉 ¡Proceso completado exitosamente!${NC}"
echo -e "${BLUE}💡 Tu código está ahora ejecutándose en el ATmega328P${NC}"

# ===============================================
# FIN DEL SCRIPT
# ===============================================
# El script termina aquí exitosamente
```

---

## 🔍 **Explicación de Conceptos**

### 🔧 **¿Qué es un Script Bash?**

Un **script bash** es un programa escrito en lenguaje shell que automatiza tareas. Está compuesto por:

- **Comandos**: Instrucciones que se ejecutan secuencialmente
- **Variables**: Almacenan valores (`MCU="atmega328p"`)
- **Funciones**: Bloques de código reutilizable (`show_help()`)
- **Condicionales**: Decisiones (`if [ condición ]; then`)
- **Manejo de errores**: Qué hacer si algo falla (`|| error_exit`)

### 📋 **Variables Importantes**

| Variable | Significado | Valor |
|----------|-------------|-------|
| `$0` | Nombre del script | `./program` |
| `$1, $2, ...` | Argumentos pasados | `simple_blink.asm` |
| `$#` | Número de argumentos | `1` |
| `$?` | Código de salida del último comando | `0` (éxito) o `>0` (error) |

### 🎨 **Códigos de Color**

```bash
# Definición de colores
RED='\033[0;31m'        # Rojo
GREEN='\033[0;32m'      # Verde
YELLOW='\033[1;33m'     # Amarillo
BLUE='\033[0;34m'       # Azul
NC='\033[0m'            # No Color (reset)

# Uso en echo
echo -e "${GREEN}Texto en verde${NC}"
```

### 🔧 **Operadores de Test**

| Operador | Significado | Ejemplo |
|----------|-------------|---------|
| `-f archivo` | ¿Archivo existe? | `[ -f "test.asm" ]` |
| `-d directorio` | ¿Directorio existe? | `[ -d "/home" ]` |
| `==` | ¿Son iguales? | `[ "$var" == "valor" ]` |
| `!=` | ¿Son diferentes? | `[ "$var" != "otro" ]` |
| `-z string` | ¿String vacío? | `[ -z "$var" ]` |

---

## 🛠️ **Personalizar el Script**

### 🔧 **Cambiar microcontrolador:**

```bash
# Para ATmega168
MCU="atmega168"

# Para ATmega32u4
MCU="atmega32u4"
```

### 🔧 **Agregar soporte para Arduino:**

```bash
# Agregar esta función después de program_chip
program_arduino() {
    local hex_file="$1"

    # Buscar puerto Arduino automáticamente
    PORT=$(ls /dev/cu.usbserial* /dev/cu.usbmodem* 2>/dev/null | head -1)

    if [ -z "$PORT" ]; then
        error_exit "No se encontró puerto Arduino"
    fi

    echo -e "${YELLOW}🚀 Programando via Arduino en $PORT...${NC}"
    avrdude -c arduino -p "$MCU" -P "$PORT" -b 115200 -U flash:w:"$hex_file":i || error_exit "Error programando Arduino"
}

# Y modificar el main para detectar tipo de hardware
```

### 🔧 **Agregar verificación de herramientas:**

```bash
# Agregar al inicio del script, después de las variables
check_tools() {
    echo -e "${YELLOW}🔍 Verificando herramientas...${NC}"

    # Verificar que avr-gcc está instalado
    which avr-gcc >/dev/null || error_exit "avr-gcc no encontrado. Instalar con: brew install avr-gcc"

    # Verificar que avrdude está instalado
    which avrdude >/dev/null || error_exit "avrdude no encontrado. Instalar con: brew install avrdude"

    # Verificar que avr-objcopy está instalado
    which avr-objcopy >/dev/null || error_exit "avr-objcopy no encontrado"

    echo -e "${GREEN}✅ Todas las herramientas disponibles${NC}"
}

# Llamar la función en el main
check_tools
```

### 🔧 **Agregar modo verbose:**

```bash
# Agregar variable de configuración
VERBOSE=false

# Modificar función para mostrar más detalles
if [ "$VERBOSE" = true ]; then
    echo -e "${BLUE}🔧 Ejecutando: avr-gcc -mmcu=$MCU -I. -x assembler-with-cpp -g -c $FILE -o ${BASENAME}.o${NC}"
fi
```

### 🔧 **Soporte para múltiples archivos:**

```bash
# Modificar para aceptar múltiples archivos
if [ $# -eq 0 ]; then
    error_exit "Falta el nombre del archivo"
fi

# Procesar cada archivo
for FILE in "$@"; do
    echo -e "${GREEN}🎯 Procesando archivo: $FILE${NC}"
    # ... resto del proceso de compilación
done
```

---

## 💡 **Tips Avanzados**

### 🔍 **Debugging del Script:**

```bash
# Ejecutar script con debug info
bash -x ./program simple_blink.asm

# Agregar prints de debug
echo "DEBUG: FILE=$FILE, BASENAME=$BASENAME"

# Verificar variables
set -x  # Activar debug mode
set +x  # Desactivar debug mode
```

### ⚡ **Optimización de Velocidad:**

```bash
# Compilar en paralelo (si tienes múltiples archivos)
avr-gcc ... & avr-objcopy ... &
wait  # Esperar a que terminen todos los procesos paralelos

# Caché de archivos compilados
if [ "${BASENAME}.hex" -ot "$FILE" ]; then
    echo "Archivo ya está actualizado, saltando compilación"
    program_chip "${BASENAME}.hex"
    exit 0
fi
```

### 🔧 **Manejo Avanzado de Errores:**

```bash
# Trap para limpiar archivos temporales si el script falla
cleanup() {
    echo -e "${YELLOW}🧹 Limpiando archivos temporales...${NC}"
    rm -f *.o temp_*
}
trap cleanup EXIT

# Logging de errores
log_error() {
    echo "$(date): $1" >> error.log
    error_exit "$1"
}
```

---

## 📖 **Versión Simplificada para Principiantes**

Si el script completo es muy complejo, aquí hay una versión básica:

```bash
#!/bin/bash

# Script básico para programar ATmega328P
FILE="$1"

# Agregar .asm si no tiene extensión
[[ "$FILE" != *.asm ]] && FILE="${FILE}.asm"

# Verificar que existe
[ ! -f "$FILE" ] && echo "❌ Archivo no encontrado" && exit 1

# Obtener nombre base
BASENAME=$(basename "$FILE" .asm)

# Compilar
echo "📦 Compilando..."
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c "$FILE" -o "${BASENAME}.o" || exit 1
avr-gcc -mmcu=atmega328p "${BASENAME}.o" -o "${BASENAME}.elf" || exit 1
avr-objcopy -O ihex "${BASENAME}.elf" "${BASENAME}.hex" || exit 1

# Programar
echo "🚀 Programando..."
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:"${BASENAME}.hex":i || exit 1

echo "✅ ¡Completado!"
```

---

## 🚀 **Scripts Relacionados Útiles**

### 🔧 **Script para limpiar archivos:**

```bash
#!/bin/bash
# cleanup.sh - Limpiar archivos generados

echo "🧹 Limpiando archivos..."
rm -f *.o *.elf *.hex *.lst
echo "✅ Limpieza completa"
```

### 🔧 **Script para ver tamaño de todos los programas:**

```bash
#!/bin/bash
# sizes.sh - Ver tamaño de todos los programas

echo "📏 Tamaños de programas:"
for hex in *.hex; do
    if [ -f "$hex" ]; then
        elf="${hex%.hex}.elf"
        if [ -f "$elf" ]; then
            echo "=== $hex ==="
            avr-size --format=avr --mcu=atmega328p "$elf"
        fi
    fi
done
```

## 📁 **Ventajas de la Estructura src/build/**

### 🎯 **¿Por qué separar archivos fuente y generados?**

```
proyecto_profesional/
├── src/                     # 📝 Solo código que escribes
│   ├── main.asm
│   ├── blink.asm
│   └── utils.asm
├── build/                   # 🔧 Solo archivos generados
│   ├── main.hex
│   ├── main.elf
│   └── main.o
├── Makefile                 # ⚙️ Automatización
└── program                  # 🚀 Este script
```

### ✅ **Beneficios tangibles:**

1. **🗑️ Git más limpio:** Solo hacer commit de `src/`, ignorar `build/`
2. **🧹 Mantenimiento fácil:** `rm -rf build/` limpia todo sin tocar código
3. **👥 Trabajo en equipo:** Evita conflictos con archivos generados
4. **🎯 Foco:** Solo el código fuente es importante de verdad
5. **📏 Proyectos escalables:** Fácil agregar subdirectorios en `src/`

### 🔧 **El script se adapta automáticamente:**

```bash
# ✅ Encuentra archivo en cualquier estructura
./program blink              # Busca src/blink.asm, luego blink.asm

# ✅ Crea build/ si no existe
# No necesitas hacer mkdir build/

# ✅ Rutas inteligentes
# src/main.asm → build/main.hex

# ✅ Mensajes informativos
# Te dice dónde encontró el archivo
```

### 🚀 **Comandos mejorados para la nueva estructura:**

```bash
# Ver estructura del proyecto
tree                         # macOS: brew install tree
# O con ls:
ls -la src/ build/

# Limpiar solo archivos generados (mantener fuentes)
rm -rf build/

# Buscar archivos fuente
find src/ -name "*.asm"

# Ver tamaños de todos los proyectos
ls build/*.elf | xargs avr-size --format=avr --mcu=atmega328p
```

---

### 🔧 **Script para backup de proyectos:**

```bash
#!/bin/bash
# backup.sh - Crear backup del proyecto

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="proyecto_backup_$DATE.tar.gz"

echo "💾 Creando backup..."
tar -czf "$BACKUP_NAME" *.asm *.h Makefile program README.md
echo "✅ Backup creado: $BACKUP_NAME"
```

---

**🏠 Regresar:** **[README.md](../README.md)**
**📚 Otros anexos:** **[anexos/](./)**
