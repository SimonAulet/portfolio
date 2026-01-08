# Configurador Web para ESP32

Este proyecto permite configurar salidas GPIO de un ESP32 a través de una interfaz web accesible vía Wi-Fi. Simula un menú de mantenimiento para un dispositivo configurable desde el navegador.

## Funcionalidades principales

- El ESP32 se inicia en modo Access Point con un captive portal
- Interfaz web clara y accesible desde cualquier dispositivo
- Permite:
  - Probar configuraciones instantáneamente (GPIO ON/OFF)
  - Guardar configuraciones en memoria no volátil (NVS)
  - Aplicar configuraciones persistentes en el arranque

## Requisitos

- ESP-IDF instalado y configurado
- ESP32 (WROOM o compatible)
- Navegador para acceder al portal
- Acceso a la terminal (`idf.py`)
- Protoboard + 3 leds + 3 resistencias de 220 ohm

## Instrucciones rápidas

```
Armar protoboard segun "conexiónes.svg"
idf.py set-target esp32
idf.py menuconfig         # Ir a example para cambiar ssid y pwd
idf.py build
idf.py flash
idf.py monitor
```

Luego, conectarse al Wi-Fi creado por el ESP32, y acceder desde el navegador (se redirige automáticamente).

## Estructura

- `src/main.c`: Por el momento, la totalidad del programa
- `src/root.html`: Pagina web para interactuar una vez configurado
- `Informe.pdf`: documentación completa del proyecto

## Autor

Desarrollado por Simon Aulet para la materia "Arquitectura de Computadoras y Sistemas Embebidos" – UNRN 2025.

Para más descrpción completa ver el informe