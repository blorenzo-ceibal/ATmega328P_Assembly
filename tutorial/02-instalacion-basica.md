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

## 🔧 **PASO 4: Obtener el Proyecto Completo (2 min)**

Ahora que tienes las herramientas instaladas, necesitas obtener el proyecto completo con todos los archivos necesarios (Makefile, script program, ejemplos, etc.).

### 🔧 **Clonar el repositorio:**

```bash
# Ir a tu Desktop (o donde prefieras tener el proyecto)
cd ~/Desktop

# Clonar el repositorio completo
git clone https://github.com/blorenzo-ceibal/ATmega328P_Assembly.git

# Entrar a la carpeta del proyecto
cd ATmega328P_Assembly

# Verificar que tienes todos los archivos
ls -la
```

**✅ Deberías ver:** `Makefile`, `program`, `src/`, `tutorial/`, etc.

### 🔧 **Hacer el script ejecutable:**

```bash
# Hacer el script program ejecutable
chmod +x program

# Verificar que ahora es ejecutable
ls -la program
```

**✅ Deberías ver algo como:** `-rwxr-xr-x ... program` (nota la "x" que indica ejecutable)

### 🎯 **Probar el script:**

```bash
# Ver la ayuda del script
./program -h
```

**✅ Si ves la ayuda del script con colores y ejemplos, ¡funciona perfectamente!**

---

## 🔧 **PASO 5: Configurar Script de Programación (2 min)**

El repositorio ya incluye un script personalizado llamado `program` que automatiza todo el proceso de compilación y programación del ATmega328P. Como ya lo hiciste ejecutable en el paso anterior, ahora puedes usarlo directamente.

###  **¿Qué hace este script?**

El script `program` automatiza todo el workflow:
1. **Compila** tu archivo .asm
2. **Genera** el archivo .hex
3. **Programa** el ATmega328P via Xplain Mini
4. **Muestra** información útil del proceso

**Ejemplos de uso:**
```bash
./program simple_blink      # Compila y programa simple_blink.asm
./program blink2           # Compila y programa blink2.asm
./program mi_proyecto      # Compila y programa mi_proyecto.asm
```---

## ✅ **Checkpoint - Verificación Final**

### 🔍 **Comandos que DEBEN funcionar:**

```bash
# 1. Homebrew instalado
brew --version

# 2. Compilador AVR funcionando
avr-gcc --version

# 3. Programador AVR detectado
avrdude -c ?

# 4. Script de programación disponible (en la carpeta del proyecto)
cd ~/Desktop/ATmega328P_Assembly && ./program -h
```

### 📊 **Tu progreso actual:**
- ✅ Requisitos verificados
- ✅ **Instalación básica completa**
- ✅ **Script de programación configurado**
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

### ❌ **"./program: Permission denied"**
- **Causa:** El script program no tiene permisos de ejecución
- **Solución:** Ejecutar `chmod +x program` en la carpeta del proyecto

### ❌ **"./program: No such file or directory"**
- **Causa:** No estás en la carpeta correcta del proyecto
- **Solución:** Navegar a la carpeta que contiene el archivo `program` con `cd`

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
