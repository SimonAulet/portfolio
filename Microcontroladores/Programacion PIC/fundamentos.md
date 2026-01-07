# Fundamentos de Sistemas Embebidos con PIC

Proyectos académicos en ensamblador y C para microcontroladores **PIC16F18875**, enfocados en manejo directo de hardware y transición hacia abstracciones.

## Proyectos Implementados

### 1. Blink en Ensamblador – Control Directo de GPIO

```assembly
main:
    CLRF   TRISA        ; PORTA como salida
    MOVLW  00000000B    ; LED OFF
    MOVWF  PORTA
    CALL   Retardo
```

- Temporización mediante triple loop en ensamblador  
- Configuración manual de puertos sin abstracciones  
- Oscilador interno HFINT1 a 1 MHz  

### 2. Lectura de Potenciómetro en Ensamblador

```assembly
adc:
    BSF   ADCON0, 0     ; Iniciar conversión
    BTFSC ADCON0, 1     ; Esperar finalización
    GOTO  $-1
    MOVF  ADRESH, W    ; Tomar 2 MSB
```

- ADC de 8 bits en canal AN0 (RA0)  
- Los 2 bits más significativos determinan nivel en barra de LEDs  
- Representación visual en RA4–RA7  

### 3. Integración con LCD en C

```c
valor = ADCC_GetSingleConversion(POT);
sprintf(buffer, "%d", valor);
lcd_writemessage(1, 1, buffer);
```

- Abstracción mediante MCC (Microchip Code Configurator)  
- Uso de librerías para LCD de caracteres  
- Mantenimiento del core funcional  

## Valor de los Fundamentos

Estos proyectos establecen la comprensión crítica del costo de las operaciones y los límites del hardware. La experiencia de escribir retardos en ensamblador y configurar registros manualmente proporciona un marco de referencia invaluable al optimizar sistemas más complejos.

El recorrido desde control bit-a-bit en ensamblador hasta drivers abstractos en C demuestra un entendimiento completo de la pila de software embebido.
