# 🔧 Troubleshooting - Solución de Problemas

> **🎯 Objetivo:** Resolver problemas comunes paso a paso
> **📋 Uso:** Consultar cuando algo no funciona como esperado

## 🚨 **Problemas de Instalación**

### ❌ **"brew: command not found"**

**Causa:** Homebrew no está instalado o no está en el PATH

**Solución:**
```bash
# 1. Reinstalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Para Mac M1/M2, agregar al PATH:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# 3. Verificar
brew --version
```

### ❌ **"avr-gcc: command not found"**

**Causa:** Toolchain AVR no instalado

**Solución:**
```bash
# 1. Verificar Homebrew funciona
brew --version

# 2. Reinstalar toolchain AVR
brew tap osx-cross/avr
brew install avr-gcc avrdude

# 3. Si sigue fallando, forzar reinstalación
brew uninstall avr-gcc avrdude
brew install avr-gcc avrdude

# 4. Verificar
avr-gcc --version
avrdude -?
```

### ❌ **Permisos denegados al instalar**

**Causa:** Problemas de permisos con Homebrew

**Solución:**
```bash
# 1. Cambiar propietario de directorios Homebrew
sudo chown -R $(whoami) /usr/local/var/homebrew/
sudo chown -R $(whoami) /usr/local/etc/homebrew/

# 2. Para Mac M1/M2:
sudo chown -R $(whoami) /opt/homebrew/

# 3. Reinstalar
brew doctor
brew update
```

---

## 🔌 **Problemas de Hardware**

### ❌ **"Device not found" al programar**

**Causa más común:** Cable USB defectuoso o conexión suelta

**Solución paso a paso:**
```bash
# 1. Verificar detección USB
system_profiler SPUSBDataType | grep -i "microchip\|atmel\|edbg"

# 2. Si no aparece nada:
# - Cambiar cable USB (causa #1 de problemas)
# - Probar otro puerto USB
# - Verificar LED de power en Xplain Mini

# 3. Si aparece pero avrdude falla:
avrdude -c xplainedmini -p atmega328p -P usb -v

# 4. Verificar que es el programador correcto:
avrdude -c ?
```

**Si sigue fallando:**
```bash
# Método alternativo - usar número de serie específico
avrdude -c xplainedmini -p atmega328p -P usb -v 2>&1 | grep "Serial number"
# Usar ese número: -P usb:SERIAL_NUMBER
```

### ❌ **"Permission denied" con dispositivo USB**

**Causa:** macOS no tiene permisos para acceder al dispositivo

**Solución:**
```bash
# 1. Agregar permisos de developer
sudo dseditgroup -o edit -a $(whoami) -t user _developer

# 2. Reiniciar sesión (logout/login) o reiniciar Mac

# 3. Verificar permisos
dseditgroup -o read _developer | grep $(whoami)

# 4. Reconectar Xplain Mini
```

### ❌ **LED no parpadea después de programar exitoso**

**Posibles causas y soluciones:**

**1. Programación no fue realmente exitosa:**
```bash
# Verificar programación con lectura
avrdude -c xplainedmini -p atmega328p -P usb -U flash:r:verify.hex:i
```

**2. LED equivocado:**
- El LED programable está en la **esquina de la placa**
- Es un **LED pequeño amarillo/verde**
- NO es el LED de power (que siempre está encendido)

**3. Frecuencia incorrecta:**
```bash
# Verificar fusibles
avrdude -c xplainedmini -p atmega328p -P usb -U lfuse:r:-:h -U hfuse:r:-:h

# Deberían ser aproximadamente: lfuse=0xFF, hfuse=0xDE
```

**4. Pin incorrecto en código:**
- Verificar que usas `PB5` en el código
- En Xplain Mini, PB5 está conectado al LED integrado

---

## 💻 **Problemas de Compilación**

### ❌ **"Error: no such file or directory: avr/io.h"**

**Causa:** Headers AVR no instalados correctamente

**Solución:**
```bash
# 1. Verificar instalación completa de toolchain
brew list avr-gcc

# 2. Si falta, reinstalar
brew uninstall avr-gcc
brew install avr-gcc

# 3. Verificar headers
find /usr/local -name "avr" -type d 2>/dev/null
find /opt/homebrew -name "avr" -type d 2>/dev/null
```

### ❌ **Errores de sintaxis Assembly**

**Errores comunes y soluciones:**

**Error:** `Error: unknown opcode 'LDI'`
**Causa:** Mayúsculas/minúsculas incorrectas
**Solución:** Usar minúsculas: `ldi` no `LDI`

**Error:** `Error: can't resolve '_SFR_IO_ADDR' {*ABS*+0x00000020} - {*UND*+0x00000000}`
**Causa:** Falta `#include <avr/io.h>`
**Solución:** Agregar al inicio del archivo

**Error:** `Error: symbol 'main' is already defined`
**Causa:** Múltiples definiciones de main
**Solución:** Solo un `main:` por programa

### ❌ **"make: *** No rule to make target..."**

**Causa:** Makefile incorrecto o archivo no existe

**Solución:**
```bash
# 1. Verificar que existe el Makefile
ls -la Makefile

# 2. Verificar sintaxis (no espacios, usar TABs)
cat -A Makefile | head -10

# 3. Recrear Makefile desde el tutorial si es necesario

# 4. Verificar que existe el archivo .asm
ls -la *.asm
```

---

## 🎨 **Problemas de VS Code**

### ❌ **No hay colores en código Assembly**

**Causa:** Extensiones no instaladas o activas

