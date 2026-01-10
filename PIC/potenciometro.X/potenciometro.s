PROCESSOR 16F18875
LIST
#include <xc.inc>
////////////////////////////////////////////////////////////////    

; PIC16F18875 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode selection bits (EC above 8MHz; PFM set to high power)
  CONFIG  RSTOSC = HFINT1       ; Power-up default value for COSC bits (LFINTOSC)
  CONFIG  CLKOUTEN = OFF        ; Clock Out Enable bit (CLKOUT function is disabled; i/o or oscillator function on OSC2)
  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (FSCM timer enabled)

; CONFIG2
  CONFIG  MCLRE = ON            ; Master Clear Enable bit (MCLR pin is Master Clear function)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  LPBOREN = OFF         ; Low-Power BOR enable bit (ULPBOR disabled)
  CONFIG  BOREN = ON            ; Brown-out reset enable bits (Brown-out Reset Enabled, SBOREN bit is ignored)
  CONFIG  BORV = LO             ; Brown-out Reset Voltage Selection (Brown-out Reset Voltage (VBOR) set to 1.9V on LF, and 2.45V on F Devices)
  CONFIG  ZCD = OFF             ; Zero-cross detect disable (Zero-cross detect circuit is disabled at POR.)
  CONFIG  PPS1WAY = ON          ; Peripheral Pin Select one-way control (The PPSLOCK bit can be cleared and set only once in software)
  CONFIG  STVREN = ON           ; Stack Overflow/Underflow Reset Enable bit (Stack Overflow or Underflow will cause a reset)

; CONFIG3
  CONFIG  WDTCPS = WDTCPS_31    ; WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)
  CONFIG  WDTE = OFF            ; WDT operating mode (WDT enabled regardless of sleep; SWDTEN ignored)
  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)
  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)

; CONFIG4
  CONFIG  WRT = OFF             ; UserNVM self-write protection bits (Write protection off)
  CONFIG  SCANE = available     ; Scanner Enable bit (Scanner module is available for use)
  CONFIG  LVP = ON              ; Low Voltage Programming Enable bit (Low Voltage programming enabled. MCLR/Vpp pin function is MCLR.)

; CONFIG5
  CONFIG  CP = OFF              ; UserNVM Program memory code protection bit (Program Memory code protection disabled)
  CONFIG  CPD = OFF             ; DataNVM code protection bit (Data EEPROM code protection disabled)

; CONFIG ADC
  BSF ANSELA, 0        ; Configurar RA0 como analógico
  BSF TRISA, 0         ; Configurar RA0 como entrada
  MOVLW 0x01           ; Seleccionar canal AN0 (RA0)
  MOVWF ADPCH
  MOVLW 0b00010101     ; ADC ON, Clock FRC, Justificado a la izquierda
  MOVWF ADCON0
  MOVLW 0b10000000     ; Referencia VDD y VSS, Justificado a la izquierda
  MOVWF ADCON1

; CONFIG LEDS
MOVLW   0b00001111   ; RA4 a 7 como salidas, el resto como estaban
ANDWF   TRISA, F


// config statements should precede project file includes.

///////////////////////////////////////////////////////////////     
PSECT resetVec,class=CODE,delta=2
resetVec:
    PAGESEL main                ;Salta al Main
    goto    main     
PSECT code

main:

START:

GOTO adc
  MOVLW  0b01010101
  MOVWF  0x20        

  ;alterno 0x20 entre unos  y ceros
  BTFSC 0x20, 7
  MOVLW 0b00000000  ;00 L2
  BTFSS 0x20, 7
  MOVLW 0b11111111  ;10 L4
  MOVWF 0x20


;chequeo resultado del potenciometro

  BTFSC 0x20, 7		;primer bit
  GOTO msb1
  GOTO msb0

msb1:
  BTFSC 0x20, 6		;segundo  bit
  GOTO nivel4
  GOTO nivel3

msb0:
  BTFSC 0x20, 6		;segundo  bit
  GOTO nivel2
  GOTO nivel1


adc:
    BSF ADCON0, 0        ; Iniciar conversión
    BTFSC ADCON0, 1      ; Esperar a que termine (mientras GO/DONE=1)
    GOTO $-1

    MOVF ADRESH, W       ; Me van a interesar solo los 2 msb
    MOVWF 0x20

    RETURN
    
;los bits de los leds son 4, 5, 6 y 7 del puerto A
nivel0: ;0000
  MOVF  LATA, W
  ANDLW 0b00001111
  MOVWF LATA

  GOTO  START

nivel1: ;0001
  MOVF  LATA, 0
  ANDLW 0b00011111
  IORLW 0b00010000
  MOVWF LATA

  GOTO  START

nivel2: ;0011
  MOVF  LATA, 0
  ANDLW 0b00111111
  IORLW 0b00110000
  MOVWF LATA

  GOTO  START

nivel3: ;0111
  MOVF  LATA, 0
  ANDLW 0b01111111
  IORLW 0b01110000
  MOVWF LATA

  GOTO  START

nivel4: ;1111
  MOVF  LATA, 0
  IORLW 0b11110000
  MOVWF LATA

  GOTO  START

END main