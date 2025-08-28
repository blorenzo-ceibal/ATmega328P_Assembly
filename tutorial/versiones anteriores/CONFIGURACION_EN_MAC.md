# 🍎 CONFIGURACIÓN COMPLETA EN MAC PARA ATmega328P

## 📋 Guía completa para programar ATmega328P en Assembly usando VS Code en macOS

Esta guía te permitirá migrar desde Microchip Studio (Windows) a un entorno completo de desarrollo en macOS usando Visual Studio Code.

---

## 🛠️ PASO 1: INSTALACIÓN DE HOMEBREW (Si no lo tienes)

```bash
# Instalar Homebrew (gestor de paquetes para macOS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Verificar instalación
brew --version
```

---

## 🔧 PASO 2: INSTALACIÓN DEL TOOLCHAIN AVR

```bash
# Agregar el tap oficial para AVR
brew tap osx-cross/avr

# Instalar el toolchain completo
brew install avr-gcc avrdude

# Instalar herramientas adicionales útiles
brew install minicom screen

# Verificar instalaciones
avr-gcc --version
avrdude -?
```

### ✅ Verificación del toolchain:
```bash
# Deberías ver algo como:
# avr-gcc (GCC) 12.2.0
# Copyright (C) 2022 Free Software Foundation, Inc.
```

---

## 💻 PASO 3: CONFIGURACIÓN DE VISUAL STUDIO CODE

### 3.1 Instalar VS Code (si no lo tienes):
```bash
brew install --cask visual-studio-code
```

### 3.2 Instalar extensiones esenciales:

**📋 Lista completa de extensiones requeridas:**

#### 🔧 Extensiones obligatorias:
1. **C/C++** - IntelliSense, debugging y navegación de código
   - ID: `ms-vscode.cpptools`
   - **Esencial para**: Soporte de headers AVR y autocompletado

2. **x86 and x86_64 Assembly** - Syntax highlighting para Assembly  
   - ID: `13xforever.language-x86-64-assembly`
   - **Esencial para**: Coloreado de sintaxis .asm con soporte general

3. **AVR Support** - Soporte específico para microcontroladores AVR
   - ID: `rockcat.avr-support`
   - **Esencial para**: Syntax highlighting optimizado para ATmega328P

#### 🚀 Extensiones recomendadas:
4. **ASM Code Lens** - Navegación avanzada en código Assembly
   - ID: `maziac.asm-code-lens`
   - **Útil para**: Referencias, hover information, outline view

5. **Code Runner** - Ejecutar comandos desde VS Code
   - ID: `formulahendry.code-runner`
   - **Útil para**: Compilar y programar con un click

6. **Makefile Tools** - Soporte completo para Makefiles
   - ID: `ms-vscode.makefile-tools`
   - **Útil para**: IntelliSense en Makefile

7. **Better Comments** - Comentarios mejorados
   - ID: `aaron-bond.better-comments`
   - **Útil para**: Documentar mejor el código Assembly

8. **Hex Editor** - Ver archivos HEX generados
   - ID: `ms-vscode.hexeditor`
   - **Útil para**: Inspeccionar archivos compilados

#### ⚡ Extensiones profesionales (opcionales):
9. **PlatformIO IDE** - Entorno completo para microcontroladores
   - ID: `platformio.platformio-ide`
   - **Avanzado**: Soporte para AVR, Arduino, ESP32, STM32 y más

10. **Embedded IDE** - IDE específico para microcontroladores
    - ID: `cl.eide`
    - **Avanzado**: Desarrollo profesional para 8051/AVR/STM8/Cortex-M

### 3.3 Instalar extensiones automáticamente:

```bash
# === EXTENSIONES OBLIGATORIAS ===
# C/C++ para headers AVR
code --install-extension ms-vscode.cpptools

# Assembly syntax highlighting general
code --install-extension 13xforever.language-x86-64-assembly

# Soporte específico para AVR
code --install-extension rockcat.avr-support

# === EXTENSIONES RECOMENDADAS ===
# Navegación avanzada en Assembly
code --install-extension maziac.asm-code-lens

# Utilidades
code --install-extension formulahendry.code-runner
code --install-extension ms-vscode.makefile-tools
code --install-extension aaron-bond.better-comments
code --install-extension ms-vscode.hexeditor

# === EXTENSIONES PROFESIONALES (OPCIONALES) ===
# Para desarrollo avanzado de microcontroladores
# code --install-extension platformio.platformio-ide
# code --install-extension cl.eide

# Verificar instalación
code --list-extensions | grep -E "(cpptools|assembly|avr-support|asm-code-lens|code-runner|makefile|better-comments|hexeditor)"
```