**Solución:**
```bash
# 1. Verificar extensiones instaladas
code --list-extensions | grep -E "assembly|avr|cpptools"

# 2. Si faltan, instalar:
code --install-extension ms-vscode.cpptools
code --install-extension 13xforever.language-x86-64-assembly
code --install-extension rockcat.avr-support

# 3. En VS Code, forzar detección:
# Cmd+Shift+P → "Change Language Mode" → "Assembly"
```

### ❌ **VS Code no reconoce comandos de terminal**

**Causa:** PATH no configurado en VS Code

**Solución:**
```bash
# 1. Verificar PATH en terminal normal
echo $PATH | grep homebrew

# 2. Agregar PATH a shell profile
echo 'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 3. Reiniciar VS Code completamente
```

---

## 📡 **Problemas de Comunicación Serie**

### ❌ **Monitor serie no muestra nada**

**Posibles causas:**

**1. Baud rate incorrecto:**
```bash
# Probar diferentes velocidades
screen /dev/cu.usbmodem* 9600
screen /dev/cu.usbmodem* 115200
```

**2. Puerto incorrecto:**
```bash
# Listar todos los puertos
ls /dev/cu.*

# Probar cada uno
screen /dev/cu.usbserial-* 9600
```

**3. Hardware no configurado:**
- Verificar que el código configura UART correctamente
- TX/RX pueden estar intercambiados

### ❌ **"No such file or directory" con screen**

**Causa:** Puerto no existe o Xplain Mini desconectada

**Solución:**
```bash
# 1. Verificar conexión USB
system_profiler SPUSBDataType | grep EDBG

# 2. Verificar puertos disponibles
ls /dev/cu.* | grep -i usb

# 3. Reconnectar Xplain Mini y verificar nuevamente
```

---

## 🔄 **Problemas de Rendimiento**

### ❌ **Compilación muy lenta**

**Causa:** Antivirus escaneando archivos temporales

**Solución:**
```bash
# 1. Agregar exclusión de antivirus para:
# - /usr/local/bin/
# - /opt/homebrew/bin/
# - Tu carpeta de proyecto

# 2. Compilar en directorio sin sincronización cloud
mkdir ~/local_projects
cd ~/local_projects
```

### ❌ **avrdude muy lento al programar**

**Causa:** Velocidad de comunicación muy baja

**Solución:**
```bash
# Agregar flag de velocidad a avrdude
avrdude -c xplainedmini -p atmega328p -P usb -B 0.1 -U flash:w:programa.hex:i
```

---

## 🛠️ **Comandos de Diagnóstico Completo**

### 🔍 **Script de diagnóstico automático:**

```bash
cat > diagnostico.sh << 'EOF'
#!/bin/bash

echo "=== DIAGNÓSTICO COMPLETO ATmega328P Setup ==="

echo -e "\n1. SISTEMA:"
sw_vers
echo "Shell: $SHELL"

echo -e "\n2. HOMEBREW:"
brew --version 2>/dev/null || echo "❌ Homebrew no instalado"

echo -e "\n3. TOOLCHAIN AVR:"
avr-gcc --version 2>/dev/null || echo "❌ avr-gcc no encontrado"
avrdude -? 2>/dev/null | head -1 || echo "❌ avrdude no encontrado"

echo -e "\n4. HARDWARE USB:"
system_profiler SPUSBDataType | grep -A 5 -B 2 "EDBG\|Xplain\|Microchip" || echo "❌ Xplain Mini no detectada"

echo -e "\n5. PUERTOS SERIE:"
ls /dev/cu.* 2>/dev/null | grep usb || echo "❌ No hay puertos USB serie"

echo -e "\n6. VS CODE EXTENSIONES:"
code --list-extensions 2>/dev/null | grep -E "cpptools|assembly|avr" || echo "❌ Extensiones no instaladas"

echo -e "\n7. ARCHIVOS DE PROYECTO:"
ls -la Makefile program *.asm 2>/dev/null || echo "❌ Archivos de proyecto no encontrados"

echo -e "\n8. TEST DE COMPILACIÓN:"
if [ -f "simple_blink.asm" ]; then
    avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c simple_blink.asm -o test.o 2>/dev/null && echo "✅ Compilación OK" || echo "❌ Error de compilación"
    rm -f test.o
else
    echo "❌ simple_blink.asm no encontrado"
fi

echo -e "\n=== FIN DIAGNÓSTICO ==="
EOF

chmod +x diagnostico.sh
./diagnostico.sh
```

---

## 📞 **¿Problema No Listado?**

### 🔍 **Pasos generales de troubleshooting:**

1. **Reiniciar desde cero:**
   ```bash
   # Desconectar hardware
   # Cerrar VS Code y Terminal
   # Reconectar hardware
   # Abrir nueva terminal
   ```

2. **Verificar una cosa a la vez:**
   - ¿Homebrew funciona? `brew --version`
   - ¿avr-gcc funciona? `avr-gcc --version`
   - ¿Hardware detectado? `system_profiler SPUSBDataType | grep EDBG`
   - ¿Archivo existe? `ls -la archivo.asm`

3. **Usar diagnóstico automático:**
   ```bash
   ./diagnostico.sh
   ```

4. **Volver a tutorial básico:**
   - Regresar a [02-instalacion-basica.md](../02-instalacion-basica.md)
   - Repetir paso que falló

### 🆘 **Si nada funciona:**

1. **Crear setup limpio:**
   ```bash
   mkdir ~/ATmega328P_Clean
   cd ~/ATmega328P_Clean
   # Seguir tutorial desde el principio
   ```

2. **Verificar con otro Mac/usuario** (si disponible)

3. **Usar método manual paso a paso** sin scripts automáticos

---

**🏠 Regresar:** **[README.md](../README.md)**
**📚 Otros anexos:** **[anexos/](./)**
