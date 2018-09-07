function z = checkPredictTime(folder, DirP, StartP, EndP, StartT, EndT, msgOpt)
% checks whether given prediction start and end times are valid according to
% the user's input, by verifying the available dates in weather forecast data
% folder and training start and end times

z=1;

opts.WindowStyle='non-modal';
opts.Interpreter='tex';
%folder='C:\Users\MOHAMED\OneDrive\Share with Surface\PVprop\Testdata\';

files = dir(folder);
removeFiles=find([files.bytes]==0);     %remove empty files
files(removeFiles)=[];


D1=datestr(datenum([files(1).name(1:8) files(1).name(10:11)],'yyyymmddHH'));
D1=datetime(D1)+hours(1);
D2=datestr(datenum([files(end).name(1:8) files(end).name(10:11)],'yyyymmddHH'));
D2a=datetime(D2)+days(8);
D2b=datetime(D2)+days(9);

%Prediction Start Time should be after the 1st available date (by 10 days)
if datenum(StartP)>datenum(D2a)
    errordlg(['\fontsize{14}Prediction Start Time cannot be after '...
        datestr(D1,0) '.'],'Prediction Times Error',opts)
    z=0;
end

%Prediction Start Time should not be after (last day - 2 days)
if datenum(StartP)>datenum(D2a)
    errordlg(['\fontsize{14}Prediction Start Time cannot be after '...
        datestr(D2a,0) '.'],'Prediction Times Error',opts)
    z=0;
end

%Prediction End Time should not be after last availabe day
if datenum(EndP)>datenum(D2b)
    errordlg(['\fontsize{14}Prediction End Time cannot be after '...
        datestr(D2b,0) '.'],'Prediction Times Error',opts)
    z=0;
end

%Prediction End time must be after Start time
if datenum(EndP)<datenum(StartP)
        errordlg(['\fontsize{14}Prediction End Time must be after '...
            'Start Time.'],'Prediction Times Error',opts)
        z=0;
end

%Prediction End time cannot be before Training Start Time
if datenum(StartP)<(datenum(EndT))
        errordlg(['\fontsize{14}Prediction Start Time must be after '...
            'Training End Time.'],'Prediction Times Error',opts)
        z=0;
end

%The directory for saving prediction results must exist
if (exist(DirP,'dir')==0)
    errordlg({'\fontsize{14}Given directory does not exist. ';...
        'PV forecast cannot be generated.'},'Results Directory Error',opts)
    z=0;    
end

%msgOpt = 1 --> show validity message
%msgOpt = 0 --> don't show validity message
if z==1 && msgOpt==1
    msgbox('\fontsize{14}Prediction times are within permissible range.', 'Check Validity',opts)
end

end