### 3.4 Verificar colores y syntax highlighting:

Después de instalar las extensiones:

1. **Abre tu archivo `simple_blink.asm`**:
   ```bash
   code simple_blink.asm
   ```

2. **Verifica que veas colores en:**:
   - ✅ Directivas (`.section`, `.global`) - Azul
   - ✅ Instrucciones (`ldi`, `out`, `sbi`) - Púrpura/Magenta  
   - ✅ Registros (`r16`, `r17`, `r18`) - Verde
   - ✅ Comentarios (`;`) - Verde/Gris
   - ✅ Labels (`main:`, `loop:`) - Amarillo
   - ✅ Constantes (`RAMEND`, `DDB5`) - Cyan

3. **Configurar tema de colores** (opcional):
   - `Cmd + Shift + P` → "Preferences: Color Theme"
   - Recomendados: "Dark+ (default dark)", "Monokai", "One Dark Pro"

### 3.5 Configuración inicial de VS Code:

Abre VS Code y configura estas preferencias básicas:

```bash
# Abrir configuración de VS Code
code --command "workbench.action.openSettings"
```

**Configuraciones importantes para Assembly:**
- `files.autoSave`: `afterDelay`
- `editor.tabSize`: `4` 
- `editor.insertSpaces`: `true`
- `editor.wordWrap`: `on`
- `files.associations`: `{"*.asm": "asm", "*.inc": "asm"}`
- `terminal.integrated.defaultProfile.osx`: `zsh`

---

## 🎛️ PASO 4: CONFIGURACIÓN PARA XPLAIN MINI

### 4.1 Identificar tu Xplain Mini:

```bash
# Conecta tu Xplain Mini y ejecuta:
system_profiler SPUSBDataType | grep -A 10 -B 5 "Xplain\|EDBG\|Microchip"

# También puedes usar:
ls /dev/cu.*
```

**Típicos identificadores para Xplain Mini:**
- `/dev/cu.usbmodem*` 
- `/dev/tty.usbmodem*`

### 4.2 Configurar permisos (importante en macOS):

```bash
# Agregar tu usuario al grupo que puede acceder a dispositivos serie
sudo dseditgroup -o edit -a $(whoami) -t user _developer

# Reiniciar para aplicar cambios (o logout/login)
```

---

## ⚙️ PASO 5: CONFIGURACIÓN DEL WORKSPACE EN VS CODE

### 5.1 Crear configuración de tasks.json:

Crea la carpeta `.vscode` en tu proyecto:
```bash
mkdir -p .vscode
```

**Archivo `.vscode/tasks.json`:**
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build ASM",
            "type": "shell",
            "command": "make",
            "args": ["all"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "label": "Program ATmega328P (Xplain Mini)",
            "type": "shell",
            "command": "make",
            "args": ["program-xplain"],
            "group": "test",
            "dependsOn": "Build ASM",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Clean",
            "type": "shell",
            "command": "make",
            "args": ["clean"],
            "group": "build"
        },
        {
            "label": "Serial Monitor",
            "type": "shell",
            "command": "screen",
            "args": ["/dev/cu.usbmodem*", "9600"],
            "isBackground": true,
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "new"
            }
        }
    ]
}
```

### 5.2 Crear configuración de launch.json (para debugging):

**Archivo `.vscode/launch.json`:**
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Build and Program",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/dummy.js",
            "preLaunchTask": "Program ATmega328P (Xplain Mini)",
            "console": "integratedTerminal"
        }
    ]
}
```

### 5.3 Configuración de settings.json:

**Archivo `.vscode/settings.json`:**
```json
{
    "files.associations": {
        "*.asm": "asm-intel-x86-generic",
        "*.inc": "asm-intel-x86-generic",
        "*.s": "asm-intel-x86-generic"
    },
    "code-runner.executorMap": {
        "asm": "cd $dir && make all && make program-xplain"
    },
    "terminal.integrated.defaultProfile.osx": "zsh"
}
```

---

## 📝 PASO 6: MAKEFILE OPTIMIZADO PARA XPLAIN MINI

**Archivo `Makefile` mejorado:**

