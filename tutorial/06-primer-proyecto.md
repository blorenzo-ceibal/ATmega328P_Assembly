# 🎯 05 - Tu Primer Proyecto

> **⏱️ Tiempo estimado:** 10 minutos
> **🎯 Objetivo:** Probar tu primer proyecto completo: LED parpadeante funcional
> **📋 Prerequisite:** Haber completado [05-configurar-vscode.md](05-configurar-vscode.md) ✅

## 🚀 **¡El Momento de la Verdad!**

Vamos a usar el proyecto que ya descargaste para **programar tu primer microcontrolador** en tu Xplain Mini.

**Al final de este paso tendrás:**
- ✅ Un LED parpadeando en tu hardware
- ✅ El comando `program simple_blink` funcionando
- ✅ Toda la configuración verificada y lista

---

## 📁 **PASO 1: Verificar Estructura del Proyecto (2 min)**

### 🔧 **Navegar al proyecto descargado:**

```bash
# Ir al directorio del proyecto (ajusta la ruta si lo clonaste en otro lugar)
cd ~/Desktop/ATmega328P_Assembly

# Verificar que estás en el lugar correcto
pwd
# Deberías ver: /Users/tuusuario/Desktop/ATmega328P_Assembly
```

### 🔧 **Verificar que tienes todos los archivos:**

```bash
# Ver estructura principal
ls -la
# Deberías ver: Makefile, program, src/, tutorial/, build/

# Ver código fuente disponible
ls src/
# Deberías ver: simple_blink.asm, blink2.asm, m328pdef.inc

# Verificar que el script es ejecutable
ls -la program
# Deberías ver: -rwxr-xr-x ... program (con 'x' de ejecutable)
```

Tu estructura ya está completa:
```
ATmega328P_Assembly/
├── src/                     # 📝 Código fuente (.asm)
│   ├── simple_blink.asm    # ← Tu primer programa
│   ├── blink2.asm          # ← Programa más avanzado
│   └── m328pdef.inc        # ← Definiciones del micro
├── build/                   # 🔧 Archivos generados
├── Makefile                 # ⚙️ Automatización
└── program                  # 🚀 Script para programar
```

---

## 📝 **PASO 2: Examinar el Código Assembly (3 min)**

### 🔧 **Abrir VS Code en el proyecto:**

```bash
# Abrir VS Code en la carpeta actual
code .

# O abrir directamente el archivo principal
code src/simple_blink.asm
```

### 🎨 **Examinar el código existente:**

El archivo `src/simple_blink.asm` ya contiene un programa funcional. **Ábrelo en VS Code** y verás:

- 🟢 **Verde:** Comentarios explicativos
- 🔵 **Azul:** Directivas del assembler (#include, .equ, .text)
- 🟡 **Amarillo:** Etiquetas (main:, delay:)
- 🟣 **Púrpura:** Instrucciones del procesador (ldi, out, rcall, etc.)

**💡 No necesitas escribir código ahora** - el archivo ya está listo para usar. Solo examina cómo está estructurado.
code simple_blink.asm
```

**✅ Deberías ver:**
- **Comentarios** (`;`) en verde
- **Directivas** (`#include`, `.section`) en azul
- **Instrucciones** (`ldi`, `out`, `sbi`) en púrpura
- **Registros** (`r16`, `r17`) en verde
- **Labels** (`main:`, `loop:`) en amarillo

---

## ⚙️ **PASO 3: Programar el Microcontrolador (5 min)**

### 🔧 **¡El momento de la verdad! Conectar hardware:**

1. **Conecta tu Xplain Mini** al Mac con cable USB
2. **Verifica que el LED de power** esté encendido (luz verde/azul)
3. **El Mac debería detectar** automáticamente el dispositivo

### 🚀 **Programar usando el script automatizado:**

```bash
# El comando mágico - programa tu primer microcontrolador
program simple_blink

# Deberías ver mensajes como:
# 🚀 Programando ATmega328P via Xplain Mini...
# ✅ Compilación exitosa
# ✅ Programación completa
```

**⏳ Esto tardará 10-20 segundos.** Es normal ver mucho texto.

### ✅ **¡MOMENTO DE CELEBRACIÓN!**

**Si todo salió bien, deberías ver:**
- 🟢 **LED parpadeando** en tu Xplain Mini (cada segundo aproximadamente)
- 💻 **Mensaje "Programación exitosa"** en la terminal
- 🎉 **¡Tu primer microcontrolador funcionando!**
EOF
```

---

## 🚀 **PASO 4: Crear el Script Program (2 min)**

### 🔧 **Script automático para programación rápida:**

```bash
cat > program << 'EOF'
#!/bin/bash

# Script de programación automática para ATmega328P
MCU="atmega328p"
PROGRAMMER="xplainedmini"
PORT="usb"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    echo -e "${GREEN}🚀 Script de programación automática para ATmega328P${NC}"
    echo -e "${YELLOW}📋 Uso:${NC}"
    echo "  program archivo.asm     - Programa archivo.asm"
    echo "  program archivo         - Programa archivo.asm (agrega .asm automáticamente)"
    echo "  program -h              - Esta ayuda"
    echo ""
    echo -e "${YELLOW}💡 Ejemplos:${NC}"
    echo "  program simple_blink    - Compila y programa simple_blink.asm"
    echo "  program main.asm        - Compila y programa main.asm"
}

