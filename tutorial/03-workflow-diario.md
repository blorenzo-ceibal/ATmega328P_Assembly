# ⚡ 03 - Tu Workflow Diario

> **⏱️ Tiempo estimado:** 7 minutos
> **🎯 Objetivo:** ¡Descubrir los comandos que cambiarán tu vida de programador!
> **📋 Prerequisito:** Haber completado [02-instalacion-basica.md](02-instalacion-basica.md)

## 🚀 **¡El Comando Mágico que Estabas Esperando!**

Con las herramientas que acabas de instalar, **este será tu workflow diario:**

```bash
# Tu nuevo comando favorito:
./program mi_archivo
```

**¡Eso es todo!** Un comando que:
- ✅ **Compila** tu código Assembly
- ✅ **Programa** el ATmega328P automáticamente
- ✅ **Verifica** que todo salió bien
- ✅ **Te dice** si hay errores

## 💡 **Ejemplos Reales (funcionarán después del setup completo)**

```bash
# Hacer parpadear un LED (usando archivos que ya existen en el proyecto)
./program simple_blink     # El script busca automáticamente en src/

# Programa más complejo
./program blink2

# Sin extensión también funciona
./program simple_blink

# Para tus propios proyectos
./program mi_proyecto
```

**💡 Nota importante:** El script `program` busca automáticamente tus archivos `.asm` en la carpeta `src/` y coloca los archivos generados (.hex, .elf, .o) en la carpeta `build/` para mantener tu proyecto ordenado.

---

## 🛠️ **Comandos que Dominarás**

### 🎯 **Nivel Principiante - Los Esenciales:**

```bash
# El comando todo-en-uno (tu favorito)
./program archivo

# Ver ayuda del comando
./program --help

# Limpiar archivos temporales
make clean
```

### 🔧 **Nivel Intermedio - Makefile:**

```bash
# Compilar todo sin programar
make all

# Programar archivo específico
make program-xplain-simple_blink

# Ver tamaño del programa
make size

# Solo compilar (sin programar)
make compile-simple_blink
```

### 🏆 **Nivel Avanzado - Control Manual:**

```bash
# Compilar paso a paso
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c archivo.asm -o archivo.o
avr-gcc -mmcu=atmega328p archivo.o -o archivo.elf
avr-objcopy -O ihex archivo.elf archivo.hex

# Programar manualmente
avrdude -c xplainedmini -p atmega328p -P usb -U flash:w:archivo.hex:i

# Información del microcontrolador
avrdude -c xplainedmini -p atmega328p -P usb -v
```

---

## 🆚 **Comparación: Antes vs Después**

### ❌ **Microchip Studio (el método viejo):**
1. Abrir Microchip Studio
2. Crear proyecto → Next → Next → Next
3. Configurar toolchain → Browse → Select
4. Escribir código
5. Build → F7
6. Tools → Device Programming
7. Seleccionar Tool → Apply
8. Seleccionar Device → Apply
9. Memories → Flash → Browse
10. Program → Go

**Total: ~10 clicks y 3 minutos por cada programación**

### ✅ **Tu nuevo workflow:**
1. Escribir código
2. `program archivo.asm`

**Total: 1 comando y 10 segundos**

---

## 🎯 **¿Cómo Funciona la Magia?**

**Para estudiantes curiosos que quieren entender:**

El comando `program` que crearás es un script que automáticamente:

1. **Detecta** si el archivo existe
2. **Compila** usando `avr-gcc` con las opciones correctas
3. **Crea** el archivo .hex que entiende el microcontrolador
4. **Busca** tu Xplain Mini conectada
5. **Programa** usando `avrdude` con configuración optimizada
6. **Verifica** que la programación fue exitosa
7. **Te reporta** errores si algo falla

**Todo esto en un comando de 1 línea.**

---

## 📊 **Tu Día Típico Programando ATmega328P**

### 🌅 **Mañana - Empezando tu proyecto:**
```bash
# Abrir VS Code en tu carpeta de proyecto
code ~/Desktop/mi_proyecto_micro

# Crear archivo nuevo
touch nuevo_programa.asm

# Escribir código...
# (en VS Code con syntax highlighting perfecto)
```

### ☀️ **Mediodía - Testing y debugging:**
```bash
# Compilar y probar
program nuevo_programa

# Si hay errores, corregir y repetir
program nuevo_programa

# Todo funcionando? Commit!
git add . && git commit -m "LED parpadeante funcionando"
```

### 🌙 **Tarde - Proyecto más complejo:**
```bash
# Trabajar en el proyecto principal
program proyecto_universidad.asm

# Probar variaciones
program version_botones.asm
program version_sensores.asm

# Limpiar archivos temporales
make clean
```

---

## 🔧 **Comandos Útiles Extra**

### 📡 **Comunicación y debugging:**
```bash
# Abrir monitor serie (para printf, debugging)
screen /dev/cu.usbmodem* 9600

# Salir del monitor: Ctrl+A, luego K, luego Y

# Alternativa con minicom
minicom -D /dev/cu.usbmodem* -b 9600
```

### 🔍 **Hardware y diagnóstico:**
```bash
# Ver qué dispositivos USB están conectados
system_profiler SPUSBDataType | grep -i "microchip\|atmel\|edbg"

# Listar puertos serie disponibles
ls /dev/cu.*

# Información completa del chip
make info
```

### 🧹 **Limpieza y mantenimiento:**
```bash
# Limpiar archivos generados
make clean

# Limpiar TODO (incluso backups)
rm -f *.o *.elf *.hex *.lst *~

# Actualizar herramientas
brew update && brew upgrade avr-gcc avrdude
```

---

## ✅ **Checkpoint - ¿Ya visualizas tu workflow?**

### 🎯 **Al completar el tutorial tendrás:**

- ✅ **Comando único** `program archivo.asm` funcional
- ✅ **VS Code** con syntax highlighting perfecto
- ✅ **Compilación automática** en segundos
- ✅ **Programación automática** de Xplain Mini
- ✅ **Error reporting** inteligente

### 📊 **Tu progreso actual:**
- ✅ Requisitos verificados
- ✅ Instalación básica completa
- ✅ **Workflow diario visualizado**
- ⏳ Configurar VS Code (¡siguiente!)
- ⏳ Primer proyecto

---

## 💡 **Motivación para Continuar**

**¿Vale la pena seguir con el tutorial?**

**¡Por supuesto!** Acabas de ver **qué** vas a poder hacer. Los siguientes pasos te enseñan **cómo** configurar todo para que funcione.

**¿Cuánto falta?** Solo 30 minutos más para tener todo funcionando.

**¿Es difícil?** No, son configuraciones paso a paso. Solo seguir las instrucciones.

---

## 📝 **Para Estudiantes de Ingeniería**

**¿Por qué este workflow es mejor?**

- **Más rápido:** 10 segundos vs 3 minutos por programación
- **Menos errores:** Configuración automática vs configuración manual
- **Más profesional:** Herramientas de línea de comandos vs GUIs
- **Más flexible:** Funciona con cualquier editor, no solo uno específico
- **Más portable:** Funciona en Mac, Linux, WSL
- **Más escalable:** Fácil de automatizar en proyectos grandes

**¿Es lo que usan los profesionales?** Sí, este tipo de workflows son estándar en la industria.

---

**✅ Workflow visualizado →** **[04-configurar-vscode.md](04-configurar-vscode.md)**

**⬅️ Paso anterior:** **[02-instalacion-basica.md](02-instalacion-basica.md)**
**🏠 Índice:** **[README.md](README.md)**
