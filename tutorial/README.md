# 🚀 Tutorial ATmega328P en Mac - Guía Completa

## 👋 ¡Bienvenido estudiante de Ingeniería!

Esta guía te ayudará a **migrar de Microchip Studio (Windows) a un entorno profesional en macOS** para programar microcontroladores ATmega328P en Assembly usando VS Code.

### 🎯 **¿Qué vas a lograr?**
- ✅ Configurar un entorno de desarrollo **más rápido** que Microchip Studio
- ✅ Programar ATmega328P con **un solo comando**: `program archivo.asm`
- ✅ Tener **syntax highlighting** y autocompletado profesional
- ✅ **Workflow optimizado** para desarrollo de microcontroladores
- ✅ **Estructura de proyecto profesional** con carpetas organizadas

### 📁 **Estructura final que tendrás:**
```
tu_proyecto/
├── src/                     # 📝 Tu código fuente (.asm)
├── build/                   # 🔧 Archivos generados (.hex, .elf, .o)
├── Makefile                 # ⚙️ Automatización de compilación
├── program                  # 🚀 Script mágico para programar
└── .gitignore              # 🗑️ Mantiene tu repo limpio
```

### ⏱️ **Tiempo total estimado:** 45-60 minutos

---

## 📋 **Índice del Tutorial**

### 🔰 **Configuración Básica** (20 min)
1. **[01-requisitos.md](01-requisitos.md)** *(3 min)*
   - ✅ Verificar que tu Mac está listo
   - ✅ Hardware necesario (Xplain Mini)

2. **[02-instalacion-basica.md](02-instalacion-basica.md)** *(10 min)*
   - 🛠️ Homebrew + AVR toolchain
   - ✅ Verificaciones paso a paso

3. **[03-workflow-diario.md](03-workflow-diario.md)** *(7 min)*
   - ⚡ **¡Los comandos que cambiarán tu vida!**
   - 🚀 Ver qué puedes hacer inmediatamente

### 🔧 **Configuración Avanzada** (25 min)
4. **[04-configurar-vscode.md](04-configurar-vscode.md)** *(12 min)*
   - 💻 VS Code + extensiones esenciales
   - 🎨 Syntax highlighting perfecto

5. **[05-primer-proyecto.md](05-primer-proyecto.md)** *(10 min)*
   - 🎯 Tu primer LED parpadeante
   - ✅ Verificación completa del setup

6. **[06-hardware-xplain.md](06-hardware-xplain.md)** *(3 min)*
   - 🔌 Configuración específica de Xplain Mini
   - 🔍 Detectar y configurar tu hardware

### 🚀 **Uso Avanzado**
7. **[07-proyectos-ejemplo.md](07-proyectos-ejemplo.md)**
   - 📚 Más ejemplos para practicar
   - 💡 Ideas para expandir tus conocimientos

---

## 📚 **Anexos de Referencia**

- **[makefile-completo.md](anexos/makefile-completo.md)** - Makefile documentado línea por línea
- **[script-program.md](anexos/script-program.md)** - Script `program` explicado en detalle
- **[comandos-referencia.md](anexos/comandos-referencia.md)** - Cheatsheet de todos los comandos
- **[troubleshooting.md](anexos/troubleshooting.md)** - 🔧 Solución de problemas comunes
- **[equivalencias-studio.md](anexos/equivalencias-studio.md)** - Comparación con Microchip Studio

---

## 🎯 **Rutas de Aprendizaje Sugeridas**

### 🟢 **Principiante Total**
Sigue: 01 → 02 → 03 → 04 → 05 → 06 → ¡Listo!

### 🟡 **Ya tienes algo configurado**
Salta directo a: 03 (workflow) → 05 (primer proyecto) → complementar lo que falte

### 🔴 **Experto que migra**
Ve a: 02 (instalación) → 03 (workflow) → anexos de referencia

---

## ⚡ **Quick Start - Solo 3 comandos**

¿Tienes prisa? Estos 3 comandos te dan un entorno básico funcional:

```bash
# 1. Instalar herramientas
brew tap osx-cross/avr && brew install avr-gcc avrdude

# 2. Crear proyecto de prueba
echo 'Código de prueba aquí' > test.asm

# 3. Programar (después de configurar)
program test.asm
```

---

## 🏆 **Al Completar Este Tutorial Tendrás:**

- ✅ **Entorno profesional** configurado en Mac
- ✅ **Workflow más rápido** que Microchip Studio
- ✅ **Comandos automáticos** para compilar y programar
- ✅ **Syntax highlighting** para Assembly AVR
- ✅ **Base sólida** para proyectos más complejos

---

## 💡 **Para Profesores y Estudiantes**

Este tutorial está diseñado para:
- **Estudiantes de Ingeniería Informática** (primeros años)
- **Migración desde Microchip Studio**
- **Desarrollo profesional en macOS**
- **Aprendizaje de herramientas modernas**

**¿Listo para empezar?** 👉 **[01-requisitos.md](01-requisitos.md)**

---

*💡 Tip: Cada archivo tiene una duración estimada. ¡No te presiones! Puedes pausar en cualquier momento y continuar después.*
