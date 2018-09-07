function y = checkTrainingTime(folder, StartT, EndT, msgOpt)
%check if the given times for Training are within range as per the data
%available in the weather forecast folder

y=1;

%folder='C:\Users\MOHAMED\OneDrive\Share with Surface\PVprop\Testdata\';

files = dir(folder);
removeFiles=find([files.bytes]==0);     %remove empty files
files(removeFiles)=[];


D1=datestr(datenum([files(1).name(1:8) files(1).name(10:11)],'yyyymmddHH'));
D1=datetime(D1)+hours(1);
D2=datestr(datenum([files(end).name(1:8) files(end).name(10:11)],'yyyymmddHH'));
D2=datetime(D2)+days(9);

%Training Start Time should be after the first available date in the data
if datenum(StartT)<datenum(D1)
    opts.WindowStyle='non-modal';
    opts.Interpreter='tex';
    errordlg(['\fontsize{14}Training Start Time must be after '...
        datestr(D1,0) '.'],'Training Times Error',opts)
    y=0;
end

%Training Start Time should be before 10 days prior to the last available
%day, so the minimum training period is 10 days (in case the user inputs
%End Time as the last available day)
DX=datetime(D2)-days(19);
if datenum(StartT)>datenum(DX)
    opts.WindowStyle='non-modal';
    opts.Interpreter='tex';
    errordlg(['\fontsize{14}Training Start Time must be before '...
        datestr(DX,0) '.'],'Training Times Error',opts)
    y=0;
end

%Training End Time should be before the last available date in the data or
%the current time
if datenum(D2)<datenum(now) && datenum(EndT)>datenum(D2)
    opts.WindowStyle='non-modal';
    opts.Interpreter='tex';
    errordlg(['\fontsize{14}Training End Time must be before '...
        datestr(D2,0) '.'],'Training Times Error',opts)
    y=0;
else if datenum(now)<datenum(D2) && datenum(EndT)>datenum(now)
    opts.WindowStyle='non-modal';
    opts.Interpreter='tex';
    errordlg(['\fontsize{14}Training End Time must be before '...
        datestr(now,0) '.'],'Training Times Error',opts)
    y=0;
    end
end


%Training End time must be after Start time
if datenum(EndT)<datenum(StartT) || (datenum(EndT)-datenum(StartT)<10)
        opts.WindowStyle='non-modal';
        opts.Interpreter='tex';
        errordlg(['\fontsize{14}Training End Time must be after '...
            'Start Time by at least 10 days.'],'Training Times Error',opts)
        y=0;
end

%if all times meet requirement, then show a message confirming validity
%msgOpt = 1 --> show validity message
%msgOpt = 0 --> don't show validity message
if y==1 && msgOpt==1
    opts.WindowStyle='non-modal';
    opts.Interpreter='tex';
    msgbox('\fontsize{14}Training times are within permissible ranges.', 'Check Validity',opts)
end

end