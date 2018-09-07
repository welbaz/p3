# The Graphical User Interface (GUI)

## About the GUI

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

## Downloads

Two sets of files are available to download for this part;

1. MATLAB codes for the GUI. The main code is _PVpredictGUI.mlapp_, which
can be edited/run through MATLAB's App Designer.

2. Executable file to use the GUI as a standalone application.
__Note:__ MATLAB Runtime will be downloaded during the installation of the .exe file.

## Acquisition of Weather Forecasts

In order to predict the output power of the PV system, the user must acquire weather
forecasts for at least 10 days. This is possible through the provided buttons:

* ‘Once’: acquiring the weather forecast once upon the click.
* ‘Continuous’: weather forecasts will be obtained every 24 hour, starting from
the first click, until the user presses ‘STOP’.
* ‘Specific Duration’: similar to ‘Continuous’; however, the acquirement will
stop after the desired duration.

One possible format for the weather server is the following:

`http://api.wunderground.com/api/User_API/hourly10day/q/Germany/Munich.json`

## Results

When ‘Generate PV Forecast’ is clicked, computations of the forecasted power start.
The resulting outcome should be similar to the figure below.

![alt text](https://github.com/welbaz/P3/blob/master/images/Finalfig.png "Result")

In addition, the 1-hour deterministic and probabilistic forecasts are stored as
Excel sheets.

![alt text](https://github.com/welbaz/P3/blob/master/images/excelScreen.png "Excel Sheets")

## Future Work

The main functions of the MATLAB code have been successfully implemented in App
Designer to create the presented GUI. Nevertheless, further improvements are
possible by reducing the number of lines and increasing the execution efficiency.
The majority of the computation time is spent on DataAcq function, where weather
forecasts are stored as a MATLAB’s tscollection object. This suggests an area of
improvement to reduce the consumed time for this function.