```makefile
# Makefile para ATmega328P en Xplain Mini con macOS
# Reemplazo de Microchip Studio para Mac

# Configuración del proyecto
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
# IMPORTANTE: Usar xplainedmini, NO jtag2updi
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
NC = \033[0m # No Color

.PHONY: all clean program program-xplain size fuses info help install-tools

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

# 🚀 TARGETS FLEXIBLES - Programar cualquier archivo
program-xplain-%: %.hex
	@echo "$(YELLOW)Programando $*.asm via Xplain Mini...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

program-arduino-%: %.hex
	@echo "$(YELLOW)Buscando puerto Arduino...$(NC)"
	@PORT=$$(ls /dev/cu.usbmodem* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)✗ No se encontró puerto Arduino$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Programando $*.asm via $$PORT...$(NC)"; \
	$(AVRDUDE) -c arduino -p $(MCU) -P $$PORT -b 115200 -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

# Target para compilar cualquier archivo
compile-%: %.asm
	@echo "$(YELLOW)Compilando $<...$(NC)"
	$(CC) $(ASFLAGS) -c $< -o $*.o
	$(CC) -mmcu=$(MCU) $*.o -o $*.elf
	$(OBJCOPY) -j .text -j .data -O ihex $*.elf $*.hex
	$(SIZE) --format=avr --mcu=$(MCU) $*.elf
	@echo "$(GREEN)✓ $*.hex listo!$(NC)"

# Programar usando Xplain Mini (target principal)
program-xplain: $(HEX)
	@echo "$(YELLOW)Programando ATmega328P via Xplain Mini...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

# Programar usando Arduino bootloader (alternativo)
program-arduino: $(HEX)
	@echo "$(YELLOW)Buscando puerto Arduino...$(NC)"
	@PORT=$$(ls /dev/cu.usbmodem* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)✗ No se encontró puerto Arduino$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Programando via $$PORT...$(NC)"; \
	$(AVRDUDE) -c arduino -p $(MCU) -P $$PORT -b 115200 -U flash:w:$<:i
	@echo "$(GREEN)✓ Programación exitosa!$(NC)"

# Leer fusibles
fuses:
	@echo "$(YELLOW)Leyendo fusibles...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h

# Configurar fusibles para 16MHz externo
set-fuses:
	@echo "$(YELLOW)Configurando fusibles para 16MHz...$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U lfuse:w:0xFF:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m

# Información del microcontrolador
info:
	@echo "$(YELLOW)Información del microcontrolador:$(NC)"
	$(AVRDUDE) $(AVRDUDE_FLAGS) -v

# Abrir monitor serie
monitor:
	@PORT=$$(ls /dev/cu.usbmodem* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)✗ No se encontró puerto serie$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Abriendo monitor serie en $$PORT...$(NC)"; \
	echo "$(YELLOW)Para salir: Ctrl+A, luego K, luego Y$(NC)"; \
	screen $$PORT 9600

# Limpiar archivos generados
clean:
	@echo "$(YELLOW)Limpiando archivos...$(NC)"
	rm -f *.o *.elf *.hex *.lst

# Instalar herramientas faltantes
install-tools:
	@echo "$(YELLOW)Instalando herramientas AVR...$(NC)"
	brew tap osx-cross/avr
	brew install avr-gcc avrdude minicom screen

# Ayuda
help:
	@echo "$(GREEN)Makefile para ATmega328P en macOS$(NC)"
	@echo "$(YELLOW)Targets disponibles:$(NC)"
	@echo "  all                    - Compilar todo"
	@echo "  program-xplain         - Programar main.asm via Xplain Mini"
	@echo "  program-xplain-ARCHIVO - Programar ARCHIVO.asm via Xplain Mini"
	@echo "  program-arduino-ARCHIVO- Programar ARCHIVO.asm via Arduino"
	@echo "  compile-ARCHIVO        - Solo compilar ARCHIVO.asm"
	@echo "  size                   - Mostrar tamaño del programa"
	@echo "  fuses                  - Leer fusibles"
	@echo "  set-fuses              - Configurar fusibles"
	@echo "  info                   - Información del micro"
	@echo "  monitor                - Monitor serie"
	@echo "  clean                  - Limpiar archivos"
	@echo "  install-tools          - Instalar herramientas"
	@echo "  help                   - Esta ayuda"
	@echo ""
	@echo "$(GREEN)Ejemplos de uso:$(NC)"
	@echo "  make program-xplain-simple_blink  # Programa simple_blink.asm"
	@echo "  make compile-test                 # Solo compila test.asm"
```

