# 📚 07 - Proyectos Ejemplo

> **⏱️ Tiempo estimado:** Variable (cada proyecto 5-10 min)
> **🎯 Objetivo:** Proyectos adicionales para practicar y expandir conocimientos
> **📋 Prerequisito:** Haber completado [06-hardware-xplain.md](06-hardware-xplain.md) ✅

## 🎯 **¡Tu Setup Está Completo!**

Con tu entorno configurado, ahora puedes crear **cualquier proyecto** para ATmega328P. Aquí tienes ejemplos progresivos para seguir aprendiendo.

---

## 🚀 **Proyecto 1: Explorar los Ejemplos Incluidos (5 min)**

### 📝 **Probar los programas incluidos:**

```bash
# LED básico (ya probado)
./program simple_blink

# LED con efectos más complejos
./program blink2

# Ver diferencias en el código
code src/simple_blink.asm
code src/blink2.asm
```

### 💡 **Comparar los dos programas:**

- **simple_blink.asm:** LED parpadea de forma simple y constante
- **blink2.asm:** LED con patrones más complejos y efectos visuales

**🎯 Ejercicio:** Modifica los delays en `blink2.asm` para cambiar la velocidad del parpadeo.

    dec r18
    brne middle_loop

    dec r20
    brne outer_loop

    pop r16
    pop r17
    pop r18
    ret
EOF
```

### 🚀 **Programar y probar:**

```bash
# Compilar y programar
./program blink_variable

# ¡El LED debe parpadear cada vez más rápido!
```

---

## 🔘 **Proyecto 2: Lectura de Botón (7 min)**

### 📝 **Código - button_test.asm:**

```bash
cat > button_test.asm << 'EOF'
; ===============================================
; LECTURA DE BOTÓN - ATmega328P
; ===============================================
; LED se enciende mientras se presiona el botón
; Botón en PB0, LED en PB5

#include <avr/io.h>

.section .text
.global main

main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ; Configurar pines
    ldi r16, (1<<DDB5)      ; PB5 como salida (LED)
    out _SFR_IO_ADDR(DDRB), r16

    ; PB0 como entrada con pull-up interno
    ldi r16, (1<<PORTB0)    ; Activar pull-up en PB0
    out _SFR_IO_ADDR(PORTB), r16

main_loop:
    ; Leer estado del botón (PB0)
    in r17, _SFR_IO_ADDR(PINB)
    andi r17, (1<<PINB0)    ; Aislar bit 0

    ; ¿Botón presionado? (0 cuando se presiona por pull-up)
    breq button_pressed     ; Si es 0, botón presionado

button_released:
    ; Apagar LED
    cbi _SFR_IO_ADDR(PORTB), PORTB5
    rjmp main_loop

button_pressed:
    ; Encender LED
    sbi _SFR_IO_ADDR(PORTB), PORTB5
    rjmp main_loop
EOF
```

### 🔧 **Hardware necesario:**
- **Conectar botón** entre PB0 (pin 14) y GND
- **O usar jumper** para simular botón (conectar/desconectar PB0 a GND)

### 🚀 **Programar y probar:**

```bash
./program button_test
# LED se enciende al presionar botón (o conectar PB0 a GND)
```

---

## 📡 **Proyecto 3: Comunicación Serie Simple (8 min)**

### 📝 **Código - serial_hello.asm:**

```bash
cat > serial_hello.asm << 'EOF'
; ===============================================
; COMUNICACIÓN SERIE SIMPLE - ATmega328P
; ===============================================
; Envía "Hello World!" cada segundo por UART

#include <avr/io.h>

.section .data
hello_msg: .ascii "Hello World!\r\n"
hello_msg_end:
.set MSG_LENGTH, hello_msg_end - hello_msg

.section .text
.global main

main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ; Configurar UART
    rcall uart_init

main_loop:
    ; Enviar mensaje
    rcall send_hello

    ; Delay 1 segundo
    rcall delay_1s

    rjmp main_loop

