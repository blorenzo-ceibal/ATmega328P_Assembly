# 🔌 06 - Configuración Hardware Xplain Mini

> **⏱️ Tiempo estimado:** 3 minutos
> **🎯 Objetivo:** Configuración específica y avanzada para Xplain Mini
> **📋 Prerequisito:** Haber completado [05-primer-proyecto.md](05-primer-proyecto.md) ✅

## 🎯 **¿Ya funciona tu LED? ¡Perfecto!**

Si completaste el paso anterior exitosamente, **tu hardware ya está funcionando**. Este paso te da información adicional para **optimizar y entender mejor** tu configuración.

---

## 🔍 **PASO 1: Identificación Completa del Hardware (1 min)**

### 🔧 **Información detallada de tu Xplain Mini:**

```bash
# Ver información USB completa
system_profiler SPUSBDataType | grep -A 10 -B 5 "Xplain\|EDBG\|Microchip"
```

**✅ Deberías ver algo como:**
```
EDBG CMSIS-DAP:
  Product ID: 0x2111
  Vendor ID: 0x03eb (Atmel Corporation)
  Version: 1.00
  Serial Number: ATML2130031800004957
  Speed: Up to 480 Mb/s
  Manufacturer: Atmel Corp.
  Location ID: 0x14200000 / 20
```

### 🔧 **Verificar puertos serie disponibles:**

```bash
# Listar todos los puertos serie
ls /dev/cu.*

# Filtrar solo los relevantes
ls /dev/cu.usbmodem* 2>/dev/null || echo "No hay puertos usbmodem detectados"
```

---

## ⚙️ **PASO 2: Configuración de Permisos macOS (1 min)**

### 🔧 **Optimizar permisos para acceso sin sudo:**

```bash
# Agregar tu usuario al grupo de desarrolladores (mejora el acceso a dispositivos)
sudo dseditgroup -o edit -a $(whoami) -t user _developer

# Verificar que fue agregado
dseditgroup -o read _developer | grep $(whoami)
```

**💡 Esto mejora la estabilidad de la comunicación con la Xplain Mini.**

---

## 🔧 **PASO 3: Comandos de Diagnóstico Avanzados (1 min)**

### 🔍 **Información completa del microcontrolador:**

```bash
# Test completo de comunicación con detalles
avrdude -c xplainedmini -p atmega328p -P usb -v -v
```

### 🔧 **Leer fusibles del microcontrolador:**

```bash
# Ver configuración actual de fusibles
avrdude -c xplainedmini -p atmega328p -P usb -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h
```

**✅ Deberías ver algo como:**
```
avrdude: reading lfuse memory:
Reading | ################################################## | 100% 0.02s
avrdude: writing output file "<stdout>"
0xff
avrdude: reading hfuse memory:
0xde
avrdude: reading efuse memory:
0xfd
```

### 🔍 **Información de memoria y flash:**

```bash
# Ver uso de memoria después de programar
make size

# Alternativa manual
avr-size --format=avr --mcu=atmega328p simple_blink.elf
```

---

## 📋 **Configuraciones Opcionales**

### 🚀 **Configurar fusibles para 16MHz (solo si es necesario):**

**⚠️ ADVERTENCIA:** Solo ejecuta esto si sabes lo que haces. Los fusibles incorrectos pueden "brickear" tu microcontrolador.

```bash
# Configurar fusibles para cristal externo 16MHz (solo si es necesario)
# avrdude -c xplainedmini -p atmega328p -P usb -U lfuse:w:0xFF:m -U hfuse:w:0xDE:m -U efuse:w:0x05:m
```

**💡 Normalmente NO necesitas cambiar fusibles en Xplain Mini.**

### 🔧 **Configuración para múltiples placas:**

Si tienes varias Xplain Mini, puedes especificar el número de serie:

```bash
# Listar todas las Xplain Mini conectadas
avrdude -c xplainedmini -p atmega328p -P usb -v 2>&1 | grep "Serial number"

# Programar placa específica (ejemplo)
# avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:programa.hex:i -B 0.1 -s 0x1234567890ABCDEF
```

---

