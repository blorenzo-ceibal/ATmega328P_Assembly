# Makefile optimizado para ATmega328P en Xplain Mini con macOS
# Reemplazo completo de Microchip Studio para Mac

# ==================== CONFIGURACIÓN DEL PROYECTO ====================
MCU = atmega328p
F_CPU = 16000000UL
TARGET = simple_blink

# ==================== HERRAMIENTAS ====================
CC = avr-gcc
AS = avr-as
LD = avr-ld
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
AVRDUDE = avrdude

# ==================== CONFIGURACIÓN XPLAIN MINI ====================
# La Xplain Mini usa el programador EDBG integrado
XPLAIN_PROGRAMMER = xplainedmini
XPLAIN_PORT = usb
XPLAIN_FLAGS = -c $(XPLAIN_PROGRAMMER) -p $(MCU) -P $(XPLAIN_PORT) -v

# ==================== CONFIGURACIÓN ALTERNATIVA ARDUINO ====================
ARDUINO_PROGRAMMER = arduino
ARDUINO_BAUD = 115200
# El puerto se detecta automáticamente
ARDUINO_FLAGS = -c $(ARDUINO_PROGRAMMER) -p $(MCU) -b $(ARDUINO_BAUD) -v

# ==================== FLAGS DE COMPILACIÓN ====================
ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp -g
LDFLAGS = -mmcu=$(MCU)

# ==================== ARCHIVOS ====================
# Carpetas del proyecto
SRC_DIR = src
BUILD_DIR = build

ASM_SOURCES = $(SRC_DIR)/$(TARGET).asm
OBJECTS = $(BUILD_DIR)/$(TARGET).o
ELF = $(BUILD_DIR)/$(TARGET).elf
HEX = $(BUILD_DIR)/$(TARGET).hex
LST = $(BUILD_DIR)/$(TARGET).lst

# ==================== COLORES PARA TERMINAL ====================
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

# ==================== TARGETS PRINCIPALES ====================
.PHONY: all clean program-xplain program-arduino size fuses info help monitor install-deps

# Target por defecto
all: $(HEX) $(LST) size

# Crear carpeta build si no existe
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# ==================== COMPILACIÓN ====================
# Compilar archivo assembly desde src/
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | $(BUILD_DIR)
	@echo "$(YELLOW)📦 Compilando $<...$(NC)"
	$(CC) $(ASFLAGS) -I$(SRC_DIR) -c $< -o $@

# Crear archivo ELF
$(ELF): $(OBJECTS) | $(BUILD_DIR)
	@echo "$(YELLOW)🔗 Enlazando...$(NC)"
	$(CC) $(LDFLAGS) $^ -o $@

# Crear archivo HEX
$(HEX): $(ELF)
	@echo "$(YELLOW)⚡ Creando archivo HEX...$(NC)"
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
	@echo "$(GREEN)✅ Compilación exitosa!$(NC)"

# Crear listado desensamblado
$(LST): $(ELF)
	@echo "$(YELLOW)📄 Creando listado...$(NC)"
	$(OBJDUMP) -h -S $< > $@

# ==================== INFORMACIÓN DEL PROGRAMA ====================
size: $(ELF)
	@echo "$(BLUE)📏 Tamaño del programa:$(NC)"
	@$(SIZE) --format=avr --mcu=$(MCU) $<
	@echo ""

# ==================== PROGRAMACIÓN ====================
# Programar usando Xplain Mini (método principal)
program-xplain: $(HEX)
	@echo "$(YELLOW)🚀 Programando ATmega328P via Xplain Mini...$(NC)"
	@echo "$(BLUE)ℹ️  Asegúrate de que la Xplain Mini esté conectada$(NC)"
	$(AVRDUDE) $(XPLAIN_FLAGS) -U flash:w:$<:i
	@echo "$(GREEN)✅ Programación via Xplain Mini exitosa!$(NC)"

# Programar usando bootloader Arduino (método alternativo)
program-arduino: $(HEX)
	@echo "$(YELLOW)🔍 Buscando puerto Arduino...$(NC)"
	@ARDUINO_PORT=$$(ls /dev/cu.usbmodem* /dev/cu.usbserial* 2>/dev/null | head -1); \
	if [ -z "$$ARDUINO_PORT" ]; then \
		echo "$(RED)❌ No se encontró puerto Arduino$(NC)"; \
		echo "$(YELLOW)💡 Conecta tu Arduino/dispositivo serie$(NC)"; \
		exit 1; \
	fi; \
	echo "$(BLUE)📡 Programando via $$ARDUINO_PORT...$(NC)"; \
	$(AVRDUDE) $(ARDUINO_FLAGS) -P $$ARDUINO_PORT -U flash:w:$<:i
	@echo "$(GREEN)✅ Programación via Arduino exitosa!$(NC)"

