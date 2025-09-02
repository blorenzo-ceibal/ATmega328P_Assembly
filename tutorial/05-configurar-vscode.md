# 💻 04 - Configurar VS Code

> **⏱️ Tiempo estimado:** 12 minutos
> **🎯 Objetivo:** Configurar VS Code con syntax highlighting perfecto y extensiones esenciales
> **📋 Prerequisito:** Haber completado [03-workflow-diario.md](03-workflow-diario.md)

## 🚀 **PASO 1: Instalar VS Code (2 min)**

### 🔧 **Si no tienes VS Code:**

```bash
# Instalar VS Code usando Homebrew
brew install --cask visual-studio-code
```

### 🔧 **Si ya tienes VS Code:**

```bash
# Verificar que está actualizado
code --version

# Debería mostrar Version 1.x.x o superior
```

---

## 🧩 **PASO 2: Instalar Extensiones Esenciales (5 min)**

**¿Por qué extensiones?** Para que tu código Assembly se vea **colorido y profesional**, con autocompletado y detección de errores.

### 📋 **Lista de extensiones que vamos a instalar:**

#### 🔧 **OBLIGATORIAS (las necesitas sí o sí):**

1. **C/C++** - IntelliSense y headers AVR
2. **x86 and x86_64 Assembly** - Syntax highlighting general
3. **AVR Support** - Soporte específico para ATmega328P

#### 🚀 **RECOMENDADAS (hacen la vida más fácil):**

4. **ASM Code Lens** - Navegación avanzada
5. **Code Runner** - Ejecutar comandos desde VS Code
6. **Makefile Tools** - Soporte para Makefiles
7. **Better Comments** - Comentarios mejorados
8. **Hex Editor** - Ver archivos .hex generados

### 🔧 **Instalar todas las extensiones automáticamente:**

```bash
# === EXTENSIONES OBLIGATORIAS ===
# C/C++ para headers AVR y autocompletado
code --install-extension ms-vscode.cpptools

# Assembly syntax highlighting general
code --install-extension 13xforever.language-x86-64-assembly

# Soporte específico para microcontroladores AVR
code --install-extension rockcat.avr-support

# === EXTENSIONES RECOMENDADAS ===
# Navegación avanzada en código Assembly
code --install-extension maziac.asm-code-lens

# Utilidades que facilitan el desarrollo
code --install-extension formulahendry.code-runner
code --install-extension ms-vscode.makefile-tools
code --install-extension aaron-bond.better-comments
code --install-extension ms-vscode.hexeditor

# Verificar que se instalaron correctamente
code --list-extensions | grep -E "(cpptools|assembly|avr-support|asm-code-lens)"
```

**⏳ Esto tardará 2-3 minutos.** Verás mensajes de instalación.

---

## 🎨 **PASO 3: Verificar Syntax Highlighting (3 min)**

Vamos a probar que los colores funcionan correctamente:

### 🔧 **Crear archivo de prueba:**

```bash
# Crear archivo Assembly de prueba
cd ~/Desktop
cat > test_colores.asm << 'EOF'
; ===============================================
; TEST DE SYNTAX HIGHLIGHTING - ATmega328P
; ===============================================

#include <avr/io.h>

.section .text
.global main

main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ; Configurar PB5 como salida (LED)
    ldi r17, (1<<DDB5)
    out _SFR_IO_ADDR(DDRB), r17

loop:
    ; Encender LED
    sbi _SFR_IO_ADDR(PORTB), PORTB5

    ; Delay simple
    ldi r18, 255
delay:
    dec r18
    brne delay

    ; Apagar LED
    cbi _SFR_IO_ADDR(PORTB), PORTB5

    ; Otro delay
    ldi r18, 255
delay2:
    dec r18
    brne delay2

    rjmp loop
EOF
```

### 🎨 **Abrir en VS Code y verificar colores:**

```bash
# Abrir el archivo en VS Code
code test_colores.asm
```

### ✅ **DEBES ver estos colores:**

- 🟦 **Azul:** Directivas (`.section`, `.global`, `#include`)
- 🟪 **Púrpura/Magenta:** Instrucciones (`ldi`, `out`, `sbi`, `cbi`, `rjmp`)
- 🟩 **Verde:** Registros (`r16`, `r17`, `r18`) y comentarios (`;`)
- 🟨 **Amarillo:** Labels (`main:`, `loop:`, `delay:`)
- 🟦 **Cyan:** Constantes (`RAMEND`, `DDB5`, `PORTB5`)

### 🔧 **Si NO ves colores:**

