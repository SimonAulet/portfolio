# Source Code - PIC Projects

Source code for PIC microcontroller programming projects presented in `pic.html`.

## Directory Structure

- `LCD_CON_I2C.X/` - LCD display control via I2C interface
- `blink.X/` - Basic LED blink example
- `potenciometro.X/` - Potentiometer reading and analog control

## Project Description

### LCD_CON_I2C
LCD display control via I2C communication. Implements driver for character displays with I2C interface, reducing the number of required pins.

### blink
Basic PIC programming example. LED control through timing, demonstrating GPIO port configuration and delay handling.

### potenciometro
Analog signal reading from potentiometer and digital processing. Includes ADC conversion, filtering, and control based on analog values.

## Technologies

- Microcontrollers: PIC16, PIC18 series
- Language: C (MPLAB XC8 Compiler)
- Environment: MPLAB X IDE
- Protocols: I2C, ADC, GPIO

## Usage

Each project is configured for MPLAB X IDE. Open the corresponding `.X` file in MPLAB X to load the complete project.

## Compilation and Programming

1. Open project in MPLAB X IDE
2. Configure specific PIC device
3. Compile with XC8 Compiler
4. Program using PICKit or compatible programmer

## Documentation

Detailed documentation for each project is found in the source files and in the corresponding web page `pic.html`.