# Target genérico (intenta Xplain primero, luego Arduino)
program: program-xplain
	@echo "$(GREEN)✅ Programación completada$(NC)"

# ==================== COMANDOS FLEXIBLES ====================
# Programar cualquier archivo con Xplain Mini: make program-xplain [archivo]
# Uso: make program-xplain main.asm
#      make program-xplain simple_blink.asm
program-xplain-%:
	@echo "$(YELLOW)🚀 Compilando y programando $*.asm via Xplain Mini...$(NC)"
	@if [ ! -f "$*.asm" ]; then \
		echo "$(RED)❌ Archivo $*.asm no encontrado$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)📦 Compilando $*.asm...$(NC)"
	$(CC) $(ASFLAGS) -c $*.asm -o $*.o
	$(CC) $(LDFLAGS) $*.o -o $*.elf
	$(OBJCOPY) -j .text -j .data -O ihex $*.elf $*.hex
	@echo "$(BLUE)🚀 Programando $*.hex via Xplain Mini...$(NC)"
	$(AVRDUDE) $(XPLAIN_FLAGS) -U flash:w:$*.hex:i
	@echo "$(GREEN)✅ $*.asm programado exitosamente!$(NC)"

# Programar cualquier archivo con Arduino: make program-arduino [archivo]
# Uso: make program-arduino main.asm
#      make program-arduino simple_blink.asm
program-arduino-%:
	@echo "$(YELLOW)🚀 Compilando y programando $*.asm via Arduino...$(NC)"
	@if [ ! -f "$*.asm" ]; then \
		echo "$(RED)❌ Archivo $*.asm no encontrado$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)📦 Compilando $*.asm...$(NC)"
	$(CC) $(ASFLAGS) -c $*.asm -o $*.o
	$(CC) $(LDFLAGS) $*.o -o $*.elf
	$(OBJCOPY) -j .text -j .data -O ihex $*.elf $*.hex
	@echo "$(YELLOW)🔍 Buscando puerto Arduino...$(NC)"
	@ARDUINO_PORT=$$(ls /dev/cu.usbmodem* /dev/cu.usbserial* 2>/dev/null | head -1); \
	if [ -z "$$ARDUINO_PORT" ]; then \
		echo "$(RED)❌ No se encontró puerto Arduino$(NC)"; \
		exit 1; \
	fi; \
	echo "$(BLUE)📡 Programando $*.hex via $$ARDUINO_PORT...$(NC)"; \
	$(AVRDUDE) $(ARDUINO_FLAGS) -P $$ARDUINO_PORT -U flash:w:$*.hex:i
	@echo "$(GREEN)✅ $*.asm programado exitosamente!$(NC)"

# Compilar cualquier archivo sin programar: make compile [archivo]
# Uso: make compile main.asm
#      make compile simple_blink.asm
compile-%:
	@echo "$(YELLOW)📦 Compilando $*.asm...$(NC)"
	@if [ ! -f "$*.asm" ]; then \
		echo "$(RED)❌ Archivo $*.asm no encontrado$(NC)"; \
		exit 1; \
	fi
	$(CC) $(ASFLAGS) -c $*.asm -o $*.o
	$(CC) $(LDFLAGS) $*.o -o $*.elf
	$(OBJCOPY) -j .text -j .data -O ihex $*.elf $*.hex
	$(OBJDUMP) -h -S $*.elf > $*.lst
	@echo "$(GREEN)✅ $*.asm compilado exitosamente!$(NC)"
	@echo "$(BLUE)📏 Tamaño del programa:$(NC)"
	@$(SIZE) --format=avr --mcu=$(MCU) $*.elf

# ==================== CONFIGURACIÓN DE FUSIBLES ====================
# Leer fusibles actuales
fuses:
	@echo "$(YELLOW)🔧 Leyendo fusibles actuales...$(NC)"
	$(AVRDUDE) $(XPLAIN_FLAGS) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h