---

## 🔌 PASO 7: CONFIGURACIÓN ESPECÍFICA PARA XPLAIN MINI

### 7.1 Verificar conexión de la Xplain Mini:

```bash
# Conectar la Xplain Mini y verificar
system_profiler SPUSBDataType | grep -A 5 "EDBG"

# Debería mostrar algo como:
# EDBG CMSIS-DAP:
#   Product ID: 0x2111
#   Vendor ID: 0x03eb (Atmel Corporation)
```

### 7.2 Test de conexión:

```bash
# Test básico de comunicación - IMPORTANTE: usar xplainedmini
avrdude -c xplainedmini -p atmega328p -P usb -v

# Si funciona, deberías ver información del chip como:
# Device signature = 0x1e950f (probably m328p)
```

### 7.3 Verificar programadores disponibles:

```bash
# Ver todos los programadores disponibles
avrdude -c ?

# Buscar específicamente xplainedmini
avrdude -c ? | grep -i xplain
```

---

## � TUTORIAL PASO A PASO: TU PRIMER PROYECTO ATmega328P

### 🎯 Objetivo: Crear proyecto simple_blink desde cero

**¿Qué vamos a hacer?**
- Crear un proyecto completo de ATmega328P
- Escribir código Assembly para hacer parpadear un LED
- Compilar y programar la Xplain Mini
- Configurar comando global para programación rápida

**Prerrequisitos:**
- Haber completado los PASOS 1-7 anteriores
- Xplain Mini conectada a tu Mac
- Tener VS Code instalado con las extensiones

---

### 📁 PASO 8.1: CREAR ESTRUCTURA DEL PROYECTO

```bash
# 1. Crear directorio del proyecto (puedes cambiarlo a tu ruta preferida)
mkdir -p ~/Desktop/ATmega328P_Assembly
cd ~/Desktop/ATmega328P_Assembly

# 2. Verificar que estás en el lugar correcto
pwd
# Deberías ver algo como: /Users/tuusuario/Desktop/ATmega328P_Assembly

# 3. Crear estructura de archivos
touch Makefile
touch simple_blink.asm
touch program

# 4. Verificar estructura
ls -la
# Deberías ver: Makefile  program  simple_blink.asm
```

### 📝 PASO 8.2: CREAR EL MAKEFILE

Copia este contenido exacto en tu archivo `Makefile`:

```bash
# Abrir Makefile en VS Code
code Makefile
```

**Contenido del Makefile (copiar completo):**
```makefile
# Makefile para ATmega328P en Xplain Mini con macOS
# Configuración del proyecto
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
NC = \033[0m # No Color

.PHONY: all clean program program-xplain size fuses info help

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

# 🚀 TARGETS FLEXIBLES - Programar cualquier archivo
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

# Programar usando Xplain Mini (target principal)
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
```

### 💡 PASO 8.3: CREAR EL CÓDIGO ASSEMBLY

Ahora vamos a crear el código del LED parpadeante:

```bash
# Abrir archivo Assembly en VS Code
code simple_blink.asm
```

**Contenido de simple_blink.asm (copiar completo):**
```assembly
; ===============================================
; SIMPLE BLINK LED - ATmega328P Assembly
; ===============================================
; Archivo: simple_blink.asm  
; Objetivo: Hacer parpadear LED conectado al pin PB5 (D13 en Arduino)
; Hardware: Xplain Mini ATmega328P
; Frecuencia: 16MHz (cristal externo)
; ===============================================

#include <avr/io.h>

; ===============================================
; CONFIGURACIÓN DE MEMORIA
; ===============================================
.section .text
.global main

; ===============================================
; PROGRAMA PRINCIPAL
; ===============================================
main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16
    
    ; Configurar PB5 como salida (LED)
    ldi r16, (1<<DDB5)          ; PB5 como salida
    out _SFR_IO_ADDR(DDRB), r16 ; Escribir a DDRB
    
    ; ===== BUCLE PRINCIPAL =====
loop:
    ; Encender LED (PB5 = 1)
    sbi _SFR_IO_ADDR(PORTB), PORTB5
    
    ; Delay de ~500ms
    rcall delay_500ms
    
    ; Apagar LED (PB5 = 0)  
    cbi _SFR_IO_ADDR(PORTB), PORTB5
    
    ; Delay de ~500ms
    rcall delay_500ms
    
    ; Repetir infinitamente
    rjmp loop

; ===============================================
; RUTINA DE DELAY ~500ms
; ===============================================
; Delay aproximado para 16MHz
; Formula: ciclos = frecuencia * tiempo
; Para 500ms: 16,000,000 * 0.5 = 8,000,000 ciclos

delay_500ms:
    ; Delay anidado para conseguir ~500ms
    ldi r18, 41         ; Contador externo
delay_outer:
    ldi r17, 198        ; Contador medio  
delay_middle:
    ldi r16, 200        ; Contador interno
delay_inner:
    dec r16             ; 1 ciclo
    brne delay_inner    ; 2 ciclos (cuando salta)
    
    dec r17             ; 1 ciclo
    brne delay_middle   ; 2 ciclos (cuando salta)
    
    dec r18             ; 1 ciclo  
    brne delay_outer    ; 2 ciclos (cuando salta)
    
    ret                 ; Regresar (4 ciclos)
```

