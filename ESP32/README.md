# Web Configurator for ESP32

This project allows configuring GPIO outputs of an ESP32 through a web interface accessible via Wi-Fi. It simulates a maintenance menu for a device configurable from the browser.

## Main Features

- ESP32 starts in Access Point mode with a captive portal
- Clear web interface accessible from any device
- Allows:
  - Testing configurations instantly (GPIO ON/OFF)
  - Saving configurations to non-volatile memory (NVS)
  - Applying persistent configurations at boot

## Requirements

- ESP-IDF installed and configured
- ESP32 (WROOM or compatible)
- Browser to access the portal
- Terminal access (`idf.py`)
- Breadboard + 3 LEDs + 3 220 ohm resistors

## Quick Instructions

```
Assemble breadboard according to "conexiónes.svg"
idf.py set-target esp32
idf.py menuconfig         # Go to example to change ssid and pwd
idf.py build
idf.py flash
idf.py monitor
```

Then, connect to the Wi-Fi created by the ESP32, and access from the browser (redirects automatically).

## Structure

- `src/main.c`: Currently, the entire program
- `src/root.html`: Web page for interaction once configured
- `Informe.pdf`: Complete project documentation

## Author

Developed by Simon Aulet for the course "Computer Architecture and Embedded Systems" – UNRN 2025.

For a complete description, see the report