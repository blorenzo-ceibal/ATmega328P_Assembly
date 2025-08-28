# 📋 Comandos de Referencia - Cheatsheet

> **🎯 Objetivo:** Referencia rápida de todos los comandos importantes
> **📋 Uso:** Para consulta rápida durante el desarrollo

## ⚡ **Comandos Esenciales**

### 🚀 **Tu Comando Favorito (TODO EN UNO):**
```bash
./program archivo.asm    # Compila y programa automáticamente
./program archivo        # Sin extensión también funciona
./program --help         # Ver ayuda completa
```

---

## 🛠️ **Comandos de Compilación**

### 🔧 **Con Script Program (Método Fácil):**
```bash
./program simple_blink          # Compilar y programar simple_blink.asm
./program button_test.asm       # Con extensión también funciona
./program mi_proyecto           # Tu proyecto personalizado
```

### 🔧 **Con Makefile (Método Intermedio):**
```bash
# Compilar todo
make all

# Programar archivo específico
make program-xplain-simple_blink
make program-xplain-button_test
make program-xplain-mi_proyecto

# Solo compilar (sin programar)
make compile-simple_blink
make compile-button_test

# Ver tamaño del programa
make size

# Limpiar archivos temporales
make clean

# Ver ayuda del Makefile
make help
```

### 🔧 **Manual Paso a Paso (Método Avanzado):**
```bash
# 1. Compilar Assembly a objeto
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c archivo.asm -o archivo.o

# 2. Enlazar a ejecutable
avr-gcc -mmcu=atmega328p archivo.o -o archivo.elf

# 3. Crear archivo HEX
avr-objcopy -O ihex archivo.elf archivo.hex

# 4. Ver tamaño
avr-size --format=avr --mcu=atmega328p archivo.elf

# 5. Programar
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:archivo.hex:i
```

---

## 🔌 **Comandos de Hardware**

### 🔍 **Verificar Conexión:**
```bash
# Detectar Xplain Mini por USB
system_profiler SPUSBDataType | grep -i "microchip\|atmel\|edbg"

# Ver puertos serie disponibles
ls /dev/cu.*

# Test básico de comunicación
avrdude -c xplainedmini -p atmega328p -P usb -v
```

### 📡 **Información del Microcontrolador:**
```bash
# Información completa del chip
avrdude -c xplainedmini -p atmega328p -P usb -v

# Leer fusibles
avrdude -c xplainedmini -p atmega328p -P usb -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h

# Leer toda la flash (backup)
avrdude -c xplainedmini -p atmega328p -P usb -U flash:r:backup.hex:i

# Verificar programación
avrdude -c xplainedmini -p atmega328p -P usb -U flash:v:programa.hex:i
```

### 🔧 **Programadores y Microcontroladores Disponibles:**
```bash
# Ver programadores soportados
avrdude -c ?

# Ver microcontroladores soportados
avrdude -p ?

# Buscar programador específico
avrdude -c ? | grep -i xplain

# Buscar microcontrolador específico
avrdude -p ? | grep -i atmega328
```

---

## 📡 **Comunicación Serie**

### 🔧 **Monitor Serie:**
```bash
# Con screen (método preferido)
screen /dev/cu.usbmodem* 9600
# Salir: Ctrl+A, luego K, luego Y

# Con minicom
minicom -D /dev/cu.usbmodem* -b 9600 -o

# Detectar puerto automáticamente
make monitor    # Si tienes el Makefile configurado
```

### 📊 **Velocidades de Baud Comunes:**
```bash
screen /dev/cu.usbmodem* 9600      # Estándar
screen /dev/cu.usbmodem* 115200    # Rápido
screen /dev/cu.usbmodem* 38400     # Intermedio
screen /dev/cu.usbmodem* 57600     # Alternativo
```

---

## 🧹 **Comandos de Limpieza**

### 🗑️ **Limpiar Archivos Generados:**
```bash
# Con Makefile
make clean

# Manual básico
rm -f *.o *.elf *.hex *.lst

# Limpieza profunda (incluye backups)
rm -f *.o *.elf *.hex *.lst *~ .*.swp

# Limpiar solo archivos específicos
rm -f simple_blink.o simple_blink.elf simple_blink.hex
```

### 🔄 **Rebuild Completo:**
```bash
# Con script
make clean && ./program archivo

# Con Makefile
make clean && make all

# Manual completo
rm -f *.o *.elf *.hex && avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c archivo.asm -o archivo.o
```

---

## 🔧 **Comandos de Instalación y Mantenimiento**

### 📦 **Instalar/Actualizar Herramientas:**
```bash
# Instalar toolchain completo
brew tap osx-cross/avr
brew install avr-gcc avrdude

# Actualizar herramientas
brew update
brew upgrade avr-gcc avrdude

# Instalar herramientas adicionales
brew install minicom screen

# Verificar versiones
avr-gcc --version
avrdude -?
brew --version
```

### 🔍 **Verificar Instalación:**
```bash
# Verificar que herramientas están en PATH
which avr-gcc
which avrdude
which avr-objcopy
which avr-size

# Verificar versiones
avr-gcc --version
avrdude -? | head -1
screen -version

# Test rápido de compilación
echo 'main: rjmp main' > test.asm && avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c test.asm && echo "✅ OK" || echo "❌ Error"
rm -f test.*
```

---

