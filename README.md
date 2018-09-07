# Probabilistic Prediction for PV Systems on Buildings


## Welcome to The P3 System

The PV Probabilistic Prediction System (The P3 System) is a tool for predicting
the short-term power output of a PV system. It is developed via MATLAB at the
Chair of Energy Systems and Energy Economy, Technical University of Munich. The
system is represented by two means:

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

## About the MATLAB Code

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
by Çağatay Eren. Both projects were part of a research internship, conducted at
the same chair, under the supervision of Wessam El-Baz.

## Support and Contact

Please review the mentioned publications above for theoretical queries about the forecasting system. For further queries:
- Wessam El-Baz (wessam.elbaz@tum.de) 
- concerning the GUI: Mohamed Eldakadosi (m.eldakadosi@tum.de)
- concerning the python codes: Çağatay Eren (c.eren@tum.de)

Feel free to clone the repository.

Pull requests are welcomed.

## License Information
