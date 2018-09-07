function MainForApp2(StartTimeT,EndTimeT,timestep1m,StartTimeP,EndTimeP,Location,PVsystem,WeatherDir,xlsDir,server,Temp,TempEff,Zen,ZenEff,ZenDir,OhmEff)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PV Probabilistic Forecast %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear EndTimeP EndTimeT error Location PV PVClearsky PVpredict PVsystem StartTimeP StartTimeT t tilt timestep tree tt UTC Distrib 
% close all
% clear PVpredictArea

%for status messages
opts.WindowStyle='replace';
opts.Interpreter='tex';
Status=msgbox('\fontsize{13}Analyzing available data in the Weather Forecast directory...  ','Forecast Status',opts);
set(findobj(Status,'style','pushbutton'),'Visible','off');
%Status.Visible='off';
%Status.Position=[500 500 350 54];
%set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Analyzing available data in the Weather Forecast directory...  ')
%Status.Visible='on';

%% Methods and Types

%Use "RelativeValues" or "AbsoluteValues" for error calculation
DiffMethod = 'RelativeValues';

%Method for Regression Tree: "GLM", "Forest" as Bagging or "NormalTree"
Method = 'Forest';

% Type of prediction
type='once';

%% Training's Time Inputs

%set training's start and end times
%(user input & depending on available data)
% % StartTimeT = datetime(2016,5,1,0,0,0);
% % EndTimeT = datetime(2016,8,30,0,0,0);

timestep=60;   %[minutes] i.e. 1 hour
% % timestep1m=10;  %for probability training

%create a time vector for training with 1-hour resolution
TimeT=StartTimeT:minutes(timestep):EndTimeT;

%create a time vector with 10-minute resolution
Time1mT=StartTimeT:minutes(timestep1m):EndTimeT;

UTC=0;

%% Prediction's Time Input

%%set training's start and end times (should be 'now' & 'now+24h')
% % StartTimeP=datetime(2016,9,1,0,0,0);         
% % EndTimeP=datetime(2016,9,2,0,0,0);         

%create a time vector for prediction with 1-hour resolution
TimeP=StartTimeP:minutes(timestep):EndTimeP;

UTC=0;

%% Parameters of Location

%user's inputs
% % Location.latitude=48.1505119;
% % Location.longitude=11.568185099999937;
% % Location.altitude=515.898;

%% Parameters of PV System

%user's input
% % ppeak=3;        %PV Peak Power
% % tilt=30;        %degrees i.e., inclination angle of the PV system ( ground == 0 verticle ==90)
% % azimuth=200;    %wrt North (phi_north = 0)
% % eff=0.16;       %system's efficiency
% % No_modules=12;  %number of modules
% % Amodule=1.67;   %area of each module [m2]
% % 
% % PVsystem.powerpeak=ppeak;
% % PVsystem.tilt=tilt;
% % PVsystem.azimuth=azimuth;
% % PVsystem.eff=eff;
% % PVsystem.No_modules=No_modules;
% % PVsystem.Amodule=Amodule;
% % PVsystem.OArea=No_modules*Amodule;  %total area PV systems

%% Data Acquisition

files = dir(WeatherDir);
removeFiles=find([files.bytes]==0);     %remove empty files
files(removeFiles)=[];
DD1=datenum([files(1).name(1:8) files(1).name(10:11)],'yyyymmddHH');
DD2=datenum([files(end).name(1:8) files(end).name(10:11)],'yyyymmddHH');

WfileName=[xlsDir 'WeatherforecastOrg.mat'];
if exist(WfileName)==2
    load(WfileName,'WeatherforecastOrg','WRange')
    if (WRange.D1~=DD1) || (WRange.D2~=DD2)
        [WeatherforecastOrg, WRange]=DataAcq2(timestep,WeatherDir);            %structuring PV measurement data if not already done
        save(WfileName,'WeatherforecastOrg','WRange')
    end
else if exist(WfileName)==0
    [WeatherforecastOrg, WRange]=DataAcq2(timestep,WeatherDir);            %structuring PV measurement data if not already done
    save(WfileName,'WeatherforecastOrg','WRange')
    end
end

%% Training

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Training...')

%Generate regression tree for training based on: parameters of location and
%PV system, training's time vector, collected weather forecast data (as per
%the availabe data in the file), error calculation method and regression
%tree method
[tree]=PVtrainApp(Location,PVsystem,TimeT,UTC,WeatherforecastOrg,DiffMethod,Method,server,Temp,TempEff,Zen,ZenEff,ZenDir,OhmEff);    % train regression tree

