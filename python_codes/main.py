# MAIN function

# import libraries
import numpy as np  # for multi-dim arrays
import pandas as pd  # for datetime, timestamp etc.
import data_acq

# ---User inputs
# The folder that contains .mat files:
real_path = '/home/erencaga/Documents/UNIVERSITY/TUM/second_semester/smartUp/data/PV Predict Group/Testdata/'
dummy_path = '/home/erencaga/Documents/UNIVERSITY/TUM/second_semester/smartUp/data/PV Predict Group/dummy_test_data/'
dot_mat_files_data_path = real_path


# ---Used method for training/prediction---
# Use 'relative_values' or 'absolute_values' for error calculation

diff_method = 'relative_values'

# 'GLM', 'forest' as bagging or 'normal_tree' as prediction method
prediction_method = 'forest'

# ---Type of prediction---
# 'daywise' : 10 day prediction. Training horizon grows day by day & inital
#    training horizon set below (time inputs for training).
# 'once' : Training horizon and prediction horizon all calculated at once.

prediction_type = 'once'

# ---Time inputs for training---

start_time_t_string = '20160501T000000'  # min. 20160501T000000
end_time_t_string = '20161230T235900'    # max. 20170601T235900

start_time_t = pd.to_datetime(start_time_t_string)  # conversion into timestamp
end_time_t = pd.to_datetime(end_time_t_string)      # conversion into timestamp

time_step = 60     # in minutes
time_step_1m = 10  # for probability training

# Generate a time range
freq_string = str(time_step) + 'min'
freq_string_1m = str(time_step_1m) + 'min'

tt = pd.date_range(start_time_t, end_time_t, freq=freq_string)  # pv prediction
t1mt = pd.date_range(start_time_t, end_time_t, freq=freq_string_1m)

# ---Time inputs for prediction

start_time_string = '20170101T000000'
end_time_string = '20171231T235900'

start_time = pd.to_datetime(start_time_string)  # conversion into timestamp
end_time = pd.to_datetime(end_time_string)      # conversion into timestamp

# Generate a time range
t = pd.date_range(start_time, end_time, freq=freq_string)
UTC = 0

# ---Setting for location and pv system

# munich data:
latitude = 48.1505119
longitude = 11.568185099999937
altitude = 515.898
# change above values for other locations
# store the location data in a dictionary
location = {'latitude': latitude, 'longitude': longitude, 'altitude': altitude}

# ---PV system parameters for prediction and training

ppeak = 3  # in kW, pv peak power
tilt = 30  # in DEGREES, inclination angle (ground = 0, verticle = 90)
azimuth = 200
eff = 0.16
number_of_modules = 12
module_area = 1.67  # in METER-SQUARED
# change above values for other pv systems
# store the pv system data in a dictionary
pv_system = {'ppeak': ppeak, 'tilt': tilt, 'azimuth': azimuth, 'eff': eff, 'number_of_modules': number_of_modules, 'module_area': module_area}


if 'weatherforecast' not in dir():
    weatherforecast = data_acq.data_acq(dot_mat_files_data_path)

# For daywise simulation
if prediction_type == 'daywise':
    data_measurement_matrix = np.zeros((1, 24 * 366))
    data_clearsky_matrix = np.zeros((1, 24 * 366))
    data_pv_certainties_matrix = np.zeros((1, 24 * 366))
    data_pv_predict_matrix = np.zeros((1, 24 * 366))

# ---Training---
