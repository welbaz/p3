# Probabilistic Prediction for PV Systems on Buildings


## Welcome to The P3 System

The PV Probabilistic Prediction System (The P3 System) is a tool for predicting
the short-term power output of a PV system. It available as:

* A graphical user interface (GUI), which you can simply download and install on
your PC. For more information, [click here](https://github.com/welbaz/P3/tree/master/MATLAB_GUI).
* A Python code, which will be implemented over a Raspberry Pi. For more information, [click here](https://github.com/welbaz/P3/tree/master/python_codes).


## Downloads

[Click here](https://github.com/welbaz/P3/tree/master/Matlab_Codes) to access all
the MATLAB codes concerning the P3 system.

The forecasts can be obtained by running _Main.m_. All the other functions must be
present as well.

To obtain the weather forecasts, run _AcquireWeather.m_. You must provide your API
key in order to be able to get the 10-day weather forecast.

## About the Code

The diagram below highlights the inputs and the outputs of the MATLAB code.

![alt text](https://github.com/welbaz/P3/blob/master/images/flowChart.png "Flow Chart")

### Input data

In order to predict the generated power of a PV system, three inputs must be
provided:

(1) _Weather Forecasts:_ This is obtained from an online service provider
(e.g.Weather Underground). In this model, 10-day forecasts of 1-hour resolution
are used. The forecasts must cover the training and prediction periods. The
temperature and the cloudiness are the critical weather parameters to the code.

(2) _PV System’s Parameters:_ Including location, orientation and technical parameters.

(3) _Historic PV System’s Generated Power:_ The generation for the training
horizon is acquired through the energy monitoring system connected to the PV modules.

### Output Forecasts

(1) _Deterministic Forecast:_ Prediction of only one profile of the PV generated
power with no probability involved.

![alt text](https://github.com/welbaz/P3/blob/master/images/detFor2.PNG "Deterministic Forecast")

(2) _Probabilistic Forecast:_ Multiple output profiles, each is associated with a
specific probability. For example, for q=30, the probability of generating less
than or equal to the corresponding profile is 30%.

![alt text](https://github.com/welbaz/P3/blob/master/images/proFor2.PNG "Probabilistic Forecast")


## Reference Publications and Developers

The MATLAB code was created at the Chair of Energy Economy and Application
Technology in the Technical University of Munich. The code is described in the
following publications:

- W. El-Baz, M. Seufzger, S. Lutzenberger, P. Tzscheutschler and U. Wagner,
"Impact of probabilistic small-scale photovoltaic generation forecast
on energy management systems," _Solar Energy_, vol. 165, pp. 136-146, 1 May 2018.

- W. El-Baz, P. Tzscheutschler and U. Wagner, "Day-ahead probabilistic PV
generation forecast for buildings energy management systems," _Solar Energy_,
vol. 171, pp. 478-490, 1 September 2018.

The GUI was developed by Mohamed Eldakadosi, while the Python codes were created
by Çağatay Eren. 

## Available Sources 
### Matlab Source Code
#### Matlab GUI

The GUI is developed, through MATLAB’s App Designer, to facilitate the prediction
process to owners of PV systems. The main layout is shown below.

![alt text](https://github.com/welbaz/P3/blob/master/images/p3.png "Main Layout")

The user is requested to provide information concerning the PV system:

* Location, technical and orientation parameters.
* The server (or address) where the historic output power is obtained.
* The weather server where the weather forecasts are acquired.
* The directory where weather forecasts are stored.
* The training horizon.
* The prediction horizon.
* The directory where PV predicted outputs are stored.

__Note:__ The button ‘Check Validity’ helps the user to verify whether the dates
entered comply with the available weather forecasts. If ‘Period Selection’ is
chosen as ‘Auto,’ then dates will be automatically filled in.

#### Downloads

Two sets of files are available to download for this part;

1. MATLAB codes for the GUI. The main code is _PVpredictGUI.mlapp_, which
can be edited/run through MATLAB's App Designer.

2. Executable file to use the GUI as a standalone application.
__Note:__ MATLAB Runtime will be downloaded during the installation of the .exe file.

#### Acquisition of Weather Forecasts

In order to predict the output power of the PV system, the user must acquire weather
forecasts for at least 10 days. This is possible through the provided buttons:

* ‘Once’: acquiring the weather forecast once upon the click.
* ‘Continuous’: weather forecasts will be obtained every 24 hour, starting from
the first click, until the user presses ‘STOP’.
* ‘Specific Duration’: similar to ‘Continuous’; however, the acquirement will
stop after the desired duration.

One possible format for the weather server is the following:

`http://api.wunderground.com/api/User_API/hourly10day/q/Germany/Munich.json`

#### Results

When ‘Generate PV Forecast’ is clicked, computations of the forecasted power start.
The resulting outcome should be similar to the figure below.

![alt text](https://github.com/welbaz/P3/blob/master/images/Finalfig.png "Result")

In addition, the 1-hour deterministic and probabilistic forecasts are stored as
Excel sheets.

![alt text](https://github.com/welbaz/P3/blob/master/images/excelScreen.png "Excel Sheets")

#### Future Work

The main functions of the MATLAB code have been successfully implemented in App
Designer to create the presented GUI. Nevertheless, further improvements are
possible by reducing the number of lines and increasing the execution efficiency.
The majority of the computation time is spent on DataAcq function, where weather
forecasts are stored as a MATLAB’s tscollection object. This suggests an area of
improvement to reduce the consumed time for this function.

### The Python Codes

#### About Python Implementation

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


## Support and Contact

Please review the mentioned publications above for theoretical queries about the forecasting system. For further queries:
- Wessam El-Baz (wessam.elbaz@tum.de) 
- concerning the GUI: Mohamed Eldakadosi (m.eldakadosi@tum.de)
- concerning the python codes: Çağatay Eren (c.eren@tum.de)
## License Information
