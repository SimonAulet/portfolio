# FPGA & Digital Systems Design Portfolio

Este repositorio compila una serie de proyectos de diseño lógico implementados en **Verilog** para la placa de desarrollo Artix-7. Los diseños abarcan desde lógica combinacional fundamental hasta máquinas de estados finitos (FSM) complejas e interactivas.

---

## Proyecto Destacado: Sistema de Alarma de 3 Estados

Una implementación robusta de un sistema de seguridad residencial simulado. El diseño se destaca por su **arquitectura modular** y el uso estricto de prácticas de diseño síncrono para garantizar la estabilidad en la FPGA.

>  **Código Completo:** Disponible en la carpeta [`Alarm`](./Alarm)

### 1. Arquitectura Síncrona y Manejo de Reloj
Uno de los desafíos principales en FPGAs es evitar la creación de múltiples dominios de reloj (*Clock Domain Crossing* o CDC), lo cual puede introducir inestabilidad y problemas de *timing*.

Para solucionarlo, implementé un módulo `freq_divider` que **no divide la línea de reloj**, sino que genera pulsos de habilitación (*ticks*) de un solo ciclo.
* **Ventaja:** Todo el sistema (FSM, Debouncers, Contadores) permanece sincronizado al reloj maestro de 100 MHz.
* **Flexibilidad:** El módulo es parametrizable, permitiendo ajustar las frecuencias para síntesis (tiempos reales) o simulación (tiempos reducidos).

<details>
  <summary>Ver Código: Generación de Ticks (freq_divider.v)</summary>

```verilog
module freq_divider #(
    parameter mf_divider = 100_000, // Parametrizable para TB vs Bitstream
    parameter lf_divider = 1_000
)(
    input  wire clk_in,
    output reg  tick_mf, // Pulso de enable (no clock)
    output reg  tick_lf
);
    // Lógica síncrona que genera un pulso '1' durante un solo ciclo de reloj
    // manteniendo la integridad de la señal de clock principal.
    // ...
endmodule
```
</details>

### 2. Optimización de Recursos en Anti-Bounce
La lógica de eliminación de rebotes (*Debounce*) aprovecha la señal `tick_mf` (1 kHz) para optimizar el uso de registros (Flip-Flops) en la FPGA.

* **Sin optimización:** Contar 20ms a 100 MHz requeriría un contador de **21 bits**.
* **Con optimización:** Al usar el pre-escalador (`tick`), el módulo `anti_bounce.v` solo necesita un contador de **6 bits** para validar la estabilidad de la señal.

<details>
  <summary>Ver Código: Lógica de Debounce Optimizada</summary>

```verilog
// anti_bounce.v
always @(posedge clk) begin
  if (btn_in != btn_stable) begin
    if (tick_mf) begin // Solo cuenta cuando el tick habilita
      if (counter == 6'd20) begin  // Contador pequeño (6 bits)
        btn_stable <= btn_in;
        counter    <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end
  // ...
end
```
</details>

### 3. Validación Modular
La robustez del sistema se garantizó mediante una estrategia de verificación *bottom-up*. Cada módulo crítico (`state_change`, `seq_detecter`, `anti_bounce`) cuenta con su propio **Testbench** dedicado antes de la integración en `top.v`.

![Arquitectura del Sistema de Alarma](img/alarma_arch.png)
*Diagrama de flujo mostrando la interacción entre el detector de secuencias y la máquina de estados de control.*

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

## Fundamentos de Verilog

Esta sección explora la construcción de hardware digital desde sus bloques más elementales, enfocándose en la modularidad, parametrización y máquinas de estados.

---

<table>
  <tr>
    <td width="50%" valign="top">
      <h3>Diseño Jerárquico: Sumador Completo (Ej. 10 y 11)</h3>
      <p>
        Este módulo ilustra la metodología de <strong>diseño "bottom-up"</strong>. En lugar de describir la lógica de suma completa de una vez, se construyó encapsulando componentes de menor nivel:
      </p>
      <ul>
        <li><strong>Nivel 1 (Half Adder):</strong> Resuelve la suma de 1 bit sin acarreo de entrada.</li>
        <li><strong>Nivel 2 (Full Adder):</strong> Instancia dos <em>Half Adders</em> y lógica de glue (OR) para gestionar el Acarreo (Carry).</li>
      </ul>
      <p>
        Esta estructura permite escalar fácilmente hacia un <strong>Sumador de 4-bits</strong> (Ripple Carry) reutilizando el módulo validado, base fundamental para la ALU.
      </p>
    </td>
    <td width="50%" valign="top">
      <img src="img/fa_esquema.png" alt="Esquemático Full Adder" width="100%">
      <br>
      <p align="center"><em>Arquitectura con 2 Half-Adders</em></p>
      <br>
      <img src="img/fa_sim.png" alt="Simulación Full Adder" width="100%">
      <p align="center"><em>Validación de tabla de verdad</em></p>
    </td>
  </tr>
