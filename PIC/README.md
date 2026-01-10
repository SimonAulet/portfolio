# Código Fuente - Proyectos PIC

Código fuente de los proyectos de programación de microcontroladores PIC presentados en `pic.html`.

## Estructura de Directorios

- `LCD_CON_I2C.X/` - Control de pantalla LCD mediante interfaz I2C
- `blink.X/` - Ejemplo básico de parpadeo de LED
- `potenciometro.X/` - Lectura de potenciómetro y control analógico

## Descripción de Proyectos

### LCD_CON_I2C
Control de pantalla LCD mediante comunicación I2C. Implementa driver para pantallas de caracteres con interfaz I2C, reduciendo el número de pines requeridos.

### blink
Ejemplo básico de programación de PIC. Control de LED mediante temporizaciones, demostrando configuración de puertos GPIO y manejo de retardos.

### potenciometro
Lectura de señal analógica desde potenciómetro y procesamiento digital. Incluye conversión ADC, filtrado y control basado en valores analógicos.

## Tecnologías

- Microcontroladores: PIC16, PIC18 series
- Lenguaje: C (MPLAB XC8 Compiler)
- Entorno: MPLAB X IDE
- Protocolos: I2C, ADC, GPIO

## Uso

Cada proyecto está configurado para MPLAB X IDE. Abrir el archivo `.X` correspondiente en MPLAB X para cargar el proyecto completo.

## Compilación y Programación

1. Abrir proyecto en MPLAB X IDE
2. Configurar dispositivo PIC específico
3. Compilar con XC8 Compiler
4. Programar mediante PICKit o programador compatible

## Documentación

La documentación detallada de cada proyecto se encuentra en los archivos fuente y en la página web correspondiente `pic.html`.