%% Prediction

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Generating PV deterministic forecast...')

%Obtain PV predicted data and also Clear Sky data for the prediction period
[PVdetpredict, PVClearsky]=PVpredictApp(Location,PVsystem,TimeP,UTC,tree,WeatherforecastOrg,DiffMethod,Temp,TempEff,Zen,ZenEff,ZenDir,OhmEff);
PVClearsky=timeseries(PVClearsky,datestr(TimeP),'name','PVCleasrsky');
PVdetpredict=timeseries(PVdetpredict,datestr(TimeP),'name','PVpredict');

%for training purposes
[PVpredictT]=PVpredictApp(Location,PVsystem,TimeT,UTC,tree,WeatherforecastOrg,DiffMethod,Temp,TempEff,Zen,ZenEff,ZenDir,OhmEff);
PVpredictT=timeseries(PVpredictT,datestr(TimeT),'name','PVpredict');

%% Deterministic Forecast

%save PV deterministic forecast to new Excel file
DataPVpredict = PVdetpredict;          
DetFileName = [xlsDir 'Deterministic_Forecast_' datestr(now,30)];

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Saving PV deterministic forecast as xls format...')

xlswrite(DetFileName,{'Time','Power [kW]'});
xlswrite(DetFileName,cellstr(datestr(TimeP,0)),1,'A2');
xlswrite(DetFileName,DataPVpredict.Data/1000,1,'B2');

%plot PV deterministic forecast
% % figure
% % plot(TimeP,PVdetpredict.Data/1000)
% % title('PV Deterministic Forecast')
% % xlabel('Time [hours]')
% % ylabel('Power [kW]')
% % xlim([datenum(StartTimeP) datenum(EndTimeP)])
% % datetick('x',15,'keeplimits')


%% Extract Data from Weather-Forecasted Data

%Extract data samples into new timeseries object
%as per periods of training and prediction
%Weatherforecast
WeatherforecastP=getsampleusingtime(WeatherforecastOrg,datenum(StartTimeP),datenum(EndTimeP));

%Weatherforecast2
WeatherforecastT=getsampleusingtime(WeatherforecastOrg,datenum(StartTimeT),datenum(EndTimeT));

%% Collect Data for training of Probability

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Generating PV probabilistic prediction...')

t1m=StartTimeT:minutes(timestep1m):EndTimeT;

%resampling is done by linearly interpolating 1-hour data to have a
%resolution of 1-m
PVpredictT_1m=resample(PVpredictT,datestr(t1m));
Weatherforecast_1m=resample(WeatherforecastOrg,datestr(t1m));
Weather_data_1m=[Weatherforecast_1m.temp.Data(:,10) Weatherforecast_1m.sky.Data(:,10) Weatherforecast_1m.cond.Data(:,10)];

%obtain 1-min-resolution AC power
AC_power_1m=emoncmsApp(server,StartTimeT,EndTimeT,timestep1m);
AC_power_1m=AC_power_1m(:,2)*1000;

%obtain 1-min-resolution Clear Sky Model
PVClearsky_1m=clearskygenApp(PVsystem,Location,t1m,UTC,Zen,ZenEff,ZenDir,OhmEff);

%% Replacing Zero with NaN

ZeroIndex_1m=find(PVClearsky_1m==0);
AC_power_1m(ZeroIndex_1m)=nan;
PVClearsky_1m(ZeroIndex_1m)=nan;
NanIndex_1m=isnan(AC_power_1m);

ZeroIndex = find(DataPVpredict.Data==0);
WeatherforecastP.cond.Data(ZeroIndex,10)=nan;

%% Training for Probability

%Diff_1m is relative difference training variable
Diff_1m=(PVpredictT_1m.Data-AC_power_1m)./PVpredictT_1m.Data;    %diff compuated as relative values

InfIndex=find(Diff_1m==inf);   %to neglect inf high values
Diff_1m(InfIndex)=nan;                  
InfIndex=find(Diff_1m==-inf); 
Diff_1m(InfIndex)=nan;

DiffDataTypeday=[Weather_data_1m(:,3) Diff_1m]; %acquire data for the generation of the CDF functions
Distrib=TrainProp(DiffDataTypeday);     %generate CDF functions

%% Calculate values for generating probability lines

%generate differences by using CDF functions
%DiffpCond is Lambda_p(t_f) (prediction of the regression trees)
DiffpCond=GenPro(Distrib,WeatherforecastP.cond.Data(:,10));

%% Generate Probability Lines 