# Configurar fusibles para 16MHz cristal externo
set-fuses-16mhz:
	@echo "$(YELLOW)⚡ Configurando fusibles para 16MHz cristal externo...$(NC)"
	@echo "$(RED)⚠️  CUIDADO: Esto puede hacer el micro inutilizable si no tienes cristal$(NC)"
	@read -p "¿Estás seguro? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		$(AVRDUDE) $(XPLAIN_FLAGS) -U lfuse:w:0xFF:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m; \
		echo "$(GREEN)✅ Fusibles configurados para 16MHz$(NC)"; \
	else \
		echo "$(YELLOW)❌ Operación cancelada$(NC)"; \
	fi

# Configurar fusibles para 8MHz interno (más seguro)
set-fuses-8mhz:
	@echo "$(YELLOW)⚡ Configurando fusibles para 8MHz interno...$(NC)"
	$(AVRDUDE) $(XPLAIN_FLAGS) -U lfuse:w:0xE2:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m
	@echo "$(GREEN)✅ Fusibles configurados para 8MHz interno$(NC)"

# ==================== INFORMACIÓN Y DIAGNÓSTICO ====================
# Información del microcontrolador
info:
	@echo "$(YELLOW)📋 Información del microcontrolador:$(NC)"
	$(AVRDUDE) $(XPLAIN_FLAGS) -v 2>&1 | grep -A 20 "Device signature"

# Verificar conexión con Xplain Mini
test-xplain:
	@echo "$(YELLOW)🔍 Verificando conexión con Xplain Mini...$(NC)"
	@if system_profiler SPUSBDataType | grep -q "EDBG\|Xplain"; then \
		echo "$(GREEN)✅ Xplain Mini detectada$(NC)"; \
		$(AVRDUDE) $(XPLAIN_FLAGS) -n; \
	else \
		echo "$(RED)❌ Xplain Mini no detectada$(NC)"; \
		echo "$(YELLOW)💡 Verifica la conexión USB$(NC)"; \
	fi

# Verificar puertos serie disponibles
list-ports:
	@echo "$(YELLOW)📡 Puertos serie disponibles:$(NC)"
	@ls -la /dev/cu.* 2>/dev/null || echo "$(RED)❌ No se encontraron puertos$(NC)"
	@echo ""
	@echo "$(YELLOW)📋 Dispositivos USB:$(NC)"
	@system_profiler SPUSBDataType | grep -A 5 -B 2 "EDBG\|Arduino\|CP210\|FTDI" || echo "$(BLUE)ℹ️  No se encontraron dispositivos conocidos$(NC)"

# ==================== MONITOR SERIE ====================
# Abrir monitor serie
monitor:
	@echo "$(YELLOW)🔍 Buscando puerto serie...$(NC)"
	@PORT=$$(ls /dev/cu.usbmodem* /dev/cu.usbserial* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)❌ No se encontró puerto serie$(NC)"; \
		make list-ports; \
		exit 1; \
	fi; \
	echo "$(GREEN)📺 Abriendo monitor serie en $$PORT (9600 baud)$(NC)"; \
	echo "$(YELLOW)💡 Para salir: Ctrl+A, luego K, luego Y$(NC)"; \
	echo "$(BLUE)🔄 Iniciando en 3 segundos...$(NC)"; \
	sleep 3; \
	screen $$PORT 9600

# Monitor con minicom (alternativa)
monitor-minicom:
	@PORT=$$(ls /dev/cu.usbmodem* /dev/cu.usbserial* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)❌ No se encontró puerto serie$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)📺 Abriendo minicom en $$PORT$(NC)"; \
	minicom -D $$PORT -b 9600

# ==================== MANTENIMIENTO ====================
# Limpiar archivos generados
clean:
	@echo "$(YELLOW)🧹 Limpiando archivos generados...$(NC)"
	rm -rf $(BUILD_DIR)
	rm -f *.o *.elf *.hex *.lst *.map  # Por si quedan archivos viejos en raíz
	@echo "$(GREEN)✅ Archivos limpiados$(NC)"

# Limpiar todo (incluyendo backups)
clean-all: clean
	@echo "$(YELLOW)🧹 Limpieza profunda...$(NC)"
	rm -f *~ *.bak .DS_Store
	@echo "$(GREEN)✅ Limpieza completa$(NC)"

# ==================== INSTALACIÓN DE DEPENDENCIAS ====================
# Instalar herramientas necesarias
install-deps:
	@echo "$(YELLOW)📦 Instalando dependencias para macOS...$(NC)"
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "$(RED)❌ Homebrew no está instalado$(NC)"; \
		echo "$(YELLOW)💡 Instala Homebrew desde: https://brew.sh$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🍺 Agregando tap de AVR...$(NC)"
	brew tap osx-cross/avr
	@echo "$(BLUE)🔧 Instalando herramientas AVR...$(NC)"
	brew install avr-gcc avrdude
	@echo "$(BLUE)📺 Instalando herramientas de terminal...$(NC)"
	brew install minicom screen
	@echo "$(GREEN)✅ Instalación completada$(NC)"
	@echo "$(YELLOW)💡 Verifica con: make verify-tools$(NC)"

