# Código Fuente - Divisor de Potencia Wilkinson

Código fuente, mediciones y análisis del divisor de potencia Wilkinson presentado en `wilkinson.html`.

## Estructura de Directorios

- `mediciones/` - Archivos de parámetros S (.s2p) medidos con VNA
- `simulaciones/` - Archivos de simulación y resultados de ADS
- `Analisis.ipynb` - Notebook de Jupyter con análisis completo de datos
- `plotear.py` - Script Python para graficar resultados

## Descripción de Contenido

### Mediciones
Archivos de parámetros S en formato Touchstone (.s2p) obtenidos con analizador de redes vectoriales Rohde & Schwarz ZNC3. Incluyen mediciones de:
- Respuesta en frecuencia del divisor
- Parámetros S (S11, S21, S31, S23)
- Datos crudos y procesados

### Simulaciones
Resultados de simulación electromagnética realizados en Keysight ADS. Incluyen:
- Archivos de proyecto de ADS
- Resultados de simulación EM
- Comparativas con mediciones reales

### Analisis.ipynb
Notebook de Jupyter que realiza análisis completo de los datos. Funcionalidades:
- Carga y procesamiento de archivos .s2p
- Comparación entre simulaciones y mediciones
- Gráficos de parámetros S vs frecuencia
- Análisis de adaptación, aislamiento y división de potencia
- Correcciones y procesamiento avanzado con scikit-rf

### plotear.py
Script Python independiente para graficar resultados. Utiliza matplotlib y scikit-rf para visualización de datos de RF.

## Tecnologías

- Análisis de RF: Python scikit-rf, matplotlib
- Simulación: Keysight ADS
- Mediciones: Rohde & Schwarz ZNC3 VNA
- Fabricación: Router CNC, sustrato Rogers 5880LZ

## Uso

### Para el Notebook
1. Instalar dependencias: `pip install scikit-rf matplotlib numpy`
2. Ejecutar Jupyter: `jupyter notebook Analisis.ipynb`
3. Seguir celdas en orden para reproducir análisis

## Documentación

La documentación detallada del proyecto, incluyendo diseño, fabricación y resultados, se encuentra en la página web correspondiente `wilkinson.html`.