error_exit() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Falta el nombre del archivo${NC}"
    show_help
    exit 1
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Obtener nombre del archivo
FILE="$1"
[[ "$FILE" != *.asm ]] && FILE="${FILE}.asm"

# Verificar que el archivo existe
[ ! -f "$FILE" ] && error_exit "Archivo '$FILE' no encontrado"

# Compilar
echo -e "${GREEN}🎯 Procesando archivo: $FILE${NC}"
BASENAME=$(basename "$FILE" .asm)

echo -e "${YELLOW}📦 Compilando $FILE...${NC}"

# Paso a paso de compilación
avr-gcc -mmcu="$MCU" -I. -x assembler-with-cpp -g -c "$FILE" -o "${BASENAME}.o" || error_exit "Error en compilación"
avr-gcc -mmcu="$MCU" "${BASENAME}.o" -o "${BASENAME}.elf" || error_exit "Error en enlazado"
avr-objcopy -j .text -j .data -O ihex "${BASENAME}.elf" "${BASENAME}.hex" || error_exit "Error creando HEX"

# Mostrar tamaño
echo -e "${BLUE}📏 Tamaño del programa:${NC}"
avr-size --format=avr --mcu="$MCU" "${BASENAME}.elf"

echo -e "${GREEN}✅ Compilación exitosa: ${BASENAME}.hex${NC}"

# Programar
echo -e "${YELLOW}🚀 Programando ATmega328P via Xplain Mini...${NC}"
echo -e "${BLUE}ℹ️  Asegúrate de que la Xplain Mini esté conectada${NC}"

avrdude -c "$PROGRAMMER" -p "$MCU" -P "$PORT" -U flash:w:"${BASENAME}.hex":i || error_exit "Error programando el chip"

echo -e "${GREEN}✅ Programación exitosa!${NC}"
echo -e "${GREEN}🎉 ¡Proceso completado exitosamente!${NC}"
echo -e "${BLUE}💡 Tu código está ahora ejecutándose en el ATmega328P${NC}"
EOF

# Hacer ejecutable el script
chmod +x program
```

---

## 🔍 **PASO 4: Probar Programa Más Avanzado (2 min)**

### � **Probar el segundo ejemplo incluido:**

```bash
# Programa más sofisticado con efectos
program blink2

# Deberías ver el mismo proceso pero con un programa diferente
```

**✅ Este programa hace que el LED parpadee con un patrón más complejo.** ¡Compara los dos para ver la diferencia!

### � **Explorar archivos generados:**

```bash
# Ver archivos que se crearon
ls build/
# Deberías ver: simple_blink.hex, simple_blink.elf, simple_blink.o, blink2.hex, etc.

# Ver tamaño de los programas
make size
```

---

## ✅ **CHECKPOINT FINAL - ¡Verificar Todo!**

### 🔍 **Tests de verificación:**

- [ ] **LED parpadeando:** El LED en la Xplain Mini parpadea cada ~500ms
- [ ] **Comando funciona:** `program simple_blink` ejecuta sin errores
- [ ] **Archivos generados:** Existen archivos en `build/`
- [ ] **Tamaño razonable:** Programa ocupa menos de 1% de la memoria

### 🛠️ **Comandos adicionales que ahora funcionan:**

```bash
# Probar otros comandos
make help                    # Ver ayuda del Makefile
program -h                # Ver ayuda del script
make clean                  # Limpiar archivos generados
make size                   # Ver tamaño del programa
```

### 📊 **¡Tu progreso COMPLETADO!:**
- ✅ Requisitos verificados
- ✅ Instalación básica completa
- ✅ Workflow diario visualizado
- ✅ VS Code configurado profesionalmente
- ✅ **¡PRIMER PROYECTO FUNCIONANDO!**

---

## 🎉 **¡FELICIDADES!**

**Has logrado:**
- ✅ **Migrar exitosamente** de Microchip Studio a un entorno Mac profesional
- ✅ **Crear tu primer programa** ATmega328P que realmente funciona
- ✅ **Configurar workflow** más rápido que herramientas comerciales
- ✅ **Dominar herramientas** de línea de comandos profesionales

### 🚀 **Tu nuevo super-poder:**

```bash
# De ahora en adelante, para cualquier proyecto:
program mi_nuevo_proyecto.asm

# ¡Y listo! Compilado y programado en 10 segundos.
```

---

## 🔧 **Si algo falló:**

### ❌ **"Device not found" o problemas de programación**
- Verificar cable USB (probar otro cable)
- Reconectar Xplain Mini
- Ver [troubleshooting.md](anexos/troubleshooting.md) para más detalles

### ❌ **Errores de compilación**
- Verificar que copiaste el código exactamente
- Revisar que VS Code muestra syntax highlighting
- Verificar que `avr-gcc --version` funciona

### ❌ **LED no parpadea**
- Verificar que veas el mensaje "✅ Programación exitosa"
- El LED está en la esquina de la Xplain Mini (LED amarillo pequeño)
- Probar desconectar y reconectar la placa

---

**✅ Proyecto funcionando →** **[06-hardware-xplain.md](06-hardware-xplain.md)**

**⬅️ Paso anterior:** **[04-configurar-vscode.md](04-configurar-vscode.md)**
**🏠 Índice:** **[README.md](README.md)**