## 🎯 **Comandos por Microcontrolador**

### 🔧 **ATmega328P (Arduino Uno, Xplain Mini):**
```bash
# Compilar
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c archivo.asm -o archivo.o

# Programar con Xplain Mini
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:archivo.hex:i

# Programar con Arduino
avrdude -c arduino -p atmega328p -P /dev/cu.usbmodem* -b 115200 -U flash:w:archivo.hex:i
```

### 🔧 **ATmega168 (Arduino Mini Pro):**
```bash
# Compilar
avr-gcc -mmcu=atmega168 -x assembler-with-cpp -c archivo.asm -o archivo.o

# Programar
avrdude -c arduino -p atmega168 -P /dev/cu.usbserial* -b 19200 -U flash:w:archivo.hex:i
```

### 🔧 **ATmega32u4 (Arduino Leonardo):**
```bash
# Compilar
avr-gcc -mmcu=atmega32u4 -x assembler-with-cpp -c archivo.asm -o archivo.o

# Programar
avrdude -c avr109 -p atmega32u4 -P /dev/cu.usbmodem* -U flash:w:archivo.hex:i
```

---

## 📊 **Comandos de Análisis**

### 🔍 **Análisis de Código:**
```bash
# Ver código desensamblado
avr-objdump -d archivo.elf

# Ver código con fuente intercalado
avr-objdump -S archivo.elf

# Ver headers y secciones
avr-objdump -h archivo.elf

# Crear listado completo
avr-objdump -h -S archivo.elf > archivo.lst
```

### 📏 **Análisis de Memoria:**
```bash
# Tamaño básico
avr-size archivo.elf

# Tamaño formato AVR
avr-size --format=avr --mcu=atmega328p archivo.elf

# Detalles de secciones
avr-size -A archivo.elf

# Comparar tamaños de múltiples archivos
avr-size *.elf
```

### 🔧 **Análisis de Símbolos:**
```bash
# Ver símbolos del programa
avr-nm archivo.elf

# Solo símbolos definidos
avr-nm -D archivo.elf

# Símbolos ordenados por dirección
avr-nm -n archivo.elf
```

---

## 🚀 **Comandos de VS Code**

### 💻 **Abrir Proyectos:**
```bash
# Abrir VS Code en directorio actual
code .

# Abrir archivo específico
code simple_blink.asm

# Abrir proyecto completo
code ~/Desktop/ATmega328P_Assembly
```

### 🔧 **Comandos Internos de VS Code:**
```bash
# Instalar extensiones desde terminal
code --install-extension ms-vscode.cpptools
code --install-extension 13xforever.language-x86-64-assembly
code --install-extension rockcat.avr-support

# Ver extensiones instaladas
code --list-extensions

# Ver extensiones con versiones
code --list-extensions --show-versions
```

---

## 🎯 **Comandos de Desarrollo Rápido**

### ⚡ **Workflow Típico:**
```bash
# 1. Crear proyecto
mkdir mi_proyecto && cd mi_proyecto
cp ~/path/to/Makefile .
cp ~/path/to/program .

# 2. Crear código
code mi_programa.asm

# 3. Compilar y programar
./program mi_programa

# 4. Ver resultado (si usa comunicación serie)
screen /dev/cu.usbmodem* 9600

# 5. Limpiar
make clean
```

### 🔄 **Testing Rápido:**
```bash
# Test de conectividad
avrdude -c xplainedmini -p atmega328p -P usb

# Test de compilación
echo '.section .text\n.global main\nmain: rjmp main' > test.asm && ./program test && rm test.*

# Test de comunicación serie
echo "Hello" > /dev/cu.usbmodem* # (solo si hay programa escuchando)
```

---

## 📱 **Comandos de Git (Control de Versiones)**

### 🔧 **Setup Inicial:**
```bash
# Inicializar repositorio
git init

# Crear .gitignore para microcontroladores
echo "*.o\n*.elf\n*.hex\n*.lst\n.DS_Store" > .gitignore

# Primera confirmación
git add .
git commit -m "Primer commit: proyecto ATmega328P"
```

### 🚀 **Workflow Diario:**
```bash
# Ver estado
git status

# Agregar archivos modificados
git add *.asm Makefile

# Confirmar cambios
git commit -m "LED parpadeante funcionando"

# Ver historial
git log --oneline
```

---

## 🏆 **Comandos de Una Línea Útiles**

```bash
# Compilar y programar en una línea
./program archivo || echo "❌ Falló"

# Ver tamaño de todos los programas
for f in *.hex; do echo "=== $f ===" && avr-size --format=avr --mcu=atmega328p "${f%.hex}.elf"; done

# Backup rápido
tar -czf "backup_$(date +%Y%m%d).tar.gz" *.asm *.h Makefile program

# Limpiar y rebuild
make clean && make all

# Verificar herramientas instaladas
for tool in avr-gcc avrdude avr-objcopy screen; do which $tool >/dev/null && echo "✅ $tool" || echo "❌ $tool"; done

# Buscar archivos Assembly
find . -name "*.asm" -type f

# Ver logs de errores de compilación
./program archivo 2>&1 | grep -i error

# Contar líneas de código
wc -l *.asm

# Buscar texto en archivos Assembly
grep -n "main:" *.asm
```

---

**🏠 Regresar:** **[README.md](../README.md)**
**📚 Otros anexos:** **[anexos/](./)**
