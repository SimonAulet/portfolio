# FPGA & Digital Systems Design Portfolio

Este repositorio compila una serie de proyectos de diseño lógico implementados en **Verilog** para la placa de desarrollo **Nexys 4 DDR** (Artix-7). Los diseños abarcan desde lógica combinacional fundamental hasta máquinas de estados finitos (FSM) complejas e interactivas.

---

## Proyecto Destacado: Sistema de Alarma de 3 Estados

Una implementación robusta de un sistema de seguridad residencial simulado. El diseño se destaca por su **arquitectura modular**, separando la lógica de detección de la lógica de control de estados.

### Arquitectura del Sistema
El sistema no utiliza una única máquina de estados monolítica, sino que orquesta dos módulos independientes para mayor claridad y escalabilidad:
1.  **Detector de Secuencias:** Verifica el ingreso correcto de una contraseña (secuencia predefinida).
2.  **Controlador de Estados (FSM):** Administra los modos de operación (IDLE, ARMED, ALARM) basándose en las señales del detector y sensores de movimiento.

![Arquitectura del Sistema de Alarma](img/alarma_arch.png)
*Diagrama de flujo mostrando la interacción entre el detector de secuencias y la máquina de estados de control.*

### Lógica de Control
La máquina gestiona transiciones críticas, como el disparo de la alarma ante una secuencia incorrecta en estado armado o el desarmado exitoso.

<details>
  <summary>Ver Código: Máquina de Estados (state_change.v)</summary>

```verilog
module state_change(
    input seq,      // Indica secuencia correcta
    input mov,      // Sensor de movimiento
    input enable,   // Habilitador (check)
    input clk,
    output reg [1:0] state
);

    // Codificación de estados: 00=IDLE, 01=ARMED, 10=ALARM
    always @(posedge clk) begin
        if (enable) begin
            case (state)
                2'b00: state <= (seq) ? 2'b01 : 2'b00; // IDLE -> ARMED
                2'b01: begin
                       if (seq) state <= 2'b00;        // ARMED -> IDLE (Desarmar)
                       else state <= 2'b10;            // Error -> ALARM
                       end
                2'b10: state <= (seq) ? 2'b00 : 2'b10; // ALARM -> IDLE (Apagar)
                default: state <= 2'b00;
            endcase
        end else if (mov && state == 2'b01) begin
            state <= 2'b10; // Disparo por movimiento
        end
    end
endmodule
```
</details>

## Secuenciador de Luces (Máquina de Moore)

Este proyecto implementa un secuenciador de efectos lumínicos controlado por botón. El desafío principal fue el manejo de **tiempos y sincronización** sin comprometer la estabilidad del reloj principal.

* **Sincronización:** Se implementó un módulo `freq_divider` que genera pulsos de habilitación (*ticks*) de 1 kHz y 1 Hz. Esto permite mantener todo el sistema síncrono al reloj master de 100 MHz, evitando los problemas de timing típicos de usar relojes derivados ("gated clocks").
* **Anti-Bounce:** Incluye lógica de debouncing para asegurar lecturas limpias del pulsador de entrada.

![Diagrama de Estados Secuenciador](img/secuenciador_fsm.png)
*Diagrama de la Máquina de Moore con 4 estados de iluminación.*

<details>
  <summary>Ver Código: Divisor de Frecuencia (freq_divider.v)</summary>

```verilog
module freq_divider #(
    parameter mf_divider = 100_000, // 1 kHz
    parameter lf_divider = 1_000    // 1 Hz
)(
    input wire clk_in,
    output reg tick_mf,
    output reg tick_lf
);
    // Generación de ticks síncronos para habilitar procesos
    // sin dividir la línea de clock principal.
    // ... (lógica de contadores)
endmodule
```
</details>

---

## Colección: Fundamentos de Verilog

Una suite de módulos fundamentales que exploran la sintaxis y las estructuras básicas de hardware digital.

| Categoría | Módulos Destacados | Descripción |
| :--- | :--- | :--- |
| **Aritmética & Lógica** | **ALU de 4-bits** (Ej. 12) | Unidad Aritmético Lógica capaz de sumar, restar (con signo), AND y OR. |
| **Lógica Secuencial** | **Contador Parametrizable** (Ej. 18) | Contador módulo-N genérico con reset asíncrono. |
| **FSM Básica** | **Detector "101"** (Ej. 20) | Máquina de Moore con solapamiento (overlap) para detección de patrones seriales. |

### Highlight: Detector de Secuencia "101"
Implementación de una FSM que analiza una entrada serial bit a bit y activa una salida al encontrar el patrón "101". Diseñado para permitir solapamiento (ej: `10101` detecta dos veces).

![FSM Detector 101](img/detector101_fsm.png)

---
*Autor: Simón Aulet - Ingeniería Electrónica y en Telecomunicaciones (UNRN)*