# Verificar que todas las herramientas estén instaladas
verify-tools:
	@echo "$(YELLOW)🔍 Verificando herramientas instaladas...$(NC)"
	@echo -n "avr-gcc: "; avr-gcc --version | head -1 || echo "$(RED)❌ No encontrado$(NC)"
	@echo -n "avrdude: "; avrdude -? 2>&1 | head -1 || echo "$(RED)❌ No encontrado$(NC)"
	@echo -n "screen: "; screen --version || echo "$(RED)❌ No encontrado$(NC)"
	@echo -n "minicom: "; minicom --version || echo "$(YELLOW)⚠️  Opcional$(NC)"
	@echo "$(GREEN)✅ Verificación completada$(NC)"

# ==================== HELP ====================
help:
	@echo "$(GREEN)🍎 Makefile para ATmega328P en macOS con Xplain Mini$(NC)"
	@echo "$(YELLOW)🎯 Reemplazo completo de Microchip Studio$(NC)"
	@echo ""
	@echo "$(BLUE)📦 Compilación:$(NC)"
	@echo "  all              - Compilar proyecto completo"
	@echo "  clean            - Limpiar archivos generados"
	@echo "  clean-all        - Limpieza completa"
	@echo "  size             - Mostrar tamaño del programa"
	@echo ""
	@echo "$(BLUE)🚀 Programación:$(NC)"
	@echo "  program-xplain   - Programar via Xplain Mini (recomendado)"
	@echo "  program-arduino  - Programar via bootloader Arduino"
	@echo "  program          - Programar (intenta Xplain primero)"
	@echo ""
	@echo "$(BLUE)⚡ Comandos Flexibles:$(NC)"
	@echo "  program-xplain-[archivo]   - Programar cualquier .asm con Xplain Mini"
	@echo "  program-arduino-[archivo]  - Programar cualquier .asm con Arduino"
	@echo "  compile-[archivo]          - Solo compilar cualquier .asm"
	@echo ""
	@echo "$(YELLOW)💡 Ejemplos de comandos flexibles:$(NC)"
	@echo "  make program-xplain-main           # Compila y programa main.asm"
	@echo "  make program-xplain-simple_blink   # Compila y programa simple_blink.asm"
	@echo "  make compile-test                  # Solo compila test.asm"
	@echo ""
	@echo "$(BLUE)🔧 Configuración:$(NC)"
	@echo "  fuses            - Leer fusibles actuales"
	@echo "  set-fuses-16mhz  - Configurar para 16MHz externo"
	@echo "  set-fuses-8mhz   - Configurar para 8MHz interno"
	@echo ""
	@echo "$(BLUE)🔍 Diagnóstico:$(NC)"
	@echo "  info             - Información del microcontrolador"
	@echo "  test-xplain      - Verificar conexión Xplain Mini"
	@echo "  list-ports       - Mostrar puertos serie disponibles"
	@echo ""
	@echo "$(BLUE)📺 Monitor:$(NC)"
	@echo "  monitor          - Monitor serie con screen"
	@echo "  monitor-minicom  - Monitor serie con minicom"
	@echo ""
	@echo "$(BLUE)🛠️ Instalación:$(NC)"
	@echo "  install-deps     - Instalar herramientas necesarias"
	@echo "  verify-tools     - Verificar instalación"
	@echo "  help             - Esta ayuda"
	@echo ""
	@echo "$(GREEN)💡 Ejemplos de uso:$(NC)"
	@echo "  make all && make program-xplain  # Compilar y programar"
	@echo "  make clean && make all           # Rebuild completo"
	@echo "  make monitor                     # Abrir monitor serie"

# ==================== WORKFLOW COMPLETO ====================
# Target para desarrollo: compilar, programar y monitor
dev: all program-xplain monitor

# Target para release: limpiar, compilar, verificar tamaño
release: clean all size
	@echo "$(GREEN)✅ Build de release completado$(NC)"

# Target para setup inicial
setup: install-deps verify-tools test-xplain
	@echo "$(GREEN)✅ Setup inicial completado$(NC)"
	@echo "$(YELLOW)💡 Ahora puedes usar: make all && make program$(NC)"
