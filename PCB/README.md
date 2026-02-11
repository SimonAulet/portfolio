# Source Code - 6-Layer PCB Design for Analog Satellite Control System

Source code and resources for the PCB design project presented in `PCB.html`.

## Directory Structure

- `componentes/` - Custom component libraries for KiCad
- `datasheets/` - Technical documentation of used components
- `LTSpice/` - Analog circuit simulations
- `Main board.kicad/` - KiCad project for the main 6-layer PCB
- `Sensors and actuators.kicad/` - KiCad project for external sensor modules

## Project Description

### Main Board (Main PCB - 6 Layers)
Comprehensive design of an analog satellite control system implemented with discrete components. The 6-layer PCB integrates:
- Orientation detection using photoresistors
- Thermal sensing with LM35
- Analog PWM generation
- Servomotor positioning
- Timing circuits with 555
- Analog latches with NPN transistors
- Autonomous control logic

### Sensors and Actuators (External Modules - 2 Layers)
Auxiliary PCB containing distributed sensors and actuators:
- Photoresistors for light/orientation detection
- LM35 temperature sensors
- MOSFET drivers for relay switching
- Heater

## Detailed Content

### `componentes/`
Custom component libraries downloaded from official sites:
- `CSD17577Q5A/` - N-Channel MOSFET (Texas Instruments)
- `CSD17585F5/` - P-Channel MOSFET (Texas Instruments)
- `lm35/` - Temperature sensor
- `lm358/` - Dual operational amplifier

Each folder contains:
- Schematic symbol (.lib/.kicad_sym)
- PCB footprint (.pretty/.kicad_mod)
- 3D model (.step/.wrl)
- Documentation files

### `datasheets/`
Official technical documentation of components:
- PDF datasheets of all used components
- Relevant application notes
- Electrical and mechanical specifications

### `LTSpice/`
Analog circuit simulations of critical circuits:
- `1.hysteresis.asc` - Hysteresis comparators (Schmitt trigger)
- `2.latch.asc` - Latches implemented with NPN transistors
- `3.orient.asc` - Orientation detection circuit with LDR
- `4.power_select.asc` - Power source switching logic
- `5.timming.asc` - Timing circuits with 555

### `Main board.kicad/`
Complete KiCad project for the main PCB:
- Hierarchical schematic organized by subsystems
- Bill of materials (BOM) with suppliers
- Routed PCB

### `Sensors and actuators.kicad/`
KiCad project for external modules:
- Double-layer design optimized for manufacturing
- Footprints for industrial mounting

## Technologies

- **PCB Design**: KiCad 9.0.7
- **Simulation**: LTSpice 26.0.1
- **Material**: FR4, 1.6mm, 1oz copper