### 🔧 PASO 8.4: CREAR SCRIPT DE PROGRAMACIÓN AUTOMÁTICA

Ahora vamos a crear el script `program` que nos permite programar con comandos simples:

```bash
# Abrir script en VS Code
code program
```

**Contenido del script program (copiar completo):**
```bash
#!/bin/bash

# ==================== SCRIPT DE PROGRAMACIÓN AUTOMÁTICA ====================
# Programa cualquier archivo .asm en ATmega328P con Xplain Mini
# Uso: ./program archivo.asm
#      ./program simple_blink
# ==================== CONFIGURACIÓN ====================

MCU="atmega328p"
PROGRAMMER="xplainedmini" 
PORT="usb"

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==================== FUNCIONES ====================

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

program_chip() {
    local hex_file="$1"
    
    echo -e "${YELLOW}🚀 Programando ATmega328P via Xplain Mini...${NC}"
    echo -e "${BLUE}ℹ️  Asegúrate de que la Xplain Mini esté conectada${NC}"
    
    avrdude -c "$PROGRAMMER" -p "$MCU" -P "$PORT" -U flash:w:"$hex_file":i || error_exit "Error programando el chip"
    
    echo -e "${GREEN}✅ Programación exitosa!${NC}"
}

# ==================== PROGRAMA PRINCIPAL ====================

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Falta el nombre del archivo${NC}"
    echo ""
    show_help
    exit 1
fi

# Mostrar ayuda
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Obtener nombre del archivo
FILE="$1"

# Agregar extensión .asm si no la tiene
if [[ "$FILE" != *.asm ]]; then
    FILE="${FILE}.asm"
fi

# Verificar que el archivo existe
if [ ! -f "$FILE" ]; then
    error_exit "Archivo '$FILE' no encontrado"
fi

# Compilar
echo -e "${GREEN}🎯 Procesando archivo: $FILE${NC}"

BASENAME=$(basename "$FILE" .asm)

echo -e "${YELLOW}📦 Compilando $FILE...${NC}"

# Compilar
avr-gcc -mmcu="$MCU" -I. -x assembler-with-cpp -g -c "$FILE" -o "${BASENAME}.o" || error_exit "Error en compilación"

# Enlazar  
avr-gcc -mmcu="$MCU" "${BASENAME}.o" -o "${BASENAME}.elf" || error_exit "Error en enlazado"

# Crear HEX
avr-objcopy -j .text -j .data -O ihex "${BASENAME}.elf" "${BASENAME}.hex" || error_exit "Error creando HEX"

# Mostrar tamaño
echo -e "${BLUE}📏 Tamaño del programa:${NC}"
avr-size --format=avr --mcu="$MCU" "${BASENAME}.elf"

echo -e "${GREEN}✅ Compilación exitosa: ${BASENAME}.hex${NC}"

# Programar
program_chip "${BASENAME}.hex"

echo -e "${GREEN}🎉 ¡Proceso completado exitosamente!${NC}"
echo -e "${BLUE}💡 Tu código está ahora ejecutándose en el ATmega328P${NC}"
```

### ⚙️ PASO 8.5: HACER EJECUTABLE EL SCRIPT

```bash
# Dar permisos de ejecución al script
chmod +x program

# Verificar permisos
ls -la program
# Deberías ver: -rwxr-xr-x ... program
```

---

## ✅ PASO 9: PRIMERA PRUEBA - ¡COMPILAR Y PROGRAMAR!

