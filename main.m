clear altitude Amodule azimuth eff Endtime Endtimet error latitude Location longitude No_modules ppeak PV PVClearsky PVpredict Pvsystem Starttime Starttimet t tilt timestep tree tt UTC Distrib 
close all


%% used Method for training/prediction
%Use "RelativeValues" or "AbsoluteValues" for error calculation
DiffMethod = 'RelativeValues';
%"GLM", "Forest" as Bagging or "NormalTree" as prediction method
Method = 'Forest';
% Type of prediction: 
%"daywise": 10 day prediction. Training horizon grows day by day & Initial
%training horizon set below (time inputs for training) !!!!DON'T FORGET TO
%UNCOMMENT FOR LOOP IN LINE 91 & 256 FOR DAYWISE!!!!
%"once": Training horizon and prediction horizon all calculated at once
type='once';

%% time inputs for training
Starttimet=datetime(2016,5,1,0,0,0);    %min 2016,5,1,0,0,0
Endtimet=datetime(2016,9,1,23,59,0);    %max 2017,6,1,23,59,0
timestep=60;                            %mins
timestep1m=10;                          %for probability training
tt=Starttimet:minutes(timestep):Endtimet;   %for PV Prediction
t1mt=Starttimet:minutes(timestep1m):Endtimet;
UTC=0;

%% time inputs for prediction
Starttime=datetime(2016,7,1,0,0,0);         %2016,7,1,0,0,0
Endtime=datetime(2016,9,1,23,59,0);         %2016,9,1,23,59,0
t=Starttime:minutes(timestep):Endtime;
UTC=0;

%% Setting for Location and PV System
%%location inputs prediction and training
latitude=48.1505119;            % Munich 
longitude=11.568185099999937;   % Munich
altitude=515.898;               %
Location=locationstruct(latitude,longitude,altitude);

%%PV System Parameters for prediction and training
ppeak=3;    % PV Peak Power
tilt=30;    % degrees i.e., inclination angle of the PV system ( ground == 0 verticle ==90)
azimuth=200; %%180
eff=0.16;
No_modules=12;
Amodule=1.67;%%% m2

Pvsystem=pvsystemstruct(ppeak,tilt,azimuth,eff,No_modules,Amodule); %save variables as pvsystem.XX

if exist('WeatherforecastOrg') ~= 1     % checks im PV measurement data already structured for calculation
WeatherforecastOrg=dataAcq(timestep);   % structuring PV measurement data if not already done
end

if isequal(type,'daywise')
%% matrixes to store genrated data (for daywise simulation)
    DataMeasurementMa = zeros(1,24*366);
    DataClearSkyMa = zeros(1,24*366);
    DataPVcertaintiesMa = zeros(9,24*366);
    DataPVpredictMa = zeros(1,24*366);