</table>

---

<table>
  <tr>
    <td width="50%" valign="top">
      <h3>Unidad Aritmético Lógica (ALU) de 4-Bits (Ej. 12)</h3>
      <p>
        Integración de lógica combinacional aritmética y lógica en un solo núcleo. La ALU realiza 4 operaciones seleccionables mediante un <strong>Opcode</strong> de 2 bits:
      </p>
      <ul>
        <li><strong>Suma (ADD):</strong> Utiliza el módulo <code>nibble_adder</code> derivado del ejercicio anterior.</li>
        <li><strong>Resta (SUB):</strong> Implementa complemento a 2 invirtiendo el operando B y forzando el Carry-In.</li>
        <li><strong>Lógica (AND / OR):</strong> Operaciones bit a bit.</li>
      </ul>
      <p>
        En las simulaciones se valida tanto el manejo de signo (formato decimal) como la operación bit a bit (formato binario).
      </p>
    </td>
    <td width="50%" valign="top">
      <img src="img/alu_dec.png" alt="Simulación ALU Decimal" width="100%">
      <p align="center"><em>Aritmética: Suma y Resta (Signo)</em></p>
      <br>
      <img src="img/alu_bin.png" alt="Simulación ALU Binaria" width="100%">
      <p align="center"><em>Lógica: AND y OR (Bitwise)</em></p>
    </td>
  </tr>
</table>

---

<table>
  <tr>
    <td width="50%" valign="top">
      <h3>Contador Parametrizable "Módulo-N" (Ej. 18)</h3>
      <p>
        Un diseño de lógica secuencial flexible que permite definir el límite de cuenta (N) dinámicamente mediante una entrada de 8 bits. Se validaron 3 escenarios críticos:
      </p>
      <ol>
        <li>
          <strong>Inicio de Cuenta:</strong> Verificación del conteo básico ascendente desde 0 hasta N.
        </li>
        <li>
          <strong>Cambio Dinámico de N:</strong> Se modificó el valor de N durante la ejecución. El sistema adapta su comparador instantáneamente sin requerir un reset, continuando la cuenta hasta el nuevo límite.
        </li>
        <li>
          <strong>Reset Asíncrono:</strong> Verificación de la prioridad de la señal de reset, que fuerza la salida a 0 independientemente del reloj.
        </li>
      </ol>
    </td>
    <td width="50%" valign="top">
      <img src="img/cnt_init.png" alt="Inicio del contador" width="100%">
      <p align="center"><em>1. Inicio de cuenta (0 a 5)</em></p>
      <br>
      <img src="img/cnt_change.png" alt="Cambio de modulo" width="100%">
      <p align="center"><em>2. Cambio de N "on-the-fly"</em></p>
      <br>
      <img src="img/cnt_reset.png" alt="Reset del contador" width="100%">
      <p align="center"><em>3. Reset Asíncrono</em></p>
    </td>
  </tr>
</table>

---

<table>
  <tr>
    <td width="60%" valign="top">
      <h3>Detector de Secuencia "101" (Ej. 20)</h3>
      <p>
        Implementación de una <strong>Máquina de Estados de Moore</strong> que analiza una entrada serial bit a bit.
      </p>
      <p>
        Diseñado para permitir <strong>solapamiento</strong> (overlap). Por ejemplo, en la secuencia <code>10101</code>, el sistema activa la detección dos veces (el "1" final de la primera detección sirve como el "1" inicial de la siguiente), demostrando una lógica de control de flujo continua.
      </p>
    </td>
    <td width="40%" valign="top">
      <img src="img/detector101_fsm.png" alt="FSM Detector 101" width="100%">
    </td>
  </tr>
</table>
---

*Autor: Simón Aulet - Ingeniería Electrónica y en Telecomunicaciones (UNRN)*