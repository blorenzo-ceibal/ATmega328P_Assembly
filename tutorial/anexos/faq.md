# ❓ FAQ - Preguntas Frecuentes

> **🎯 Objetivo:** Respuestas rápidas a las dudas más comunes
> **📋 Nivel:** Todos los niveles
> **⏱️ Tiempo de lectura:** 5-10 minutos

<div align="center">

## 🚀 **¡Soluciones Rápidas que Funcionan!**

*La mayoría de problemas tienen solución en menos de 2 minutos*

</div>

---

## � **Índice Rápido**

| �🔧 [**Instalación**](#-problemas-de-instalación) | 🔌 [**Hardware**](#-problemas-de-hardware) | 💻 [**Script**](#-problemas-con-el-script) |
|:---:|:---:|:---:|
| [brew not found](#-brew-command-not-found) • [avr-gcc missing](#-avr-gcc-command-not-found) • [Permisos](#-error-de-permisos-al-instalar-homebrew) | [No detecta Xplain](#-mi-xplain-mini-no-se-detecta) • [Programmer error](#-programmer-not-responding) • [USB permisos](#-permission-denied-al-acceder-al-usb) | [Permission denied](#-program-permission-denied) • [File not found](#-program-no-such-file-or-directory) • [Compile fails](#-el-script-encuentra-el-archivo-asm-pero-falla-al-compilar) |

| 📝 [**VS Code**](#-problemas-con-vs-code) | 🔄 [**Workflow**](#-problemas-de-workflow) | 🆘 [**Reset Total**](#-reset-completo) |
|:---:|:---:|:---:|
| [Sin colores](#-no-veo-colores-en-assembly) • [ASM files](#-archivos-asm-no-se-reconocen) • [IntelliSense](#-intellisense-no-funciona) | [Make errors](#-make-no-funciona) • [File targets](#-no-rule-to-make-target) • [LED speed](#-el-led-parpadea-incorrectamente) | [Limpiar todo](#limpiar-todo) • [Reinstalar](#reinstalar) • [Reclonar](#reclonar-repositorio) |

---

<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; color: white; margin: 20px 0;">

## 🔧 **Problemas de Instalación**

*Los 3 errores más comunes y sus soluciones inmediatas*

</div>

### 🟡 **"brew: command not found"**

<details>
<summary><strong>💡 Click para ver la solución (funciona el 95% de las veces)</strong></summary>

**🔍 Causa:** Homebrew no se agregó al PATH automáticamente

**✅ Solución rápida:**

```bash
# 🍎 Para Mac M1/M2 (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# 🖥️ Para Mac Intel (x86_64)
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# ✅ Verificar que funciona
brew --version
```

**💭 ¿Cómo saber qué Mac tengo?**
```bash
uname -m
# arm64 = Mac M1/M2
# x86_64 = Mac Intel
```

</details>

### 🟡 **"avr-gcc: command not found"**

<details>
<summary><strong>💡 Click para ver la solución completa</strong></summary>

**🔍 Causa:** El repositorio AVR no se instaló correctamente

**✅ Solución paso a paso:**

```bash
# 1️⃣ Limpiar instalación previa
brew untap osx-cross/avr

# 2️⃣ Agregar repositorio oficial
brew tap osx-cross/avr

# 3️⃣ Instalar herramientas
brew install avr-gcc avrdude

# 4️⃣ Verificar instalación
avr-gcc --version
avrdude -?
```

**🎯 Resultado esperado:**
- `avr-gcc` debe mostrar versión 12.x.x o superior
- `avrdude` debe mostrar ayuda completa

</details>

### 🟡 **Error de permisos al instalar Homebrew**

<details>
<summary><strong>💡 Soluciones para diferentes escenarios</strong></summary>

**🔍 Causa:** No tienes permisos de administrador

**✅ Opción 1 - Con permisos admin:**
```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**✅ Opción 2 - Sin permisos admin (más seguro):**
```bash
# Instalar en directorio personal
mkdir ~/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.homebrew

# Agregar al PATH
echo 'export PATH="$HOME/.homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verificar
brew --version
```

</details>

---

<div style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); padding: 20px; border-radius: 10px; color: white; margin: 20px 0;">

## 🔌 **Problemas de Hardware**

*Xplain Mini: diagnóstico y soluciones paso a paso*

</div>

### 🟡 **Mi Xplain Mini no se detecta**

<details>
<summary><strong>💡 Diagnóstico sistemático (sigue los pasos en orden)</strong></summary>

**📋 Checklist de diagnóstico:**

#### **1️⃣ Verificar conexión física**
```bash
# Ver todos los dispositivos USB
system_profiler SPUSBDataType | grep -i "microchip\|atmel\|edbg"
```
**✅ Resultado esperado:** Debe aparecer "EDBG" o "Atmel Corp."

#### **2️⃣ Revisar hardware básico**
- [ ] **Cable USB:** Probar otro cable (cables de carga NO funcionan)
- [ ] **LED power:** Debe estar encendido (verde/azul)
- [ ] **Puerto USB:** Probar otro puerto del Mac

#### **3️⃣ Reset del dispositivo**
1. Desconectar Xplain Mini
2. Esperar 10 segundos
3. Reconectar
4. Verificar LED power

#### **4️⃣ Test de comunicación**
```bash
avrdude -c xplainedmini -p atmega328p -P usb -v
```
**✅ Resultado esperado:** Información del chip sin errores

</details>

### 🟡 **"programmer not responding"**

<details>
<summary><strong>💡 Solución en 3 pasos</strong></summary>

**🔍 Causa más común:** Conflicto con otros programas

**✅ Solución rápida:**

```bash
# 1️⃣ Cerrar programas que pueden interferir
# - Arduino IDE
# - Microchip Studio
# - Atmel Studio
# - Otros programadores

# 2️⃣ Reset hardware
# Desconectar y reconectar Xplain Mini

# 3️⃣ Test de comunicación
avrdude -c xplainedmini -p atmega328p -P usb -v
```

**🚨 Si sigue fallando:**
```bash
# Opción nuclear (usar con cuidado)
sudo avrdude -c xplainedmini -p atmega328p -P usb -v
```

</details>

### 🟡 **"Permission denied" al acceder al USB**

<details>
<summary><strong>💡 Configuración de permisos macOS</strong></summary>

**🔍 Causa:** macOS requiere permisos especiales para dispositivos USB

**✅ Solución:**

```bash
# Agregar usuario al grupo de desarrolladores
sudo dseditgroup -o edit -a $(whoami) -t user _developer

# Verificar que se agregó
dseditgroup -o read _developer | grep $(whoami)

# Cerrar terminal y abrir nueva
# Probar nuevamente
./program simple_blink
```

**💡 Alternativa si no funciona:**
- System Preferences → Security & Privacy → Privacy
- Unlock (click 🔒)
- Developer Tools → Add Terminal

</details>

---

<div style="background: linear-gradient(135deg, #fc466b 0%, #3f5efb 100%); padding: 20px; border-radius: 10px; color: white; margin: 20px 0;">

## 💻 **Problemas con el Script**

*Errores del comando `./program` y sus soluciones*

</div>

### 🟡 **"./program: Permission denied"**

<details>
<summary><strong>💡 Solución en 30 segundos</strong></summary>

**🔍 Causa:** El script no tiene permisos de ejecución

**✅ Solución:**

```bash
# 1️⃣ Hacer ejecutable
chmod +x program

# 2️⃣ Verificar permisos
ls -la program
# ✅ Debe mostrar: -rwxr-xr-x ... program

# 3️⃣ Probar
./program -h
```

**🎯 Si funciona, verás la ayuda colorida del script**

</details>

### 🟡 **"./program: No such file or directory"**

<details>
<summary><strong>💡 Problema de ubicación - solución inmediata</strong></summary>

**🔍 Causa:** No estás en la carpeta correcta

**✅ Solución:**

```bash
# 1️⃣ Ver dónde estás
pwd

# 2️⃣ Ir a la carpeta del proyecto
cd ~/Desktop/ATmega328P_Assembly

# 3️⃣ Verificar que el script existe
ls -la program
# ✅ Debe aparecer en la lista

# 4️⃣ Probar
./program simple_blink
```

</details>

### 🟡 **El script encuentra el archivo .asm pero falla al compilar**

<details>
<summary><strong>💡 Debug de código Assembly</strong></summary>

**🔍 Causa:** Error de sintaxis en tu código

**🔧 Diagnóstico manual:**

```bash
# Compilar manualmente para ver errores detallados
avr-gcc -mmcu=atmega328p -x assembler-with-cpp -c src/mi_archivo.asm -o build/mi_archivo.o
```

**🔍 Errores más comunes:**

| Error | Causa | Solución |
|:------|:------|:---------|
| `fatal error: avr/io.h: No such file` | Falta include | Agregar `#include <avr/io.h>` |
| `undefined reference to 'main'` | Falta etiqueta main | Agregar `main:` |
| `Error: unknown opcode` | Instrucción mal escrita | Revisar sintaxis |

**📝 Template básico que siempre funciona:**
```assembly
#include <avr/io.h>

.text
.global main

main:
    ; Tu código aquí
    rjmp main
```

</details>

---

<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; color: white; margin: 20px 0;">

## 📝 **Problemas con VS Code**

*Syntax highlighting y configuración*

</div>

### 🟡 **No veo colores en Assembly**

<details>
<summary><strong>💡 Instalación automática de extensiones</strong></summary>

**✅ Script de instalación completa:**

```bash
# Extensiones obligatorias
code --install-extension ms-vscode.cpptools
code --install-extension 13xforever.language-x86-64-assembly

# Verificar instalación
code --list-extensions | grep -E "(cpptools|assembly)"
```

**🎨 Configuración manual si falla:**
1. Abrir VS Code
2. `Cmd+Shift+X` (Extensions)
3. Buscar "Assembly"
4. Instalar "x86 and x86_64 Assembly"

</details>

### 🟡 **Archivos .asm no se reconocen**

<details>
<summary><strong>💡 Asociación manual de archivos</strong></summary>

**✅ Configuración paso a paso:**

1. Abrir cualquier archivo `.asm` en VS Code
2. Click en **"Plain Text"** (esquina inferior derecha)
3. Escribir "Assembly" en el buscador
4. Seleccionar **"Assembly (x86_64)"**
5. VS Code recordará la asociación

**⚙️ O crear configuración permanente:**

Crear `.vscode/settings.json`:
```json
{
    "files.associations": {
        "*.asm": "asm-intel-x86-generic"
    }
}
```

</details>

### 🟡 **IntelliSense no funciona**

<details>
<summary><strong>💡 Configuración avanzada de IntelliSense</strong></summary>

**✅ Crear `.vscode/c_cpp_properties.json`:**

```json
{
    "configurations": [
        {
            "name": "AVR",
            "includePath": [
                "${workspaceFolder}/**",
                "/usr/local/avr/include/**",
                "/opt/homebrew/avr/include/**"
            ],
            "defines": [
                "__AVR_ATmega328P__"
            ],
            "compilerPath": "/usr/local/bin/avr-gcc",
            "cStandard": "c11",
            "intelliSenseMode": "gcc-x64"
        }
    ],
    "version": 4
}
```

</details>

---

<div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 20px; border-radius: 10px; color: white; margin: 20px 0;">

## 🔄 **Problemas de Workflow**

*Make, archivos y estructura del proyecto*

</div>

### 🟡 **Make no funciona**

<details>
<summary><strong>💡 Problemas con Makefile</strong></summary>

**🔍 Causa:** Makefile faltante o corrupto

**✅ Solución:**

```bash
# 1️⃣ Verificar que existe
ls -la Makefile

# 2️⃣ Si no existe o está vacío, reclone repositorio
cd ~/Desktop
rm -rf ATmega328P_Assembly
git clone https://github.com/blorenzo-ceibal/ATmega328P_Assembly.git
cd ATmega328P_Assembly
```

</details>

### 🟡 **"No rule to make target"**

<details>
<summary><strong>💡 Archivo no existe</strong></summary>

**🔍 Causa:** Intentas compilar un archivo que no existe

**✅ Solución:**

```bash
# Ver archivos disponibles
ls src/

# Usar nombres exactos (sin .asm al final)
./program simple_blink  # ✅ Correcto
./program simple_blink.asm  # ❌ Error común
```

</details>

### 🟡 **El LED parpadea incorrectamente**

<details>
<summary><strong>💡 Calibración de delays</strong></summary>

**🔍 Causa:** Delays calibrados para diferente frecuencia

**🔧 Verificar frecuencia del cristal:**
```bash
# Leer fusibles
avrdude -c xplainedmini -p atmega328p -P usb -U lfuse:r:-:h
```

**✅ Fusible bajo correcto para 16MHz:** `0xFF`

**💡 Ajustar delays en código si es necesario**

</details>

---

<div style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%); padding: 20px; border-radius: 10px; color: #333; margin: 20px 0; border: 2px solid #ff6b6b;">

## 🆘 **Reset Completo**

*Cuando todo falla, esto siempre funciona*

</div>

### 🚨 **Procedimiento de Emergencia**

<details>
<summary><strong>🔥 Script automático de reset total</strong></summary>

**📋 Copia y pega este bloque completo:**

```bash
#!/bin/bash
echo "🧹 Iniciando reset completo..."

# Limpiar todo
echo "1️⃣ Removiendo herramientas..."
brew uninstall avr-gcc avrdude 2>/dev/null
brew untap osx-cross/avr 2>/dev/null

# Reinstalar
echo "2️⃣ Reinstalando herramientas..."
brew tap osx-cross/avr
brew install avr-gcc avrdude

# Reclone repositorio
echo "3️⃣ Actualizando repositorio..."
cd ~/Desktop
rm -rf ATmega328P_Assembly 2>/dev/null
git clone https://github.com/blorenzo-ceibal/ATmega328P_Assembly.git
cd ATmega328P_Assembly
chmod +x program

# Test final
echo "4️⃣ Probando configuración..."
avr-gcc --version
echo "✅ Herramientas reinstaladas"

ls -la program
echo "✅ Script configurado"

echo "🎉 Reset completo terminado"
echo "💡 Ahora prueba: ./program simple_blink"
```

</details>

---

## 🔗 **Ayuda Adicional**

### � **¿Dónde obtener más ayuda?**

| Canal | Descripción | Link |
|:------|:------------|:-----|
| 🐛 **Issues** | Reportar bugs | [GitHub Issues](https://github.com/blorenzo-ceibal/ATmega328P_Assembly/issues) |
| 💬 **Discusiones** | Preguntas generales | [GitHub Discussions](https://github.com/blorenzo-ceibal/ATmega328P_Assembly/discussions) |
| 📧 **Email** | Soporte directo | blorenzo@ceibal.edu.uy |

### 🎯 **Tips para reportar problemas**

**🔍 Incluye siempre:**
- Versión de macOS: `sw_vers`
- Tipo de Mac: `uname -m`
- Versión de herramientas: `brew --version`, `avr-gcc --version`
- Comando exacto que falla
- Mensaje de error completo
- Lo que intentaste antes

---

<div align="center" style="margin-top: 50px; padding: 20px; background: #f8f9fa; border-radius: 10px;">

## 💡 **¿Este FAQ te ayudó?**

**⭐ Si resolviste tu problema, considera:**
- ⭐ Dar star al repositorio en GitHub
- 🔄 Compartir con otros desarrolladores
- 💬 Dejar feedback en Discussions

**¡Tu experiencia ayuda a mejorar el tutorial para todos!**

</div>

---

**⬅️ Volver al índice:** **[README.md](../README.md)**