end
% for tagVomJahr = 1:365  %For Daywise simulation(don't forget "end" at the end

%% Train

[tree]=PVtrain(Location,Pvsystem,tt,UTC,WeatherforecastOrg,DiffMethod,Method);    % train regression tree

%% Predict
[PVpredict2 PVClearsky2 AC_power2 error2]=PVpredict(Location,Pvsystem,tt,UTC,tree,WeatherforecastOrg,DiffMethod,Method);  %Prediction for Time horizon of trainin set...
                                                                                                        %...(needed for Training of Probability Generation)
[PVpredict PVClearsky AC_power error]=PVpredict(Location,Pvsystem,t,UTC,tree,WeatherforecastOrg,DiffMethod,Method);       %Prediction for Time horizon of Prediction
PVClearsky=timeseries(PVClearsky,datestr(t),'name','PVCleasrsky');
PVpredict=timeseries(PVpredict,datestr(t),'name','PVpredict');
PVpredict2=timeseries(PVpredict2,datestr(tt),'name','PVpredict');
AC_power=timeseries(AC_power,datestr(t),'name','AC_power');

DataPVpredict = PVpredict;          
save('DataPVpredict.mat','DataPVpredict');  %saving of normal PV prediction, needed for non-probilistic load shifting

Weatherforecast=getsampleusingtime(WeatherforecastOrg,datenum(Starttime),datenum(Endtime));
Weatherforecast2=getsampleusingtime(WeatherforecastOrg,datenum(Starttimet),datenum(Endtimet));
% %%
% PVClearsky=resample(PVClearsky,t1m);

% AC_power=resample(AC_power,t1m);
% Weatherforecast_train=resample(WeatherforecastOrg,datestr(t1mt));

Weather_data=[Weatherforecast.temp.Data(:,10) Weatherforecast.sky.Data(:,10) Weatherforecast.cond.Data(:,10)];
%%%%%Input for training
figure(2)
PV=[PVpredict.Data PVClearsky.Data AC_power.Data];
plot(PV,'DisplayName','PV')
title('Plot of PV');
legend('PVpredicted','PV Clearsky','AC power')

%%%%% Basic Error Analysis
Diff=PVpredict.Data-AC_power.data;
figure;
zs=find(AC_power.Data==0);
AC_power_OZNan=AC_power.Data;
Weather_data(zs,:)=[];
Diff(zs)=[];
AC_power_OZNan(zs)=[];
zs=find(AC_power.Data==nan);
Weather_data(zs,:)=[];
Diff(zs)=[];
AC_power_OZNan(zs)=[];
figure(3)
histfit(Diff)
title('histift von Diff');
figure(4)
boxplot(Diff)
title('boxplot von Diff');
% 
figure(5)
xRange = 1:10;         % Range of integers to compute a probability for
N = hist(Diff);        % Bin the data
plot(xRange,N./numel(Diff)) 
title('komischer plot');
figure(6)
[D, PD] = allfitdist(Diff, 'PDF'); %%% D(1) is the best distribution
%Diffp=icdf(PD{1,1},[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9])
%repmat(Diffp,[length()
%%%%%
%trainprop(DiffDataTemp);
relativeDiff=abs(Diff./AC_power_OZNan).*100;
relativeDiff(isnan(relativeDiff))=[];

%% Collect Data for training of Probability

t1m=Starttimet:minutes(timestep1m):Endtimet;
% 
PVpredict_1m=resample(PVpredict2,datestr(t1m));
Weatherforecast_1m=resample(WeatherforecastOrg,datestr(t1m));
Weather_data_1m=[Weatherforecast_1m.temp.Data(:,10) Weatherforecast_1m.sky.Data(:,10) Weatherforecast_1m.cond.Data(:,10)];
AC_power_1m=emoncms(1,320,Starttimet,Endtimet,timestep1m);
AC_power_1m=AC_power_1m(:,2)*1000;

PVClearsky_1m=clearskygen(Pvsystem,Location,t1m,UTC); %needed for line 116 /betterway:take PV-Predict in l.116 maybe

%% Pre-Processing of Data before using it 
%ZeroIndex_1m=find(AC_power_1m==0); 
ZeroIndex_1m=find(PVClearsky_1m==0);      %just take values for probabilities into account where PV-Prediction>0
AC_power_1m(ZeroIndex_1m)=nan;
PVClearsky_1m(ZeroIndex_1m)=nan;
NanIndex_1m=isnan(AC_power_1m);

ZeroIndex = find(DataPVpredict.Data==0);
Weatherforecast.cond.Data(ZeroIndex,10)=nan;

%% Training for Probability
%Diff_1m=PVpredict_1m.Data-AC_power_1m;  %original
Diff_1m=(PVpredict_1m.Data-AC_power_1m)./PVpredict_1m.Data;    %diff compuated as relative values
% InfIndex=find(Diff_1m>1);    %can be used for relativ values for areas at sunrise
                               %and sunset to avoid that values is huge due to very low
                               %value of PVpredict
% Diff_1m(InfIndex)=1;
InfIndex=find(Diff_1m==inf);            %dinf inf high values, occure due to partition with zero
Diff_1m(InfIndex)=nan;                  %don't consider inf values
InfIndex=find(Diff_1m==-inf); 
Diff_1m(InfIndex)=nan;

DiffDataTypeday=[Weather_data_1m(:,3) Diff_1m]; %aquire data for the generation of the CDF functions
Distrib=trainprop(DiffDataTypeday);     %generate CDF functions
%% Calculate values for generating probability lines
DiffpCond=genpro(Distrib,Weatherforecast.cond.Data(:,10));  %generate differences by using CDF functions
%  Diff_1m(NanIndex_1m)=[];
%  AC_power_1m(NanIndex_1m)=[];
%  Weather_data_1m(NanIndex_1m,:)=[];
%  relativeDiff_1m=(Diff_1m./AC_power_1m).*100;
%  figure(7)
%  xRange = 1:10;              %# Range of integers to compute a probability for
%  N = hist(Diff_1m);        %# Bin the data
%  plot(xRange,N./numel(Diff_1m)) 
%  figure(8)
%  boxplot(Diff_1m)


%freq=histc(Diff_1m,-2000:500:2500);



% % %%% 10%% cloudiness%%5
%  Weather_prop=weatherset(WeatherforecastOrg,Starttime,Endtime,2,timestep);
%  DiffDataTypeday(1:length(Diff_1m),2)=Diff_1m;
%  DiffDataTypeday(:,1)=floor(DiffDataTypeday(:,1));
%   Distrib=trainprop(DiffDataTypeday);
%   DiffpCond=genpro(Distrib,Weather_prop(:,3));
%   DistribTemp=trainprop(DiffDataTemp);
%  
%   DiffpSky=genpro(DistribSky,Weatherforecast.sky.Data(:,10))
%  
%   DiffpTemp=genpro(DistribSky,Weatherforecast.temp.Data(:,10))
%  
%   [m n]=size(DiffpSky);
%   for i=1:m
%       for j=1:n
%   Diffpf(i,j)=min(abs(DiffpSky(i,j)),abs(DiffpTemp(i,j)));
%       end
%   end
% %%%% Probability curves%%%%
% 

%% Generate Probability Lines 
  PVpredictp=repmat(PVpredict.Data, [1,9]);
  figure;
  plot(DiffpCond);
%   PVClearskyp=repmat(PVClearsky.Data, [1,9]);
%  PVpredictp1=PVClearskyp-Diffpf;
% PVpredictp2=PVpredictp-DiffpCond;
 PVpredictp2=PVpredictp-DiffpCond.*PVpredictp;       %
%  figure;
%  plot(PVpredictp2);
[Ix Iy]=find(PVpredictp2<0)
PVpredictp2(Ix,Iy)=0;

[Ix Iy]=find(PVpredictp2>3000)
PVpredictp2(Ix,Iy)=3000
figure;
plot(PVpredictp2);
hold;
plot(PVpredict.Data,'b--o');
ZeroIndex_After=find(PVpredict.Data==0);
PVpredictp2(ZeroIndex_After,:)=0;
figure;
plot(PVpredictp2);

%% Save Variables for Prediction+Mesh / NOT DAYWISE SIMULATION
% These mat-files can than be imported into Mesh algorithm
DataMeasurement = zeros(1,length(t));
DataMeasurement = AC_power.Data;
save('DataMeasurement.mat','DataMeasurement');
DataClearSky = zeros(1,length(t));
DataClearSky = PVClearsky.Data;
save('DatalClearSky.mat','DataClearSky');
DataPVcertainties = zeros(9, length(t));
DataPVcertainties = PVpredictp2;
save('DataPVcertainties.mat','DataPVcertainties');

yForecast = DataPVcertainties;
yObserved = DataMeasurement;

%% Save Variables for Prediction+Mesh / DAYWISE SIMULATION
if isequal(type,'daywise')
    DataMeasurementMa(1,tagVomJahr*24-23:tagVomJahr*24) = AC_power.Data(1:24,1);
    save('DataMeasurement.mat','DataMeasurement');
    DataClearSkyMa(1,tagVomJahr*24-23:tagVomJahr*24) = PVClearsky.Data(1:24,1);
    save('DatalClearSky.mat','DataClearSky');
    DataPVcertaintiesMa(:,tagVomJahr*24-23:tagVomJahr*24) = transpose(PVpredictp2(1:24,:));
    save('DataPVcertainties.mat','DataPVcertainties');

    DataMeasurement = AC_power.Data;
    DataClearSky = PVClearsky.Data;
    DataPVcertainties = PVpredictp2;
end

%end        %end for daywise simulation