### 🚀 PASO 9.1: VERIFICAR CONEXIÓN HARDWARE

```bash
# 1. Conectar tu Xplain Mini al Mac vía USB
# 2. Verificar que se detecta
system_profiler SPUSBDataType | grep -i "edbg\|xplain"

# 3. Test de comunicación
avrdude -c xplainedmini -p atmega328p -P usb -v
```

**✅ Si ves algo como:**
```
avrdude: Version 7.x
...
Device signature = 0x1e950f (probably m328p)
avrdude done. Thank you.
```
**¡Estás listo!**

### 🚀 PASO 9.2: PRIMERA COMPILACIÓN Y PROGRAMACIÓN

```bash
# Opción 1: Usar el script program (MÁS FÁCIL)
./program simple_blink

# Opción 2: Usar Makefile
make program-xplain-simple_blink

# Opción 3: Paso a paso manual
make compile-simple_blink
make program-xplain-simple_blink
```

**✅ Si todo sale bien deberías ver:**
```
🎯 Procesando archivo: simple_blink.asm
📦 Compilando simple_blink.asm...
📏 Tamaño del programa:
AVR Memory Usage
----------------
Device: atmega328p

Program:     174 bytes (0.5% Full)
(.text + .data + .bootloader)

✅ Compilación exitosa: simple_blink.hex
🚀 Programando ATmega328P via Xplain Mini...
Writing | ################################################## | 100%
✅ Programación exitosa!
🎉 ¡Proceso completado exitosamente!
```

**🔍 ¿Qué verificar?**
- El LED en la Xplain Mini debe estar parpadeando
- Cada parpadeo debe durar aproximadamente 500ms
- El programa debe ocupar ~174 bytes

---

## ⚡ PASO 10: CONFIGURAR COMANDO GLOBAL

Para poder usar `program simple_blink` desde cualquier lugar:

### 🔧 PASO 10.1: AGREGAR ALIAS AL SHELL

```bash
# Agregar alias a tu .zshrc
echo "# ATmega328P Programming Command" >> ~/.zshrc
echo "alias program='$(pwd)/program'" >> ~/.zshrc

# Aplicar cambios (para sesión actual)
alias program='$(pwd)/program'

# Verificar que funciona
program simple_blink
```

### 🔧 PASO 10.2: ALTERNATIVA - COPIA GLOBAL

```bash
# Copiar a directorio del sistema (alternativa)
sudo cp program /usr/local/bin/program
sudo chmod +x /usr/local/bin/program
```

---

## 🎯 VERIFICACIÓN FINAL COMPLETA

### ✅ CHECKLIST DE VERIFICACIÓN

- [ ] **Homebrew instalado**: `brew --version`
- [ ] **Toolchain AVR**: `avr-gcc --version` y `avrdude -?`
- [ ] **VS Code con extensiones**: Al menos C/C++ y Assembly
- [ ] **Xplain Mini detectada**: `system_profiler SPUSBDataType | grep EDBG`
- [ ] **Comunicación funciona**: `avrdude -c xplainedmini -p atmega328p -P usb -v`
- [ ] **Proyecto compilado**: Archivos .hex creados
- [ ] **LED parpadeando**: Verificación visual en hardware
- [ ] **Comando global**: `program simple_blink` funciona

### 🔧 COMANDOS DE PRUEBA FINAL

```bash
# Test completo desde cero
cd ~/Desktop/ATmega328P_Assembly
make clean                    # Limpiar archivos
program simple_blink         # Compilar y programar
ls -la *.hex                 # Verificar archivos generados
```

**🎉 ¡FELICIDADES!**
Si llegaste hasta aquí, tienes un entorno completo de desarrollo para ATmega328P en Mac que funciona mejor que Microchip Studio.

---

## �🚀 PASO 8: WORKFLOW DE DESARROLLO

### 8.1 Comandos de VS Code:

- **Compilar**: `Cmd + Shift + P` → "Tasks: Run Task" → "Build ASM"
- **Programar**: `Cmd + Shift + P` → "Tasks: Run Task" → "Program ATmega328P"
- **Monitor Serie**: `Cmd + Shift + P` → "Tasks: Run Task" → "Serial Monitor"

### 8.2 Atajos de teclado útiles:

Agregar a tu `keybindings.json`:

```json
[
    {
        "key": "cmd+f5",
        "command": "workbench.action.tasks.runTask",
        "args": "Build ASM"
    },
    {
        "key": "cmd+shift+f5",
        "command": "workbench.action.tasks.runTask",
        "args": "Program ATmega328P (Xplain Mini)"
    }
]
```

---

## 🔧 PASO 12: TROUBLESHOOTING COMÚN

### Problema: "Device not found"
```bash
# Verificar conexión USB
system_profiler SPUSBDataType | grep -A 10 Atmel

# Verificar permisos
ls -la /dev/cu.usbmodem*

# Solución: Reconectar el dispositivo y probar de nuevo
```

### Problema: "Permission denied"
```bash
# Agregar permisos de dialout (equivalente en Mac)
sudo dseditgroup -o edit -a $(whoami) -t user _developer

# Reiniciar terminal o sesión
```

### Problema: avrdude no encuentra el programador
```bash
# Verificar que EDBG esté disponible
avrdude -c ?

# Debería listar xplainedmini como opción disponible
```

### Problema: Compilación falla
```bash
# Verificar sintaxis Assembly
# Asegúrate de usar formato compatible con avr-gcc:
# - Usar #include <avr/io.h>
# - Usar _SFR_IO_ADDR() para acceso a registros
# - Usar .section .text y .global main
```

### Problema: LED no parpadea
```bash
# Verificar conexiones hardware
# En Xplain Mini, el LED está conectado al pin PB5
# Verificar el código Assembly para PB5/PORTB5
```

---

## 📚 PASO 13: RECURSOS ADICIONALES