## 🛠️ **Comandos de Referencia Rápida**

### 🔧 **Testing y verificación:**

```bash
# Test básico de conexión
avrdude -c xplainedmini -p atmega328p -P usb

# Información del chip
avrdude -c xplainedmini -p atmega328p -P usb -v | head -20

# Ver programadores disponibles
avrdude -c ?

# Ver microcontroladores soportados
avrdude -p ?
```

### 🔧 **Programación manual paso a paso:**

```bash
# Si prefieres control total manual:

# 1. Compilar
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c mi_programa.asm -o mi_programa.o
avr-gcc -mmcu=atmega328p mi_programa.o -o mi_programa.elf
avr-objcopy -O ihex mi_programa.elf mi_programa.hex

# 2. Verificar antes de programar
avrdude -c xplainedmini -p atmega328p -P usb -U flash:v:mi_programa.hex:i -n

# 3. Programar
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:mi_programa.hex:i

# 4. Verificar después de programar
avrdude -c xplainedmini -p atmega328p -P usb -U flash:r:verificacion.hex:i
```

---

## 🔧 **Configuración para Monitor Serie**

### 📡 **Configurar comunicación serie (UART):**

```bash
# Abrir monitor serie con screen (método preferido)
screen /dev/cu.usbmodem* 9600

# Salir de screen: Ctrl+A, luego K, luego Y

# Alternativa con minicom
minicom -D /dev/cu.usbmodem* -b 9600 -o
```

### 🔧 **Agregar función de monitor al Makefile:**

Esta función ya está incluida en el Makefile que creamos, pero aquí está la explicación:

```makefile
# Monitor serie automático
monitor:
	@PORT=$$(ls /dev/cu.usbmodem* 2>/dev/null | head -1); \
	if [ -z "$$PORT" ]; then \
		echo "$(RED)✗ No se encontró puerto serie$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Abriendo monitor serie en $$PORT...$(NC)"; \
	echo "$(YELLOW)Para salir: Ctrl+A, luego K, luego Y$(NC)"; \
	screen $$PORT 9600
```

---

## ✅ **Checkpoint - Hardware Optimizado**

### 🔍 **Verificaciones finales:**

- [ ] **Detección USB:** `system_profiler SPUSBDataType | grep EDBG` muestra información
- [ ] **Comunicación:** `avrdude -c xplainedmini -p atmega328p -P usb` funciona sin errores
- [ ] **Permisos:** Tu usuario está en el grupo `_developer`
- [ ] **Fusibles:** Configuración correcta (si la verificaste)

### 📊 **Tu setup está 100% optimizado:**
- ✅ Hardware detectado y configurado
- ✅ Permisos optimizados para macOS
- ✅ Comunicación estable y confiable
- ✅ Comandos de diagnóstico disponibles

---

## 💡 **Para Estudiantes - Información Técnica**

### 🔬 **¿Cómo funciona la Xplain Mini?**

La Xplain Mini tiene **dos microcontroladores**:

1. **ATmega328P principal** - Donde va tu código
2. **Debugger integrado (EDBG)** - Maneja USB y programación

**Comunicación:**
- USB ↔ EDBG ↔ ATmega328P (vía SPI/JTAG)
- EDBG también provee UART virtual para comunicación serie

### 🔧 **¿Por qué programador "xplainedmini"?**

- **xplainedmini** es el driver específico para EDBG
- **Más estable** que drivers genéricos
- **Soporte nativo** para debugging y programación
- **Velocidad optimizada** para este hardware específico

### 📊 **Especificaciones técnicas:**

- **ATmega328P:** 32KB Flash, 2KB RAM, 1KB EEPROM
- **Frecuencia:** 16MHz cristal externo
- **Voltaje:** 5V (alimentado por USB)
- **Comunicación:** USB 2.0 Full Speed (12 Mbps)

---

**✅ Hardware optimizado →** **[07-proyectos-ejemplo.md](07-proyectos-ejemplo.md)**

**⬅️ Paso anterior:** **[05-primer-proyecto.md](05-primer-proyecto.md)**
**🏠 Índice:** **[README.md](README.md)**
