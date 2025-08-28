;===============================================================================
; Definiciones de registros para ATmega328P
; Compatible con avr-gcc assembler
; Version simplificada para evitar conflictos de sintaxis
;===============================================================================

;===============================================================================
; REGISTROS DE I/O - PUERTO B
;===============================================================================
.equ PINB,   0x03     ; Port B Input Pins
.equ DDRB,   0x04     ; Port B Data Direction Register
.equ PORTB,  0x05     ; Port B Data Register

; Bits del Puerto B
.equ PB0,    0        ; Port B bit 0
.equ PB1,    1        ; Port B bit 1
.equ PB2,    2        ; Port B bit 2
.equ PB3,    3        ; Port B bit 3
.equ PB4,    4        ; Port B bit 4
.equ PB5,    5        ; Port B bit 5 (Arduino pin 13 - LED)
.equ PB6,    6        ; Port B bit 6 (XTAL1)
.equ PB7,    7        ; Port B bit 7 (XTAL2)

;===============================================================================
; REGISTROS DE I/O - PUERTO C
;===============================================================================
.equ PINC,   0x06     ; Port C Input Pins
.equ DDRC,   0x07     ; Port C Data Direction Register
.equ PORTC,  0x08     ; Port C Data Register

; Bits del Puerto C
.equ PC0,    0        ; Port C bit 0 (ADC0)
.equ PC1,    1        ; Port C bit 1 (ADC1)
.equ PC2,    2        ; Port C bit 2 (ADC2)
.equ PC3,    3        ; Port C bit 3 (ADC3)
.equ PC4,    4        ; Port C bit 4 (ADC4/SDA)
.equ PC5,    5        ; Port C bit 5 (ADC5/SCL)
.equ PC6,    6        ; Port C bit 6 (RESET)

;===============================================================================
; REGISTROS DE I/O - PUERTO D
;===============================================================================
.equ PIND,   0x09     ; Port D Input Pins
.equ DDRD,   0x0A     ; Port D Data Direction Register
.equ PORTD,  0x0B     ; Port D Data Register

; Bits del Puerto D
.equ PD0,    0        ; Port D bit 0 (RXD)
.equ PD1,    1        ; Port D bit 1 (TXD)
.equ PD2,    2        ; Port D bit 2 (INT0) - Arduino pin 2
.equ PD3,    3        ; Port D bit 3 (INT1)
.equ PD4,    4        ; Port D bit 4 (T0)
.equ PD5,    5        ; Port D bit 5 (T1)
.equ PD6,    6        ; Port D bit 6 (AIN0)
.equ PD7,    7        ; Port D bit 7 (AIN1)

;===============================================================================
; UART/USART - LOS MÁS USADOS
;===============================================================================
.equ UDR0,   0xC6     ; USART I/O Data Register
.equ UBRR0L, 0xC4     ; USART Baud Rate Register Low
.equ UBRR0H, 0xC5     ; USART Baud Rate Register High
.equ UCSR0A, 0xC0     ; USART Control and Status Register A
.equ UCSR0B, 0xC1     ; USART Control and Status Register B
.equ UCSR0C, 0xC2     ; USART Control and Status Register C

; Bits críticos del UCSR0A
.equ UDRE0,  5        ; USART Data Register Empty
.equ TXC0,   6        ; USART Transmit Complete
.equ RXC0,   7        ; USART Receive Complete

; Bits críticos del UCSR0B
.equ TXEN0,  3        ; Transmitter Enable
.equ RXEN0,  4        ; Receiver Enable

; Bits críticos del UCSR0C
.equ UCSZ00, 1        ; Character Size bit 0
.equ UCSZ01, 2        ; Character Size bit 1

;===============================================================================
; STACK POINTER
;===============================================================================
.equ SPL,    0x3D     ; Stack Pointer Low
.equ SPH,    0x3E     ; Stack Pointer High

;===============================================================================
; MEMORIA RAM
;===============================================================================
.equ RAMEND, 0x8FF    ; Último byte de RAM (ATmega328P tiene 2KB RAM)

;===============================================================================
; FIN DE DEFINICIONES
;===============================================================================
