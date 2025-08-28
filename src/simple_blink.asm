;===============================================================================
; EJEMPLO SIMPLIFICADO - LED Blink básico
; Solo parpadea un LED - ideal para empezar
; Compatible con avr-gcc (sintaxis AT&T/gas)
;===============================================================================

#include <avr/io.h>

.equ LED_PIN, 5             ; LED en PB5 (Arduino pin 13)

.text
.global main

main:
    ; Configurar stack pointer
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16

    ; Configurar PB5 como salida
    sbi _SFR_IO_ADDR(DDRB), LED_PIN

main_loop:
    ; Encender LED
    sbi _SFR_IO_ADDR(PORTB), LED_PIN
    rcall delay
    
    ; Apagar LED
    cbi _SFR_IO_ADDR(PORTB), LED_PIN
    rcall delay
    
    ; Repetir
    rjmp main_loop

; Rutina de delay simple
delay:
    ldi r18, 20         ; Delay aproximado de 500ms
delay_outer:
    ldi r19, 200
delay_middle:
    ldi r20, 250
delay_inner:
    nop
    dec r20
    brne delay_inner
    dec r19
    brne delay_middle
    dec r18
    brne delay_outer
    ret
