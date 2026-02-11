# Source Code - Wilkinson Power Divider

Source code, measurements, and analysis of the Wilkinson power divider presented in `wilkinson.html`.

## Directory Structure

- `mediciones/` - S-parameter files (.s2p) measured with VNA
- `simulaciones/` - Simulation files and ADS results
- `Analisis.ipynb` - Jupyter notebook with complete data analysis
- `plotear.py` - Python script for plotting results

## Content Description

### Measurements
S-parameter files in Touchstone format (.s2p) obtained with Rohde & Schwarz ZNC3 vector network analyzer. Includes measurements of:
- Frequency response of the divider
- S-parameters (S11, S21, S31, S23)
- Raw and processed data

### Simulations
Electromagnetic simulation results performed in Keysight ADS. Includes:
- ADS project files
- EM simulation results
- Comparisons with real measurements

### Analisis.ipynb
Jupyter notebook performing complete data analysis. Features:
- Loading and processing of .s2p files
- Comparison between simulations and measurements
- S-parameter vs frequency plots
- Analysis of matching, isolation, and power division
- Corrections and advanced processing with scikit-rf

### plotear.py
Independent Python script for plotting results. Uses matplotlib and scikit-rf for RF data visualization.

## Technologies

- RF Analysis: Python scikit-rf, matplotlib
- Simulation: Keysight ADS
- Measurements: Rohde & Schwarz ZNC3 VNA
- Fabrication: CNC router, Rogers 5880LZ substrate

## Usage

### For the Notebook
1. Install dependencies: `pip install scikit-rf matplotlib numpy`
2. Run Jupyter: `jupyter notebook Analisis.ipynb`
3. Follow cells in order to reproduce analysis

## Documentation

Detailed project documentation, including design, fabrication, and results, is found in the corresponding web page `wilkinson.html`.