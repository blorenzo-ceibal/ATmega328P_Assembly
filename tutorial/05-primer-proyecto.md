# 🎯 05 - Tu Primer Proyecto

> **⏱️ Tiempo estimado:** 10 minutos
> **🎯 Objetivo:** Crear tu primer proyecto completo: LED parpadeante funcional
> **📋 Prerequisito:** Haber completado [04-configurar-vscode.md](04-configurar-vscode.md)

## 🚀 **¡El Momento de la Verdad!**

Vamos a crear un proyecto completo desde cero que **realmente funcione** en tu Xplain Mini.

**Al final de este paso tendrás:**
- ✅ Un LED parpadeando en tu hardware
- ✅ El comando `program simple_blink` funcionando
- ✅ Toda la configuración verificada y lista

---

## 📁 **PASO 1: Crear Estructura del Proyecto (2 min)**

### 🔧 **Crear directorio de trabajo:**

```bash
# Crear directorio principal (puedes cambiar la ruta si prefieres)
mkdir -p ~/Desktop/ATmega328P_Assembly
cd ~/Desktop/ATmega328P_Assembly

# Crear estructura profesional
mkdir src                    # Para tu código fuente

# Verificar que estás en el lugar correcto
pwd
# Deberías ver: /Users/tuusuario/Desktop/ATmega328P_Assembly
```

### 🔧 **Crear archivos del proyecto:**

```bash
# Crear archivos principales
touch Makefile
touch src/simple_blink.asm   # ¡Nota que va en src/!
touch program

# Hacer el script ejecutable
chmod +x program

# Verificar estructura
ls -la
# Deberías ver: Makefile  program  src/

ls src/
# Deberías ver: simple_blink.asm
```

Tu estructura quedará así:
```
ATmega328P_Assembly/
├── src/                     # 📝 Tu código fuente (.asm)
│   └── simple_blink.asm    # Tu programa
├── Makefile                 # ⚙️ Automatización
└── program                  # 🚀 Script para programar
```

---

## 📝 **PASO 2: Crear el Código Assembly (3 min)**

### 🔧 **Escribir código del LED parpadeante:**

```bash
# Abrir VS Code en la carpeta actual
code .

# O abrir directamente el archivo
code src/simple_blink.asm
```

### 🎨 **Verificar syntax highlighting:**

```bash
# Abrir en VS Code para verificar colores
code simple_blink.asm
```

**✅ Deberías ver:**
- **Comentarios** (`;`) en verde
- **Directivas** (`#include`, `.section`) en azul
- **Instrucciones** (`ldi`, `out`, `sbi`) en púrpura
- **Registros** (`r16`, `r17`) en verde
- **Labels** (`main:`, `loop:`) en amarillo

---

## ⚙️ **PASO 3: Crear el Makefile (2 min)**

### 🔧 **Makefile completo y funcional:**