```bash
# Verificar que las extensiones están activas
code --list-extensions --show-versions

# Forzar detección del lenguaje
# En VS Code: Cmd + Shift + P → "Change Language Mode" → "Assembly"
```

---

## ⚙️ **PASO 4: Configurar Preferencias de VS Code (2 min)**

### 🔧 **Configuración básica para Assembly:**

```bash
# Abrir configuración de VS Code
code --command "workbench.action.openSettings"
```

**En la interfaz de configuración, buscar y configurar:**

- **Files: Auto Save** → `afterDelay`
- **Editor: Tab Size** → `4`
- **Editor: Insert Spaces** → `✓ activado`
- **Editor: Word Wrap** → `on`

### 🔧 **Configuración avanzada (opcional):**

Si quieres configuración más específica, crear archivo de configuración:

```bash
# Crear carpeta de configuración en tu proyecto
mkdir -p ~/Desktop/ATmega328P_Assembly/.vscode

# Crear configuración específica
cat > ~/Desktop/ATmega328P_Assembly/.vscode/settings.json << 'EOF'
{
    "files.associations": {
        "*.asm": "asm-intel-x86-generic",
        "*.inc": "asm-intel-x86-generic",
        "*.s": "asm-intel-x86-generic"
    },
    "code-runner.executorMap": {
        "asm": "cd $dir && program $fileNameWithoutExt"
    },
    "terminal.integrated.defaultProfile.osx": "zsh",
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.wordWrap": "on",
    "files.autoSave": "afterDelay"
}
EOF
```

---

## 🎯 **PASO 5: Configurar Temas de Colores (opcional)**

### 🎨 **Temas recomendados para Assembly:**

```bash
# En VS Code, abrir selector de temas:
# Cmd + Shift + P → "Preferences: Color Theme"
```

**Mejores temas para código Assembly:**
- **Dark+ (default dark)** - Viene por defecto, muy bueno
- **Monokai** - Colores vibrantes, fácil de leer
- **One Dark Pro** - Profesional, usado por muchos developers

---

## ⚡ **PASO 6: Configurar Atajos de Teclado (opcional)**

### 🔧 **Atajos útiles para microcontroladores:**

```bash
# Abrir configuración de atajos:
# Cmd + Shift + P → "Preferences: Open Keyboard Shortcuts (JSON)"
```

**Agregar estos atajos útiles:**

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

## ✅ **Checkpoint - Verificar Configuración**

### 🔍 **Tests que DEBEN funcionar:**

1. **Abrir archivo .asm** → Se ve con colores
2. **Autocompletado** → Al escribir `ldi ` sugiere registros
3. **Error highlighting** → Líneas rojas si hay errores de sintaxis
4. **Navegación** → Cmd+Click en labels funciona

### 🔧 **Test práctico:**

```bash
# 1. Abrir VS Code en tu proyecto
code ~/Desktop/ATmega328P_Assembly

# 2. Crear archivo nuevo
touch mi_test.asm

# 3. Escribir código de prueba
echo '; Mi primer programa
.section .text
.global main
main:
    ldi r16, 0xFF' > mi_test.asm

# 4. Abrir en VS Code
code mi_test.asm

# 5. Verificar colores y autocompletado
```

### 📊 **Tu progreso actual:**
- ✅ Requisitos verificados
- ✅ Instalación básica completa
- ✅ Workflow diario visualizado
- ✅ **VS Code configurado profesionalmente**
- ⏳ Primer proyecto (¡casi llegamos!)

---

## 🧹 **Limpiar archivos de prueba:**

```bash
# Remover archivos temporales
rm ~/Desktop/test_colores.asm
rm ~/Desktop/mi_test.asm
```

---

## 📝 **Para Estudiantes - ¿Qué acabas de configurar?**

**VS Code ahora es tu IDE profesional para microcontroladores:**

- ✅ **Syntax highlighting** específico para AVR Assembly
- ✅ **Autocompletado** de instrucciones y registros
- ✅ **Error detection** en tiempo real
- ✅ **Code navigation** entre labels y funciones
- ✅ **Integración** con herramientas de compilación
- ✅ **Temas profesionales** optimizados para código

**¿Es mejor que Microchip Studio?**
- **Más rápido** al abrir y trabajar
- **Más flexible** con cualquier tipo de archivo
- **Más moderno** con actualizaciones constantes
- **Más extensible** con miles de extensiones disponibles
- **Multi-platform** funciona igual en Mac, Linux, Windows

---

**✅ VS Code configurado →** **[05-primer-proyecto.md](05-primer-proyecto.md)**

**⬅️ Paso anterior:** **[03-workflow-diario.md](03-workflow-diario.md)**
**🏠 Índice:** **[README.md](README.md)**
