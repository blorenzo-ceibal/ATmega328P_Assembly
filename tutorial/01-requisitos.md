# ✅ 01 - Verificar Requisitos

> **⏱️ Tiempo estimado:** 3 minutos
> **🎯 Objetivo:** Verificar que tienes todo lo necesario antes de empezar

## 📋 **Checklist de Requisitos**

### 💻 **Software - Tu Mac debe tener:**

- [ ] **macOS 10.14 (Mojave) o superior**
  ```bash
  # Verificar versión
  sw_vers
  ```

- [ ] **Acceso de administrador** (para instalar software)

- [ ] **Conexión a Internet** (para descargar herramientas)

- [ ] **Terminal/zsh funcionando**
  ```bash
  # Este comando debe funcionar
  echo $SHELL
  # Deberías ver: /bin/zsh
  ```

### 🔧 **Hardware Necesario:**

- [ ] **ATmega328P Xplain Mini** (la placa azul de Microchip)
- [ ] **Cable USB A a Micro-B** (para conectar la Xplain Mini)
- [ ] **Puerto USB libre** en tu Mac

### 📁 **Espacio en Disco:**

- [ ] **~500 MB libres** para herramientas AVR + VS Code
  ```bash
  # Verificar espacio disponible
  df -h ~
  ```

## 🔍 **Verificaciones Rápidas**

### ✅ **1. Tu Mac está actualizado**
```bash
# Ver versión del sistema
sw_vers

# Debería mostrar algo como:
# ProductName: macOS
# ProductVersion: 12.x.x o superior
```

### ✅ **2. Terminal funciona correctamente**
```bash
# Abrir Terminal (Cmd + Espacio → "Terminal")
# Ejecutar este comando:
whoami

# Debe mostrar tu nombre de usuario
```

### ✅ **3. Hardware conectado**
- Conecta tu **Xplain Mini** al Mac
- El LED de power debe encenderse (luz verde/azul)
- macOS debe detectar un nuevo dispositivo USB

```bash
# Verificar detección USB (comando opcional por ahora)
system_profiler SPUSBDataType | grep -i "microchip\|atmel\|edbg"
```

## 🚨 **Si algo falla aquí:**

### ❌ **macOS muy viejo (anterior a 10.14)**
- **Solución:** Actualizar macOS o usar una Mac más nueva
- **Alternativa:** Usar una máquina virtual con macOS más reciente

### ❌ **No tienes permisos de administrador**
- **Solución:** Contactar al administrador del sistema
- **Para estudiantes:** Hablar con el departamento de IT de tu universidad

### ❌ **Xplain Mini no se detecta**
- **Revisar:** Cable USB (probar con otro cable)
- **Revisar:** Puerto USB (probar otro puerto)
- **Verificar:** LED de power encendido en la Xplain Mini

## ✅ **Checkpoint - ¿Todo listo?**

Si puedes marcar ✅ todos los puntos de arriba, **¡estás listo para continuar!**

### 📊 **Tu progreso actual:**
- ✅ Requisitos verificados
- ⏳ Instalación básica (siguiente)
- ⏳ Workflow diario
- ⏳ Configurar VS Code
- ⏳ Primer proyecto

---

## 📝 **Notas para Estudiantes**

**¿Por qué necesitamos esto?**
- **macOS actualizado:** Las herramientas AVR requieren librerías modernas
- **Permisos admin:** Para instalar Homebrew y herramientas de desarrollo
- **Xplain Mini:** Es el hardware oficial de Microchip, más confiable que clones
- **Cable USB bueno:** Los cables baratos pueden causar problemas de comunicación

**¿Es normal tener dudas?** ¡Por supuesto! Este es tu primer setup profesional de microcontroladores.

---

**✅ Todo verificado →** **[02-instalacion-basica.md](02-instalacion-basica.md)**

**⬅️ Regresar al índice:** **[README.md](README.md)**
