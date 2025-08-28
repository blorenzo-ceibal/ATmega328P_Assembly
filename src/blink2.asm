;===============================================================================
; EJEMPLO SIMPLIFICADO - LED Blink básico
; Solo parpadea un LED - ideal para empezar
; Compatible con sintaxis clásica de AVR Assembly
;===============================================================================

.include "m328pdef.inc"

;===============================================================================
; DEFINICIONES Y CONSTANTES
;===============================================================================
.equ LED_PIN, 5          ; LED en PB5 (Arduino pin 13)

;===============================================================================
; CÓDIGO PRINCIPAL
;===============================================================================
.text
.global main

main:
    ; Configurar stack pointer
    ldi r16, lo8(RAMEND)
    out SPL, r16
    ldi r16, hi8(RAMEND)
    out SPH, r16

    ; Configurar PB5 como salida
    sbi DDRB, LED_PIN

main_loop:
    ; Encender LED
    sbi PORTB, LED_PIN
    rcall delay

    ; Apagar LED
    cbi PORTB, LED_PIN
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