### 13.1 Documentación útil:
- **ATmega328P Datasheet**: [Microchip oficial](https://www.microchip.com/wwwproducts/en/ATmega328P)
- **AVR Assembly Tutorial**: [AVR Freaks](https://www.avrfreaks.net/)
- **Xplain Mini User Guide**: [Microchip](https://www.microchip.com/developmenttools/)

### 13.2 Comandos de referencia rápida:

```bash
# Compilar y programar en un comando
program simple_blink         # Método más fácil
make program-xplain-simple_blink # Alternativa con Makefile

# Limpiar y rebuild completo  
make clean && make all

# Monitor serie rápido
screen /dev/cu.usbmodem* 9600

# Verificar herramientas
which avr-gcc avrdude

# Ver información del chip
avrdude -c xplainedmini -p atmega328p -P usb -v
```

---

## 🎯 EQUIVALENCIAS CON MICROCHIP STUDIO

| **Microchip Studio** | **VS Code + Mac Setup** |
|---------------------|-------------------------|
| Build (F7) | `program archivo.asm` |
| Start Debugging (F5) | `program archivo` |
| Device Programming | `avrdude` integrado |
| Solution Explorer | VS Code Explorer |
| Output Window | Terminal Integrado |
| Project Templates | Makefile + script program |
| Simulator | AVR Simulator (separado) |
| IntelliSense | Extensión C/C++ |

---

## 🚀 PASO 14: CONFIGURACIÓN DEL COMANDO GLOBAL `program`

### 14.1 ¿Qué acabamos de configurar?

En el tutorial paso a paso ya configuramos:
- ✅ Script `program` ejecutable
- ✅ Alias en `~/.zshrc` 
- ✅ Funcionalidad `program archivo.asm` y `program archivo`

### 14.2 Verificar configuración actual:

```bash
# Verificar que el alias existe
grep "alias program" ~/.zshrc

# Probar el comando
program simple_blink

# Ver ayuda
program --help
```

### 14.3 Opciones adicionales (si necesitas):

#### Opción A: Copia global al sistema
```bash
sudo cp program /usr/local/bin/program
sudo chmod +x /usr/local/bin/program
```

#### Opción B: Función avanzada en shell
Agregar a `~/.zshrc`:
```bash
# Función avanzada para programar ATmega328P
program_advanced() {
    local current_dir=$(pwd)
    local project_dir="/Users/$(whoami)/Desktop/ATmega328P_Assembly"
    
    if [ $# -eq 0 ]; then
        echo "❌ Error: Especifica el archivo a programar"
        return 1
    fi
    
    local file="$1"
    [[ "$file" != *.asm ]] && file="${file}.asm"
    
    if [ -f "$file" ]; then
        "$project_dir/program" "$file"
    elif [ -f "$project_dir/$file" ]; then
        cd "$project_dir" && ./program "$file" && cd "$current_dir"
    else
        echo "❌ Archivo '$file' no encontrado"
        return 1
    fi
}
```

---

## 🎯 COMANDOS DE REFERENCIA RÁPIDA FINALES

### 📋 Tu arsenal de comandos:

```bash
# === PROGRAMACIÓN RÁPIDA ===
program simple_blink.asm    # Compilar y programar (con extensión)
program simple_blink        # Compilar y programar (sin extensión)
program --help              # Ver ayuda del script

# === MAKEFILE TRADICIONAL ===
make program-xplain-simple_blink  # Programar archivo específico
make compile-simple_blink         # Solo compilar
make clean                        # Limpiar archivos

# === COMANDOS MANUALES ===
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c file.asm -o file.o
avr-gcc -mmcu=atmega328p file.o -o file.elf  
avr-objcopy -O ihex file.elf file.hex
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:file.hex:i

# === DEBUGGING Y VERIFICACIÓN ===
avrdude -c xplainedmini -p atmega328p -P usb -v  # Info del chip
system_profiler SPUSBDataType | grep EDBG       # Verificar conexión
screen /dev/cu.usbmodem* 9600                   # Monitor serie
```

### 🏆 **¡WORKFLOW FINAL OPTIMIZADO!**

```bash
# El flujo de trabajo más eficiente:
cd ~/Desktop/ATmega328P_Assembly   # Ir al proyecto
code mi_programa.asm              # Escribir código en VS Code  
program mi_programa               # Compilar y programar
# ¡Y listo! 🚀
```

---

¡Listo! Ahora tienes un entorno completo de desarrollo para ATmega328P en macOS que reemplaza completamente a Microchip Studio. 🚀

---

## 🏆 RESUMEN FINAL: ¡LO QUE HAS LOGRADO!

### ✅ **Entorno completo configurado:**
- **Homebrew** + **AVR Toolchain** instalados y funcionando
- **VS Code** optimizado con todas las extensiones necesarias
- **Xplain Mini** detectada y configurada correctamente
- **avrdude** con programador `xplainedmini` funcional

### 🛠️ **Herramientas de desarrollo:**
- **Makefile inteligente** con targets flexibles
- **Script `program`** para programación rápida de un comando
- **Alias global** configurado en tu shell
- **Sintaxis Assembly** compatible con avr-gcc

### 🚀 **Capacidades logradas:**
- ✅ Compilar código Assembly para ATmega328P
- ✅ Programar Xplain Mini con un solo comando
- ✅ Usar `program archivo.asm` desde cualquier directorio
- ✅ Debugging visual con LED parpadeante funcionando
- ✅ Workflow más rápido que Microchip Studio

### 🎯 **Tu workflow optimizado:**
```bash
# El ciclo de desarrollo más eficiente:
code mi_programa.asm      # 1. Escribir código
program mi_programa       # 2. Compilar y programar
# 3. ¡Ver resultado en hardware!
```

### 📊 **Mejoras vs Microchip Studio:**
| Característica | Microchip Studio | Tu setup en Mac |
|---|---|---|
| **Velocidad compilación** | Media | ⚡ Muy rápida |
| **Programación** | Varios clicks | 🚀 Un comando |
| **Flexibilidad** | Limitada | 🎯 Total |
| **Costo** | Solo Windows | 💚 Gratis + Mac |
| **Personalización** | Básica | 🔧 Completa |

### 🎓 **Para estudiantes de Ingeniería Informática:**

**Has aprendido:**
- Configuración avanzada de toolchains en macOS
- Uso de Makefile para automatización
- Scripting en bash para desarrollo
- Configuración de VS Code para microcontroladores
- Integración de herramientas de línea de comandos

**Ventajas académicas:**
- Entorno profesional de desarrollo
- Transferible a otros microcontroladores AVR
- Base sólida para proyectos más complejos
- Experiencia con herramientas de código abierto

### 💡 **Próximos pasos sugeridos:**
1. **Crear más proyectos** de ejemplo (botones, sensores, comunicación serie)
2. **Explorar debugging** con GDB para AVR
3. **Integrar con Git** para control de versiones
4. **Aprender interrupciones** y timers en Assembly
5. **Experimentar con librerías** AVR en C

### 🏁 **¡FELICIDADES!**
Has superado las limitaciones de Microchip Studio y creado un entorno de desarrollo profesional en macOS. Ahora puedes desarrollar para ATmega328P con la velocidad y flexibilidad de las herramientas modernas.

**¡Tu ATmega328P está listo para cualquier desafío!** 🚀
