# The Python Codes

## About Python Implementation

Python code puts into action the same algorithm as in the MATLAB code in Python
language. It is believed that Python version reaches a broader audience in the
open source community and paves the way for running the code in Linux on lower-end
computer hardware (such as Raspberry Pi).

To run the code on your local machine, you need:

- Python version 3.x.x, available for download [here](https://www.python.org/downloads/).

- Code in this repository. Simply clone/download the code inside this repository.

## Current Progress

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

### DataAcq.m

Data acquisition function gathers weather data from a directory on the local
machine. This weather data is stored in form of a .mat file. The function keeps
track of missing .mat files. Temperature, UV index, weather condition, etc.,
data are stored in matrices.

Python form of this function imitates this behavior. It uses numpy arrays for
matrix manipulations, it uses pandas time series for putting a timestamp on
individual data points. In the end, Python data acquisition function returns
a dictionary data containing weather data and the timestamp data.

## Future Work

Future work involves rewriting the remaining MATLAB functions in Python. The
Python data structures that are used earlier may be subject to change in the
future work, if shortcomings of certain data types against the MATLAB code are
detected.
