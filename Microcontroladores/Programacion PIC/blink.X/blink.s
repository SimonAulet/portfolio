PROCESSOR 16F18875
LIST
#include <xc.inc>
////////////////////////////////////////////////////////////////    

; PIC16F18875 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
;  CONFIG  FEXTOSC = ECH         ; External Oscillator mode selection bits (EC above 8MHz; PFM set to high power)
;  CONFIG  RSTOSC = LFINT        ; Power-up default value for COSC bits (LFINTOSC)
;  CONFIG  CLKOUTEN = OFF        ; Clock Out Enable bit (CLKOUT function is disabled; i/o or oscillator function on OSC2)
;  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
;  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (FSCM timer enabled)

CONFIG  FEXTOSC = OFF        ; Desactiva el oscilador externo
CONFIG  RSTOSC = HFINT1      ; Usa el oscilador interno de alta frecuencia (1 MHz)
CONFIG  CLKOUTEN = OFF       ; Deshabilita la salida de reloj
CONFIG  CSWEN = ON           ; Permite cambiar la frecuencia en tiempo de ejecución
CONFIG  FCMEN = OFF          ; Desactiva el Fail-Safe Clock Monitor (ya no es necesario)

    
    
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
  CONFIG  WDTE = ON             ; WDT operating mode (WDT enabled regardless of sleep; SWDTEN ignored)
  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)
  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)

; CONFIG4
  CONFIG  WRT = OFF             ; UserNVM self-write protection bits (Write protection off)
  CONFIG  SCANE = available     ; Scanner Enable bit (Scanner module is available for use)
  CONFIG  LVP = ON              ; Low Voltage Programming Enable bit (Low Voltage programming enabled. MCLR/Vpp pin function is MCLR.)

; CONFIG5
  CONFIG  CP = OFF              ; UserNVM Program memory code protection bit (Program Memory code protection disabled)
  CONFIG  CPD = OFF             ; DataNVM code protection bit (Data EEPROM code protection disabled)

///////////////////////////////////////////////////////////////     
PSECT resetVec,class=CODE,delta=2
resetVec:
    PAGESEL main
    goto    main     

PSECT code
main:
    CLRF   TRISA        ; Configurar PORTA como salida

START:
    MOVLW  00000000B    ; Apagar LED en RA3
    MOVWF  PORTA        

    CALL Retardo        ; Llamar al retardo

    MOVLW  11111111B    ; Encender LED en RA3
    MOVWF  PORTA        

    CALL Retardo        ; Llamar al retardo

    GOTO   START        ; Repetir el ciclo

;-------------------
; Subrutina de Retardo
;-------------------
Retardo:
	    MOVLW   0xFF
	    MOVWF   0x20
	    
	    MOVLW   0xFF
	    MOVWF   0x21
	    
	    MOVLW   0x16
	    MOVWF   0x22

	Loop1: ;decrementa 20
	    DECFSZ  0x20, F
	    GOTO    Loop1
	Loop2: ;decrementa 21
	    MOVLW   0xFF
	    MOVWF   0x20 ;reseteo reg 1
	    DECFSZ  0x21, F     
	    GOTO    Loop1
	Loop3: ;decrementa 22
	    MOVLW   0xFF
	    MOVWF   0x20 ;reseteo reg 1
	    MOVLW   0xFF
	    MOVWF   0x21 ;reseteo reg 2
	    DECFSZ  0x22, F
	    GOTO    Loop1       
	    RETURN             

    END main