# Comandos útiles para desarrollo en Assembly ATmega328P

## 🔧 Instalación de herramientas

### macOS con Homebrew:
```bash
# Instalar toolchain AVR
brew tap osx-cross/avr
brew install avr-gcc avrdude

# Verificar instalación
avr-gcc --version
avrdude -?
```

### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install gcc-avr binutils-avr avr-libc avrdude
```

### Windows:
1. Descargar WinAVR o AVR Studio
2. O usar Arduino IDE con herramientas incluidas

## 💾 Comandos de compilación

```bash
# Compilar archivo assembly
avr-as -mmcu=atmega328p -o main.o main.asm

# Enlazar
avr-ld -mmcu=atmega328p -o main.elf main.o

# Crear archivo HEX
avr-objcopy -j .text -j .data -O ihex main.elf main.hex

# Ver tamaño del programa
avr-size --format=avr --mcu=atmega328p main.elf

# Crear listado desensamblado
avr-objdump -h -S main.elf > main.lst
```

## 📡 Programación del microcontrolador

```bash
# Con Arduino Uno como programador (bootloader)
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -b 57600 -U flash:w:main.hex

# Con ISP programador
avrdude -c usbasp -p atmega328p -U flash:w:main.hex

# Leer fusibles actuales
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h

# Configurar fusibles para 16MHz externo
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -U lfuse:w:0xFF:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m
```

## 🔍 Debugging y análisis

```bash
# Ver contenido del archivo HEX
hexdump -C main.hex

# Simular con simulavr (si está instalado)
simulavr -d atmega328p -f main.elf

# Usar gdb para debugging (con simulador)
avr-gdb main.elf
```

## 📊 Información del microcontrolador

```bash
# Ver información detallada del ATmega328P
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -v

# Leer signature del chip
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -U signature:r:-:h

# Verificar programación
avrdude -c arduino -p atmega328p -P /dev/tty.usbserial* -U flash:v:main.hex
```

## 🛠️ Comandos del Makefile

```bash
# Compilar todo
make all

# Solo compilar sin programar
make

# Programar el microcontrolador
make program

# Ver tamaño del programa
make size

# Leer fusibles
make fuses

# Configurar fusibles
make set-fuses

# Limpiar archivos generados
make clean

# Ver ayuda
make help
```

## 📱 Monitor serie

```bash
# macOS/Linux con screen
screen /dev/tty.usbserial* 9600

# macOS/Linux con minicom
minicom -D /dev/tty.usbserial* -b 9600

# Salir de screen: Ctrl+A, luego K, luego Y

# Ver puertos serie disponibles (macOS)
ls /dev/tty.usb*

# Ver puertos serie disponibles (Linux)
ls /dev/ttyUSB* /dev/ttyACM*
```

## 🎯 Configuraciones útiles

### Fusibles para diferentes frecuencias:

```bash
# 16MHz cristal externo
-U lfuse:w:0xFF:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m

# 8MHz interno
-U lfuse:w:0xE2:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m

# 1MHz interno (por defecto)
-U lfuse:w:0x62:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m
```

### Cálculo de UART BAUD rate:
```
UBRR = (F_CPU / (16 * BAUD)) - 1

Para 16MHz y 9600 baud:
UBRR = (16000000 / (16 * 9600)) - 1 = 103 (0x67)
```

## 🚨 Troubleshooting común

```bash
# Si no encuentra el puerto serie
ls /dev/tty.*

# Si avrdude da error de sincronización
# 1. Verificar conexiones
# 2. Presionar reset justo antes de programar
# 3. Probar diferente velocidad: -b 115200 o -b 19200

# Si el programa no arranca
# Verificar fusibles (especialmente CKSEL para frecuencia del clock)

# Para resetear completamente los fusibles (CUIDADO!)
# Solo usar si el micro está "bricked"
avrdude -c usbasp -p atmega328p -U lfuse:w:0x62:m -U hfuse:w:0xD9:m -U efuse:w:0xFF:m
```