; Inicializar UART (9600 baud, 16MHz)
uart_init:
    ; Configurar baud rate (9600 bps @ 16MHz)
    ldi r16, 103            ; UBRR = (F_CPU/(16*BAUD)) - 1
    sts UBRR0L, r16
    ldi r16, 0
    sts UBRR0H, r16

    ; Habilitar transmisor
    ldi r16, (1<<TXEN0)
    sts UCSR0B, r16

    ; Configurar formato: 8 data bits, 1 stop bit
    ldi r16, (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, r16

    ret

; Enviar mensaje "Hello World!"
send_hello:
    push r16
    push r17
    push r28
    push r29

    ; Configurar puntero al mensaje
    ldi r28, lo8(hello_msg)
    ldi r29, hi8(hello_msg)
    ldi r17, MSG_LENGTH

send_loop:
    ; Cargar carácter
    ld r16, Y+

    ; Enviar carácter por UART
    rcall uart_send_char

    ; Decrementar contador
    dec r17
    brne send_loop

    pop r29
    pop r28
    pop r17
    pop r16
    ret

; Enviar un carácter por UART
; r16 contiene el carácter a enviar
uart_send_char:
    push r17

wait_tx_ready:
    lds r17, UCSR0A
    andi r17, (1<<UDRE0)
    breq wait_tx_ready

    sts UDR0, r16

    pop r17
    ret

; Delay aproximado de 1 segundo
delay_1s:
    push r18
    push r17
    push r16

    ldi r18, 82         ; ~1 segundo @ 16MHz
delay_1s_outer:
    ldi r17, 198
delay_1s_middle:
    ldi r16, 200
delay_1s_inner:
    dec r16
    brne delay_1s_inner
    dec r17
    brne delay_1s_middle
    dec r18
    brne delay_1s_outer

    pop r16
    pop r17
    pop r18
    ret
EOF
```

### 🚀 **Programar y probar:**

```bash
# 1. Programar el microcontrolador
./program serial_hello

# 2. Abrir monitor serie para ver los mensajes
make monitor

# O manualmente:
screen /dev/cu.usbmodem* 9600

# Deberías ver "Hello World!" cada segundo
# Para salir: Ctrl+A, luego K, luego Y
```

---

## 🎵 **Proyecto 4: Generador de Tonos (10 min)**

### 📝 **Código - tone_generator.asm:**

```bash
cat > tone_generator.asm << 'EOF'
; ===============================================
; GENERADOR DE TONOS - ATmega328P
; ===============================================
; Genera diferentes tonos en PB1 (pin 15)
; Conectar speaker o LED con resistencia

#include <avr/io.h>

.section .text
.global main

main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ; Configurar PB1 como salida (pin 15)
    ldi r16, (1<<DDB1)
    out _SFR_IO_ADDR(DDRB), r16

main_loop:
    ; Tono grave (DO)
    ldi r19, 120
    rcall play_tone
    rcall pause

    ; Tono medio (MI)
    ldi r19, 90
    rcall play_tone
    rcall pause

    ; Tono agudo (SOL)
    ldi r19, 60
    rcall play_tone
    rcall pause

    rjmp main_loop

; Reproducir tono
; r19 contiene el período (menor = más agudo)
play_tone:
    push r18
    push r17

    ldi r18, 200        ; Duración del tono

tone_loop:
    ; Pin alto
    sbi _SFR_IO_ADDR(PORTB), PORTB1

    ; Delay (determina frecuencia)
    mov r17, r19
delay_high:
    dec r17
    brne delay_high

    ; Pin bajo
    cbi _SFR_IO_ADDR(PORTB), PORTB1

    ; Delay (determina frecuencia)
    mov r17, r19
delay_low:
    dec r17
    brne delay_low

    dec r18
    brne tone_loop

    pop r17
    pop r18
    ret

; Pausa entre tonos
pause:
    push r18
    push r17

    ldi r18, 100
pause_outer:
    ldi r17, 255
pause_inner:
    dec r17
    brne pause_inner
    dec r18
    brne pause_outer

    pop r17
    pop r18
    ret
EOF
```

### 🔧 **Hardware para audio (opcional):**
- **Speaker pequeño** entre PB1 (pin 15) y GND
- **O LED con resistencia** para ver el patrón visualmente

### 🚀 **Programar y probar:**

```bash
./program tone_generator
# Deberías escuchar 3 tonos diferentes que se repiten
# O ver LED parpadeando a diferentes frecuencias
```

---

## 🔄 **Proyecto 5: Secuencia LED Multiple (8 min)**

### 📝 **Código - led_sequence.asm:**

```bash
cat > led_sequence.asm << 'EOF'
; ===============================================
; SECUENCIA DE LEDS - ATmega328P
; ===============================================
; Secuencia tipo "Knight Rider" en pines PB0-PB5

#include <avr/io.h>

.section .text
.global main

main:
    ; Configurar stack pointer
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ; Configurar todos los pines de PORTB como salida
    ldi r16, 0xFF
    out _SFR_IO_ADDR(DDRB), r16

    ; Inicializar patrón
    ldi r19, 0b00000001     ; Empezar con primer LED

main_loop:
    ; Secuencia hacia la derecha
    ldi r20, 6              ; 6 pasos (PB0 a PB5)

right_sequence:
    ; Mostrar patrón actual
    out _SFR_IO_ADDR(PORTB), r19
    rcall delay_200ms

    ; Rotar a la derecha
    lsl r19                 ; Shift left (hacia PB siguiente)

    dec r20
    brne right_sequence

    ; Secuencia hacia la izquierda
    ldi r20, 6

left_sequence:
    ; Rotar a la izquierda
    lsr r19                 ; Shift right (hacia PB anterior)

    ; Mostrar patrón actual
    out _SFR_IO_ADDR(PORTB), r19
    rcall delay_200ms

    dec r20
    brne left_sequence

    rjmp main_loop

; Delay de ~200ms
delay_200ms:
    push r18
    push r17
    push r16

    ldi r18, 17
delay_outer:
    ldi r17, 198
delay_middle:
    ldi r16, 200
delay_inner:
    dec r16
    brne delay_inner
    dec r17
    brne delay_middle
    dec r18
    brne delay_outer

    pop r16
    pop r17
    pop r18
    ret
EOF
```

### 🚀 **Programar y probar:**

```bash
./program led_sequence
# El LED integrado se moverá en patrón de ida y vuelta
# Si tienes LEDs externos en PB0-PB4, verás el efecto completo
```

---

## 📊 **Comandos Útiles para Todos los Proyectos**

### 🔧 **Gestión de proyectos:**

```bash
# Compilar cualquier proyecto
./program nombre_proyecto

# Usar Makefile específico
make program-xplain-nombre_proyecto
make compile-nombre_proyecto

# Ver tamaño de todos los proyectos
for f in *.asm; do echo "=== $f ==="; make compile-${f%.asm} && avr-size --format=avr --mcu=atmega328p ${f%.asm}.elf; done

# Limpiar todo
make clean
rm -f *.hex *.elf *.o *.lst
```

### 🔍 **Debugging y análisis:**

```bash
# Ver código generado (listado)
avr-objdump -h -S programa.elf > programa.lst
cat programa.lst

# Comparar tamaños de programas
ls -la *.hex

# Monitor serie para debugging
make monitor
```

---

## 🚀 **Ideas para Proyectos Más Avanzados**

### 🎯 **Nivel Intermedio:**
- **PWM para control de brillo** de LED
- **Lectura de sensores analógicos** (ADC)
- **Comunicación I2C** básica
- **Timer interrupts** para multitarea simple

### 🎯 **Nivel Avanzado:**
- **Protocolo SPI** para comunicación con periféricos
- **Máquina de estados** para comportamientos complejos
- **Comunicación serie bidireccional** con comandos
- **Interface con LCD** 16x2

### 🎯 **Proyectos de Universidad:**
- **Sistema de control de temperatura**
- **Data logger** con memoria EEPROM
- **Interface de usuario** con botones y display
- **Comunicación wireless** con módulos RF

---

## ✅ **¡Tu Arsenal Completo Está Listo!**

### 🏆 **Lo que has logrado:**
- ✅ **Setup profesional** Mac para ATmega328P
- ✅ **5 proyectos funcionales** de ejemplo
- ✅ **Workflow optimizado** para desarrollo rápido
- ✅ **Base sólida** para proyectos universitarios
- ✅ **Herramientas profesionales** nivel industria

### 🚀 **Tu comando mágico para cualquier proyecto:**

```bash
# Para siempre:
./program mi_nuevo_proyecto.asm
```

**¡Eso es todo! Ahora eres completamente independiente para desarrollar en ATmega328P en Mac.**

---

**✅ ¡Tutorial COMPLETO! 🎉**

**🏠 Regresar al índice:** **[README.md](README.md)**
**📚 Ver anexos:** **[anexos/](anexos/)**
