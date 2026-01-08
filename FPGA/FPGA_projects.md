# FPGA & Digital Systems Design Portfolio

Este repositorio compila una serie de proyectos de diseño lógico implementados en **Verilog** para la placa de desarrollo Artix-7. Los diseños abarcan desde lógica combinacional fundamental hasta máquinas de estados finitos (FSM) complejas e interactivas.

---

## Sistema de Alarma de 3 Estados

Este proyecto implementa un sistema de control de seguridad residencial basado en una arquitectura de hardware síncrona. El núcleo del diseño es una máquina de estados finitos que administra tres modos de operación: Desarmado, Armado y Alarma Activa.

> **Código Fuente:** [`/Alarm`](./Alarm)

![Arquitectura del Sistema de Alarma](img/alarma_arch.png)
*Arquitectura del sistema: flujo de señales entre la detección de secuencia y el control de estados.*

### Lógica de Control y Funcionamiento

La interfaz de usuario consta de tres pulsadores de combinación (`b1`, `b2`, `b3`) y un comando de validación (`check`). El sistema evalúa la secuencia ingresada únicamente cuando se presiona la validación, lo que permite una lógica de control robusta: si el usuario intenta validar una secuencia incorrecta mientras el sistema está armado, la transición es inmediata hacia el estado de Alarma. Del mismo modo, el estado de alerta se dispara ante la activación del sensor de movimiento (`MOV`).

### Estrategia de Sincronización

Para garantizar la estabilidad operativa dentro de la FPGA y evitar la creación de múltiples dominios de reloj, se optó por una estrategia de habilitadores síncronos. En lugar de dividir la línea de reloj principal —con sus correspondientes problemas de timing— se implementó el módulo `freq_divider`.

Este componente genera pulsos de un solo ciclo ("ticks") que habilitan procesos a frecuencias menores (como 1 kHz y 1 Hz), manteniendo todo el diseño perfectamente sincronizado al reloj maestro de 100 MHz. Además, el módulo es totalmente **parametrizable**, lo que permite ajustar las escalas de división para acelerar los tiempos en etapas de simulación o definir los valores finales para la síntesis.

<details>
  <summary>Ver Código: Generador de Ticks (freq_divider.v)</summary>

```verilog
always @(posedge clk_in)
begin
  if((lf_counter == 0) && (mf_counter==0))
    tick_lf <= 1'b1;
  else
    tick_lf <= 1'b0;
end
// Freq divider mf
always@(posedge clk_in)
begin
  if(mf_counter == 0)
    tick_mf <= 1'b1;
  else
    tick_mf <= 1'b0;
end
```
</details>

### Optimización de Recursos

El acondicionamiento de las señales de entrada se beneficia directamente de la estrategia de sincronización anterior. El módulo `anti_bounce` utiliza los ticks de 1 kHz como referencia temporal para filtrar el ruido mecánico de los pulsadores. Esta decisión de diseño permite reducir significativamente el uso de registros: la ventana de estabilidad de 20 ms se gestiona con un contador compacto de 6 bits, evitando la necesidad de contadores de 21 bits que serían requeridos si se operara directamente sobre la frecuencia base de 100 MHz.

### Verificación

La confiabilidad del sistema se aseguró mediante una metodología de validación incremental. Los módulos fueron sometidos a testbenches dedicados para verificar correcto funcionamiento antes de su integración final en la entidad superior.

## Secuenciador de Luces (Máquina de Moore)

Este diseño implementa un secuenciador de efectos lumínicos controlado por un único pulsador. La arquitectura se basa estrictamente en el modelo de **Máquina de Moore**, donde las salidas dependen exclusivamente del estado actual y no de las entradas directas.

> **Código Fuente:** [`/Moore_seq`](./Moore_seq)

### Arquitectura Desacoplada

Para maximizar la modularidad, se dividió el sistema en dos bloques funcionales independientes que operan bajo el mismo dominio de reloj (100 MHz), sincronizados mediante las señales de habilitación (`ticks`) heredadas del diseño anterior:

1.  **Control de Estados (`state_change.v`):** Gestiona la lectura del pulsador, el *debouncing* (usando `tick_mf`) y las transiciones de estados.
2.  **Decodificación de Salida (`led_change.v`):** Interpreta el estado actual y genera los patrones visuales correspondientes.

<table>
  <tr>
    <td width="60%" valign="top">
      <h3>Lógica de Transición y Salida</h3>
      <p>
        El sistema cicla a través de 4 estados operativos con cada pulsación validada. La lógica de salida aprovecha la señal de baja frecuencia (<code>tick_lf</code> de 1 Hz) para generar efectos de parpadeo sin necesidad de contadores adicionales dentro del módulo de LEDs.
      </p>
      <ul>
        <li><strong>Estado 00 (IDLE):</strong> Sistema en reposo, salidas apagadas.</li>
        <li><strong>Estado 01:</strong> LED A parpadeando a 1 Hz.</li>
        <li><strong>Estado 10:</strong> LED B parpadeando a 1 Hz.</li>
        <li><strong>Estado 11:</strong> Ambos LEDs parpadeando sincronizados.</li>
      </ul>
      <p>
        Esta separación permite alterar los patrones lumínicos (ej: cambiar la frecuencia o el patrón de bit) modificando únicamente el módulo de salida, sin riesgo de alterar la lógica de control de flujo.
      </p>
    </td>
    <td width="40%" valign="top">
      <img src="img/secuenciador_fsm.png" alt="Diagrama de Estados Secuenciador" width="100%">
      <p align="center"><em>Diagrama de estados del secuenciador (Moore)</em></p>
    </td>
  </tr>
</table>

<details>
  <summary>Ver Código: Lógica de Salida (led_change.v)</summary>

```verilog
module led_change(
  input  wire[1:0] state,
  input  wire      clk,
  input  wire      tick_lf, // Habilitador de 1 Hz
  output reg       led_a,
  output reg       led_b
);

always@(posedge clk)
  case(state)
  2'b00: begin // Reposo
    led_a <= 0;
    led_b <= 0;
  end
  2'b01: begin // Blink LED A
    if(tick_lf) led_a <= ~led_a;
    led_b <= 0;
  end
  2'b10: begin // Blink LED B
    led_a <= 0;
    if(tick_lf) led_b <= ~led_b;
  end
  2'b11: begin // Blink Ambos
    if(tick_lf) led_a <= ~led_a;
    led_b <= led_a; // Copia estado para sincronía
  end
  default: begin led_a <= 0; led_b <= 0; end
endcase
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
