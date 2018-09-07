def data_acq(dot_mat_files_data_path):

    '''
    TO DO'S:
    1- Write a doc-string explaining the input arguments and return arguments,
        and the general flow of the function code.
    '''
    import os.path  # for folder reading
    import numpy as np  # for multi-dim arrays
    import scipy.io  # for reading .mat files
    import pandas as pd  # for datetime, timestamp etc.
    import math  # for NaN values

    # DEFINE DATA PATH:
    # `real` for real operation
    # `dummy` for testing purposes -contains less amount of .mat files
    data_path = dot_mat_files_data_path
    # indices that squeeze the time data of the .mat files:
    lower_index = -41
    upper_index = -27

    # END- DATA PATH

    # SORT FILES:
    # Sort the files in the `data_path` according to their creation date from
    # oldest to the newest.


    def sorted_ls(path):
        mtime = lambda f: os.stat(os.path.join(path, f)).st_mtime
        return list(sorted(os.listdir(path), key=mtime))


    # Store the sorted file list
    sorted_file_list = sorted_ls(data_path)

    # Give full path to data in `sorted_file_list`
    a = 0
    for file in sorted_file_list:
        sorted_file_list[a] = data_path + file
        a += 1

    del a, file  # purge auxiliary variables

    # Check and eliminate the files with 0 bytes of size
    index = 0
    for file in sorted_file_list:
        if os.path.getsize(sorted_file_list[index]) == 0:
            del sorted_file_list[index]
        index += 1

    del index, file  # purge auxiliary variables

    # Check the creation (last modification times) dates of individual files
    # in `sorted_file_list`
    index = 0
    mem = 0  # keep the length change in `file_index_list_with_errors` in mind
    file_index_list = list(range(0, len(sorted_file_list)))
    file_index_list_with_errors = file_index_list[:]  # dont change file_index_list
    while index < len(sorted_file_list) - 1:
        # calculate the time difference (in seconds) between two consecutive files
        diff_secs = os.path.getmtime(sorted_file_list[index +1]) - os.path.getmtime(sorted_file_list[index])
        # check if the time difference between .mat files
        # is less than 15 mins or more than 2 days
        # 169344 secs = 1.94 days, and 90720 secs - 89856 secs = 14.4 minutes
        if (diff_secs > 169344 or (89856 < diff_secs < 90720)):
            # convert time difference into days
            # 86430 seconds = 1 day
            diff_days = round(diff_secs / 86430)
            if diff_days > 1:
                k = diff_days - 1
            else:
                k = diff_days
            # fill missing days with `nan` indices
            file_index_list_with_errors[(index + mem + 1):(index + mem + 1)] = [math.nan] * k
            mem += k

        index += 1

    del index, mem, diff_secs, diff_days, k  # purge auxiliary variables

    m = len(file_index_list_with_errors)
    # END- SORT FILES

    # PREPARE WEATHER DATA CONTAINERS:
    # Initialize the data containers for weather data

    # Store following attributes from .mat weather data
    # Beware deep copy vs. shallow copy in python !
    array_shape = (m, 240 + m * 24)
    temp = np.zeros(array_shape)
    uvi = np.zeros(array_shape)
    cond = np.empty(array_shape, dtype=object)
    cond[:, :] = 'NA'
    sky = np.zeros(array_shape)
    wspd = np.zeros(array_shape)
    wdir = np.zeros(array_shape)
    snow = np.zeros(array_shape)
    humidity = np.zeros(array_shape)
    mslp = np.zeros(array_shape)
    wx = np.empty(array_shape, dtype=object)
    wx[:, :] = 'NA'

    # END- PREPARE WEATHER DATA CONTAINERS

    # READ .MAT FILES
    # Read .mat files in the folder. Store the file contents in numpy arrays.
    # Loop through the variables inside the .mat file
    ii = list(range(0, m))
    k = 0
    for i in ii:
        # `nan` values in the `file_index_list_with_errors` denote some missing data.
        # Skip those files.
        # if the given element is not `nan`:
        if ~np.isnan(file_index_list_with_errors[i]):
            # load the file_index-th file
            file_name = sorted_file_list[file_index_list_with_errors[i]]
            mat_read = scipy.io.loadmat(file_name, struct_as_record=False, squeeze_me=True)
            mat_DataOut = mat_read['DataOut']
            j = 0
            while(j < 240):
                if hasattr(mat_DataOut.data, 'hourly_forecast') and (mat_DataOut.data.hourly_forecast.size):
                    temp[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].temp.metric)
                    uvi[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].uvi)
                    cond[i, k + j] = mat_DataOut.data.hourly_forecast[j].condition
                    sky[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].sky)
                    wspd[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].wspd.metric)
                    wdir[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].wdir.degrees)
                    snow[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].snow.metric)
                    humidity[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].humidity)
                    mslp[i, k + j] = float(mat_DataOut.data.hourly_forecast[j].mslp.metric)
                    wx[i, k + j] = mat_DataOut.data.hourly_forecast[j].wx
                else:
                    # put 'NaN' to most of them and 'Clear' to one of them
                    temp[i, k + j] = float('nan')
                    uvi[i, k + j] = float('nan')
                    cond[i, k + j] = 'Clear'
                    sky[i, k + j] = float('nan')
                    wspd[i, k + j] = float('nan')
                    wdir[i, k + j] = float('nan')
                    snow[i, k + j] = float('nan')
                    humidity[i, k + j] = float('nan')
                    mslp[i, k + j] = float('nan')
                    wx[i, k + j] = 'Nan'
                    #
                j += 1
            #
            k = (i + 1) * 24  # leave 24 zero values for each line

    del i, ii, k, j, file_name, mat_read, mat_DataOut  # purge auxiliary variables
    # let's save the data containers as .txt files so that we can examine them
    np.savetxt('temp.txt', temp)
    np.savetxt('uvi.txt', uvi)
    np.savetxt('cond.txt', cond, fmt='%s')
    np.savetxt('sky.txt', sky)
    np.savetxt('wspd.txt', wspd)
    np.savetxt('wdir.txt', wdir)
    np.savetxt('snow.txt', snow)
    np.savetxt('humidity.txt', humidity)
    np.savetxt('mslp.txt', mslp)
    np.savetxt('wx.txt', wx, fmt='%s')
    # END- READ .MAT FILES

    # POST-PROCESSING
    # Post processing initialization
    n = (m + 9) * 24

    temp_10 = np.zeros((10, n))
    uvi_10 = np.zeros((10, n))
    cond_10 = np.empty((10, n), dtype=object)
    sky_10 = np.zeros((10, n))
    wspd_10 = np.zeros((10, n))
    wdir_10 = np.zeros((10, n))
    snow_10 = np.zeros((10, n))
    humidity_10 = np.zeros((10, n))
    mslp_10 = np.zeros((10, n))
    wx_10 = np.empty((10, n), dtype=object)

    # Assign selected elements of temp, uvi, etc. into temp_10, uvi_10 etc.
    # Put the first 240 elements of first 10 rows of temp into first 240 elements
    # of first 10 rows (has already only 10 rows) of temp_10.
    # Do the same for other `_10` lists.

    temp_10[:, 0:240] = temp[0:10, 0:240]
    temp_10[:, n-240:n] = temp[m-10:m, n-240:n]

    uvi_10[:, 0:240] = uvi[0:10, 0:240]
    uvi_10[:, n-240:n] = uvi[m-10:m, n-240:n]

    cond_10[:, 0:240] = cond[0:10, 0:240]
    cond_10[:, n-240:n] = cond[m-10:m, n-240:n]

    sky_10[:, 0:240] = sky[0:10, 0:240]
    sky_10[:, n-240:n] = sky[m-10:m, n-240:n]

    wspd_10[:, 0:240] = wspd[0:10, 0:240]
    wspd_10[:, n-240:n] = wspd[m-10:m, n-240:n]

    wdir_10[:, 0:240] = wdir[0:10, 0:240]
    wdir_10[:, n-240:n] = wdir[m-10:m, n-240:n]

    snow_10[:, 0:240] = snow[0:10, 0:240]
    snow_10[:, n-240:n] = snow[m-10:m, n-240:n]

    humidity_10[:, 0:240] = humidity[0:10, 0:240]
    humidity_10[:, n-240:n] = humidity[m-10:m, n-240:n]

    mslp_10[:, 0:240] = mslp[0:10, 0:240]
    mslp_10[:, n-240:n] = mslp[m-10:m, n-240:n]

    wx_10[:, 0:240] = wx[0:10, 0:240]
    wx_10[:, n-240:n] = wx[m-10:m, n-240:n]

    i = 2
    jj = list(range(241, n - 241, 24))
    for j in jj:
        temp_10[:, j:j+24] = temp[i:i+10, j:j+24]
        uvi_10[:, j:j+24] = uvi[i:i+10, j:j+24]
        cond_10[:, j:j+24] = cond[i:i+10, j:j+24]
        sky_10[:, j:j+24] = sky[i:i+10, j:j+24]
        wspd_10[:, j:j+24] = wspd[i:i+10, j:j+24]
        wdir_10[:, j:j+24] = wdir[i:i+10, j:j+24]
        snow_10[:, j:j+24] = snow[i:i+10, j:j+24]
        humidity_10[:, j:j+24] = humidity[i:i+10, j:j+24]
        mslp_10[:, j:j+24] = mslp[i:i+10, j:j+24]
        wx_10[:, j:j+24] = wx[i:i+10, j:j+24]
        #
        i += 1

    cond_10_mat = np.full((10, cond_10.shape[1]), np.nan)

    NA = cond_10 == 'exact'
    C = cond_10 == 'Clear'
    F = cond_10 == 'Fog'
    P = cond_10 == 'Partly Cloudy'
    M = cond_10 == 'Mostly Cloudy'
    O = cond_10 == 'Overcast'
    CR = cond_10 == 'Chance of Rain'
    CT = cond_10 == 'Chance of a Thunderstorm'
    R = cond_10 == 'Rain'
    T = cond_10 == 'Thunderstorm'
    S = cond_10 == 'Snow'
    SS = cond_10 == 'Snow Showers'

    np.place(cond_10_mat, NA == True, [0])
    np.place(cond_10_mat, C == True, [1])
    np.place(cond_10_mat, F == True, [2])
    np.place(cond_10_mat, P == True, [3])
    np.place(cond_10_mat, M == True, [4])
    np.place(cond_10_mat, O == True, [5])
    np.place(cond_10_mat, CR == True, [6])
    np.place(cond_10_mat, CT == True, [7])
    np.place(cond_10_mat, R == True, [8])
    np.place(cond_10_mat, T == True, [9])
    np.place(cond_10_mat, S == True, [10])
    np.place(cond_10_mat, SS == True, [11])

    wx_10_mat = np.full((10, wx_10.shape[1]), np.nan)
    unqwx = np.unique(wx)

    for i in list(range(len(unqwx))):
        wx_search = wx_10 == unqwx[i]
        np.place(wx_10_mat, wx_search == True, [i+1])

    start_time = pd.to_datetime(sorted_file_list[0][lower_index:upper_index+1])
    end_time = pd.to_datetime(sorted_file_list[-1][lower_index:upper_index+1])
    UTC = 0
    time_step = 60
    freq_string = str(time_step) + 'min'
    # generate a date range
    time_range = pd.date_range(start_time + pd.Timedelta(minutes=60) - pd.Timedelta(hours=UTC), end_time + pd.Timedelta(days=10) - pd.Timedelta(hours=UTC), freq=freq_string)

    # mimic matlab's tscollection object as a dictionary type data container in
    # python
    # `weatherforecast` stores the weather data which are read from the .mat files
    weatherforecast = {'temp': np.transpose(temp_10), 'uvi': np.transpose(uvi_10), 'sky': np.transpose(sky_10), 'wspd': np.transpose(wspd_10), 'wdir': np.transpose(wdir_10), 'snow': np.transpose(snow_10), 'cond': np.transpose(cond_10_mat), 'humidity': np.transpose(humidity_10), 'mslp': np.transpose(mslp_10), 'wx': np.transpose(wx_10_mat), 'time': time_range}

    # END- POST-PROCESSING
    return weatherforecast
