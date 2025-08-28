# 🛠️ 02 - Instalación Básica

> **⏱️ Tiempo estimado:** 10 minutos
> **🎯 Objetivo:** Instalar Homebrew y el toolchain AVR completo
> **📋 Prerequisito:** Haber completado [01-requisitos.md](01-requisitos.md)

## 🍺 **PASO 1: Instalar Homebrew (5 min)**

**¿Qué es Homebrew?** Es el "gestor de paquetes" más popular para Mac. Piénsalo como una "tienda de aplicaciones" para herramientas de desarrollo desde terminal.

### 🔧 **Instalación de Homebrew:**

```bash
# Ejecutar este comando en Terminal:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**⏳ Esto tardará 3-5 minutos.** Verás muchos mensajes, es normal.

### ✅ **Verificar instalación:**

```bash
# Verificar que Homebrew se instaló correctamente
brew --version

# Deberías ver algo como:
# Homebrew 4.x.x
```

### 🔧 **Si tienes Mac con chip M1/M2:**

Es posible que necesites agregar Homebrew al PATH:

```bash
# Solo para Mac M1/M2, ejecutar estos comandos:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Verificar nuevamente:
brew --version
```

---

## ⚙️ **PASO 2: Instalar Toolchain AVR (5 min)**

**¿Qué es el toolchain AVR?** Son las herramientas que convierten tu código Assembly en archivos que puede entender el ATmega328P.

### 🔧 **Agregar repositorio oficial AVR:**

```bash
# Agregar el "tap" oficial para herramientas AVR
brew tap osx-cross/avr
```

### 🔧 **Instalar herramientas esenciales:**

```bash
# Instalar el compilador y programador
brew install avr-gcc avrdude

# Instalar herramientas adicionales útiles
brew install minicom screen
```

**⏳ Esto tardará 3-5 minutos.** Verás mucho texto, es normal.

### ✅ **Verificar instalaciones:**

```bash
# Verificar compilador AVR
avr-gcc --version
# Deberías ver: avr-gcc (GCC) 12.x.x o similar

# Verificar programador
avrdude -?
# Deberías ver la ayuda de avrdude (muchas líneas de texto)

# Verificar herramientas adicionales
minicom --version
screen -version
```

**✅ Si todos los comandos muestran información (no errores), ¡perfecto!**

---

## 🎯 **PASO 3: Primera Prueba Rápida**

Vamos a probar que todo funciona con un test muy simple:

### 🔧 **Crear archivo de prueba:**

```bash
# Ir a tu Desktop
cd ~/Desktop

# Crear archivo de prueba simple
echo '#include <avr/io.h>
.section .text
.global main
main:
    ldi r16, 0xFF
    out _SFR_IO_ADDR(DDRB), r16
    rjmp main' > test_simple.asm
```

### 🔧 **Compilar archivo de prueba:**

```bash
# Compilar el archivo de prueba
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c test_simple.asm -o test_simple.o

# Si no hay errores, crear archivo HEX
avr-gcc -mmcu=atmega328p test_simple.o -o test_simple.elf
avr-objcopy -O ihex test_simple.elf test_simple.hex

# Verificar que se creó el archivo HEX
ls -la test_simple.hex
```

**✅ Si ves el archivo `test_simple.hex` listado, ¡la compilación funciona!**

### 🧹 **Limpiar archivos de prueba:**

```bash
# Remover archivos de prueba
rm test_simple.*
```

---

## ✅ **Checkpoint - Verificación Final**

### 🔍 **Comandos que DEBEN funcionar:**

```bash
# 1. Homebrew instalado
brew --version

# 2. Compilador AVR funcionando
avr-gcc --version

# 3. Programador AVR detectado
avrdude -c ?
```

### 📊 **Tu progreso actual:**
- ✅ Requisitos verificados
- ✅ **Instalación básica completa**
- ⏳ Workflow diario (¡siguiente!)
- ⏳ Configurar VS Code
- ⏳ Primer proyecto

---

## 🔧 **Si algo falla aquí:**

### ❌ **"brew: command not found"**
- **Causa:** Homebrew no se instaló o no está en el PATH
- **Solución:** Repetir PASO 1, especialmente la parte de M1/M2

### ❌ **"avr-gcc: command not found"**
- **Causa:** El toolchain AVR no se instaló
- **Solución:** Repetir `brew tap osx-cross/avr` y `brew install avr-gcc avrdude`

### ❌ **Error en compilación de prueba**
- **Causa:** Sintaxis incorrecta (normal, es código muy básico)
- **Solución:** Continúa al siguiente paso, ahí haremos un proyecto real

---

## 📝 **¿Qué acabas de instalar?**

**Para estudiantes curiosos:**

- **Homebrew:** Gestor de paquetes que facilita instalar software
- **avr-gcc:** Compilador que convierte Assembly → código máquina
- **avrdude:** Programador que sube código al microcontrolador
- **minicom/screen:** Herramientas para comunicación serie (debugging)

**¿Por qué no Microchip Studio?**
- Solo funciona en Windows
- Estas herramientas son más flexibles y profesionales
- Usadas en la industria real
- Código abierto y gratuitas

---

**✅ Instalación completa →** **[03-workflow-diario.md](03-workflow-diario.md)**

**⬅️ Paso anterior:** **[01-requisitos.md](01-requisitos.md)**
**🏠 Índice:** **[README.md](README.md)**
