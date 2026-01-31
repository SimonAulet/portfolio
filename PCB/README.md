# Código Fuente - Diseño de PCB 6 Capas para Sistema de Control Satelital Analógico

Código fuente y recursos del proyecto de diseño de PCB presentado en `PCB.html`.

## Estructura de Directorios

- `componentes/` - Librerías personalizadas de componentes para KiCad
- `datasheets/` - Documentación técnica de componentes utilizados
- `LTSpice/` - Simulaciones de circuitos analógicos
- `Main board.kicad/` - Proyecto KiCad del PCB principal de 6 capas
- `Sensors and actuators.kicad/` - Proyecto KiCad de los módulos sensoriales externos

## Descripción de Proyectos

### Main Board (PCB Principal - 6 Capas)
Diseño integral de un sistema de control satelital analógico implementado con componentes discretos. El PCB de 6 capas integra:
- Detección de orientación mediante fotoresistencias
- Sensado térmico con LM35
- Generación de PWM analógica
- Posicionamiento de servomotor
- Circuitos de timing con 555
- Latches analógicos con transistores NPN
- Lógica de control autónoma

### Sensors and Actuators (Módulos Externos - 2 Capas)
PCB auxiliar que contiene los sensores y actuadores distribuidos:
- Fotoresistencias para detección de luz/orientación
- Sensores de temperatura LM35
- Drivers MOSFET para conmutación de relays
- Heater

## Contenido Detallado

### `componentes/`
Librerías personalizadas de componentes descargados de sitios oficiales:
- `CSD17577Q5A/` - MOSFET N-Channel (Texas Instruments)
- `CSD17585F5/` - MOSFET P-Channel (Texas Instruments)
- `lm35/` - Sensor de temperatura
- `lm358/` - Amplificador operacional dual

Cada carpeta contiene:
- Símbolo esquemático (.lib/.kicad_sym)
- Footprint PCB (.pretty/.kicad_mod)
- Modelo 3D (.step/.wrl)
- Archivos de documentación

### `datasheets/`
Documentación técnica oficial de los componentes:
- Hojas de datos PDF de todos los componentes utilizados
- Notas de aplicación relevantes
- Especificaciones eléctricas y mecánicas

### `LTSpice/`
Simulaciones de circuitos analógicos críticos:
- `1.hysteresis.asc` - Comparadores con histéresis (Schmitt trigger)
- `2.latch.asc` - Latches implementados con transistores NPN
- `3.orient.asc` - Circuito de detección de orientación con LDR
- `4.power_select.asc` - Lógica de conmutación de fuentes de alimentación
- `5.timming.asc` - Circuitos de temporización con 555

### `Main board.kicad/`
Proyecto completo de KiCad para el PCB principal:
- Esquemático jerárquico organizado por subsistemas
- Listas de materiales (BOM) con proveedores
- PCB ruteado

### `Sensors and actuators.kicad/`
Proyecto de KiCad para los módulos externos:
- Diseño de doble capa optimizado para fabricación
- Footprints para montaje industrial

## Tecnologías

- **Diseño PCB**: KiCad 9.0.7
- **Simulación**: LTSpice 26.0.1
- **Material**: FR4, 1.6mm, 1oz copper
