# Probabilistic Prediction for PV Systems on Buildings

## Introduction

This repository holds files used for probabilistic prediction of photovoltaic
energy generation on buildings. Here you can find the MATLAB code, a graphical
user interface for the MATLAB code, and a Python implementation of the same
code (in progress).

Use this code to generate probabilistic prediction of energy generation for
your own PV system.

Please mind the basic license (see below) in using this work.

## Guide to Download

### GUI

The GUI is developed, through MATLAB’s App Designer, to facilitate the prediction
process to owners of PV systems. The main layout is shown below.

![alt text][image]

[image]: 

Three sets of codes are available to download for this project;
1- MATLAB codes for the forecasting system
2- MATLAB codes for the GUI
3- Executable file to use the GUI as a standalone application.
Note: MATLAB Runtime will be downloaded during the installation of the .exe file.

### Python Implementation

Python code puts into action the same algorithm as in the MATLAB code in Python
language. It is believed that Python version reaches a broader audience in the
open source community and paves the way for running the code in Linux on lower-end
computer hardware (such as Raspberry Pi).

To run the code on your local machine, you need:

- Python version 3.x.x, available for download [here](https://www.python.org/downloads/).

- Code in this repository. Simply clone/download the code inside this repository.

#### Current Progress

There are fourteen core .mat files that work on the probabilistic PV prediction
algorithm. They are given in the list below with their rewriting-in-Python work
statuses:

| Function           | Progress      |
| ------------------ | -------------:|
| Main.m             | in progress   |
| DataAcq.m          | completed     |
| PVtrain.m          | future work   |
| clearskygen.m      | future work   |
| clearsky.m         | future work   |
| emoncms.m          | future work   |
| missingData.m      | future work   |
| unixtime.m         | future work   |
| weatherset.m       | future work   |
| PVpredict.m        | future work   |
| errorcalc.m        | future work   |
| TrainProp.m        | future work   |
| allfitdist_woFig.m | future work   |
| GenPro.m           | future work   |

##### DataAcq.m

Data acquisition function gathers weather data from a directory on the local
machine. This weather data is stored in form of a .mat file. The function keeps
track of missing .mat files. Temperature, UV index, weather condition, etc.,
data are stored in matrices.

Python form of this function imitates this behavior. It uses numpy arrays for
matrix manipulations, it uses pandas time series for putting a timestamp on
individual data points. In the end, Python data acquisition function returns
a dictionary data containing weather data and the timestamp data.

#### Future Work

Future work involves rewriting the remaining MATLAB functions in Python. The
Python data structures that are used earlier may be subject to change in the
future work, if shortcomings of certain data types against the MATLAB code are
detected.


## Theory Behind PV Forecasting System

## Reference Publications

The MATLAB code was created at the Chair of Energy Economy and Application
Technology in the Technical University of Munich. The code is described in the
following publications:

- El-Baz, Wessam, Peter Tzscheutschler, and Ulrich Wagner. "Day-ahead probabilistic
PV generation forecast for buildings energy management systems." Solar Energy
171 (2018): 478-490.

- El-Baz, Wessam, et al. "Impact of probabilistic small-scale photovoltaic
generation forecast on energy management systems." Solar Energy 165 (2018): 136-146.

The GUI was developed by Mohamed Eldakadosi, while the Python codes were created
by Çağatay Eren. Both projects were part of a research internship, conducted at
the same chair, under the supervision of Wessam El-Baz.

## Support and Contact

- Wessam El-Baz, wessam.elbaz@tum.de

- Mohamed Eldakadosi (GUI), m.eldakadosi@tum.de

- Cagatay Eren (Python code), c.eren@tum.de

Feel free to clone the repository.

Pull requests are welcomed.

# License Information