```bash
cat > Makefile << 'EOF'
# Makefile para ATmega328P en Xplain Mini con macOS
MCU = atmega328p
F_CPU = 16000000UL
TARGET = main

# Herramientas
CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
AVRDUDE = avrdude

# Flags del compilador
ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp

# Configuración del programador para Xplain Mini
PROGRAMMER = xplainedmini
PORT = usb
AVRDUDE_FLAGS = -c $(PROGRAMMER) -p $(MCU) -P $(PORT) -v

# Archivos
ASM_SOURCES = $(TARGET).asm
OBJECTS = $(ASM_SOURCES:.asm=.o)
ELF = $(TARGET).elf
HEX = $(TARGET).hex
LST = $(TARGET).lst

# Colores para output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[1;33m
NC = \033[0m

.PHONY: all clean program program-xplain size help

# Target por defecto
all: $(HEX) $(LST) size

# Patrón para compilar cualquier archivo .asm
%.o: %.asm
	@echo "$(YELLOW)Compilando $<...$(NC)"
	$(CC) $(ASFLAGS) -c $< -o $@

# Crear archivo ELF
$(ELF): $(OBJECTS)
	@echo "$(YELLOW)Enlazando...$(NC)"
	$(CC) -mmcu=$(MCU) $^ -o $@

# Crear archivo HEX
$(HEX): $(ELF)
	@echo "$(YELLOW)Creando archivo HEX...$(NC)"
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
	@echo "$(GREEN)✓ Compilación exitosa!$(NC)"

# Crear listado
$(LST): $(ELF)
	@echo "$(YELLOW)Creando listado...$(NC)"
	$(OBJDUMP) -h -S $< > $@

# Mostrar tamaño
size: $(ELF)
	@echo "$(YELLOW)Tamaño del programa:$(NC)"
	$(SIZE) --format=avr --mcu=$(MCU) $<

# Targets flexibles - programar cualquier archivo
program-xplain-%: %.hex
	@echo "$(YELLOW)Programando $*.asm via Xplain Mini...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

# Target para compilar cualquier archivo
compile-%: %.asm
	@echo "$(YELLOW)Compilando $<...$(NC)"
	$(CC) $(ASFLAGS) -c $< -o $*.o
	$(CC) -mmcu=$(MCU) $*.o -o $*.elf
	$(OBJCOPY) -j .text -j .data -O ihex $*.elf $*.hex
	$(SIZE) --format=avr --mcu=$(MCU) $*.elf
	@echo "$(GREEN)✓ $*.hex listo!$(NC)"

# Programar usando Xplain Mini
program-xplain: $(HEX)
	@echo "$(YELLOW)Programando ATmega328P via Xplain Mini...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

# Limpiar archivos generados
clean:
	@echo "$(YELLOW)Limpiando archivos...$(NC)"
	rm -f *.o *.elf *.hex *.lst

# Ayuda
help:
	@echo "$(GREEN)Makefile para ATmega328P en macOS$(NC)"
	@echo "$(YELLOW)Targets disponibles:$(NC)"
	@echo "  all                    - Compilar todo"
	@echo "  program-xplain-ARCHIVO - Programar ARCHIVO.asm via Xplain Mini"
	@echo "  compile-ARCHIVO        - Solo compilar ARCHIVO.asm"
	@echo "  clean                  - Limpiar archivos"
	@echo ""
	@echo "$(GREEN)Ejemplo: make program-xplain-simple_blink$(NC)"
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
    echo "  ./program archivo.asm     - Programa archivo.asm"
    echo "  ./program archivo         - Programa archivo.asm (agrega .asm automáticamente)"
    echo "  ./program -h              - Esta ayuda"
    echo ""
    echo -e "${YELLOW}💡 Ejemplos:${NC}"
    echo "  ./program simple_blink    - Compila y programa simple_blink.asm"
    echo "  ./program main.asm        - Compila y programa main.asm"
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

## ⚡ **PASO 5: Primera Prueba - ¡El Momento de la Verdad! (1 min)**

### 🔌 **Verificar hardware:**

1. **Conecta tu Xplain Mini** al Mac vía USB
2. **Verifica que se detecta:**

```bash
# Test de detección (debe mostrar información)
system_profiler SPUSBDataType | grep -i "edbg\|xplain"

# Test de comunicación
avrdude -c xplainedmini -p atmega328p -P usb -v
```

**✅ Si ves información del dispositivo y del chip, ¡estás listo!**

### 🚀 **¡El gran momento!**

```bash
# El comando mágico - tu primer programa
./program simple_blink
```

**✅ Si todo funciona deberías ver:**

```
🎯 Procesando archivo: simple_blink.asm
📦 Compilando simple_blink.asm...
📏 Tamaño del programa:
AVR Memory Usage
----------------
Device: atmega328p
Program:     174 bytes (0.5% Full)
✅ Compilación exitosa: simple_blink.hex
🚀 Programando ATmega328P via Xplain Mini...
Writing | ################################################## | 100%
✅ Programación exitosa!
🎉 ¡Proceso completado exitosamente!
💡 Tu código está ahora ejecutándose en el ATmega328P
```

**🎉 ¡Y el LED en tu Xplain Mini debe estar parpadeando!**

---

## ✅ **CHECKPOINT FINAL - ¡Verificar Todo!**

### 🔍 **Tests de verificación:**

- [ ] **LED parpadeando:** El LED en la Xplain Mini parpadea cada ~500ms
- [ ] **Comando funciona:** `./program simple_blink` ejecuta sin errores
- [ ] **Archivos generados:** Existen `simple_blink.hex`, `.elf`, `.o`
- [ ] **Tamaño razonable:** Programa ocupa ~174 bytes (menos de 1%)

### 🛠️ **Comandos adicionales que ahora funcionan:**

```bash
# Probar otros comandos
make help                           # Ver ayuda del Makefile
make program-xplain-simple_blink   # Programar usando Makefile
make clean                         # Limpiar archivos
make compile-simple_blink          # Solo compilar (sin programar)
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
./program mi_nuevo_proyecto.asm

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
