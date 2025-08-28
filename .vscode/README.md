# 📋 VS CODE SETTINGS para ATmega328P Assembly

## Configuración completa de Visual Studio Code para desarrollo en Assembly

Esta carpeta contiene todos los archivos de configuración necesarios para VS Code.

---

## 📁 Estructura de configuración

```
.vscode/
├── tasks.json          # Tareas de compilación y programación
├── launch.json         # Configuración de debugging/launch
├── settings.json       # Configuración del workspace
└── keybindings.json    # Atajos de teclado personalizados
```

---

## ⚡ Atajos de teclado principales

| Atajo | Acción |
|-------|--------|
| `Cmd + Shift + B` | Compilar (Build) |
| `Cmd + F5` | Compilar proyecto |
| `Cmd + Shift + F5` | Programar ATmega328P |
| `F5` | Build y Program |
| `Cmd + Shift + M` | Monitor Serie |

---

## 🛠️ Tareas disponibles

- **Build ASM** - Compilar el proyecto
- **Program ATmega328P (Xplain Mini)** - Programar vía Xplain Mini
- **Program ATmega328P (Arduino)** - Programar vía bootloader Arduino
- **Clean** - Limpiar archivos generados
- **Serial Monitor** - Abrir monitor serie
- **Test Connection** - Verificar conexión con hardware

---

## 🎯 Uso rápido

1. **Para compilar**: `Cmd + Shift + P` → "Tasks: Run Build Task"
2. **Para programar**: `Cmd + Shift + P` → "Tasks: Run Task" → "Program ATmega328P"
3. **Para monitor serie**: `Cmd + Shift + P` → "Tasks: Run Task" → "Serial Monitor"

---

## 🔧 Personalización

Puedes modificar estos archivos según tus necesidades:

- **`tasks.json`** - Agregar nuevas tareas o modificar comandos
- **`settings.json`** - Cambiar configuración del editor
- **`keybindings.json`** - Personalizar atajos de teclado

Los archivos están documentados internamente para facilitar la personalización.