%duplicate PV_Deterministic_Forecast 9 times
%corresponding to q=[10% ... 90%]
PVpredictDup=repmat(PVdetpredict.Data, [1,9]);

%generate Point Generation Forecast (P_pf(t_f))
PVpredictp2=PVpredictDup-DiffpCond.*PVpredictDup;

[Ix Iy]=find(PVpredictp2<0);
PVpredictp2(Ix,Iy)=0;
[Ix Iy]=find(PVpredictp2>3000);
PVpredictp2(Ix,Iy)=3000;

ZeroIndex_After=find(PVdetpredict.Data==0);
PVpredictp2(ZeroIndex_After,:)=0;

%% Save PV Probabilistic Forecast to Excel

PVpropPredict = PVpredictp2;
PropFileName = [xlsDir 'Probabilistic_Forecast_' datestr(now,30)];

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Saving PV probabilistic prediction as xls format...')

xlswrite(PropFileName,{'Power [kW]'},1,'B1');
columns = {'Time','q=10%','q=20%','q=30%','q=40%','q=50%',...
    'q=60%','q=70%','q=80%','q=90%'};
xlswrite(PropFileName,columns,1,'A2');
xlswrite(PropFileName,cellstr(datestr(TimeP,0)),1,'A3');
xlswrite(PropFileName,PVpropPredict/1000,1,'B3');

%% Plot PV Probabilistic Forecast

[w z]=size(PVpredictp2);
PVpredictArea(:,1)=PVpredictp2(:,9);
for i=2:z
    PVpredictArea(:,i)=PVpredictp2(:,z+1-i)-PVpredictp2(:,z-i+2);
end
PVpredictArea=PVpredictArea/1000;

% % figure
% % bar(datenum(TimeP),PVpredictArea,'stacked','EdgeColor','none')
% % %colormap('gray')
% % legend('q=90%','q=80%','q=70%','q=60%','q=50%','q=40%','q=30%','q=20%','q=10%')
% % ylabel('Power [kW]')
% % % set(gca,'XTick',0:2:24,...
% % %     'XTickLabel',...
% % %     {'0 ','2 ','4 ','6 ','8 ','10','12','14','16','18','20','22','24'});
% % xlabel('Time [hours]')
% % title('PV Probabilistic Forecast')
% % xlim([datenum(StartTimeP) datenum(EndTimeP)])
% % datetick('x',15,'keeplimits')


%% Creating Figures in seperate UIFigures

set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}Plotting PV deterministic and probabilistic forecasts...')

% PV deterministic forecast
DetFor = uifigure('Name','PV Deterministic Forecast','Position',[139 227 751 639]);
DetForAx = uiaxes(DetFor);
DetForAx.FontSize = 20;
DetForAx.Position = [20 28 700 600];
plot(DetForAx, TimeP, PVdetpredict.Data/1000)
title(DetForAx, {'PV Deterministic Forecast'; ['(' datestr(StartTimeP,'dd.mm.yyyy HH:MM:SS')...
    ' to ' datestr(EndTimeP,'dd.mm.yyyy HH:MM:SS') ')']});
xlabel(DetForAx, 'Time [hour]')
ylabel(DetForAx, 'Power [kW]')
xlim(DetForAx, [StartTimeP EndTimeP])
ylim(DetForAx, [0.0 3.0])

% PV probabilistic forecast
PropFor = uifigure('Name','PV Probabilistic Forecast','Position',[950 227 751 639]);
PropForAx = uiaxes(PropFor);
PropForAx.FontSize = 20;
PropForAx.Position = [20 28 700 600];
bar(PropForAx,TimeP,PVpredictArea,'stacked','EdgeColor','none')
legend(PropForAx,'q=90%','q=80%','q=70%','q=60%','q=50%','q=40%','q=30%','q=20%','q=10%')
ylabel(PropForAx,'Power [kW]')
xlabel(PropForAx,'Time [hours]')
title(PropForAx,{'PV Probabilistic Forecast'; ['(' datestr(StartTimeP,'dd.mm.yyyy HH:MM:SS')...
    ' to ' datestr(EndTimeP,'dd.mm.yyyy HH:MM:SS') ')']})
xlim(PropForAx,[StartTimeP EndTimeP])
ylim(PropForAx, [0.0 3.0])
%datetick('x',15,'keeplimits')


%Display Completion Message
set(findobj(Status,'Tag','MessageBox'),'String','\fontsize{13}\color[rgb]{0,0.6,0}Prediction generation has been successfully completed!')

end
